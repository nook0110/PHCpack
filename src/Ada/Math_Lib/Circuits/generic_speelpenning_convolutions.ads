with Standard_Integer_Numbers;          use Standard_Integer_Numbers;
with Standard_Integer_Vectors;
with Standard_Integer_VecVecs;
with Abstract_Ring;
with Generic_Vectors;
with Generic_Matrices;
with Generic_VecVecs;
with Generic_VecMats;

generic

  with package Ring is new Abstract_Ring(<>);
  with package Vectors is new Generic_Vectors(Ring);
  with package VecVecs is new Generic_VecVecs(Ring,Vectors);
  with package Matrices is new Generic_Matrices(Ring,Vectors);
  with package VecMats is new Generic_VecMats(Ring,Vectors,Matrices);

package Generic_Speelpenning_Convolutions is

-- DESCRIPTION :
--   The reverse mode of algorithmic differentiation computes
--   the value of a product and all its partial derivatives.
--   This package offers a vectorized version on the coefficients
--   of power series, all truncated to the same fixed degree.

-- DATA STRUCTURES :

  type VecVecVec is array ( integer32 range <> ) of VecVecs.Link_to_VecVec;
  -- A three dimensional structure to store the coefficient vectors
  -- of powers of series.
 
  type Link_to_VecVecVec is access VecVecVec; -- stores the power table

-- A convolution circuit is a data structure for the efficient evaluation
-- and differentiation of polynomials in several variables at the
-- coefficient vectors of power series using the reverse mode of
-- algorithmic differentiation.

  type Circuit ( nbr,dim,dim1,dim2 : integer32 ) is record
    xps : Standard_Integer_VecVecs.VecVec(1..nbr); -- exponent vectors
    idx : Standard_Integer_VecVecs.VecVec(1..nbr); -- exponent indices
    fac : Standard_Integer_VecVecs.VecVec(1..nbr); -- factor indices
    cff : VecVecs.VecVec(1..nbr); -- coefficients of the monomials
    cst : Vectors.Link_to_Vector; -- the constant coefficient
   -- workspace for products and coefficient vectors of series
    forward : VecVecs.VecVec(1..dim1);        -- forward products
    backward,cross : VecVecs.VecVec(1..dim2); -- backward and cross products
    wrk,acc : Vectors.Link_to_Vector;         -- series coefficients
  end record;

  type Link_to_Circuit is access Circuit;

  type Circuits is array ( integer32 range <> ) of Link_to_Circuit;

  type Link_to_Circuits is access Circuits;

-- A system stores the sequence of convolution circuits for each polynomial
-- and the work space to hold auxiliary results and the final outcomes.

  type System ( neq,neq1,dim,deg : integer32 ) is record
    crc : Circuits(1..neq); -- circuits for the equations
    mxe : Standard_Integer_Vectors.Vector(1..dim); -- exponent maxima
    pwt : Link_to_VecVecVec;      -- the power table
    yd : VecVecs.VecVec(1..neq1); -- work space for EvalDiff on one circuit
    vy : VecVecs.VecVec(0..deg);  -- linearized evaluated power series
    yv : VecVecs.VecVec(1..neq);  -- delinearized evaluated power series
    vm : VecMats.VecMat(0..deg);  -- differentiation result as matrix series
  end record;

  type Link_to_System is access System;

-- CONSTRUCTORS :

  function Create ( c : Circuits; dim,deg : integer32 ) return System;
  function Create ( c : Circuits; dim,deg : integer32 ) return Link_to_System;

  -- DESCRIPTION:
  --   The system on return stores the convolution circuits in crc,
  --   contains the values for the exponent maxima in mxe, and
  --   has allocated space for pwt, yd, vy, yv, and vm.

  function Exponent_Maxima
             ( c : Circuits; dim : integer32 )
             return Standard_Integer_Vectors.Vector;

  -- DESCRIPTION :
  --   Returns the maximal exponents of the dim variables in the circuits.
  --   The result of this function is the 'd' in the Create procedure
  --   of the power table.

  function Create ( x : VecVecs.VecVec;
                    d : Standard_Integer_Vectors.Vector )
                  return Link_to_VecVecVec;

  -- DESCRIPTION :
  --   Stores all powers x(i)^k for k ranging from 2 to d(i),
  --   for i in d'range = x'range, in the power table.
  --   The i-th entry in the power table contains the powers of x(i),
  --   if d(i) > 1, starting with x(i)^2 at the first position.
  --   The Create(x,d) combines the function Allocate(d,deg) 
  --   and the Compute(pwt,d,x) procedure below.

  function Allocate ( mxe : Standard_Integer_Vectors.Vector;
                      deg : integer32 )
                    return Link_to_VecVecVec;

  -- DESCRIPTION :
  --   Allocates space for the power table, given the exponent maxima
  --   for each variable in mxe and the degrees of the power series in deg.

  procedure Compute ( pwt : in Link_to_VecVecVec;
                      mxe : in Standard_Integer_Vectors.Vector;
                      x : in VecVecs.VecVec );

  -- DESCRIPTION :
  --   Computes the powers in the allocated power table for the
  --   coefficients in the power series in x.

  -- REQUIRED : pwt = Allocate(mxe,deg) has been executed,
  --   and pwt'range = x'range.

  -- ON ENTRY :
  --   pwt      allocated power table for the exponent maxima in mxe
  --            and for power series of the degree of the series in x;
  --   mxe      exponent maxima for each variable in the system;
  --   x        coefficient of power series.

