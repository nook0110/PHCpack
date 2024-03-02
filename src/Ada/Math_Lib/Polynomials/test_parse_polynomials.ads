with text_io;                          use text_io;
with String_Splitters;                 use String_Splitters;
with Standard_Natural_Numbers;         use Standard_Natural_Numbers;

package Test_Parse_Polynomials is

-- DESCRIPTION :
--   Tests the parsing of strings into polynomials.

  procedure Parse_Standard_Number;

  -- DESCRIPTION :
  --   Prompts for a string an extracts the complex number
  --   from the string in double precision.

  procedure Parse_Multiprecision_Number;

  -- DESCRIPTION :
  --   Prompts for the size of the number, a string,
  --   and then extract the complex number from the string
  --   in the precision of the given size.

  procedure Parse_Standard_Polynomial;

  -- DESCRIPTION :
  --   Prompts for a string, the number of variables, and then
  --   parses the string for a polynomial using double precision
  --   to compute the coefficients.

  procedure Parse_DoblDobl_Polynomial;

  -- DESCRIPTION :
  --   Prompts for a string, the number of variables, and then
  --   parses the string for a polynomial using double double precision
  --   to compute the coefficients.

  procedure Parse_QuadDobl_Polynomial;

  -- DESCRIPTION :
  --   Prompts for a string, the number of variables, and then
  --   parses the string for a polynomial using quad double precision
  --   to compute the coefficients.

  procedure Parse_Multprec_Polynomial;

  -- DESCRIPTION :
  --   Prompts for a string, the number of variables, 
  --   the size of the numbers, and then parses the string 
  --   for a polynomial using multiprecision to compute the coefficients.

  procedure Parse_Standard_Laurent_Polynomial;

  -- DESCRIPTION :
  --   Prompts for a string, the number of variables,
  --   and then parses the string for a Laurent polynomial,
  --   with complex coefficients in double precision.

  procedure Parse_DoblDobl_Laurent_Polynomial;

  -- DESCRIPTION :
  --   Prompts for a string, the number of variables,
  --   and then parses the string for a Laurent polynomial,
  --   with complex coefficients in double double precision.

  procedure Parse_QuadDobl_Laurent_Polynomial;

  -- DESCRIPTION :
  --   Prompts for a string, the number of variables,
  --   and then parses the string for a Laurent polynomial,
  --   with complex coefficients in quad double precision.

  procedure Parse_Multprec_Laurent_Polynomial;

  -- DESCRIPTION :
  --   Prompts for a string, the number of variables,
  --   the size of the numbers, and then parses the string 
  --   for a Laurent polynomial, with complex coefficients
  --   in multiprecision.

  procedure Parse_String_from_System;

  -- DESCRIPTION :
  --   Prompts the user for a system from file,
  --   converts the system into a string and then parses it.

  function Scan_for_Delimiter 
             ( file : in file_type; d : in character ) return string;

  -- DESCRIPTION :
  --   Scans the file for characters until d is met, or end_of_file.
  --   The string on return contains all character read from file,
  --   the deliminter d included.

  procedure Parse_String_from_File;

  -- DESCRIPTION :
  --   Prompts the user for a file name and then stores the system
  --   from file into a string for parsing.

  procedure Read_Strings
              ( n,m : out natural32; p : out Link_to_Array_of_Strings );

  -- DESCRIPTION :
  --   Reads from file n strings with polynomials in m variables,
  --   stored in p on return.

  procedure Parse_Standard_Complex_Strings_from_File;

  -- DESCRIPTION :
  --   Reads strings from file and parses the strings into
  --   a polynomial system with complex coefficients
  --   in double precision.
   
  procedure Parse_Standard_Laurent_Strings_from_File;

  -- DESCRIPTION :
  --   Reads strings from file and parses the strings into
  --   a Laurent polynomial system with complex coefficients
  --   in double precision.

  procedure Parse_Multprec_Complex_Strings_from_File;

  -- DESCRIPTION :
  --   Reads strings from file, prompts for the size of the numbers,
  --   and parses the strings into a polynomial system with complex
  --   coefficients in multiprecision.

  procedure Parse_Multprec_Laurent_Strings_from_File;

  -- DESCRIPTION :
  --   Reads strings from file, prompts for the size of the numbers,
  --   and parses the strings into a Laurent polynomial system
  --   with complex coefficients in multiprecision.

  procedure Main;

  -- DESCRIPTION :
  --   Runs the test after receiving the prompt from a menu.

end Test_Parse_Polynomials;
