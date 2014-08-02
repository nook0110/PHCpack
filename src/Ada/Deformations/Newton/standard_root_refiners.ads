with text_io;                            use text_io;
with Standard_Natural_Numbers;           use Standard_Natural_numbers;
with Standard_Floating_Numbers;          use Standard_Floating_Numbers;
with Standard_Complex_Vectors;           use Standard_Complex_Vectors;
with Standard_Complex_Laur_Systems;      use Standard_Complex_Laur_Systems;
with Standard_Complex_Poly_Systems;      use Standard_Complex_Poly_Systems;
with Standard_Complex_Poly_SysFun;       use Standard_Complex_Poly_SysFun;
with Standard_Complex_Laur_SysFun;       use Standard_Complex_Laur_SysFun;
with Standard_Complex_Jaco_Matrices;
with Standard_Complex_Laur_Jacomats;
with Standard_Complex_Solutions;         use Standard_Complex_Solutions;
with Standard_Point_Lists;               use Standard_Point_Lists;

package Standard_Root_Refiners is

-- DESCRIPTION:
--   The aim of this package is to provide some routines to
--   perform root refining, to validate the approximate solutions.
--   It can be used as a postprocessor to check the computed roots,
--   or, as preprocessor, to find some suitable starting values for
--   the continuation procedure.

--   The basic root refiner is Newton's method, with a modification
--   to estimate multiplicities.  There are six versions:
--    + reporting/silent : with/without intermediate output;
--    + standard/function evaluator;
--    + with or without deflation.

