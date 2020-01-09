with text_io;                            use text_io;
with Communications_with_User;           use Communications_with_User;
with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Standard_Natural_Numbers_io;        use Standard_Natural_Numbers_io;
with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Integer_Numbers_io;        use Standard_Integer_Numbers_io;
with Standard_Floating_Numbers;          use Standard_Floating_Numbers;
with Standard_Floating_Numbers_io;       use Standard_Floating_Numbers_io;
with Double_Double_Numbers;              use Double_Double_Numbers;
with Double_Double_Numbers_io;           use Double_Double_Numbers_io;
with Quad_Double_Numbers;                use Quad_Double_Numbers;
with Quad_Double_Numbers_io;             use Quad_Double_Numbers_io;
with Standard_Complex_Numbers;
with Standard_Complex_Numbers_io;        use Standard_Complex_Numbers_io;
with DoblDobl_Complex_Numbers;
with DoblDobl_Complex_Numbers_io;        use DoblDobl_Complex_Numbers_io;
with QuadDobl_Complex_Numbers;
with QuadDobl_Complex_Numbers_io;        use QuadDobl_Complex_Numbers_io;
with Standard_Integer_Vectors;
with Standard_Complex_Vectors;
with Standard_Complex_VecVecs;
with Standard_Complex_VecVecs_io;        use Standard_Complex_VecVecs_io;
with DoblDobl_Complex_Vectors;
with DoblDobl_Complex_VecVecs;
with DoblDobl_Complex_VecVecs_io;        use DoblDobl_Complex_VecVecs_io;
with QuadDobl_Complex_Vectors;
with QUadDobl_Complex_VecVecs;
with QUadDobl_Complex_VecVecs_io;        use QUadDobl_Complex_VecVecs_io;
with Standard_Complex_Poly_Systems;
with DoblDobl_Complex_Poly_Systems;
with QuadDobl_Complex_Poly_Systems;
with Standard_Speelpenning_Convolutions;
with DoblDobl_Speelpenning_Convolutions;
with QuadDobl_Speelpenning_Convolutions;
with System_Convolution_Circuits;        use System_Convolution_Circuits;
with Standard_Complex_Solutions;
with Standard_System_and_Solutions_io;
with DoblDobl_Complex_Solutions;
with DoblDobl_System_and_Solutions_io;
with QuadDobl_Complex_Solutions;
with QuadDobl_System_and_Solutions_io;
with Convergence_Radius_Estimates;
with Newton_Convolutions;                use Newton_Convolutions;

procedure ts_fabry is

