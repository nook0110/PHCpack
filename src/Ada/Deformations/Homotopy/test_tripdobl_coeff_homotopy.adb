with text_io;                           use text_io;
with Communications_with_User;          use Communications_with_User;
with Timing_Package;                    use Timing_Package;
with Standard_Natural_Numbers_io;       use Standard_Natural_Numbers_io;
with Standard_Integer_Numbers_io;       use Standard_Integer_Numbers_io;
with Triple_Double_Numbers;             use Triple_Double_Numbers;
with TripDobl_Complex_Numbers;
with TripDobl_Complex_Numbers_io;       use TripDobl_Complex_Numbers_io;
with TripDobl_Random_Numbers;
with TripDobl_Complex_Vectors;
with TripDobl_Complex_Vectors_io;       use TripDobl_Complex_Vectors_io;
with TripDobl_Random_Vectors;
with Symbol_Table;
with TripDobl_Random_Polynomials;       use TripDobl_Random_Polynomials;
with TripDobl_Complex_Poly_Randomizers;
with TripDobl_Complex_Poly_Systems_io;  use TripDobl_Complex_Poly_Systems_io;
with TripDobl_Homotopy;
with TripDobl_Coefficient_Homotopy;

package body Test_TripDobl_Coeff_Homotopy is

  procedure Write_Elements ( A,B : in TripDobl_Complex_Matrices.Matrix ) is
  begin
    for i in A'range(1) loop
      for j in A'range(2) loop
        put("A("); put(i,1); put(","); put(j,1); put(") = ");
        put(A(i,j)); new_line;
        put("B("); put(i,1); put(","); put(j,1); put(") = ");
        put(B(i,j)); new_line;
      end loop;
    end loop;
  end Write_Elements;

  procedure TripDobl_Compared_Encapsulated_Eval ( n : in natural32 ) is

    use TripDobl_Complex_Numbers;

    t : constant triple_double := abs(TripDobl_Random_Numbers.Random);
    ct : constant Complex_Number := Create(t);
    x : constant TripDobl_Complex_Vectors.Vector(1..integer32(n))
      := TripDobl_Random_Vectors.Random_Vector(1,integer32(n));
    y : constant TripDobl_Complex_Vectors.Vector
      := TripDobl_Homotopy.Eval(x,ct);
    z : constant TripDobl_Complex_Vectors.Vector
      := TripDobl_Coefficient_Homotopy.Eval(x,ct);
    A : constant TripDobl_Complex_Matrices.Matrix(x'range,x'range)
      := TripDobl_Homotopy.Diff(x,ct);
    B : constant TripDobl_Complex_Matrices.Matrix(x'range,x'range)
      := TripDobl_Coefficient_Homotopy.Diff(x,ct);

  begin
    put("A random t : "); put(ct); new_line;
    put_line("A random point : "); put_line(x);
    put_line("-> y = "); put_line(y);
    put_line("-> z = "); put_line(z);
    Write_Elements(A,B);
  end TripDobl_Compared_Encapsulated_Eval;

  procedure TripDobl_Random_Systems
              ( n : in integer32;
                p,q : out TripDobl_Complex_Poly_Systems.Poly_Sys ) is

    m,d : natural32 := 0;

  begin
    put("Give the number of monomials : "); get(m);
    put("Give upper bound on degree : "); get(d);
    for i in p'range loop
      p(i) := Random_Sparse_Poly(natural32(n),d,m,0);
      q(i) := Random_Sparse_Poly(natural32(n),d,m,0);
    end loop;
    put_line("-> p = "); put(p);
    put_line("-> q = "); put(q);
  end TripDobl_Random_Systems;

  procedure TripDobl_Random_Coefficient_Systems
              ( n : in integer32;
                p,q : out TripDobl_Complex_Poly_Systems.Poly_Sys ) is

    m,d : natural32 := 0;

  begin
    put("Give the number of monomials : "); get(m);
    put("Give upper bound on degree : "); get(d);
    for i in p'range loop
      p(i) := Random_Sparse_Poly(natural32(n),d,m,0);
      q(i) := TripDobl_Complex_Poly_Randomizers.Complex_Randomize1(p(i));
    end loop;
    put_line("-> p = "); put(p);
    put_line("-> q = "); put(q);
  end TripDobl_Random_Coefficient_Systems;

  procedure TripDobl_Compared_Encapsulation_Test is

    use TripDobl_Complex_Numbers;

    n : natural32 := 0;

  begin
    put("Give the number variables : "); get(n);
    Symbol_Table.Init(n);
    declare
      p,q : TripDobl_Complex_Poly_Systems.Poly_Sys(1..integer32(n));
      gamma : constant Complex_Number := TripDobl_Random_Numbers.Random1;
    begin
      TripDobl_Random_Systems(integer32(n),p,q);
      TripDobl_Coefficient_Homotopy.Create(p,q,2,gamma);
      TripDobl_Homotopy.Create(q,p,2,gamma);
      TripDobl_Compared_Encapsulated_Eval(n);
    end;
  end TripDobl_Compared_Encapsulation_Test;

  procedure TripDobl_Homotopy_Performance ( n,m : natural32 ) is

    use TripDobl_Complex_Numbers;

    t : triple_double;
    ct : Complex_Number;
    x,y : TripDobl_Complex_Vectors.Vector(1..integer32(n));
    A : TripDobl_Complex_Matrices.Matrix(x'range,x'range);
    timer : Timing_Widget;

  begin
    tstart(timer);
    for i in 1..m loop
      t := abs(TripDobl_Random_Numbers.Random);
      ct := Create(t);
      x := TripDobl_Random_Vectors.Random_Vector(1,integer32(n));
      y := TripDobl_Homotopy.Eval(x,ct);
      A := TripDobl_Homotopy.Diff(x,ct);
    end loop;
    tstop(timer);
    new_line;
    print_times(standard_output,timer,"eval & diff of TripDobl homotopy");
  end TripDobl_Homotopy_Performance;

  procedure TripDobl_Coefficient_Homotopy_Performance ( n,m : natural32 ) is

    use TripDobl_Complex_Numbers;

    t : triple_double;
    ct : Complex_Number;
    x,y : TripDobl_Complex_Vectors.Vector(1..integer32(n));
    A : TripDobl_Complex_Matrices.Matrix(x'range,x'range);
    timer : Timing_Widget;

  begin
    tstart(timer);
    for i in 1..m loop
      t := abs(TripDobl_Random_Numbers.Random);
      ct := Create(t);
      x := TripDobl_Random_Vectors.Random_Vector(1,integer32(n));
      y := TripDobl_Coefficient_Homotopy.Eval(x,ct);
      A := TripDobl_Coefficient_Homotopy.Diff(x,ct);
    end loop;
    tstop(timer);
    new_line;
    print_times(standard_output,timer,"eval & diff of coefficient homotopy");
  end TripDobl_Coefficient_Homotopy_Performance;

  procedure TripDobl_Performance_Test is

    use TripDobl_Complex_Numbers;

    n,m : natural32 := 0;

  begin
    put("Give the number of evaluations : "); get(m);
    put("Give the number variables : "); get(n);
    Symbol_Table.Init(n);
    declare
      p,q : TripDobl_Complex_Poly_Systems.Poly_Sys(1..integer32(n));
      gamma : constant Complex_Number := TripDobl_Random_Numbers.Random1;
    begin
      TripDobl_Random_Coefficient_Systems(integer32(n),p,q);
      TripDobl_Coefficient_Homotopy.Create(p,q,2,gamma);
      TripDobl_Homotopy.Create(q,p,2,gamma);
    end;
    TripDobl_Homotopy_Performance(n,m);
    TripDobl_Coefficient_Homotopy_Performance(n,m);
  end TripDobl_Performance_Test;

  procedure Main is

    ans : character;

  begin
    new_line;
    put_line("Evaluating a homotopy pair of polynomials ...");
    put_line("  1. compare for triple double random systems;");
    put_line("  2. performance of triple double homotopies.");
    put("Type 1 or 2 to choose a test : ");
    Ask_Alternative(ans,"12");
    new_line;
    case ans is
      when '1' => TripDobl_Compared_Encapsulation_Test;
      when '2' => TripDobl_Performance_Test;
      when others => null;
    end case;
  end Main;

end Test_TripDobl_Coeff_Homotopy;