-- ROOT ACCOUNTING :

  procedure Write_Info ( file : in file_type; zero : in Solution;
                         initres : in double_float;
                         i,numb,nbdef : in natural32;
                         fail,infty : in boolean );

  -- DESCRIPTION :
  --   The information concerning the zero is written

  -- ON ENTRY :
  --   file     file which must be opened for output;
  --   zero     a solution;
  --   initres  the initial residual
  --   i        number of solution;
  --   numb     number of iterations;
  --   nbdef    number of deflations;
  --   fail     if failed or not;
  --   infty    at infinity or not.

  procedure Multiplicity
              ( h1,h2 : in Standard_Complex_Vectors.Vector;
                pl : in out Point_List; ls : in Link_to_Solution;
                nb : in natural32; sa : in out Solution_Array;
                fail,infty,deflate : in boolean;
                tolsing,tolclus : in double_float );

  -- DESCRIPTION :
  --   Checks whether the solution ls at position nb in sa is clustered.

  -- ON ENTRY :
  --   h1       first hash function for solution vectors;
  --   h2       second hash function for solution vectors;
  --   pl       list of hashed points;
  --   ls       current solution;
  --   nb       position of the solution ls in sa;
  --   sa       array of solutions;
  --   fail     if Newton failed to converge;
  --   infty    if at infinity;
  --   deflate  if deflation will be applied;
  --   tolsing  tolerance on singular solution;
  --   tolclus  tolerance for two solutions to be clustered.

  -- ON RETURN :
  --   pl       updated list of hashed points;
  --   ls       ls.m will reflect if multiple or clustered:
  --            if clustered, then ls.m < 0 and refers to the
  --            other solution in sa that is equal to ls.

  procedure Multiplicity
              ( h1,h2 : in Standard_Complex_Vectors.Vector;
                pl : in out Point_List; ls : in Link_to_Solution;
                nb : in natural32; sols : in out Solution_List;
                fail,infty,deflate : in boolean;
                tolsing,tolclus : in double_float );

  -- DESCRIPTION :
  --   Checks whether the solution ls at position nb in sa is clustered.

  -- ON ENTRY :
  --   h1       first hash function for solution vectors;
  --   h2       second hash function for solution vectors;
  --   pl       list of hashed points;
  --   ls       current solution;
  --   nb       position of the solution ls in sa;
  --   sols     list of solutions;
  --   fail     if Newton failed to converge;
  --   infty    if at infinity;
  --   deflate  if deflation will be applied;
  --   tolsing  tolerance on singular solution;
  --   tolclus  tolerance for two solutions to be clustered.

  -- ON RETURN :
  --   pl       updated list of hashed points;
  --   ls       ls.m will reflect if multiple or clustered:
  --            if clustered, then ls.m < 0 and refers to the
  --            other solution in sols that is equal to ls.

  procedure Write_Type
               ( file : in file_type;
                 h1,h2 : in Standard_Complex_Vectors.Vector;
                 pl : in out Point_List; ls : in Link_to_Solution;
                 nb : in natural32; sa : in out Solution_Array;
                 fail,infty,deflate : in boolean;
                 tolsing,tolclus : in double_float; nbfail,nbinfty,
                 nbreal,nbcomp,nbreg,nbsing,nbclus : in out natural32 );

  -- DESCRIPTION :
  --   Writes the type of solution, after root accounting.

  -- ON ENTRY :
  --   file      file opened for output;
  --   h1        first hash function on a solution vector;
  --   h2        second hash function on a solution vector;
  --   pl        list of hashed points;
  --   ls        the current solution;
  --   nb        index of the solution in the array sa;
  --   sa        solution array;
  --   fail      if Newton failed to converge;
  --   infty     if at infinity;
  --   deflate   if deflation will be applied;
  --   tolsing   tolerance for singular solutions;
  --   tolclus   tolerance for clustered solutions;
  --   nbfail    current number of failures;
  --   nbinfty   current number of at infinity;
  --   nbreal    current number of real solutions;
  --   nbcomp    current number of complex solutions;
  --   nbreg     current number of regular solutions;
  --   nbsing    current number of singular solutions;
  --   nbclus    current number of clustered solutions.

  -- ON RETURN :
  --   pl        list with new hashed point;
  --   ls        multiplicity field may be adjusted;
  --   sa        some solution may have increased multiplicities;
  --   nbfail    updated number of failures;
  --   nbinfty   updated number of at infinity;
  --   nbreal    updated number of real solutions;
  --   nbcomp    updated number of complex solutions;
  --   nbreg     updated number of regular solutions;
  --   nbsing    updated number of singular solutions;
  --   nbclus    updated number of clustered solutions.

  procedure Write_Type
               ( file : in file_type; ls : in Link_to_Solution;
                 fail,infty : in boolean;
                 tolsing : in double_float;
                 nbfail,nbinfty : in out natural32;
                 nbreal,nbcomp,nbreg,nbsing : in out natural32 );

  -- DESCRIPTION :
  --   Writes the type of the solution to file without cluster analysis.

  -- ON ENTRY :
  --   file      file opened for output;
  --   ls        the current solution;
  --   fail      if Newton failed to converge;
  --   infty     if at infinity;
  --   tolsing   tolerance for singular solutions;
  --   nbfail    current number of failures;
  --   nbinfty   current number of at infinity;
  --   nbreal    current number of real solutions;
  --   nbcomp    current number of complex solutions;
  --   nbreg     current number of regular solutions;
  --   nbsing    current number of singular solutions.

  -- ON RETURN :
  --   nbfail    updated number of failures;
  --   nbinfty   updated number of at infinity;
  --   nbreal    updated number of real solutions;
  --   nbcomp    updated number of complex solutions;
  --   nbreg     updated number of regular solutions;
  --   nbsing    updated number of singular solutions.

  procedure Write_Global_Info
               ( file : in file_type; tot,nbfail,nbinfty,
                 nbreal,nbcomp,nbreg,nbsing,nbclus : in natural32 );

  -- DESCRIPTION :
  --   Writes the global information summary at the end of the solutions.

  -- ON ENTRY :
  --   file      file openen for output;
  --   tot       total number of solutions;
  --   nbfail    number of failures;
  --   nbinfty   number of solutions at infinity;
  --   nbreal    number of real solutions;
  --   nbcomp    number of complex solutions;
  --   nbreg     number of regular solutions;
  --   nbsing    number of singular solutions;
  --   nbclus    number of clustered solutions.

-- ONE NEWTON STEP :

  procedure Standard_Newton_Step
              ( f : in Standard_Complex_Poly_SysFun.Eval_Poly_Sys;
                jf : in  Standard_Complex_Jaco_Matrices.Eval_Jaco_Mat;
                x : in out Standard_Complex_Vectors.Vector;
                err,rco,res : out double_float );
  procedure Standard_Newton_Step
              ( f : in Standard_Complex_Laur_SysFun.Eval_Laur_Sys;
                jf : in  Standard_Complex_Laur_JacoMats.Eval_Jaco_Mat;
                x : in out Standard_Complex_Vectors.Vector;
                err,rco,res : out double_float );

  -- DESCRIPTION :
  --   Does one Newton step in standard complex arithmetic.

  -- ON ENTRY :
  --   f        evaluable form of a (Laurent) polynomial system;
  --   jf       Jacobian matrix of f;
  --   x        current approximate solution.

  -- ON RETURN :
  --   x        updated approximate solution;
  --   err      norm of the update vector;
  --   rco      estimate for the inverse condition number;
  --   res      residual, norm of the function value.

