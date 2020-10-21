with text_io;                            use text_io;
with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Floating_Numbers;          use Standard_Floating_Numbers;
with Double_Double_Numbers;              use Double_Double_Numbers;
with Quad_Double_Numbers;                use Quad_Double_Numbers;
with Standard_Integer_Vectors;
with Standard_Complex_Vectors;
with Standard_Complex_VecVecs;
with Standard_Complex_Matrices;
with Standard_Complex_VecMats;
with DoblDobl_Complex_Vectors;
with DoblDobl_Complex_VecVecs;
with DoblDobl_Complex_Matrices;
with DoblDobl_Complex_VecMats;
with QuadDobl_Complex_Vectors;
with QuadDobl_Complex_VecVecs;
with QuadDobl_Complex_Matrices;
with QuadDobl_Complex_VecMats;
with Standard_Complex_Vector_Series;
with DoblDobl_Complex_Vector_Series;
with QuadDobl_Complex_Vector_Series;

package Test_mtSeries_Linearization is

-- DESCRIPTION :
--   Tests the linearization of solving linear systems of truncated series
--   with multitasking.

  function Error ( xs : Standard_Complex_Vector_Series.Vector;
                   bscff : Standard_Complex_VecVecs.VecVec;
                   output : boolean := true ) return double_float;
  function Error ( xs : DoblDobl_Complex_Vector_Series.Vector;
                   bscff : DoblDobl_Complex_VecVecs.VecVec;
                   output : boolean := true ) return double_double;
  function Error ( xs : QuadDobl_Complex_Vector_Series.Vector;
                   bscff : QuadDobl_Complex_VecVecs.VecVec;
                   output : boolean := true ) return quad_double;

  -- DESCRIPTION :
  --   Returns the sum of all differences between the coefficients in xs
  --   and those in bscff.  If output, then the coefficient vectors are
  --   written to screen for both xs and bscff.

  function Compute_Speedup
             ( serial,multi : duration;
               verbose : boolean := false ) return duration;

  -- DESCRIPTION :
  --   On input are the elapsed serial and multitasked times.
  --   The speedup is computed if serial /= 0.0.
  --   If verbose, then the speedup is shown.

  procedure Show_Speedup
              ( nbt : in integer32; serial,multi : in duration );

  -- DESCRIPTION :
  --   On input are the elapsed serial and multitasked times,
  --   for a number of tasks equal to nbt.
  --   If serial /= 0.0, then the speedup and efficiency are shown.

  procedure Standard_Run
              ( nbt,neq,nvr : in integer32;
                vm : in Standard_Complex_VecMats.VecMat;
                vb : in Standard_Complex_VecVecs.VecVec;
                xs : in Standard_Complex_Vector_Series.Vector;
                mltelp,serelp : in out Duration;
                output,nbrotp,usesvd : in boolean );
  procedure DoblDobl_Run
              ( nbt,neq,nvr : in integer32;
                vm : in DoblDobl_Complex_VecMats.VecMat;
                vb : in DoblDobl_Complex_VecVecs.VecVec;
                xs : in DoblDobl_Complex_Vector_Series.Vector;
                mltelp,serelp : in out Duration;
                output,nbrotp,usesvd : in boolean );
  procedure QuadDobl_Run
              ( nbt,neq,nvr : in integer32;
                vm : in QuadDobl_Complex_VecMats.VecMat;
                vb : in QuadDobl_Complex_VecVecs.VecVec;
                xs : in QuadDobl_Complex_Vector_Series.Vector;
                mltelp,serelp : in out Duration;
                output,nbrotp,usesvd : in boolean );

  -- DESCRIPTION :
  --   Does a run with nbt tasks in double, double double,
  --   or quad double precision.
  --   Solves the linearized matrix series system defined by vm and vb.
  --   Prints the elapsed time and if defined, the speedup.
  --   Prints the difference between the computed and the generated solution.

  -- REQUIRED : neq >= nvr.

  -- ON ENTRY :
  --   nbt      the number of tasks is 1 or larger;
  --   neq      number of equations, number of rows in the matrices;
  --   nvr      number of variables, number of columns in the matrices;
  --   vm       matrices in the series equation;
  --   vb       right hand side vector of the equation;
  --   xs       the generated solution to the matrix series equation;
  --   serelp   the previous elapsed wall clock time of a serial run;
  --   mltelp   the previous elapsed wall clock time of a multitasked run;
  --   output   if true, the multitasked run is verbose, else silent;
  --   nbrotp   if true, all numbers are shown, else not;
  --   usesvd   if SVD has to be used when neq > nvr.

  -- ON RETURN :
  --   serelp   updated elapsed wall clock time of a serial run,
  --            if nbt = 1 and the user did not want multitasking;
  --   mltelp   updated elapsed wall clock time of a multitasked run,
  --            if nbt > 1.



  -- DESCRIPTION :
  --   Does a run with nbt tasks in double double precision.
  --   Solves the linearized matrix series system defined by vm and vb.
  --   Prints the elapsed time and if defined, the speedup.
  --   Prints the difference between the computed and the generated solution.

  -- ON ENTRY :
  --   nbt      the number of tasks is 1 or larger;
  --   neq      number of equations, number of rows in the matrices;
  --   nvr      number of variables, number of columns;
  --   vm       matrices in the series equation;
  --   vb       right hand side vector of the equation;
  --   xs       the generated solution to the matrix series equation;
  --   serelp   the previous elapsed wall clock time of a serial run;
  --   mltelp   the previous elapsed wall clock time of a multitasked run;
  --   output   if true, the multitasked run is verbose, else silent;
  --   nbrotp   if true, all numbers are shown, else not;
  --   usesvd   if SVD has to be used when neq > nvr.

  -- ON RETURN :
  --   serelp   updated elapsed wall clock time of a serial run,
  --            if nbt = 1 and the user did not want multitasking;
  --   mltelp   updated elapsed wall clock time of a multitasked run,
  --            if nbt > 1.

  procedure Prompt_for_Flags
              ( neq,nvr : in integer32; 
                nbrotp,otp,usesvd : out boolean );

  -- DESCRIPTION :
  --   Prompts the user for output flags and whether SVD has
  --   to be used when the number of equations is larger than
  --   the number of variables.

  -- ON ENTRY :
  --   neq      number of equations;
  --   nvr      number of variables.

  -- ON RETURN :
  --   nbropt   output of numbeers;
  --   opt      output during multitasking;
  --   usesvd   if SVD needs to be used when neq > nvr.

  procedure Standard_Test ( m,n,d : in integer32 );

  -- DESCRIPTION :
  --   Generates an m-by-n matrix of series of degree d,
  --   with complex coefficients and a solution of the same dimension
  --   and degree, in double precision,
  --   Prompts then the user for the number of tasks and runs the test.

  procedure DoblDobl_Test ( m,n,d : in integer32 );

  -- DESCRIPTION :
  --   Generates an m-by-n matrix of series of degree d,
  --   with complex coefficients and a solution of the same dimension
  --   and degree, in double double precision,
  --   Prompts then the user for the number of tasks and runs the test.

  procedure QuadDobl_Test ( m,n,d : in integer32 );

  -- DESCRIPTION :
  --   Generates an m-by-n matrix of series of degree d,
  --   with complex coefficients and a solution of the same dimension
  --   and degree, in quad double precision,
  --   Prompts then the user for the number of tasks.

  function to_double_double
             ( A : QuadDobl_Complex_Matrices.Matrix )
             return DoblDobl_Complex_Matrices.Matrix;

  -- DESCRIPTION :
  --   Returns the double double equivalent to the matrix A.

  function to_double
             ( A : QuadDobl_Complex_Matrices.Matrix )
             return Standard_Complex_Matrices.Matrix;

  -- DESCRIPTION :
  --   Returns the double precision equivalent to the matrix A.

  function to_double_double
             ( A : QuadDobl_Complex_VecMats.VecMat )
             return DoblDobl_Complex_VecMats.VecMat;

  -- DESCRIPTION :
  --   Converts every matrix in A to double double precision.

  function to_double
             ( A : QuadDobl_Complex_VecMats.VecMat )
             return Standard_Complex_VecMats.VecMat;

  -- DESCRIPTION :
  --   Converts every matrix in A to double precision.

  procedure Standard_Benchmark
              ( file : in file_type; n,nbruns,inc : in integer32;
                A : in Standard_Complex_VecMats.VecMat;
                b : in Standard_Complex_VecVecs.VecVec;
		verbose : in boolean := false );
  procedure DoblDobl_Benchmark
              ( file : in file_type; n,nbruns,inc : in integer32;
                A : in DoblDobl_Complex_VecMats.VecMat;
                b : in DoblDobl_Complex_VecVecs.VecVec;
                verbose : in boolean := false );
  procedure QuadDobl_Benchmark
              ( file : in file_type; n,nbruns,inc : in integer32;
                A : in QuadDobl_Complex_VecMats.VecMat;
                b : in QuadDobl_Complex_VecVecs.VecVec;
                verbose : in boolean := false );

  -- DESCRIPTION :
  --   Runs multitasked benchmarks in double, double double,
  --   or quad double precision. 

  -- ON ENTRY :
  --   file     file opened for output to write speedups;
  --   n        number of equations and variables;
  --   nbruns   the number of multitasked runs;
  --   inc      increment on the number of tasks;
  --   A        matrices in the linear system;
  --   b        right hand side vector of the linear system;
  --   verbose  writes timings if true, otherwise stays silent.

  procedure Benchmark ( n,d : in integer32 );

  -- DESCRIPTION :
  --   Generates a random n-dimensional linear system of power series
  --   of degree in double, double double, and quad double precision.

  procedure Main;

  -- DESCRIPTION :
  --   Prompts for the dimension of the linear system,
  --   the degrees of the series in the system, the number of tasks;
  --   and then runs tests.

end Test_mtSeries_Linearization;
