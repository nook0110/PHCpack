with text_io;                            use text_io;
with Communications_with_User;           use Communications_with_User;
with Test_Standard_Linearization;
with Test_DoblDobl_Linearization;
with Test_TripDobl_Linearization;
with Test_QuadDobl_Linearization;
with Test_PentDobl_Linearization;
with Test_OctoDobl_Linearization;
with Test_DecaDobl_Linearization;
with Test_HexaDobl_Linearization;

procedure ts_cserlin is

-- DESCRIPTION :
--   Tests the linearization of solving linear systems of truncated series.

  procedure Main is

  -- DESCRIPTION :
  --   Prompts for the precision and then runs tests.

    ans : character;

  begin
    new_line;
    put_line("MENU to select the working precision :");
    put_line("  0. double precision");
    put_line("  1. double double precision");
    put_line("  2. triple double precision");
    put_line("  3. quad double precision");
    put_line("  4. penta double precision");
    put_line("  5. octo double precision");
    put_line("  6. deca double precision");
    put_line("  7. hexa double precision");
    put("Type 0, 1, 2, 3, 4, 5, 6, or 7 to select the precision : ");
    Ask_Alternative(ans,"01234567");
    case ans is
      when '0' => Test_Standard_Linearization.Main;
      when '1' => Test_DoblDobl_Linearization.Main;
      when '2' => Test_TripDobl_Linearization.Main;
      when '3' => Test_QuadDobl_Linearization.Main;
      when '4' => Test_PentDobl_Linearization.Main;
      when '5' => Test_OctoDobl_Linearization.Main;
      when '6' => Test_DecaDobl_Linearization.Main;
      when '7' => Test_HexaDobl_Linearization.Main;
      when others => null;
    end case;
  end Main;

begin
  Main;
end ts_cserlin;