-- NEWTON's METHOD :

  procedure Silent_Newton 
               ( p_eval : in Eval_Poly_Sys;
                 j_eval : in Standard_Complex_Jaco_Matrices.Eval_Jaco_Mat;
                 zero : in out Solution; epsxa,epsfa : in double_float; 
                 numit : in out natural32; max : in natural32;
                 fail : out boolean );

  procedure Silent_Newton 
               ( p_eval : in Eval_Laur_Sys;
                 j_eval : in Standard_Complex_Laur_Jacomats.Eval_Jaco_Mat;
                 zero : in out Solution; epsxa,epsfa : in double_float; 
                 numit : in out natural32; max : in natural32;
                 fail : out boolean );

  procedure Silent_Newton 
               ( p_eval : in Standard_Complex_Poly_SysFun.Evaluator;
                 j_eval : in Standard_Complex_Jaco_Matrices.Evaluator;
                 zero : in out Solution; epsxa,epsfa : in double_float; 
                 numit : in out natural32; max : in natural32;
                 fail : out boolean );

  procedure Reporting_Newton
               ( file : in file_type; p_eval : in Eval_Poly_Sys;
                 j_eval : in Standard_Complex_Jaco_Matrices.Eval_Jaco_Mat;
                 zero : in out Solution; epsxa,epsfa : in double_float;
                 numit : in out natural32; max : in natural32;
                 fail : out boolean );

  procedure Reporting_Newton
               ( file : in file_type; p_eval : in Eval_Laur_Sys;
                 j_eval : in Standard_Complex_Laur_Jacomats.Eval_Jaco_Mat;
                 zero : in out Solution; epsxa,epsfa : in double_float;
                 numit : in out natural32; max : in natural32;
                 fail : out boolean );

  procedure Reporting_Newton
               ( file : in file_type;
                 p_eval : in Standard_Complex_Poly_SysFun.Evaluator;
                 j_eval : in Standard_Complex_Jaco_Matrices.Evaluator;
                 zero : in out Solution; epsxa,epsfa : in double_float;
                 numit : in out natural32; max : in natural32;
                 fail : out boolean );

  -- DESCRIPTION :
  --   Newton's method is applied to refine the approximation of a root.
  --   The stopping criteria are:
  --     * numit > max   (maximum number of iterations is exceeded);
  --     * zero.err < epsxa (accuracy for x is reached);
  --     * zero.res < epsfa (tolerance for residual is reached).
  --   When one of these conditions is fulfilled, the procedure stops.

  -- ON ENTRY :
  --   file      to write intermediate results on;
  --   p_eval    evaluable form of the polynomial system;
  --   j_eval    evaluable form of the Jacobian matrix;
  --   zero      starting value;
  --   epsxa     maximum absolute error on the zero;
  --   epsfa     maximum absolute value of the residue;
  --   numit     number of iterations, to be initialized with zero;
  --   max       maximum number of iterations.

  -- ON RETURN :
  --   zero      refined root;
  --   orders    estimated orders of multiplicities, if estord was on;
  --   numit     number of iterations performed;
  --   fail      is true when the desired precision is not reached.

