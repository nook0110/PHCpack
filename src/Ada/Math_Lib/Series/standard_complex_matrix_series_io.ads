with text_io;                           use text_io;
with Standard_Complex_Matrix_Series;    use Standard_Complex_Matrix_Series;

package Standard_Complex_Matrix_Series_io is

-- DESCRPTION :
--   Provides very basic output for series with matrix coefficients.

  procedure put ( A : in Matrix );
  procedure put ( file : in file_type; A : in Matrix );

  -- DESCRIPTION :
  --   Writes the coefficients of the Matrix series A to standard output,
  --   or to file.  The matrix coefficients are separated by a new line.

end Standard_Complex_Matrix_Series_io;