-- DEALLOCATORS :

  procedure Clear ( pwt : in out Link_to_VecVecVec );

  -- DESCRIPTION :
  --   Deallocates the space occupied by the power table pwt.

  procedure Clear ( c : in out Circuit );
  procedure Clear ( c : in out Link_to_Circuit );
  procedure Clear ( c : in out Circuits );
  procedure Clear ( c : in out Link_to_Circuits );

  -- DESCRIPTION :
  --   Deallocates the space occupied by the convolution circuits.

  procedure Clear ( s : in out System );
  procedure Clear ( s : in out Link_to_System );

  -- DESCRIPTION :
  --   Deallocates the space occupied by the system s.

-- ALLOCATORS :

  function Allocate_Coefficients
             ( deg : integer32 ) return Vectors.Link_to_Vector;

  -- DESCRIPTION :
  --   Returns allocated space for the coefficients of the series,
  --   truncaged to degree deg and initialized to zero.

  function Allocate_Coefficients
             ( dim,deg : integer32 ) return VecVecs.VecVec;

  -- DESCRIPTION :
  --   Returns allocated space for the coefficients of the series
  --   truncated to degree deg and initialized to zero.
  --   The vector on return has range 1..dim.

  function Linearized_Allocation
             ( dim,deg : integer32 ) return VecVecs.VecVec;

  -- DESCRIPTION :
  --   Returns allocated space for the coefficients of the series
  --   truncated to degree deg and initialized to zero,
  --   in linearized form.
  --   The vector on return has range 0..deg and represents a series
  --   truncated to degree deg and with vectors of range 1..dim as
  --   its coefficients.

  function Allocate_Coefficients
             ( nbq,nvr,deg : integer32 ) return VecMats.VecMat;

  -- DESCRIPTION :
  --   Returns a vector of matrices, of range 0..deg,
  --   of nbq-by-nvr matrices of coefficients,
  --   where nbq equals the number of equations
  --   and nvr is the number of variables.

-- AUXILIARY COMPUTATIONAL PROCEDURES :

  procedure Update ( values : in Vectors.Link_to_Vector;
                     inc : in Vectors.Link_to_Vector );

  -- DESCRIPTION :
  --   Adds the elements in inc to the values.

  -- REQUIRED : values'range = inc'range.

  procedure Multiply ( first,second,product : in Vectors.Link_to_Vector );

  -- DESCRIPTION :
  --   Convolutes the vectors first and second into the product,
  --   corresponding to the multiplication of two series of the same degree.

  -- REQUIRED : first'last = second'last = product'last.

-- PLAIN EVALUATION AT A NUMBER :

  function Eval ( c : Circuit; x : Vectors.Vector ) return Ring.number;
  function Eval ( c : Link_to_Circuit; x : Vectors.Vector ) return Ring.number;
  function Eval ( c : Circuits; x : Vectors.Vector ) return Vectors.Vector;

  -- DESCRIPTION :
  --   Returns the evaluation of c at the number x,
  --   via a straighforward sum of evaluated terms, at t = 0,
  --   only considering the leading coefficients of power series.

  function Eval ( c : Circuit; x : Vectors.Vector;
                  t : Ring.number ) return Ring.number;
  function Eval ( c : Link_to_Circuit; x : Vectors.Vector;
                  t : Ring.number ) return Ring.number;
  function Eval ( c : Circuits; x : Vectors.Vector;
                  t : Ring.number ) return Vectors.Vector;

  -- DESCRIPTION :
  --   Returns the evaluation of c at the number x and t for the series
  --   parameter via a straighforward sum of evaluated terms.

