with Standard_Integer_Numbers;          use Standard_Integer_Numbers;
with C_Integer_Arrays;                  use C_Integer_Arrays;

package Multprec_LaurSys_Interface is

-- DESCRIPTION :
--   The functions below define the interface to the container of
--   Laurent polynomials with multiprecision coefficients.
--   The integer returned by all functions should be zero if the job
--   was successful, otherwise the nonzero job code is returned.

  function Multprec_LaurSys_Read
             ( vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Prompts the user for a Laurent polynomial system with multiprecision
  --   coefficients and initializes the container with the system.
  --   The verbose level is given in vrblvl.

  function Multprec_LaurSys_Write
             ( vrblvl : in integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Writes the Laurent polynomial system with multiprecision coefficients
  --   to the defined output file or to screen.
  --   The verbose level is given in vrblvl.
 
  function Multprec_LaurSys_Get_Dimension
             ( a : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Returns the dimension of the Laurent polynomial system
  --   with multiprecision coefficients.

  -- ON ENTRY :
  --   vrblvl  the verbose level.

  -- ON RETURN :
  --   a       the number of Laurent polynomials
  --           with multiprecision coefficients.

  function Multprec_LaurSys_Set_Dimension
             ( a : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Initializes the number of Laurent polynomials with multiprecision
  --   coefficients and initializes the symbol table as well.

  -- ON ENTRY :
  --   a       the dimension of the Laurent polynomial system;
  --   vrblvl  the verbose level.

  function Multprec_LaurSys_Size
             ( a : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Returns the number of terms of a Laurent polynomial
  --   with multiprecision coefficients.

  -- ON ENTRY :
  --   a       a[1] is the index of a Laurent polynomial;
  --   vrblvl  the verbose level.

  -- ON RETURN :
  --   a       a[0] is the number of terms of a Laurent polynomial 
  --           stored in multiprecision with index in a[1].

  function Multprec_LaurSys_Clear
             ( vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Clears all Laurent polynomials with multiprecision coefficients.
  --   The verbose level is given in vrblvl.

end Multprec_LaurSys_Interface;
