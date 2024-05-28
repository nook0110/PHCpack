with text_io;                            use text_io;
with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Integer_Numbers_io;        use Standard_Integer_Numbers_io;
with Standard_Floating_Numbers;          use Standard_Floating_Numbers;
with Standard_Floating_Numbers_io;       use Standard_Floating_Numbers_io;
with Standard_Complex_Numbers;
with Standard_Random_Numbers;
with Standard_Natural_Vectors;
with Standard_Floating_Vectors;
with Standard_Floating_Vectors_io;       use Standard_Floating_Vectors_io;
with Standard_Integer_Vectors;
with Standard_Complex_Vectors;
with Standard_Complex_Vectors_io;        use Standard_Complex_Vectors_io;
with Standard_Complex_Matrices;
with Standard_Complex_Matrices_io;       use Standard_Complex_Matrices_io;
with Standard_Complex_Linear_Solvers;    use Standard_Complex_Linear_Solvers;
with Symbol_Table;
with Standard_Complex_Polynomials;       use Standard_Complex_Polynomials;
with Standard_Complex_Poly_Systems;      use Standard_Complex_Poly_Systems;
with Standard_Complex_Poly_Systems_io;   use Standard_Complex_Poly_Systems_io;
with Standard_Complex_Poly_SysFun;
with Standard_Complex_Solutions;
with Standard_Homotopy;
with Standard_Fabry_on_Homotopy;
with Double_Taylor_Developments;         use Double_Taylor_Developments;

procedure ts_fliphom is

-- DESCRIPTION :
--   Prototypes a polyhedral homotopy on extending an initial form system
--   with one monomial, as geometrically in a bistellar flip.

  function Random_Polynomial
             ( cff : Standard_Floating_Vectors.Vector ) return Poly is

  -- DESCRIPTION :
  --   Returns the polynomial supported on (0,0), (1,0), (0,1), (1,1),
  --   with random complex coefficients, using the coefficients cff
  --   of the Taylor developments of the coefficient of (1,1).

    res : Poly;
    mon : Term;

  begin
    mon.dg := new Standard_Natural_Vectors.Vector(1..3);
    mon.dg(1) := 0;
    mon.dg(2) := 0;
    mon.dg(3) := 0;
    mon.cf := Standard_Random_Numbers.Random1;
    res := Create(mon);
    mon.dg(1) := 0;
    mon.dg(2) := 1;
    mon.dg(3) := 0;
    mon.cf := Standard_Random_Numbers.Random1;
    Add(res, mon);
    mon.dg(1) := 0;
    mon.dg(2) := 0;
    mon.dg(3) := 1;
    mon.cf := Standard_Random_Numbers.Random1;
    Add(res, mon);
    for k in cff'range loop
      mon.dg(1) := natural32(k);
      mon.dg(2) := 1;
      mon.dg(3) := 1;
      mon.cf := Standard_Complex_Numbers.Create(cff(k));
      Add(res, mon);
    end loop;
    Clear(mon);
    return res;
  end Random_Polynomial;

  function Random_Square_System 
             ( cff : Standard_Floating_Vectors.Vector ) return Poly_Sys is

  -- DESCRIPTION :
  --   Returns the system supported on (0,0), (1,0), (0,1), (1,1),
  --   with random complex coefficients, using the coefficients of
  --   the Taylor developments for the coefficient of (1,1).

    res : Poly_Sys(1..2);

  begin
    res(1) := Random_Polynomial(cff);
    res(2) := Random_Polynomial(cff);
    return res;
  end Random_Square_System;

  procedure Solve_Linear_System
              ( p : in Poly_Sys; s : out Standard_Complex_Vectors.Vector ) is 

  -- DESCRIPTION :
  --   Extracts the linear part of the system in p
  --   and return the solution of the linear system in s.

    mat : Standard_Complex_Matrices.Matrix(1..2,1..2);
    rhs : Standard_Complex_Vectors.Vector(1..2);
    deg : Standard_Complex_Polynomials.Degrees
        := new Standard_Natural_Vectors.Vector(1..3);
    piv : Standard_Integer_Vectors.Vector(1..2);
    info : integer32;
    wrk : Standard_Complex_Vectors.Vector(1..3);
    eva : Standard_Complex_Vectors.Vector(1..2);

    use Standard_Complex_Numbers;

  begin
    deg(1) := 0;
    deg(2) := 0;
    deg(3) := 0;
    rhs(1) := -Coeff(p(1),deg);
    rhs(2) := -Coeff(p(2),deg);
    put_line("The right hand side vector :");
    put_line(rhs);
    deg(2) := 1;
    mat(1,1) := Coeff(p(1),deg);
    mat(2,1) := Coeff(p(2),deg);
    deg(2) := 0;
    deg(3) := 1;
    mat(1,2) := Coeff(p(1),deg);
    mat(2,2) := Coeff(p(2),deg);
    put_line("The coefficient matrix :"); put(mat);
    lufac(mat,2,piv,info);
    lusolve(mat,2,piv,rhs);
    Clear(deg);
    wrk(1) := Standard_Complex_Numbers.Create(0.0);
    wrk(2) := rhs(1);
    wrk(3) := rhs(2);
    put_line("The solution :");
    put_line(rhs);
    eva := Standard_Complex_Poly_SysFun.Eval(p,wrk);
    put_line("The value at the system :");
    put_line(eva);
    s := rhs;
  end Solve_Linear_System;

  procedure Double_Test
              ( deg : in integer32; alpha, point : in double_float ) is

  -- DESCRIPTION :
  --   Generates a random square system and builds a homotopy.

    cff : constant Standard_Floating_Vectors.Vector(0..deg)
        := Double_Taylor_Coefficients(deg,alpha,point);
    sys : constant Poly_Sys := Random_Square_System(cff);
    sol : Standard_Complex_Solutions.Solution(2);
    sols : Standard_Complex_Solutions.Solution_List;

  begin
    Symbol_Table.Init(3);
    Symbol_Table.Add_String("t");
    Symbol_Table.Add_String("x");
    Symbol_Table.Add_String("y");
    put_line("The coefficients of the Taylor series :");
    put_line(cff);
    put_line("The homotopy :");
    put_line(sys);
    Standard_Homotopy.Create(sys,1);
    Solve_Linear_System(sys,sol.v);
    sol.m := 1;
    sol.t := Standard_Complex_Numbers.Create(point);
    Standard_Complex_Solutions.Add(sols,sol);
    Standard_Fabry_on_Homotopy.Run(0,2,1,deg,sols);
  end Double_Test;

  procedure Main is

  -- DESCRIPTION :
  --   Prompts for the main parameters: truncation degree
  --   and exponent of the power of the continuation parameter.

    deg : integer32 := 0;
    alpha,point : double_float := 0.0;

  begin
    new_line;
    put("Give the truncation degree : "); get(deg);
    put("Give the positive real power : "); get(alpha);
    put("Give the positive real point : "); get(point);
    new_line;
    put("-> the truncation degree : "); put(deg,1); new_line;
    put("-> power of the monomial :"); put(alpha); new_line;
    put("-> point of development  :"); put(point); new_line;
    Double_Test(deg,alpha,point);
  end Main;

begin
  Main;
end ts_fliphom;
