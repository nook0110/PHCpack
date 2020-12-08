with Ada.Calendar;
with Time_Stamps;
with Communications_with_User;           use Communications_with_User;
with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Standard_Integer_Numbers_io;        use Standard_Integer_Numbers_io;
with Standard_Floating_Numbers;          use Standard_Floating_Numbers;
with Standard_Floating_Numbers_io;       use Standard_Floating_Numbers_io;
with Triple_Double_Numbers;              use Triple_Double_Numbers;
with TripDobl_Complex_Numbers;
with TripDobl_Complex_Numbers_io;        use TripDobl_Complex_Numbers_io;
with TripDobl_Random_Numbers;
with Standard_Integer_Vectors;
with TripDobl_Complex_VecVecs;
with TripDobl_Complex_VecVecs_io;        use TripDobl_Complex_VecVecs_io;
with TripDobl_Complex_Polynomials;
with TripDobl_Complex_Poly_Systems;
with TripDobl_Complex_Poly_Systems_io;   use TripDobl_Complex_Poly_Systems_io;
with TripDobl_System_and_Solutions_io;
with TripDobl_Homotopy;
with Standard_Parameter_Systems;
with Solution_Drops;
with TripDobl_Homotopy_Convolutions_io;
with TripDobl_Newton_Convolutions;
with TripDobl_Newton_Convolution_Steps;
with Convergence_Radius_Estimates;
with Fabry_on_Homotopy_Helpers;
with Multitasked_Power_Newton;