-- SECOND DERIVATIVE AT A NUMBER :

  function Diff ( x : Vectors.Vector;
                  e : Standard_Integer_Vectors.Vector; i,j : integer32 )  
                return Ring.number;

  -- DESCRIPTION :
  --   Returns the value of the second derivative of the monomial
  --   with exponents in e, with respect to i and j, evaluated at x.

  -- REQUIRED : i is in e'range and j is in e'range, 
  --   i and j can be the same if the second derivative
  --   with the same i is requested.

  function Diff ( c : Circuit; x : Vectors.Vector; i,j : integer32 )  
                return Ring.number;

  -- DESCRIPTION :
  --   Returns the value of the second derivative of the monomials
  --   with exponents in c, with respect to i and j, evaluated at x.

  -- REQUIRED : i is in e'range and j is in e'range, 
  --   i and j can be the same if the second derivative
  --   with the same i is requested.

-- REVERSE MODE OF ALGORITHMIC DIFFERENTIATION :

  procedure Speel ( x : in VecVecs.VecVec;
                    forward,backward,cross : in VecVecs.VecVec );
  procedure Speel ( x : in VecVecs.VecVec;
                    idx : in Standard_Integer_Vectors.Vector;
                    forward,backward,cross : in VecVecs.VecVec );

  -- DESCRIPTION :
  --   Inline computation of the coefficients of the product
  --   of the series in x, which are all of the same degree.

  -- REQUIRED :
  --   The range of x starts at 1 and ends at 2 or a larger value.
  --   All vectors in x, forward, backward, and cross are allocated
  --   and of the range 0..degree, for some same fixed degree.

  -- ON ENTRY :
  --   x            a vector with range starting at 1, ending at 2 or higher;
  --   idx          if provided, then only those indices of x with values
  --                in idx participate and dim = idx'last,
  --                otherwise, all values of x participate and dim = x'last;
  --   forward      has space allocated for dim-1 coefficient vectors,
  --                for series of the same fixed degree;
  --   backward     has space reserved for dim-2 coefficient vectors,
  --                for series of the same fixed degree;
  --   cross        has space reserved for dim-2 coefficient vectors,
  --                for series of the same fixed degree.

  -- ON RETURN :
  --   forward      accumulates the forward products,
  --                forward(dim-1) holds the coefficients for the product,
  --                forward(dim-2) holds the coefficients for the value
  --                of the last partial derivative in x;
  --   backward     accumulates the backward products,
  --                backward(dim-2) holds the coefficients of the first
  --                partial derivative of the product;
  --   cross        stores the cross products, cross(k) contains the
  --                coefficients of the partial derivative w.r.t. k+1.

  procedure Speel ( idx : in Standard_Integer_VecVecs.VecVec;
                    x : in VecVecs.VecVec;
                    forward,backward,cross,yd : in VecVecs.VecVec );
  procedure Speel ( idx : in Standard_Integer_VecVecs.VecVec;
                    cff : in VecVecs.VecVec; x : in VecVecs.VecVec;
                    forward,backward,cross,yd : in VecVecs.VecVec;
                    wrk : in Vectors.Link_to_Vector );

  -- DESCRIPTION :
  --   Evaluation and differentiation of the sum of products,
  --   given in indexed format at a power series.

  -- ON ENTRY :
  --   idx          indexed representation of a sum of products of variables;
  --   cff          coefficients of the products, if not provided,
  --                then all coefficients are considered as one;
  --   x            coefficient vectors of power series of same degree;
  --   forward      work space allocated for x'last-1 coefficient vectors
  --                of the same fixed degree as the series in x;
  --   backward     work space allocated for x'last-2 coefficient vectors
  --                of the same fixed degree as the series in x;
  --   cross        work space allocated for x'last-2 coefficient vectors
  --                of the same fixed degree as the series in x;
  --   yd           vector of range 0..x'last with space allocated for the
  --                coefficients of power series of the same fixed degree;
  --   wrk          work space for the coefficients of the same fixed degree.

  -- ON RETURN :
  --   yd           yd(x'last+1) contains the coefficient vector of the value
  --                of the sum of products, evaluated at x,
  --                yd(k) is the k-th partial derivative at x.

  procedure Multiply_Factor
                  ( xpk,facidx : in Standard_Integer_Vectors.Link_to_Vector;
                    x : in VecVecs.VecVec;
                    cff,wrk,acc : in Vectors.Link_to_Vector;
                    pwt : in Link_to_VecVecVec );

  -- DESCRIPTION :
  --   Multiplies the coefficient with the common factor.

  -- REQUIRED : facidx /= null.

  -- ON ENTRY :
  --   xpk          k-th exponent vector;
  --   facidx       factor index of k-th exponents in xpk;
  --   x            values for the variables;
  --   cff          coefficient of the monomial;
  --   wrk          allocated space for coefficients of series of same degree;
  --   acc          allocated space for coefficients of series of same degree;
  --   pwt          the power table of the values in x.

  -- ON RETURN :
  --   acc          accumulates the product of the coefficients with
  --                the evaluated powers of x as defined by xpk and
  --                the factor index in facidx.

  procedure Multiply_Power
                  ( multiplier : in integer32;
                    cff : in Vectors.Link_to_Vector ); 

  -- DESCRIPTION :
  --   Multiplies the coefficients of the power series with multiplier.

  -- ON ENTRY:
  --   multiplier   is the multiplier exponent;
  --   cff          coefficients of a power series.

  -- ON RETURN :
  --   cff          coefficients multiplied with multiplier.

  procedure Speel ( xps,idx,fac : in Standard_Integer_VecVecs.VecVec;
                    cff : in VecVecs.VecVec; x : in VecVecs.VecVec;
                    forward,backward,cross,yd : in VecVecs.VecVec;
                    wrk,acc : in Vectors.Link_to_Vector;
                    pwt : in Link_to_VecVecVec );

  -- DESCRIPTION :
  --   Evaluation and differentiation of a polynomial,
  --   given in indexed format at a power series.

  -- ON ENTRY :
  --   xps          exponent vector of the monomials;
  --   idx          indexed representation of the variables in exponents;
  --   fac          factor index of the exponents;
  --   cff          coefficients of the products, if not provided,
  --                then all coefficients are considered as one;
  --   x            coefficient vectors of power series of same degree;
  --   forward      work space allocated for x'last-1 coefficient vectors
  --                of the same fixed degree as the series in x;
  --   backward     work space allocated for x'last-2 coefficient vectors
  --                of the same fixed degree as the series in x;
  --   cross        work space allocated for x'last-2 coefficient vectors
  --                of the same fixed degree as the series in x;
  --   yd           vector of range 1..x'last+1 with space allocated for the
  --                coefficients of power series of the same fixed degree;
  --   wrk          work space for the coefficients of the same fixed degree;
  --   acc          work space for the coefficients of the same fixed degree;
  --   pwt          power table of the values in x.

  -- ON RETURN :
  --   yd           yd(x'last+1) contains the coefficient vector of the value
  --                of the sum of products, evaluated at x,
  --                yd(k) is the k-th partial derivative at x.

  procedure EvalDiff ( c : in Circuit; x : in VecVecs.VecVec;
                       pwt : in Link_to_VecVecVec; yd : in VecVecs.VecVec );

  -- DESCRIPTION :
  --   Wraps the Speel procedure for the convolution circuit c,
  --   to evaluate at x, with the aid of the power table pwt.
  --   The result is placed in yd.

  procedure EvalDiff ( c : in Circuits; x : in VecVecs.VecVec;
                       pwt : in Link_to_VecVecVec; yd : in VecVecs.VecVec;
                       vy : in VecVecs.VecVec; vm : in VecMats.VecMat );

  -- DESCRIPTION :
  --   Evaluates and differentiates the convolution circuits in c at x.

  -- ON ENTRY :
  --   c            an array of convolution circuits;
  --   x            coefficient vectors of power series of same degree;
  --   pwt          power table of the values in x.
  --   yd           work space of range 1..x'last+1 to contain the
  --                gradient and the value of the circuits in c;
  --   vy           allocated space for the values of the circuits at x,
  --                done by the above procedure Linearized_Allocation,
  --   vm           space allocated for a series of some fixed degree
  --                with matrix coefficients.

  -- ON RETURN :
  --   vy           values of the circuits at x, in linearized form;
  --   vm           the evaluated circuits at x as a series 
  --                of some fixe degree with matrix coefficients.

  procedure Delinearize ( vy,yv : in VecVecs.VecVec );

  --  DESCRIPTION :
  --    Converts the linearized representation in vy into the vector yv
  --    of coefficient vectors of the series.
  --    This conversion is convenient for the difference computation
  --    and needed in the application of Newton's method.

  -- REQUIRED :
  --   if vy'range = 0..degree and vy(k)'range = 1..dimension,
  --   then yv'range = 1..dimension and yv(k)'range = 0..degree.

  procedure EvalDiff ( s : in System; x : in VecVecs.VecVec );
  procedure EvalDiff ( s : in Link_to_System; x : in VecVecs.VecVec );

  -- DESCRIPTION :
  --   Wraps the EvalDiff on the convolution circuits in s.crc.

  -- REQUIRED :
  --   All data in s are allocated properly with respect to dimension
  --   and degree, the power table s.pwt is up to data with the given x.

end Generic_Speelpenning_Convolutions;
