/* The dbl3_polynomials_testers.h contains the prototypes of functions to test
 * polynomial evaluation and differentiation in triple double precision. */

#ifndef __dbl3_polynomials_testers_h__
#define __dbl3_polynomials_testers_h__

void dbl3_make_input
 ( int dim, int nbr, int nva, int pwr, int deg,
   int *nvr, int **idx, int **exp,
   double **inputhi, double **inputmi, double **inputlo,
   double *csthi, double *cstmi, double *cstlo,
   double **cffhi, double **cffmi, double **cfflo, bool verbose );
/*
 * DESCRIPTION :
 *   Generates random polynomials and input series.
 *
 * ON ENTRY :
 *   dim      dimension, total number of variables;
 *   nbr      number of terms in the polynomial;
 *   nva      number of variables in each monomial (for products, cyclic);
 *   pwr      highest power of each variable;
 *   deg      truncation degree of the series;
 *   nvr      space for nbr integers;
 *   idx      space for nbr pointers to integers;
 *   exp      space for nbr pointers to integers;
 *   inputhi  space for dim arrays of deg+1 doubles;
 *   inputmi  space for dim arrays of deg+1 doubles;
 *   inputlo  space for dim arrays of deg+1 doubles;
 *   csthi    space for deg+1 doubles;
 *   cstmi    space for deg+1 doubles;
 *   cstlo    space for deg+1 doubles;
 *   cffhi    space for nbr arrays of deg+1 doubles;
 *   cffmi    space for nbr arrays of deg+1 doubles;
 *   cfflo    space for nbr arrays of deg+1 doubles;
 *   verbose  if true, then output is written.
 *
 * ON RETURN :
 *   nvr      nvr[k] has the number of variables in monomial k;
 *   idx      idx[k] holds nvr[k] indices to variables in monomial k;
 *   exp      exp[k] holds nvr[k] exponents of variables in monomial k;
 *   inputhi  has the high doubles of dim input series of degree deg;
 *   inputmi  has the middle doubles of dim input series of degree deg;
 *   inputlo  has the low doubles of dim input series of degree deg;
 *   csthi    has the high doubles of the constant series;
 *   cstmi    has the middle doubles of the constant series;
 *   cstlo    has the low doubles of the constant series;
 *   cffhi    cffhi[k] has the high doubles of the coefficient series
 *            of monomial k;
 *   cffmi    cffmi[k] has the middle doubles of the coefficient series
 *            of monomial k;
 *   cfflo    cfflo[k] has the low doubles of the coefficient series
 *            of monomial k. */

void cmplx3_make_input
 ( int dim, int nbr, int nva, int pwr, int deg,
   int *nvr, int **idx, int **exp,
   double **inputrehi, double **inputremi, double **inputrelo,
   double **inputimhi, double **inputimmi, double **inputimlo,
   double *cstrehi, double *cstremi, double *cstrelo,
   double *cstimhi, double *cstimmi, double *cstimlo,
   double **cffrehi, double **cffremi, double **cffrelo,
   double **cffimhi, double **cffimmi, double **cffimlo, bool verbose );
