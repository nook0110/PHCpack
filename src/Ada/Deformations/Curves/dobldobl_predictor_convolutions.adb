with unchecked_deallocation;
with text_io;                            use text_io;
with DoblDobl_Mathematical_Functions;
with DoblDobl_Complex_Singular_Values;
with DoblDobl_Rational_Approximations;
with Newton_Convolutions;
with Newton_Power_Convolutions;
with Convergence_Radius_Estimates;
with Hessian_Convolution_Circuits;

package body DoblDobl_Predictor_Convolutions is

  function Create ( sol : DoblDobl_Complex_Vectors.Vector;
                    neq,deg,numdeg,dendeg : integer32 ) return LU_Predictor is

    res : LU_Predictor(sol'last,deg,numdeg,dendeg);
    zero : constant Complex_Number := Create(integer(0));
    knum : constant DoblDobl_Complex_Vectors.Vector(0..numdeg)
         := (0..numdeg => zero);
    kden : constant DoblDobl_Complex_Vectors.Vector(0..dendeg)
         := (0..dendeg => zero);

  begin
    res.sol := Newton_Convolutions.Series_Coefficients(sol,deg);
    res.wrk := new DoblDobl_Complex_Vectors.Vector'(1..neq => zero);
    for k in sol'range loop
      res.numcff(k) := new DoblDobl_Complex_Vectors.Vector'(knum);
      res.dencff(k) := new DoblDobl_Complex_Vectors.Vector'(kden);
    end loop;
    return res;
  end Create;

  function Create ( sol : DoblDobl_Complex_Vectors.Vector;
                    neq,deg,numdeg,dendeg : integer32 )
                  return SVD_Predictor is

    dim : constant integer32 := sol'last;
    res : SVD_Predictor(neq,dim,dim+1,deg,numdeg,dendeg);
    zero : constant Complex_Number := Create(integer(0));
    knum : constant DoblDobl_Complex_Vectors.Vector(0..numdeg)
         := (0..numdeg => zero);
    kden : constant DoblDobl_Complex_Vectors.Vector(0..dendeg)
         := (0..dendeg => zero);

  begin
    res.sol := Newton_Convolutions.Series_Coefficients(sol,deg);
    res.wrk := new DoblDobl_Complex_Vectors.Vector'(1..neq => zero);
    res.ewrk := new DoblDobl_Complex_Vectors.Vector'(1..dim => zero);
    res.dx := Allocate_Coefficients(dim,deg);
    res.xd := Linearized_Allocation(dim,deg);
    for k in sol'range loop
      res.numcff(k) := new DoblDobl_Complex_Vectors.Vector'(knum);
      res.dencff(k) := new DoblDobl_Complex_Vectors.Vector'(kden);
    end loop;
    res.svl := (res.svl'range => zero);
    return res;
  end Create;

  function Create ( sol : DoblDobl_Complex_Vectors.Vector;
                    neq,deg,numdeg,dendeg : integer32 ) 
                  return Link_to_LU_Predictor is

    prd : constant LU_Predictor(sol'last,deg,numdeg,dendeg)
        := Create(sol,neq,deg,numdeg,dendeg);
    res : constant Link_to_LU_Predictor := new LU_Predictor'(prd);

  begin
    return res;
  end Create;

  function Create ( sol : DoblDobl_Complex_Vectors.Vector;
                    neq,deg,numdeg,dendeg : integer32 ) 
                  return Link_to_SVD_Predictor is

    dim : constant integer32 := sol'last;
    prd : constant SVD_Predictor(neq,dim,dim+1,deg,numdeg,dendeg)
        := Create(sol,neq,deg,numdeg,dendeg);
    res : constant Link_to_SVD_Predictor := new SVD_Predictor'(prd);

  begin
    return res;
  end Create;

  procedure Predict
              ( hom : in Link_to_System; prd : in Link_to_LU_Predictor;
                maxit : in integer32; tol : in double_float;
                nbrit : out integer32; absdx : out double_double;
                fail : out boolean; z : out Complex_Number;
                rad,err : out double_double; output : in boolean ) is

    use DoblDobl_Rational_Approximations;
    use Newton_Power_Convolutions;

    info : integer32;

  begin
    nbrit := 0;
    if output then
      LU_Newton_Steps
        (standard_output,hom,prd.sol,maxit,nbrit,tol,absdx,fail,
         info,prd.newtpiv,prd.wrk,false);
      Convergence_Radius_Estimates.Fabry(prd.sol,z,rad,err,fail);
    else
      LU_Newton_Steps
        (hom,prd.sol,maxit,nbrit,tol,absdx,fail,
         info,prd.newtpiv,prd.wrk,false,false);
      Convergence_Radius_Estimates.Fabry(prd.sol,z,rad,err,fail,false);
    end if;
    Pade_Vector(prd.numdeg,prd.dendeg,prd.sol,prd.numcff,prd.dencff,
                prd.mat,prd.rhs,prd.padepiv,info,false);
  end Predict;

  procedure Predict
              ( hom : in Link_to_System; prd : in Link_to_SVD_Predictor;
                maxit : in integer32; tol : in double_float;
                nbrit : out integer32; absdx,rcond : out double_double;
                fail : out boolean; z : out Complex_Number;
                rad,err : out double_double; output : in boolean ) is

    use DoblDobl_Rational_Approximations;
    use Newton_Power_Convolutions;

    info : integer32;

  begin
    nbrit := 0;
    if output then
      SVD_Newton_Steps
        (standard_output,hom,prd.sol,prd.dx,prd.xd,maxit,nbrit,tol,absdx,
         fail, prd.svl,prd.U,prd.V,info,rcond,prd.ewrk,prd.wrk,false);
      Convergence_Radius_Estimates.Fabry(prd.sol,z,rad,err,fail);
    else
      SVD_Newton_Steps
        (hom,prd.sol,prd.dx,prd.xd,maxit,nbrit,tol,absdx,fail,
         prd.svl,prd.U,prd.V,info,rcond,prd.ewrk,prd.wrk,false,false);
      Convergence_Radius_Estimates.Fabry(prd.sol,z,rad,err,fail,false);
    end if;
    Pade_Vector(prd.numdeg,prd.dendeg,prd.sol,prd.numcff,prd.dencff,
                prd.mat,prd.rhs,prd.padepiv,info,false);
  end Predict;

  procedure Second
              ( hom : in Link_to_System; svh : in Link_to_SVD_Hessians;
                sol : in DoblDobl_Complex_Vectors.Vector ) is

    n : constant integer32 := svh.dim;
    p : constant integer32 := svh.dim;
    job : constant integer32 := 11;
    info : integer32;

    use DoblDobl_Complex_Singular_Values;

  begin
    for k in hom.crc'range loop
      svh.H := Hessian_Convolution_Circuits.Hessian(hom.crc(k),sol);
      SVD(svh.H,n,p,svh.svl,svh.ewrk,svh.U,svh.V,job,info);
      svh.vals(k) := svh.svl(1);
    end loop;
  end Second;

  function DoblDobl_Distance
              ( svh : in DoblDobl_Predictor_Convolutions.Link_to_SVD_Hessians )
              return double_double is

    sigma1 : constant double_double
           := DoblDobl_Complex_Numbers.REAL_PART(svh.vals(0));
    accsum,acc,nrm : double_double := create(0.0);

  begin
    for k in 1..svh.dim loop
      acc := DoblDobl_Complex_Numbers.REAL_PART(svh.vals(k));
      accsum := accsum + acc*acc; 
    end loop;
    nrm := DoblDobl_Mathematical_Functions.SQRT(accsum);
    return (2.0*sigma1)/nrm;
  end DoblDobl_Distance;

-- DESTRUCTORS :

  procedure Clear ( p : in out Link_to_LU_Predictor ) is

    procedure free is
      new unchecked_deallocation(LU_Predictor,Link_to_LU_Predictor);

  begin
    if p /= null then
      DoblDobl_Complex_VecVecs.Clear(p.sol);
      DoblDobl_Complex_VecVecs.Clear(p.numcff);
      DoblDobl_Complex_VecVecs.Clear(p.dencff);
      free(p);
    end if;
  end Clear;

  procedure Clear ( p : in out Link_to_SVD_Predictor ) is

    procedure free is
      new unchecked_deallocation(SVD_Predictor,Link_to_SVD_Predictor);

  begin
    if p /= null then
      DoblDobl_Complex_VecVecs.Clear(p.sol);
      DoblDobl_Complex_Vectors.Clear(p.wrk);
      DoblDobl_Complex_Vectors.Clear(p.ewrk);
      DoblDobl_Complex_VecVecs.Clear(p.dx);
      DoblDobl_Complex_VecVecs.Clear(p.xd);
      DoblDobl_Complex_VecVecs.Clear(p.numcff);
      DoblDobl_Complex_VecVecs.Clear(p.dencff);
      free(p);
    end if;
  end Clear;

  procedure Clear ( h : in out Link_to_SVD_Hessians ) is

    procedure free is
      new unchecked_deallocation(SVD_Hessians,Link_to_SVD_Hessians);

  begin
    if h /= null
     then free(h);
    end if;
  end Clear;

end DoblDobl_Predictor_Convolutions;
