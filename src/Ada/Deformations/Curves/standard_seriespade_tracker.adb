with text_io;                            use text_io;
with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Standard_Floating_Numbers_io;       use Standard_Floating_Numbers_io;
with Standard_Complex_Numbers_io;        use Standard_Complex_Numbers_io;
with Standard_Complex_Vectors;
with Standard_Complex_VecVecs_io;        use Standard_Complex_VecVecs_io;
with Symbol_Table;
with Standard_Complex_Polynomials;       use Standard_Complex_Polynomials;
with Standard_Complex_Poly_SysFun;
with Standard_Complex_Jaco_Matrices;
with Standard_Complex_Hessians;
with Standard_Complex_Series_VecVecs;
with Standard_CSeries_Vector_Functions;
with Standard_CSeries_Poly_Systems;
with Standard_CSeries_Poly_SysFun;
with Standard_CSeries_Jaco_Matrices;
with Standard_Homotopy;
with Standard_Coefficient_Homotopy;
with Projective_Transformations;
with Standard_Pade_Approximants_io;
with Homotopy_Pade_Approximants;
with Series_and_Homotopies;
with Series_and_Predictors;
with Standard_Pade_Trackers;
with Homotopy_Series_Readers;
with Homotopy_Newton_Steps;
with Homotopy_Mixed_Residuals;
with Homotopy_Coefficient_Scaling;
with Singular_Values_of_Hessians;

package body Standard_SeriesPade_Tracker is

-- INTERNAL DATA :

  nbeqs : integer32;  -- number of equations
  nbvar : integer32;  -- number of variables
  idxpar : integer32; -- index of continuation parameter, 0 if artificial
  homconpars : Homotopy_Continuation_Parameters.Link_to_Parameters;
  htp : Standard_CSeries_Poly_Systems.Link_to_Poly_Sys;
  fhm : Standard_CSeries_Poly_SysFun.Link_to_Eval_Coeff_Poly_Sys;
  fcf : Standard_Complex_Series_VecVecs.Link_to_VecVec;
  ejm : Standard_CSeries_Jaco_Matrices.Link_to_Eval_Coeff_Jaco_Mat;
  mlt : Standard_CSeries_Jaco_Matrices.Link_to_Mult_Factors;
  abh : Standard_Complex_Poly_SysFun.Link_to_Eval_Poly_Sys;
  jm : Standard_Complex_Jaco_Matrices.Link_to_Jaco_Mat;
  hs : Standard_Complex_Hessians.Link_to_Array_of_Hessians;
  current_poles : Standard_Complex_VecVecs.Link_to_VecVec;
  current : Link_to_Solution;
  current_servec : Standard_Complex_Series_Vectors.Link_to_Vector;
  current_padvec : Standard_Pade_Approximants.Link_to_Pade_Vector;
  current_frp,solnrm,eta : double_float;
  current_cfp : Complex_Number;
  series_step,pole_step,hessian_step,current_step : double_float;
  cntsstp,cntdstp,cntpstp : natural32;
  homcoord : boolean := false; -- homogeneous coordinates or not

