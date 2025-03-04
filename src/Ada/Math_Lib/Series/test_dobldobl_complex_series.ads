with Standard_Integer_Numbers;          use Standard_Integer_Numbers;

package Test_DoblDobl_Complex_Series is

-- DESCRIPTION :
--   Test on series with complex coefficients in double double precision.

  procedure DoblDobl_Construct;

  -- DESCRIPTION :
  --   Basic test on the construction of a series.

  procedure DoblDobl_Test_Creation ( degree : in integer32 );

  -- DESCRIPTION :
  --   Verifies that 1/(1-t) = 1 + t + t^2 + ...
  --   for a truncated power series with coefficients
  --   on variable degree series.

  procedure DoblDobl_Test_Arithmetic ( degree : in integer32 );

  -- DESCRIPTION :
  --   Does a basic test on the arithmetic,
  --   on random series of the given degree.

  procedure DoblDobl_Random_Test_sqrt ( degree : in integer32 );

  -- DESCRIPTION :
  --   Generates a random series of the given degree
  --   and tests the square root computation.

  procedure DoblDobl_Random_Test_root ( degree : in integer32 );

  -- DESCRIPTION :
  --   Generates a random series of the given degree
  --   and tests the square root computation.

  procedure DoblDobl_Random_Test_Poly_Root ( degree : in integer32 );

  -- DESCRIPTION :
  --   Tests the series expansion of the given degree 
  --   of a root of a random polynomial.

  procedure DoblDobl_Test_Conjugate ( degree : in integer32 );

  -- DESCRIPTION :
  --   Generates a random series of the given degree
  --   and makes the product with its conjugate.

  procedure DoblDobl_Test_Norm ( degree : in integer32 );

  -- DESCRIPTION :
  --   Generates a random series of the given degree and computes its norm.

  procedure DoblDobl_Test_Shift ( degree : in integer32 );

  -- DESCRIPTION :
  --   Does a basic test on shifting the series parameter
  --   on random series of the given degree.

  procedure DoblDobl_Test_Power ( degree : in integer32 );

  -- DESCRIPTION :
  --   Tests the computation of powers on series of the given degree.

  procedure DoblDobl_Test_Transform ( degree : in integer32 );

  -- DESCRIPTION :
  --   Tests the coefficient modulus transform on series of the given degree.

  procedure Main;

  -- DESCRIPTION :
  --   Displays a menu and prompts for a test.

end Test_DoblDobl_Complex_Series;