-- APPLICATION OF NEWTON's METHOD ON A LIST OF SOLUTIONS.
--   The silent versions simply perform the calculations.  
--   The reporting root refiners allow the output of intermediate results and
--   produce a summary of the calculations.
--   With each version, an additional output parameter can be supplied to
--   contain only those solutions that satisfy the accuracy requirements.
  
  procedure Silent_Root_Refiner
               ( p : in Poly_Sys; sols : in out Solution_List;
                 epsxa,epsfa,tolsing : in double_float;
                 numit : in out natural32; max : in natural32;
                 deflate : in out boolean );

  procedure Silent_Root_Refiner
               ( p : in Standard_Complex_Poly_SysFun.Evaluator;
                 j : in Standard_Complex_Jaco_Matrices.Evaluator;
                 sols : in out Solution_List;
                 epsxa,epsfa,tolsing : in double_float;
                 numit : in out natural32; max : in natural32 );

  procedure Silent_Root_Refiner
               ( p : in Poly_Sys; sols,refsols : in out Solution_List;
                 epsxa,epsfa,tolsing : in double_float;
                 numit : in out natural32; max : in natural32;
                 deflate : in out boolean );

  procedure Silent_Root_Refiner
               ( p : in Laur_Sys; sols,refsols : in out Solution_List;
                 epsxa,epsfa,tolsing : in double_float;
                 numit : in out natural32; max : in natural32 );

  procedure Silent_Root_Refiner
               ( p : in Standard_Complex_Poly_SysFun.Evaluator;
                 j : in Standard_Complex_Jaco_Matrices.Evaluator;
                 sols,refsols : in out Solution_List;
                 epsxa,epsfa,tolsing : in double_float;
                 numit : in out natural32; max : in natural32 );

  procedure Reporting_Root_Refiner
               ( file : in file_type;
                 p : in Poly_Sys; sols : in out Solution_List;
                 epsxa,epsfa,tolsing : in double_float;
                 numit : in out natural32; max : in natural32;
                 deflate : in out boolean; wout : in boolean );

  procedure Reporting_Root_Refiner
               ( file : in file_type;
                 p : in Standard_Complex_Poly_SysFun.Evaluator;
                 j : in Standard_Complex_Jaco_Matrices.Evaluator;
                 sols : in out Solution_List;
                 epsxa,epsfa,tolsing : in double_float;
                 numit : in out natural32; max : in natural32;
                 wout : in boolean );

  procedure Reporting_Root_Refiner
               ( file : in file_type;
                 p : in Poly_Sys; sols,refsols : in out Solution_List;
                 epsxa,epsfa,tolsing : in double_float;
                 numit : in out natural32; max : in natural32;
                 deflate : in out boolean; wout : in boolean );

  procedure Reporting_Root_Refiner
               ( file : in file_type;
                 p : in Laur_Sys; sols,refsols : in out Solution_List;
                 epsxa,epsfa,tolsing : in double_float;
                 numit : in out natural32; max : in natural32;
                 wout : in boolean );

  procedure Reporting_Root_Refiner
               ( file : in file_type;
                 p : in Standard_Complex_Poly_SysFun.Evaluator;
                 j : in Standard_Complex_Jaco_Matrices.Evaluator; 
                 sols,refsols : in out Solution_List;
                 epsxa,epsfa,tolsing : in double_float;
                 numit : in out natural32; max : in natural32;
                 wout : in boolean );

  -- DESCRIPTION :
  --   The list of solutions sols is refined w.r.t. the system p.
  --   The multiplicity of each solution in sols is determined as follows:
  --     m = 0 : if the solution is singular and probably non isolated
  --             or if the solution lies at infinity ( in fact no solution );
  --     m = 1 : if the solution is regular;
  --     m > 1 : a multiple solution with multiplicity m.

  -- ON ENTRY :
  --   file      file for writing diagnostics on;
  --   p         a polynomial system;
  --   j         Jacobian matrix of p;
  --   sols      the start solutions;
  --   epsxa     maximum absolute error on the zero;
  --   epsfa     maximum absolute value for the residue;
  --   tolsing   tolerance on inverse condition number for singular solution;
  --   numit     the number of iterations, to be initialized with zero;
  --   max       maximum number of iterations per zero;
  --   deflate   if true, apply deflation to singular solutions;
  --   wout      has to be true when intermediate output is wanted.

  -- ON RETURN :
  --   sols      a list of computed solutions;
  --   refsols   only those solutions which satisfy the given accuracy;
  --   numit     the number of iterations;
  --   deflate   if set to false, then the system was too large to deflate.

