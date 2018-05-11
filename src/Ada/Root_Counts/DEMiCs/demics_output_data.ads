with Standard_Integer_Numbers;        use Standard_Integer_Numbers;
with Standard_Floating_Numbers;       use Standard_Floating_Numbers;
with Standard_Integer_Vectors;
with Standard_Floating_VecVecs;
with Lists_of_Strings;

package DEMiCs_Output_Data is

-- DESCRIPTION :
--   This package stores the output data computed by DEMiCs.

  procedure Initialize_Lifting
              ( crdsup : in Standard_Integer_Vectors.Vector );

  -- DESCRIPTION :
  --   Allocates memory for the lifting values,
  --   given in crdsup(i) the number of points in the i-th support.

  procedure Assign_Lifting 
              ( idxsup,idxpnt : in integer32; val : in double_float );

  -- DESCRIPTION :
  --   Assigns the point with index idxpnt in support idxsup
  --   the lifting value equal to val.

  -- REQUIRED : Initialized_Lifting() was executed and both idxsup
  --   and idxpnt are in valid ranges.

  function Retrieve_Lifting
             ( idxsup,idxpnt : integer32) return double_float;

  -- DESCRIPTION :
  --   Returns the lifting value of the point with index idxpnt
  --   in the support with index idxsup.

  -- REQUIRED : Initialized_Lifting() was executed and both idxsup
  --   and idxpnt are in valid ranges.

  function Lifting_Values return Standard_Floating_VecVecs.Link_to_VecVec;

  -- DESCRIPTION :
  --   Returns the stored lifting values.

  procedure Add_Cell_Indices ( strcell : in string );

  -- DESCRIPTION :
  --   Adds the string representation of a cell,
  --   as defined by its indices.

  function Retrieve_Cell_Indices return Lists_of_Strings.List;

  -- DESCRIPTION :
  --   Returns list of the cell indices accumulated
  --   by the application of the Add_Cell_Indices procedure.

  procedure Clear_Lifting;

  -- DESCRIPTION :
  --   Deallocates the memory for the lifting values.

  procedure Clear_Cell_Indices;

  -- DESCRIPTION :
  --   Deallocates the memory occupied by the cell indices.

end DEMiCs_Output_Data;
