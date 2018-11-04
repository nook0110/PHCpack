with text_io;                           use text_io;
with DoblDobl_Complex_Vector_Series;    use DoblDobl_Complex_Vector_Series;

package DoblDobl_Complex_Vector_Series_io is

-- DESCRPTION :
--   Provides very basic output for series with vector coefficients.

  procedure put ( v : in Vector );
  procedure put ( file : in file_type; v : in Vector );

  -- DESCRIPTION :
  --   Writes the coefficients of the vector series v to standard output,
  --   or to file.  The coefficients are separated by a new line.

end DoblDobl_Complex_Vector_Series_io;