-- CONSTRUCTORS :

  procedure Init ( pars : in Homotopy_Continuation_Parameters.Parameters ) is
  begin
    homconpars := new Homotopy_Continuation_Parameters.Parameters'(pars);
  end Init;

  procedure Initialize_Series_and_Approximants is

  -- DESCRIPTION :
  --   Allocates space for power series and Pade approximants.

    numdeg : constant integer32 := integer32(homconpars.numdeg);
    dendeg : constant integer32 := integer32(homconpars.dendeg);
    servec : Standard_Complex_Series_Vectors.Vector(1..nbvar);
    padvec : constant Standard_Pade_Approximants.Pade_Vector
           := Standard_Pade_Approximants.Allocate(nbvar,numdeg,dendeg);

    use Homotopy_Pade_Approximants;
    allpoles : constant Standard_Complex_VecVecs.VecVec
             := Allocate_Standard_Poles(nbeqs,dendeg);

  begin
    current_servec := new Standard_Complex_Series_Vectors.Vector'(servec);
    current_padvec := new Standard_Pade_Approximants.Pade_Vector'(padvec);
    current_poles := new Standard_Complex_VecVecs.VecVec'(allpoles);
  end Initialize_Series_and_Approximants;

  procedure Init ( p,q : in Link_to_Poly_Sys; homogeneous : in boolean ) is

    tpow : constant natural32 := 2;
    gamma : constant Complex_Number := homconpars.gamma;
    vp : Link_to_Poly_Sys := p;
    vq : Link_to_Poly_Sys := q;

    use Singular_Values_of_Hessians;

  begin
    idxpar := 0; -- artificial-parameter homotopy
    homcoord := homogeneous;
    if not homogeneous then
      Standard_Homotopy.Create(p.all,q.all,tpow,gamma);
    else
      Homotopy_Series_Readers.Standard_Projective_Transformation(vp,vq);
      Symbol_Table.Enlarge(1);
      Symbol_Table.Add_String("Z0");
      Standard_Homotopy.Create(vp.all,vq.all,1,gamma);
      Standard_Coefficient_Homotopy.Create(vq.all,vp.all,1,gamma);
    end if;
    abh := new Standard_Complex_Poly_SysFun.Eval_Poly_Sys'
                 (Homotopy_Mixed_Residuals.Standard_AbsVal_Homotopy);
    if homogeneous then
      nbeqs := vp'last;
      nbvar := integer32(Number_of_Unknowns(vp(vp'first)));
    else
      nbeqs := p'last;
      nbvar := integer32(Number_of_Unknowns(p(p'first)));
    end if;
   -- series homotopy is define when initializing the solution
    Initialize_Series_and_Approximants;
    Standard_Jacobian_Hessians_of_Homotopy(jm,hs);
  end Init;

  procedure Init ( h : in Link_to_Poly_Sys; idx : in integer32 ) is

    use Singular_Values_of_Hessians;

  begin
    idxpar := idx;
    Standard_Homotopy.Create(h.all,idx);
    abh := new Standard_Complex_Poly_SysFun.Eval_Poly_Sys'
                 (Homotopy_Mixed_Residuals.Standard_AbsVal_Homotopy);
    nbeqs := h'last;
    nbvar := integer32(Number_of_Unknowns(h(h'first))) - 1;
    Initialize_Series_and_Approximants;
    Standard_Jacobian_Hessians_of_Homotopy(idx,jm,hs);
  end Init;

  procedure Init ( s : in Link_to_Solution ) is

    conpar : integer32;

  begin
    if idxpar = 0
     then conpar := nbeqs + 1;
     else conpar := idxpar;
    end if;
    if not homcoord then
      current := s;
    else
      declare
        p1s : constant Solution(s.n+1)
            := Projective_Transformations.Projective_Transformation(s.all);
      begin
        current := new Solution'(p1s);
      end;
    end if;
    Standard_CSeries_Poly_Systems.Clear(htp);
    Standard_CSeries_Poly_SysFun.Clear(fhm);
    Standard_Complex_Series_VecVecs.Deep_Clear(fcf);
    Standard_CSeries_Jaco_Matrices.Clear(ejm);
    Standard_CSeries_Jaco_Matrices.Clear(mlt);
    declare -- reset the shifted homotopy
      hs : constant Standard_Complex_Poly_Systems.Poly_Sys(1..nbeqs)
         := Standard_Homotopy.Homotopy_System;
      sh : constant Standard_CSeries_Poly_Systems.Poly_Sys(1..nbeqs)
         := Series_and_Homotopies.Create(hs,conpar,false);
      fs : constant Standard_CSeries_Poly_SysFun.Eval_Coeff_Poly_Sys(sh'range)
         := Standard_CSeries_Poly_SysFun.Create(sh);
      fc : constant Standard_Complex_Series_VecVecs.VecVec(sh'range)
         := Standard_CSeries_Poly_SysFun.Coeff(sh);
      nv : constant integer32 := nbvar;
      dm : Standard_CSeries_Jaco_Matrices.Eval_Coeff_Jaco_Mat(sh'range,1..nv);
      mt : Standard_CSeries_Jaco_Matrices.Mult_Factors(sh'range,1..nv);
    begin
      htp := new Standard_CSeries_Poly_Systems.Poly_Sys'(sh);
      fhm := new Standard_CSeries_Poly_SysFun.Eval_Coeff_Poly_Sys'(fs);
      fcf := new Standard_Complex_Series_VecVecs.VecVec'(fc);
      Standard_CSeries_Jaco_Matrices.Create(sh,dm,mt);
      ejm := new Standard_CSeries_Jaco_Matrices.Eval_Coeff_Jaco_Mat'(dm);
      mlt := new Standard_CSeries_Jaco_Matrices.Mult_Factors'(mt);
    end;
    cntsstp := 0; cntdstp := 0; cntpstp := 0;
  end Init;

-- PREDICTOR-CORRECTOR STAGE :

  procedure Step_Control ( verbose : in boolean := false ) is

    numdeg : constant integer32 := integer32(homconpars.numdeg);
    dendeg : constant integer32 := integer32(homconpars.dendeg);
    maxdeg : constant integer32 := numdeg + dendeg + 2;
    nit : constant integer32 := Standard_Pade_Trackers.Maximum(5,maxdeg/2);
    eva : Standard_Complex_Series_Vectors.Vector(1..nbeqs);
    t : double_float := Standard_Complex_Numbers.REAL_PART(current.t);
   -- tolcff : constant double_float := homconpars.epsilon;
   -- alpha : constant double_float := homconpars.alpha;

  begin
    if verbose then
     -- Series_and_Predictors.Newton_Prediction
     --   (standard_output,maxdeg,nit,htp.all,current.v,current_servec.all,
     --    eva,false); -- verbose);
      Series_and_Predictors.Newton_Prediction
        (standard_output,maxdeg,nit,fhm.all,fcf.all,ejm.all,mlt.all,
         current.v,current_servec.all,eva,false);
     -- series_step := Series_and_Predictors.Set_Step_Size
     --                  (standard_output,eva,tolcff,alpha,verbose);
    else
      -- Series_and_Predictors.Newton_Prediction
      --   (maxdeg,nit,htp.all,current.v,current_servec.all,eva);
      Series_and_Predictors.Newton_Prediction
        (maxdeg,nit,fhm.all,fcf.all,ejm.all,mlt.all,
         current.v,current_servec.all,eva);
     -- series_step := Series_and_Predictors.Set_Step_Size(eva,tolcff,alpha);
    end if;
    series_step := 1.0; -- disable series step -- homconpars.sbeta*series_step;
   -- if verbose
   --  then put("series step : "); put(series_step,2); new_line;
   -- end if;
    Series_and_Predictors.Pade_Approximants
      (current_servec.all,current_padvec.all,current_poles.all,
       current_frp,current_cfp);
    pole_step := homconpars.pbeta*current_frp;
    if verbose then
      put_line("The Pade vector : ");
      for i in current_padvec'range loop
        put_line(Standard_Pade_Approximants_io.Write(current_padvec(i)));
      end loop;
      put_line("The poles : "); put_line(current_poles.all);
      put("pole step : "); put(pole_step,2);
      put("  smallest pole radius : "); put(current_frp,2); new_line;
      put("closest pole : "); put(current_cfp); new_line;
    end if;
    if not verbose then
      hessian_step := Series_and_Predictors.Step_Distance
                        (maxdeg,homconpars.cbeta,t,jm,hs,current.v,
                         current_servec.all,current_padvec.all);
      Standard_Pade_Trackers.Minimum_Step_Size
        (series_step,hessian_step,pole_step,current_step,
         cntsstp,cntdstp,cntpstp);
    else
      declare -- must extend the solution vector with the value for t
        use Standard_Complex_Vectors,Singular_Values_of_Hessians;
        solxt : Vector(current.v'first..current.v'last+1);
      begin
        solxt(current.v'range) := current.v;
        solxt(solxt'last) := current.t;
        eta := Standard_Distance(jm.all,hs.all,solxt);
      end;
      solnrm := Homotopy_Pade_Approximants.Solution_Error_Norm
                  (current_servec.all,current_padvec.all);
      hessian_step := Series_and_Predictors.Step_Distance
                        (maxdeg,homconpars.cbeta,eta,solnrm);
      put("Hessian step : "); put(hessian_step,2);
      put("  eta : "); put(eta,2);
      put("  nrm : "); put(solnrm,2); new_line;
      Standard_Pade_Trackers.Minimum_Step_Size
        (standard_output,series_step,hessian_step,
         pole_step,current_step,cntsstp,cntdstp,cntpstp);
    end if;
    Standard_Pade_Trackers.Set_Step(t,current_step,homconpars.maxsize,1.0);
    current.t := Standard_Complex_Numbers.Create(t);
    if verbose
     then put("Step size :"); put(current_step,2); put("  t ="); put(t,2);
    end if;
    Standard_Complex_Series_Vectors.Clear(eva);
  end Step_Control;

  procedure Predictor_Feedback_Loop
              ( fail : out boolean; verbose : in boolean := false ) is

    sol : Standard_Complex_Vectors.Vector(1..current.n) := current.v;
    t : double_float := Standard_Complex_Numbers.REAL_PART(current.t);
    predres : double_float := 0.0;
    alpha : constant double_float := homconpars.alpha;

  begin
    fail := false;
    loop
      sol := Series_and_Predictors.Predicted_Solution
               (current_padvec.all,current_step);
      predres := Standard_Pade_Trackers.Residual_Prediction(abh.all,sol,t);
      if verbose
       then put("  predictor residual :"); put(predres,2); new_line;
      end if;
      exit when (predres <= alpha);
      t := t - current_step; current_step := current_step/2.0;
      t := t + current_step;
      if verbose
       then put("Step size :"); put(current_step,2); put("  t ="); put(t,2);
      end if;
      if current_step < homconpars.minsize
       then fail := true; exit;
      end if;
    end loop;
    current.t := Standard_Complex_Numbers.Create(t);
    current.v := sol;
  end Predictor_Feedback_Loop;

  procedure Predict ( fail : out boolean; verbose : in boolean := false ) is

    t : double_float := Standard_Complex_Numbers.REAL_PART(current.t);

  begin
   -- if verbose then
   --   Homotopy_Coefficient_Scaling.Scale_Solution_Coefficients
   --     (standard_output,fhm.all,fcf.all,current.v,t,homconpars.gamma,true);
   -- else -- verbose with scaling is for debugging purposes only
    Homotopy_Coefficient_Scaling.Scale_Solution_Coefficients
      (fcf.all,current.v,t,homconpars.gamma);
   -- end if;
    Step_Control(verbose);
    Predictor_Feedback_Loop(fail,verbose);
    t := Standard_Complex_Numbers.REAL_PART(current.t);
    if t = 1.0 
     then fail := false;
     else fail := (current_step < homconpars.minsize);
    end if;
    Series_and_Homotopies.Shift(htp.all,-current_step);
  end Predict;

  procedure Correct ( fail : out boolean; verbose : in boolean := false ) is

    t : constant double_float := REAL_PART(current.t);
    nbrit : natural32 := 0;
    extra : constant natural32 := 1;

  begin
    if verbose then
      Homotopy_Newton_Steps.Correct
        (standard_output,abh.all,t,homconpars.tolres,homconpars.corsteps,nbrit,
         current.v,current.err,current.rco,current.res,fail,extra,true);
    else
      Homotopy_Newton_Steps.Correct
        (abh.all,t,homconpars.tolres,homconpars.corsteps,nbrit,
         current.v,current.err,current.rco,current.res,fail,extra);
    end if;
  end Correct;

  procedure Predict_and_Correct
              ( fail : out boolean; verbose : in boolean := false ) is
  begin
    Predict(fail,verbose);
    if not fail
     then Correct(fail,verbose);
    end if;
    Standard_CSeries_Vector_Functions.Shift(fcf.all,-current_step);
  end Predict_and_Correct;

-- SELECTORS :

  function Get_Parameters
    return Homotopy_Continuation_Parameters.Link_to_Parameters is

  begin
    return homconpars;
  end Get_Parameters;

  function Get_Current_Solution return Link_to_Solution is
  begin
    return current;
  end Get_Current_Solution;

  function Get_Current_Series_Vector
    return Standard_Complex_Series_Vectors.Link_to_Vector is
  begin
    return current_servec;
  end Get_Current_Series_Vector;

  function Get_Current_Pade_Vector
    return Standard_Pade_Approximants.Link_to_Pade_Vector is
  begin
    return current_padvec;
  end Get_Current_Pade_Vector;

  function Get_Current_Poles return Standard_Complex_VecVecs.Link_to_VecVec is
  begin
    return current_poles;
  end Get_Current_Poles;

  function Get_Current_Pole_Radius return double_float is
  begin
    return current_frp;
  end Get_Current_Pole_Radius;

  function Get_Current_Closest_Pole return Complex_Number is
  begin
    return current_cfp;
  end Get_Current_Closest_Pole;

  function Get_Current_Series_Step return double_float is
  begin
    return series_step;
  end Get_Current_Series_Step;

  function Get_Current_Pole_Step return double_float is
  begin
    return pole_step;
  end Get_Current_Pole_Step;

  function Get_Current_Estimated_Distance return double_float is
  begin
    return eta;
  end Get_Current_Estimated_Distance;

  function Get_Current_Hessian_Step return double_float is
  begin
    return hessian_step;
  end Get_Current_Hessian_Step;

  function Get_Current_Step_Size return double_float is
  begin
    return current_step;
  end Get_Current_Step_Size;

  function Get_Current_t_Value return double_float is
  begin
    return REAL_PART(current.t);
  end Get_Current_t_Value;

-- DESTRUCTOR :

  procedure Clear is
  begin
    Homotopy_Continuation_Parameters.Clear(homconpars);
    Standard_CSeries_Poly_Systems.Clear(htp);
    Standard_CSeries_Poly_SysFun.Clear(fhm);
    Standard_Complex_Series_VecVecs.Deep_Clear(fcf);
    Standard_CSeries_Jaco_Matrices.Clear(ejm);
    Standard_CSeries_Jaco_Matrices.Clear(mlt);
    Standard_Complex_Poly_SysFun.Clear(abh);
    Standard_Complex_Jaco_Matrices.Clear(jm);
    Standard_Complex_Hessians.Clear(hs);
    Standard_Complex_VecVecs.Deep_Clear(current_poles);
    Standard_Complex_Series_Vectors.Clear(current_servec);
    Standard_Pade_Approximants.Clear(current_padvec);
  end Clear;

end Standard_SeriesPade_Tracker;
