with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Complex_Solutions;
with DoblDobl_Complex_Solutions;
with QuadDobl_Complex_Solutions;

package Interactive_Pade_Trackers is

-- DESCRIPTION :
--   An interactive path tracker prompts the user to continue
--   after each new step on the solution path.

  procedure Standard_Loop
              ( sols : in out Standard_Complex_Solutions.Solution_List );

  -- DESCRIPTION :
  --   With the homotopy initialized properly,
  --   runs the step-by-step tracker, starting at the solutions in sols,
  --   in standard double precision.

  procedure DoblDobl_Loop
              ( sols : in out DoblDobl_Complex_Solutions.Solution_List );

  -- DESCRIPTION :
  --   With the homotopy initialized properly,
  --   runs the step-by-step tracker, starting at the solutions in sols,
  --   in double double precision.

  procedure QuadDobl_Loop
              ( sols : in out QuadDobl_Complex_Solutions.Solution_List );

  -- DESCRIPTION :
  --   With the homotopy initialized properly,
  --   runs the step-by-step tracker, starting at the solutions in sols,
  --   in quad double precision.

  procedure Standard_Main ( verbose : in integer32 := 0 );

  -- DESCRIPTION :
  --   Allows the user to tune the homotopy continuation parameters,
  --   prompts for a target, start system, and start solutions,
  --   in standard double precision.
  --   The level of verbosity is defined by the value of verbose.

  procedure DoblDobl_Main ( verbose : in integer32 := 0 );

  -- DESCRIPTION :
  --   Allows the user to tune the homotopy continuation parameters,
  --   prompts for a target, start system, and start solutions,
  --   in double double precision.
  --   The level of verbosity is defined by the value of verbose.

  procedure QuadDobl_Main ( verbose : in integer32 := 0 );

  -- DESCRIPTION :
  --   Allows the user to tune the homotopy continuation parameters,
  --   prompts for a target, start system, and start solutions,
  --   in quad double precision.
  --   The level of verbosity is defined by the value of verbose.

end Interactive_Pade_Trackers;
