with text_io;                            use text_io;
with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Integer_Numbers_io;        use Standard_Integer_Numbers_io;
with Standard_Floating_Numbers;          use Standard_Floating_Numbers;
with octo_double_Numbers;              use octo_double_Numbers;
with OctoDobl_Complex_Numbers;           use OctoDobl_Complex_Numbers;
with OctoDobl_Complex_Numbers_Polar;
with OctoDobl_Complex_Series_io;         use OctoDobl_Complex_Series_io;

package body OctoDobl_Complex_Algebraic_Series is

  function sqrt ( c : Series; i : natural32;
                  verbose : boolean := false ) return Series is

    res : Series(c.deg) := Create(0,c.deg);
    cpc : constant Series(c.deg) := c;
    wrk,dx : Series(c.deg);
    one : constant octo_double := create(integer32(1));
    two : constant octo_double := create(integer32(2));
    half : constant octo_double := one/two;
    fac : constant Complex_Number := Create(half);
    tol : constant double_float := 1.0E-24;

  begin
    if AbsVal(cpc.cff(0)) < tol then
      res := Create(0,c.deg);
    else
      res := Create(0,c.deg);
      res.cff(0) := OctoDobl_Complex_Numbers_Polar.Root(cpc.cff(0),2,i);
      for i in 0..c.deg loop
        wrk := res*res - cpc;
        dx := fac*wrk/res;
        if verbose then
          put("evaluation at degree = "); put(res.deg,1);
          put_line(" :"); put(wrk);
          put("update dx at degree = "); put(res.deg,1);
          put_line(" :"); put(dx);
        end if;
        res := res - dx;
      end loop;
    end if;
    return res;
  end sqrt;

  function Root ( c : Series; n,i : natural32;
                  verbose : boolean := false ) return Series is

    res : Series(c.deg) := Create(0,c.deg);
    cpc : constant Series(c.deg) := c;
    wrk,dx : Series(c.deg);
    one : constant octo_double := create(1.0);
    ddn : constant octo_double := create(n);
    denominator : constant octo_double := one/ddn;
    fac : constant Complex_Number := Create(denominator);

  begin
    res.cff(0) := OctoDobl_Complex_Numbers_Polar.Root(cpc.cff(0),n,i);
    for i in 0..c.deg loop
      wrk := res**integer(n) - cpc;
      dx := fac*wrk/(res**integer(n-1));
      if verbose then
        put("update dx at degree = "); put(res.deg,1);
        put_line(" :"); put(dx);
      end if;
      res := res - dx;
    end loop;
    return res;
  end Root;

end OctoDobl_Complex_Algebraic_Series;