-- DESCRIPTION :
--   Given a polynomial system, adds a parameter t to every coefficient
--   and runs the Newton's method on the power series.
--   The smallest ratio of the coefficients of the series will give
--   the convergence radius and the location for the nearest singularity.

  procedure Add_Continuation_Parameter
              ( c : in Standard_Speelpenning_Convolutions.
                       Link_to_Convolution_Circuit ) is

  -- DESCRIPTION :
  --   To every coefficient adds 't' as the linear coefficient
  --   in all power series coefficients of the circuit.

    cf : Standard_Complex_Vectors.Link_to_Vector;

    use Standard_Complex_Vectors;

  begin
    for k in c.cff'range loop
      cf := c.cff(k);
      cf(1) := Standard_Complex_Numbers.Create(1.0);
    end loop;
    if c.cst /= null then
      c.cst(1) := Standard_Complex_Numbers.Create(1.0);
    end if;
  end Add_Continuation_Parameter;

  procedure Add_Continuation_Parameter
              ( c : in DoblDobl_Speelpenning_Convolutions.
                       Link_to_Convolution_Circuit ) is

  -- DESCRIPTION :
  --   To every coefficient adds 't' as the linear coefficient
  --   in all power series coefficients of the circuit.

    cf : DoblDobl_Complex_Vectors.Link_to_Vector;
    one : constant double_double := create(1.0);

    use DoblDobl_Complex_Vectors;

  begin
    for k in c.cff'range loop
      cf := c.cff(k);
      cf(1) := DoblDobl_Complex_Numbers.Create(one);
    end loop;
    if c.cst /= null then
      c.cst(1) := DoblDobl_Complex_Numbers.Create(one);
    end if;
  end Add_Continuation_Parameter;

  procedure Add_Continuation_Parameter
              ( c : in QuadDobl_Speelpenning_Convolutions.
                       Link_to_Convolution_Circuit ) is

  -- DESCRIPTION :
  --   To every coefficient adds 't' as the linear coefficient
  --   in all power series coefficients of the circuit.

    cf : QuadDobl_Complex_Vectors.Link_to_Vector;
    one : constant quad_double := create(1.0);

    use QuadDobl_Complex_Vectors;

  begin
    for k in c.cff'range loop
      cf := c.cff(k);
      cf(1) := QuadDobl_Complex_Numbers.Create(one);
    end loop;
    if c.cst /= null then
      c.cst(1) := QuadDobl_Complex_Numbers.Create(one);
    end if;
  end Add_Continuation_Parameter;

  procedure Add_Continuation_Parameter
              ( c : in Standard_Speelpenning_Convolutions.
                       Convolution_Circuits ) is

  -- DESCRIPTION :
  --   To every coefficient adds 't' as the linear coefficient
  --   in all power series coefficients of the circuits.

  begin
    for k in c'range loop
      Add_Continuation_Parameter(c(k));
    end loop;
  end Add_Continuation_Parameter;

  procedure Add_Continuation_Parameter
              ( c : in DoblDobl_Speelpenning_Convolutions.
                       Convolution_Circuits ) is

  -- DESCRIPTION :
  --   To every coefficient adds 't' as the linear coefficient
  --   in all power series coefficients of the circuits.

  begin
    for k in c'range loop
      Add_Continuation_Parameter(c(k));
    end loop;
  end Add_Continuation_Parameter;

  procedure Add_Continuation_Parameter
              ( c : in QuadDobl_Speelpenning_Convolutions.
                       Convolution_Circuits ) is

  -- DESCRIPTION :
  --   To every coefficient adds 't' as the linear coefficient
  --   in all power series coefficients of the circuits.

  begin
    for k in c'range loop
      Add_Continuation_Parameter(c(k));
    end loop;
  end Add_Continuation_Parameter;

  procedure Standard_Newton_Steps
              ( s : in Standard_Speelpenning_Convolutions.Link_to_System;
                scf : in Standard_Complex_VecVecs.VecVec;
                dim : in integer32 ) is

  -- DESCRIPTION :
  --   Applies several Newton steps on the system of convolution circuits s,
  --   departing from the series coefficients in scf.

    info : integer32;
    ipvt : Standard_Integer_Vectors.Vector(1..dim);
    wrk : Standard_Complex_Vectors.Link_to_Vector
        := new Standard_Complex_Vectors.Vector(1..dim);
    ans : character;

  begin
    loop
      Standard_Newton_Step(s,scf,info,ipvt,wrk);
      put("Continue ? (y/n) "); Ask_Yes_or_No(ans);
      exit when (ans /= 'y');
    end loop;
    Standard_Complex_Vectors.Clear(wrk);
  end Standard_Newton_Steps;

  procedure DoblDobl_Newton_Steps
              ( s : in DoblDobl_Speelpenning_Convolutions.Link_to_System;
                scf : in DoblDobl_Complex_VecVecs.VecVec;
                dim : in integer32 ) is

  -- DESCRIPTION :
  --   Applies several Newton steps on the system of convolution circuits s,
  --   departing from the series coefficients in scf.

    info : integer32;
    ipvt : Standard_Integer_Vectors.Vector(1..dim);
    wrk : DoblDobl_Complex_Vectors.Link_to_Vector
        := new DoblDobl_Complex_Vectors.Vector(1..dim);
    ans : character;

  begin
    loop
      DoblDobl_Newton_Step(s,scf,info,ipvt,wrk);
      put("Continue ? (y/n) "); Ask_Yes_or_No(ans);
      exit when (ans /= 'y');
    end loop;
    DoblDobl_Complex_Vectors.Clear(wrk);
  end DoblDobl_Newton_Steps;

  procedure QuadDobl_Newton_Steps
              ( s : in QuadDobl_Speelpenning_Convolutions.Link_to_System;
                scf : in QuadDobl_Complex_VecVecs.VecVec;
                dim : in integer32 ) is

  -- DESCRIPTION :
  --   Applies several Newton steps on the system of convolution circuits s,
  --   departing from the series coefficients in scf.

    info : integer32;
    ipvt : Standard_Integer_Vectors.Vector(1..dim);
    wrk : QuadDobl_Complex_Vectors.Link_to_Vector
        := new QuadDobl_Complex_Vectors.Vector(1..dim);
    ans : character;

  begin
    loop
      QuadDobl_Newton_Step(s,scf,info,ipvt,wrk);
      put("Continue ? (y/n) "); Ask_Yes_or_No(ans);
      exit when (ans /= 'y');
    end loop;
    QuadDobl_Complex_Vectors.Clear(wrk);
  end QuadDobl_Newton_Steps;

  procedure Standard_Test ( degree : in integer32 ) is

  -- DESCRIPTION :
  --   Prompts the user for a witness set.

    lp : Standard_Complex_Poly_Systems.Link_to_Poly_Sys;
    sols : Standard_Complex_Solutions.Solution_List;
    nbr,dim : natural32;

    use Standard_Speelpenning_Convolutions;

  begin
    Standard_System_and_Solutions_io.get(lp,sols);
    dim := natural32(lp'last);
    nbr := Standard_Complex_Solutions.Length_Of(sols);
    new_line;
    put("Read "); put(nbr,1); put(" solutions in dimension ");
    put(dim,1); put_line(".");
    declare
      c : constant Convolution_Circuits(lp'range)
        := Make_Convolution_Circuits(lp.all,natural32(degree));
      s : Link_to_System := Create(c,lp'last,degree);
      sol : constant Standard_Complex_Solutions.Link_to_Solution
          := Standard_Complex_Solutions.Head_Of(sols);
      scf : constant Standard_Complex_VecVecs.VecVec(1..sol.n)
          := Series_Coefficients(sol.v,degree);
      z : Standard_Complex_Numbers.Complex_Number;
      r,err : double_float;
      fail : boolean;
    begin
      Add_Continuation_Parameter(c);
      put_line("The coefficients of the convolution circuits :");
      for i in c'range loop
        put_line(c(i).cff);
      end loop;
      Standard_Newton_Steps(s,scf,lp'last);
      Clear(s);
      Convergence_Radius_Estimates.Fabry(scf,z,r,err,fail);
      if not fail then
        put("z : "); put(z); 
        put("  error estimate :"); put(err,3); new_line;
        put("estimated radius :"); put(r,3); new_line;
      end if;
    end;
  end Standard_Test;

  procedure DoblDobl_Test ( degree : in integer32 ) is

  -- DESCRIPTION :
  --   Prompts the user for a polynomial system with solutions.

    lp : DoblDobl_Complex_Poly_Systems.Link_to_Poly_Sys;
    sols : DoblDobl_Complex_Solutions.Solution_List;
    nbr,dim : natural32;

    use DoblDobl_Speelpenning_Convolutions;

  begin
    DoblDobl_System_and_Solutions_io.get(lp,sols);
    dim := natural32(lp'last);
    nbr := DoblDobl_Complex_Solutions.Length_Of(sols);
    new_line;
    put("Read "); put(nbr,1); put(" solutions in dimension ");
    put(dim,1); put_line(".");
    declare
      c : constant Convolution_Circuits(lp'range)
        := Make_Convolution_Circuits(lp.all,natural32(degree));
      s : Link_to_System := Create(c,lp'last,degree);
      sol : constant DoblDobl_Complex_Solutions.Link_to_Solution
          := DoblDobl_Complex_Solutions.Head_Of(sols);
      scf : constant DoblDobl_Complex_VecVecs.VecVec(1..sol.n)
          := Series_Coefficients(sol.v,degree);
      z : DoblDobl_Complex_Numbers.Complex_Number;
      r,err : double_double;
      fail : boolean;
    begin
      Add_Continuation_Parameter(c);
      put_line("The coefficients of the convolution circuits :");
      for i in c'range loop
        put_line(c(i).cff);
      end loop;
      DoblDobl_Newton_Steps(s,scf,lp'last);
      Clear(s);
      Convergence_Radius_Estimates.Fabry(scf,z,r,err,fail);
      if not fail then
        put("z : "); put(z); 
        put("  error estimate : "); put(err,3); new_line;
        put("estimated radius : "); put(r,3); new_line;
      end if;
    end;
  end DoblDobl_Test;

  procedure QuadDobl_Test ( degree : in integer32 ) is

  -- DESCRIPTION :
  --   Prompts the user for a polynomial system with solutions.

    lp : QuadDobl_Complex_Poly_Systems.Link_to_Poly_Sys;
    sols : QuadDobl_Complex_Solutions.Solution_List;
    nbr,dim : natural32;

    use QuadDobl_Speelpenning_Convolutions;

  begin
    QuadDobl_System_and_Solutions_io.get(lp,sols);
    dim := natural32(lp'last);
    nbr := QuadDobl_Complex_Solutions.Length_Of(sols);
    new_line;
    put("Read "); put(nbr,1); put(" solutions in dimension ");
    put(dim,1); put_line(".");
    declare
      c : constant Convolution_Circuits(lp'range)
        := Make_Convolution_Circuits(lp.all,natural32(degree));
      s : Link_to_System := Create(c,lp'last,degree);
      sol : constant QuadDobl_Complex_Solutions.Link_to_Solution
          := QuadDobl_Complex_Solutions.Head_Of(sols);
      scf : constant QuadDobl_Complex_VecVecs.VecVec(1..sol.n)
          := Series_Coefficients(sol.v,degree);
      z : QuadDobl_Complex_Numbers.Complex_Number;
      r,err : quad_double;
      fail : boolean;
    begin
      Add_Continuation_Parameter(c);
      put_line("The coefficients of the convolution circuits :");
      for i in c'range loop
        put_line(c(i).cff);
      end loop;
      QuadDobl_Newton_Steps(s,scf,lp'last);
      Clear(s);
      Convergence_Radius_Estimates.Fabry(scf,z,r,err,fail);
      if not fail then
        put("z : "); put(z); 
        put("  error estimate : "); put(err,3); new_line;
        put("estimated radius : "); put(r,3); new_line;
      end if;
    end;
  end QuadDobl_Test;

  procedure Main is

  -- DESCRIPTION :
  --   Prompts the user for the degree of the series,
  --   and for the precision.  Launches the tests.

    deg : integer32 := 0;
    prc : character;

  begin
    new_line;
    put_line("Developing series starting at a regular solution ...");
    new_line;
    put("Give the degree of the power series : "); get(deg); skip_line;
    new_line;
    put_line("MENU for the working precision :");
    put_line("  0. standard double precision");
    put_line("  1. double double precision");
    put_line("  2. quad double precision");
    put("Type 0, 1, or 2 to select the precision :");
    Ask_Alternative(prc,"012");
    case prc is
      when '0' => Standard_Test(deg);
      when '1' => DoblDobl_Test(deg);
      when '2' => QuadDobl_Test(deg);
      when others => null;
    end case;
  end Main;

begin
  Main;
end ts_fabry;
