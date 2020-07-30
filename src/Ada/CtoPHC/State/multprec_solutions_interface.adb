with text_io;                           use text_io;
with Interfaces.C;
with Standard_Natural_Numbers;          use Standard_Natural_Numbers;
with Multprec_Floating_Numbers;
with Multprec_Complex_Polynomials_io;
with Multprec_Complex_Poly_Systems;
with Multprec_Complex_Solutions;
with Multprec_Complex_Solutions_io;
with Multprec_System_and_Solutions_io;
with Assignments_in_Ada_and_C;          use Assignments_in_Ada_and_C;
with PHCpack_Operations;
with Multprec_PolySys_Container;
with Multprec_Solutions_Container;

package body Multprec_Solutions_Interface is

  function Multprec_Solutions_Read 
             ( vrblvl : integer32 := 0 ) return integer32 is

    sols : Multprec_Complex_Solutions.Solution_List;

  begin
    if vrblvl > 0 then
      put("-> in Multprec_Solutions_interface.");
      put_line("Multprec_Solutions_Read ...");
    end if;
    Multprec_Complex_Solutions_io.Read(sols);
    Multprec_Solutions_Container.Initialize(sols);
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in Multprec_Solutions_interface.");
        put_line("Multprec_Solutions_Read.");
      end if;
      return 450;
  end Multprec_Solutions_Read;

  function Multprec_System_Solutions_Read_from_File
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32 is

    use Interfaces.C;

    v_a : constant C_Integer_Array
        := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(2));
    nc : constant natural := natural(v_a(v_a'first));
    nbdeci : constant natural32 := natural32(v_a(v_a'first+1));
    vb : constant C_Integer_Array(0..Interfaces.C.size_t(nc))
       := C_Intarrs.Value(b,Interfaces.C.ptrdiff_t(nc+1));
    sv : constant String(1..nc) := C_Integer_Array_to_String(natural32(nc),vb);
    size : constant natural32
         := Multprec_Floating_Numbers.Decimal_to_Size(nbdeci);

  begin
    if vrblvl > 0 then
      put("-> in multprec_solutions_interface.");
      put_line("Multprec_System_Solutions_Read_from_File ...");
    end if;
    Multprec_Complex_Polynomials_io.Set_Working_Precision(size);
   -- new_line;
   -- put_line("Opening the file with name " & sv & " ...");
    declare
      file : file_type;
      p : Multprec_Complex_Poly_Systems.Link_to_Poly_Sys;
      sols : Multprec_Complex_Solutions.Solution_List;
    begin
      Open(file,in_file,sv);
      Multprec_System_and_Solutions_io.get(file,p,sols);
      Multprec_PolySys_Container.Clear;
      Multprec_PolySys_Container.Initialize(p.all);
      Multprec_Solutions_Container.Clear;
      Multprec_Solutions_Container.Initialize(sols);
      exception 
        when NAME_ERROR =>
          put_line("File with name " & sv & " could not be found!");
          return 547;
        when USE_ERROR =>
          put_line("File with name " & sv & " could not be read!");
          return 547;
    end;
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in multprec_solutions_interface.");
        put_line("Multprec_System_Solutions_Read_from_file.");
      end if;
      return 547;
  end Multprec_System_Solutions_Read_from_File;

  function Multprec_Solutions_Write
             ( vrblvl : integer32 := 0 ) return integer32 is

    use Multprec_Complex_Solutions;
    use Multprec_Complex_Solutions_io;

    sols : constant Solution_List := Multprec_Solutions_Container.Retrieve;

  begin
    if vrblvl > 0 then
      put("-> in Multprec_Solutions_interface.");
      put_line("Multprec_Solutions_Write ...");
    end if;
    if not Is_Null(sols) then
      if PHCpack_Operations.Is_File_Defined then
        put(PHCpack_Operations.output_file,
            Length_Of(sols),natural32(Head_Of(sols).n),sols);
      else
        put(standard_output,Length_Of(sols),natural32(Head_Of(sols).n),sols);
      end if;
    end if;
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in Multprec_Solutions_interface.");
        put_line("Multprec_Solutions_Write.");
      end if;
      return 451;
  end Multprec_Solutions_Write;

  function Multprec_Solutions_Size 
             ( b : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32 is
  begin
    if vrblvl > 0 then
      put("-> in Multprec_Solutions_interface.");
      put_line("Multprec_Solutions_Size ...");
    end if;
    Assign(integer32(Multprec_Solutions_Container.Length),b);
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in Multprec_Solutions_interface.");
        put_line("Multprec_Solutions_Size.");
      end if;
      return 452;
  end Multprec_Solutions_Size;

  function Multprec_Solutions_Dimension
             ( b : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32 is
  begin
    if vrblvl > 0 then
      put("-> in Multprec_Solutions_interface.");
      put_line("Multprec_Solutions_Dimension ...");
    end if;
    Assign(integer32(Multprec_Solutions_Container.Dimension),b);
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in Multprec_Solutions_interface.");
        put_line("Multprec_Solutions_Dimension.");
      end if;
      return 453;
  end Multprec_Solutions_Dimension;

  function Multprec_Solutions_Clear
             ( vrblvl : integer32 := 0 ) return integer32 is
  begin
    if vrblvl > 0 then
      put("-> in Multprec_Solutions_interface.");
      put_line("Multprec_Solutions_Clear ...");
    end if;
    Multprec_Solutions_Container.Clear;
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in Multprec_Solutions_interface.");
        put_line("Multprec_Solutions_Clear.");
      end if;
      return 457;
  end Multprec_Solutions_Clear;

end Multprec_Solutions_Interface;