package body TripDobl_Fabry_on_Homotopy is

  procedure Newton_Fabry
              ( cfs : in TripDobl_Speelpenning_Convolutions.Link_to_System;
                sol : in TripDobl_Complex_Vectors.Vector ) is

    dim : constant integer32 := sol'last;
    deg : constant integer32 := cfs.deg;
    scf : constant TripDobl_Complex_VecVecs.VecVec(1..dim)
        := TripDobl_Newton_Convolutions.Series_Coefficients(sol,deg);
    maxit : integer32 := deg/2;
    nbrit,nbtasks,info : integer32 := 0;
    tol : double_float := 1.0E-20;
    ipvt : Standard_Integer_Vectors.Vector(1..dim);
    wrk : TripDobl_Complex_Vectors.Link_to_Vector
        := new TripDobl_Complex_Vectors.Vector(1..dim); -- dim = #equations
    fail,verbose : boolean;
    absdx,rcond,rad,err : triple_double;
    scale : constant boolean := false;
    zpt : TripDobl_Complex_Numbers.Complex_Number;

  begin
    Fabry_on_Homotopy_Helpers.Prompt_for_Parameters(maxit,tol,verbose);
    new_line;
    put("Give the number of tasks (0 for no multitasking) : "); get(nbtasks);
    if verbose then
      if nbtasks = 0 then
        TripDobl_Newton_Convolution_Steps.LU_Newton_Steps
          (standard_output,cfs,scf,maxit,nbrit,tol,absdx,fail,rcond,
           ipvt,wrk,scale);
      else
        Multitasked_Power_Newton.TripDobl_Run
          (standard_output,nbtasks,dim,maxit,cfs,scf,tol,true,fail,
           info,nbrit,rcond,absdx);
      end if;
    else
      if nbtasks = 0 then
        TripDobl_Newton_Convolution_Steps.LU_Newton_Steps
          (cfs,scf,maxit,nbrit,tol,absdx,fail,rcond,ipvt,wrk,scale,false);
      else
        Multitasked_Power_Newton.TripDobl_Run
          (nbtasks,dim,maxit,cfs,scf,tol,true,fail,
           info,nbrit,rcond,absdx,false,false);
      end if;
    end if;
    put_line("The coefficients of the series : "); put_line(scf);
    Convergence_Radius_Estimates.Fabry
      (standard_output,scf,zpt,rad,err,fail,1,true);
    Fabry_on_Homotopy_Helpers.Write_Report(standard_output,rad,err,zpt,fail);
    TripDobl_Complex_Vectors.Clear(wrk);
  end Newton_Fabry;

  procedure Run ( nbequ,idxpar,deg : in integer32;
                  sols : in out TripDobl_Complex_Solutions.Solution_List ) is

    cvh : TripDobl_Speelpenning_Convolutions.Link_to_System;
    tmp : TripDobl_Complex_Solutions.Solution_List := sols;
    ls : TripDobl_Complex_Solutions.Link_to_Solution;
    ans : character;

  begin
    cvh := TripDobl_Homotopy_Convolutions_io.Make_Homotopy(nbequ,idxpar,deg);
    while not TripDobl_Complex_Solutions.Is_Null(tmp) loop
      ls := TripDobl_Complex_Solutions.Head_Of(tmp);
      Newton_Fabry(cvh,ls.v);
      put("Continue with the next solution ? (y/n) "); Ask_Yes_or_No(ans);
      exit when (ans /= 'y');
      tmp := TripDobl_Complex_Solutions.Tail_Of(tmp);
    end loop;
  end Run;

  procedure Run ( file : in file_type; nbequ,idxpar,deg : in integer32;
                  sols : in out TripDobl_Complex_Solutions.Solution_List ) is

    cvh : TripDobl_Speelpenning_Convolutions.Link_to_System;
    tmp : TripDobl_Complex_Solutions.Solution_List := sols;
    ls : TripDobl_Complex_Solutions.Link_to_Solution
       := TripDobl_Complex_Solutions.Head_Of(sols);
    dim : constant integer32 := ls.v'last;
    scf : TripDobl_Complex_VecVecs.VecVec(1..dim)
        := TripDobl_Newton_Convolutions.Series_Coefficients(ls.v,deg);
    maxit : integer32 := deg/2;
    tol : double_float := 1.0E-32;
    nbrit,nbtasks,info : integer32 := 0;
    ipvt : Standard_Integer_Vectors.Vector(1..dim);
    wrk : TripDobl_Complex_Vectors.Link_to_Vector
        := new TripDobl_Complex_Vectors.Vector(1..dim); -- dim = #equations
    fail,verbose : boolean;
    absdx,rcond,rad,err : triple_double;
    scale : constant boolean := false;
    zpt : TripDobl_Complex_Numbers.Complex_Number;
    tstart,tstop : Ada.Calendar.Time;
    cnt : integer32 := 0;

  begin
    Fabry_on_Homotopy_Helpers.Prompt_for_Parameters(maxit,tol,verbose);
    new_line;
    put("Give the number of tasks (0 for no multitasking) : "); get(nbtasks);
    if nbtasks = 0 then
      put_line(file,"no multitasking");
    else
      put(file,"number of tasks : "); put(file,nbtasks,1); new_line(file);
    end if;
    put(file,"maximum number of iterations : ");
    put(file,maxit,1); new_line(file);
    put(file,"tolerance :"); put(file,tol,3); new_line(file);
    new_line(file);
    new_line;
    put_line("See the output file for results ...");
    new_line;
    cvh := TripDobl_Homotopy_Convolutions_io.Make_Homotopy(nbequ,idxpar,deg);
    tstart := Ada.Calendar.Clock;
    loop
      if verbose then
        if nbtasks = 0 then
          TripDobl_Newton_Convolution_Steps.LU_Newton_Steps
            (file,cvh,scf,maxit,nbrit,tol,absdx,fail,rcond,ipvt,wrk,scale);
        else
          Multitasked_Power_Newton.TripDobl_Run
            (file,nbtasks,dim,maxit,cvh,scf,tol,true,fail,
             info,nbrit,rcond,absdx);
        end if;
      else
        if nbtasks = 0 then
          TripDobl_Newton_Convolution_Steps.LU_Newton_Steps
            (cvh,scf,maxit,nbrit,tol,absdx,fail,rcond,ipvt,wrk,scale,false);
        else
          Multitasked_Power_Newton.TripDobl_Run
            (nbtasks,dim,maxit,cvh,scf,tol,true,fail,
             info,nbrit,rcond,absdx,false,false);
        end if;
      end if;
      put(file,"The coefficients of the series for solution ");
      cnt := cnt + 1; put(file,cnt,1); put_line(file," :");
      put_line(file,scf);
      Convergence_Radius_Estimates.Fabry(file,scf,zpt,rad,err,fail,1,true);
      Fabry_on_Homotopy_Helpers.Write_Report(file,rad,err,zpt,fail);
      tmp := TripDobl_Complex_Solutions.Tail_Of(tmp);
      exit when TripDobl_Complex_Solutions.Is_Null(tmp);
      ls := TripDobl_Complex_Solutions.Head_Of(tmp);
      scf := TripDobl_Newton_Convolutions.Series_Coefficients(ls.v,deg);
    end loop;
    tstop := Ada.Calendar.Clock;
    new_line(file);
    Time_Stamps.Write_Elapsed_Time(file,tstart,tstop);
    TripDobl_Complex_Vectors.Clear(wrk);
    TripDobl_Speelpenning_Convolutions.Clear(cvh);
  end Run;

  procedure Artificial_Setup is

    target,start : TripDobl_Complex_Poly_Systems.Link_to_Poly_Sys;
    sols : TripDobl_Complex_Solutions.Solution_List;
    gamma : TripDobl_Complex_Numbers.Complex_Number;
    nbequ,nbvar,nbsols,deg : integer32 := 0;
    ans : character;
    tofile : boolean;
    outfile : file_type;

    use TripDobl_Complex_Polynomials;

  begin
    new_line;
    put_line("Reading the name of a file for the target system ...");
    get(target);
    nbequ := target'last;
    nbvar := integer32(Number_of_Unknowns(target(target'first)));
    new_line;
    put("Read "); put(nbequ,1); put(" polynomials in ");
    put(nbvar,1); put_line(" variables.");
    new_line;
    put_line
      ("Reading the name of a file for the start system and solutions ...");
    TripDobl_System_and_Solutions_io.get(start,sols);
    nbsols := integer32(TripDobl_Complex_Solutions.Length_Of(sols));
    if nbsols = 0 then
      put_line("No solutions read.");
    else
      nbvar := TripDobl_Complex_Solutions.Head_Of(sols).n;
      new_line;
      put("Read "); put(nbsols,1); put(" solutions in dimension ");
      put(nbvar,1); put_line(".");
      new_line;
      put("Output to file ? (y/n) "); Ask_Yes_or_No(ans);
      tofile := (ans = 'y');
      if tofile then
        new_line;
        put_line("Reading the name of the output file ...");
        Read_Name_and_Create_File(outfile);
        put(outfile,target'last); new_line(outfile);
        put(outfile,target.all);
        new_line(outfile);
        put_line(outfile,"THE START SYSTEM :");
        TripDobl_System_and_Solutions_io.put
          (outfile,start.all,sols,"THE START SOLUTIONS :");
      end if;
      new_line;
      put("Random gamma ? (y/n) "); Ask_Yes_or_No(ans);
      if ans = 'y'
       then gamma := TripDobl_Random_Numbers.Random1;
       else gamma := TripDobl_Complex_Numbers.Create(integer(1));
      end if;
      TripDobl_Homotopy.Create(target.all,start.all,1,gamma);
      new_line;
      put("Give the degree of the power series : "); get(deg);
      if not tofile then
        Run(nbequ,nbvar+1,deg,sols);
      else
        new_line(outfile);
        put(outfile,"gamma : "); put(outfile,gamma); new_line(outfile);
        put(outfile,"degree : "); put(outfile,deg,1); new_line(outfile);
        Run(outfile,nbequ,nbvar+1,deg,sols);
      end if;
    end if;
  end Artificial_Setup;

  procedure Natural_Setup is

    hom : TripDobl_Complex_Poly_Systems.Link_to_Poly_Sys;
    sols,dropsols : TripDobl_Complex_Solutions.Solution_List;
    nbequ,sysnbvar,solnbvar,nbsols,idxpar,deg : integer32 := 0;
    par : Standard_Integer_Vectors.Vector(1..1);
    ans : character;
    tofile : boolean;
    outfile : file_type;

    use TripDobl_Complex_Polynomials;

  begin
    new_line;
    put_line("Reading the name of a file for a homotopy ...");
    TripDobl_System_and_Solutions_io.get(hom,sols);
    nbequ := hom'last;
    sysnbvar := integer32(Number_of_Unknowns(hom(hom'first)));
    new_line;
    put("Read "); put(nbequ,1); put(" polynomials in ");
    put(sysnbvar,1); put_line(" variables.");
    nbsols := integer32(TripDobl_Complex_Solutions.Length_Of(sols));
    if nbsols = 0 then
      put_line("No solutions read.");
    else
      solnbvar := TripDobl_Complex_Solutions.Head_Of(sols).n;
      put("Read "); put(nbsols,1); put(" solutions in dimension ");
      put(solnbvar,1); put_line(".");
      new_line;
      par := Standard_Parameter_Systems.Define_Parameters(nbequ,sysnbvar,1);
      idxpar := par(1);
      put("The index to the continuation parameter : ");
      put(idxpar,1); new_line;
      if solnbvar = nbequ then
        put_line("Solution dimension is okay.");
      else
        put_line("Dropping one coordinate of each solution ...");
        dropsols := Solution_Drops.Drop(sols,natural32(idxpar));
      end if;
      new_line;
      put("Output to file ? (y/n) "); Ask_Yes_or_No(ans);
      tofile := (ans = 'y');
      if tofile then
        new_line;
        put_line("Reading the name of the output file ...");
        Read_Name_and_Create_File(outfile);
        if solnbvar = nbequ then
          TripDobl_System_and_Solutions_io.put
            (outfile,hom.all,sols,"THE START SOLUTIONS :");
        else
          TripDobl_System_and_Solutions_io.put
            (outfile,hom.all,dropsols,"THE START SOLUTIONS :");
        end if;
      end if;
      TripDobl_Homotopy.Create(hom.all,idxpar);
      new_line;
      put("Give the degree of the power series : "); get(deg);
      if not tofile then
        if solnbvar = nbequ
         then Run(nbequ,idxpar,deg,sols);
         else Run(nbequ,idxpar,deg,dropsols);
        end if;
      else
        new_line(outfile);
        put(outfile,"degree : "); put(outfile,deg,1); new_line(outfile);
        if solnbvar = nbequ
         then Run(outfile,nbequ,idxpar,deg,sols);
         else Run(outfile,nbequ,idxpar,deg,dropsols);
        end if;
      end if;
    end if;
  end Natural_Setup;

  procedure Main is

    ans : character;

  begin
    new_line;
    put("Artificial-parameter homotopy ? (y/n) "); Ask_Yes_or_No(ans);
    if ans = 'y'
     then Artificial_Setup;
     else Natural_Setup;
    end if;
  end Main;

end TripDobl_Fabry_on_Homotopy;