/*
 * DESCRIPTION :
 *   Generates random complex polynomials and complex input series.
 *
 * ON ENTRY :
 *   dim        dimension, total number of variables;
 *   nbr        number of terms in the polynomial;
 *   nva        number of variables in each monomial (for products, cyclic);
 *   pwr        highest power of each variable;
 *   deg        truncation degree of the series;
 *   nvr        space for nbr integers;
 *   idx        space for nbr pointers to integers;
 *   exp        space for nbr pointers to integers;
 *   inputrehi  space for dim arrays of deg+1 doubles;
 *   inputremi  space for dim arrays of deg+1 doubles;
 *   inputrelo  space for dim arrays of deg+1 doubles;
 *   inputimhi  space for dim arrays of deg+1 doubles;
 *   inputimmi  space for dim arrays of deg+1 doubles;
 *   inputimlo  space for dim arrays of deg+1 doubles;
 *   cstrehi    space for deg+1 doubles;
 *   cstremi    space for deg+1 doubles;
 *   cstrelo    space for deg+1 doubles;
 *   cstimhi    space for deg+1 doubles;
 *   cstimmi    space for deg+1 doubles;
 *   cstimlo    space for deg+1 doubles;
 *   cffrehi    space for nbr arrays of deg+1 doubles;
 *   cffremi    space for nbr arrays of deg+1 doubles;
 *   cffrelo    space for nbr arrays of deg+1 doubles;
 *   cffimhi    space for nbr arrays of deg+1 doubles;
 *   cffimmi    space for nbr arrays of deg+1 doubles;
 *   cffimlo    space for nbr arrays of deg+1 doubles;
 *   verbose    if true, then output is written.
 *
 * ON RETURN :
 *   nvr        nvr[k] has the number of variables in monomial k;
 *   idx        idx[k] holds nvr[k] indices to variables in monomial k;
 *   exp        exp[k] holds nvr[k] exponents of variables in monomial k;
 *   inputrehi  has the high doubles of the real parts 
 *              of dim input series of degree deg;
 *   inputremi  has the middle doubles of the real parts 
 *              of dim input series of degree deg;
 *   inputrelo  has the low doubles of the real parts
 *              of dim input series of degree deg;
 *   inputimhi  has the high doubles of the imaginary parts 
 *              of dim input series of degree deg;
 *   inputimmi  has the middle doubles of the imaginary parts 
 *              of dim input series of degree deg;
 *   inputimlo  has the low doubles of the imaginary parts
 *              of dim input series of degree deg;
 *   cstrehi    has the high doubles of the real parts
 *              of the constant series;
 *   cstremi    has the middle doubles of the real parts
 *              of the constant series;
 *   cstrelo    has the low doubles of the real parts
 *              of the constant series;
 *   cstimhi    has the high doubles of the imaginary parts
 *              of the constant series;
 *   cstimmi    has the middle doubles of the imaginary parts
 *              of the constant series;
 *   cstimlo    has the low doubles of the imaginary parts
 *              of the constant series;
 *   cffrehi    cffrehi[k] has the high doubles of the real parts
 *              of the coefficient series of monomial k;
 *   cffremi    cffrehi[k] has the middle doubles of the real parts
 *              of the coefficient series of monomial k;
 *   cffrelo    cffrelo[k] has the low doubles of the real parts
 *              of the coefficient series of monomial k;
 *   cffimhi    cffrehi[k] has the high doubles of the imaginary parts
 *              of the coefficient series of monomial k;
 *   cffimmi    cffrehi[k] has the middle doubles of the imaginary parts
 *              of the coefficient series of monomial k;
 *   cffimlo    cffrelo[k] has the low doubles of the imaginary parts
 *              of the coefficient series of monomial k. */

double dbl3_error_sum
 ( int dim, int deg,
   double **results1hi_h, double **results1mi_h, double **results1lo_h,
   double **results2hi_h, double **results2mi_h, double **results2lo_h,
   double **resultshi_d, double **resultsmi_d, double **resultslo_d,
   bool verbose );
/*
 * DESCRIPTION :
 *   Returns the sum of all errors, comparing results computed on the host
 *   with results computed on the device.
 *
 * ON ENTRY :
 *   dim      dimension, total number of variables;
 *   deg      truncation degree of the series;
 *   results1hi_h are the high doubles computed on the host without jobs;
 *   results1mi_h are the middle doubles computed on the host without jobs;
 *   results1lo_h are the low doubles computed on the host without jobs;
 *   results2hi_h are the high doubles computed on the host
 *            with convolution and addition jobs;
 *   results2mi_h are the middle doubles computed on the host
 *            with convolution and addition jobs;
 *   results2lo_h are the low doubles computed on the host
 *            with convolution and addition jobs;
 *   resultshi_d are the high doubles computed on the device;
 *   resultsmi_d are the middle doubles computed on the device;
 *   resultslo_d are the low doubles computed on the device;
 *   verbose  if true, then all results and intermediate errors are shown. */

double test_dbl3_real_polynomial
 ( int dim, int nbr, int nva, int pwr, int deg, int verbose,
   bool jobrep=true, int mode=2 );