-- APPLICATION of Gauss-Newton for overdetermined systems

  procedure Silent_Gauss_Newton
               ( f : in Eval_Poly_Sys;
                 jf : in Standard_Complex_Jaco_Matrices.Eval_Jaco_Mat; 
                 zero : in out Solution; tol,epsxa,epsfa : in double_float; 
                 numit : in out natural32; max : in natural32;
                 fail : out boolean );
  procedure Silent_Gauss_Newton
               ( f : in Eval_Laur_Sys;
                 jf : in Standard_Complex_Laur_Jacomats.Eval_Jaco_Mat; 
                 zero : in out Solution; tol,epsxa,epsfa : in double_float; 
                 numit : in out natural32; max : in natural32;
                 fail : out boolean );
  procedure Reporting_Gauss_Newton
               ( file : in file_type; f : in Eval_Poly_Sys;
                 jf : in Standard_Complex_Jaco_Matrices.Eval_Jaco_Mat; 
                 zero : in out Solution; tol,epsxa,epsfa : in double_float; 
                 numit : in out natural32; max : in natural32;
                 fail : out boolean );
  procedure Reporting_Gauss_Newton
               ( file : in file_type; f : in Eval_Laur_Sys;
                 jf : in Standard_Complex_Laur_Jacomats.Eval_Jaco_Mat; 
                 zero : in out Solution; tol,epsxa,epsfa : in double_float; 
                 numit : in out natural32; max : in natural32;
                 fail : out boolean );

  -- DESCRIPTION :
  --   Applies at most max steps of Gauss-Newton to sharpen the zero
  --   of a system f with Jacobian matrix function jf.

  -- ON ENTRY :
  --   f         evaluable form of a polynomial system;
  --   jf        evaluable form of a Jacobian matrix;
  --   tol       tolerance to determine the numerical rank;
  --   epsxa     maximum absolute error on the zero;
  --   epxfa     maximum absolute error for the residue;
  --   zero      current approximation of the solution;
  --   numit     the number of iterations, to be initialized with zero;
  --   max       maximum number of iterations per zero.

  -- ON RETURN :
  --   zero      sharpened approximate root;
  --   fail      true if tolerances for accuracy are not met.
  
  procedure Silent_Root_Sharpener
               ( p : in Poly_Sys; sols : in out Solution_List;
                 epsxa,epsfa,tolsing : in double_float;
                 numit : in out natural32; max : in natural32;
                 deflate : in boolean );

  procedure Silent_Root_Sharpener
               ( p : in Poly_Sys; sols,refsols : in out Solution_List;
                 epsxa,epsfa,tolsing : in double_float;
                 numit : in out natural32; max : in natural32;
                 deflate : in boolean );

  procedure Silent_Root_Sharpener
               ( p : in Laur_Sys; sols,refsols : in out Solution_List;
                 epsxa,epsfa,tolsing : in double_float;
                 numit : in out natural32; max : in natural32 );

  procedure Reporting_Root_Sharpener
               ( file : in file_type;
                 p : in Poly_Sys; sols : in out Solution_List;
                 epsxa,epsfa,tolsing : in double_float;
                 numit : in out natural32; max : in natural32;
                 deflate,wout : in boolean );

  procedure Reporting_Root_Sharpener
               ( file : in file_type;
                 p : in Poly_Sys; sols,refsols : in out Solution_List;
                 epsxa,epsfa,tolsing : in double_float;
                 numit : in out natural32; max : in natural32;
                 deflate,wout : in boolean );

  procedure Reporting_Root_Sharpener
               ( file : in file_type;
                 p : in Laur_Sys; sols,refsols : in out Solution_List;
                 epsxa,epsfa,tolsing : in double_float;
                 numit : in out natural32; max : in natural32;
                 wout : in boolean );

  -- DESCRIPTION :
  --   The list of solutions sols is refined w.r.t. the system p.
  --   The multiplicity of each solution in sols is determined as follows:
  --     m = 0 : if the solution is singular and probably non isolated
  --             or if the solution lies at infinity ( in fact no solution );
  --     m = 1 : if the solution is regular;
  --     m > 1 : a multiple solution with multiplicity m.

  -- ON ENTRY :
  --   file      file for writing diagnostics on;
  --   p         a polynomial system;
  --   j         Jacobian matrix of p;
  --   sols      the start solutions;
  --   epsxa     maximum absolute error on the zero;
  --   epsfa     maximum absolute value for the residue;
  --   tolsing   tolerance on inverse condition number for singular solution;
  --   numit     the number of iterations, to be initialized with zero;
  --   max       maximum number of iterations per zero;
  --   deflate   if true, apply deflation to singular solutions;
  --   wout      has to be true when intermediate output is wanted.

  -- ON RETURN :
  --   sols      a list of computed solutions;
  --   refsols   only those solutions which satisfy the given accuracy;
  --   numit     the number of iterations.

end Standard_Root_Refiners;