/*
 * DESCRIPTION :
 *   Tests the evaluation and differentiation for random real data.
 *   Returns the sum of all errors.
 * 
 * ON ENTRY :
 *   dim      dimension, total number of variables;
 *   nbr      number of terms in the polynomial;
 *   nva      number of variables per monomial (for products and cyclic);
 *   pwr      highest power of each variable;
 *   deg      truncation degree of the series;
 *   verbose  if zero, then no output is written,
 *            otherwise, the higher the value, the more output;
 *   jobrep   if verbose is nonzero and jobrep is true,
 *            then the jobs report is written,
 *            otherwise no jobs report is written.
 *            When running the same problems in many precisions,
 *            the jobs reports needs to be written only once;
 *   mode     the mode of execution, either 0, 1, or 2, as follows:
 *            0 : GPU only; 1 : CPU only; 2 : GPU and CPU. */

double test_cmplx3_real_polynomial
 ( int dim, int nbr, int nva, int pwr, int deg, int verbose,
   bool jobrep=true, int mode=2 );
/*
 * DESCRIPTION :
 *   Tests the evaluation and differentiation for random complex data.
 *   Returns the sum of all errors.
 * 
 * ON ENTRY :
 *   dim      dimension, total number of variables;
 *   nbr      number of terms in the polynomial;
 *   nva      number of variables per monomial (for products and cyclic);
 *   pwr      highest power of each variable;
 *   deg      truncation degree of the series;
 *   verbose  if zero, then no output is written,
 *            otherwise, the higher the value, the more output;
 *   jobrep   if verbose is nonzero and jobrep is true,
 *            then the jobs report is written,
 *            otherwise no jobs report is written.
 *            When running the same problems in many precisions,
 *            the jobs reports needs to be written only once;
 *   mode     the mode of execution, either 0, 1, or 2, as follows:
 *            0 : GPU only; 1 : CPU only; 2 : GPU and CPU. */

int main_dbl3_test_polynomial
 ( int seed, int dim, int nbr, int nva, int pwr, int deg, int vrblvl,
   double tol=1.0e-40, bool jobrep=true, int mode=2 );
/*
 * DESCRIPTION :
 *   Runs tests on a random polynomial in triple double precision.
 *   Returns 0 if all tests passed,
 *   otherwise, returns the number of failed tests.
 *
 * ON ENTRY :
 *   seed     seed for the random number generator;
 *   dim      dimension, total number of variables;
 *   nbr      number of terms in the polynomial;
 *   nva      number of variables in each monomial (for products, cyclic);
 *   pwr      highest power of each variable;
 *   deg      truncation degree of the series;
 *   vrblvl   is the verbose level, if 0 then no output,
 *            otherwise, the higher the value, the more output:
 *            if 1, then the sum of all errors is shown,
 *            if 2, then job counts and timings are listed,
 *            if 3 (or higher), then all values are written;
 *   tol      tolerance to decide pass or fail,
 *            fail if the sum of all errors is larger than tol;
 *   jobrep   if verbose is nonzero and jobrep is true,
 *            then the jobs report is written,
 *            otherwise no jobs report is written.
 *            When running the same problems in many precisions,
 *            the jobs reports needs to be written only once;
 *   mode     the mode of execution, either 0, 1, or 2, as follows:
 *            0 : GPU only; 1 : CPU only; 2 : GPU and CPU. */

int test_dbl3_sequence
 ( int seed, int dim, int nva, int nbr, int pwr, int vrblvl,
   bool jobrep, int mode );
/*
 * DESCRIPTION :
 *   For an increasing sequence of degrees,
 *   runs tests in triple double precision.
 *
 * ON ENTRY :
 *   dim      dimension, total number of variables;
 *   nbr      number of terms in the polynomial;
 *   nva      number of variables per monomial (for products and cyclic);
 *   pwr      highest power of each variable;
 *   vrblvl   if zero, then no output is written,
 *            otherwise, the higher the value, the more input;
 *   jobrep   if verbose is nonzero and jobrep is true,
 *            then the jobs report is written,
 *            otherwise no jobs report is written.
 *            When running the same problems in many precisions,
 *            the jobs reports needs to be written only once;
 *   mode     the mode of execution, either 0, 1, or 2, as follows:
 *            0 : GPU only; 1 : CPU only; 2 : GPU and CPU. */

#endif
