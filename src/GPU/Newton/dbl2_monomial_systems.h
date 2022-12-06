// The file dbl2_monomial_systems.h specifies functions to generate
// monomial systems with prescribed solutions in double double precision.

#ifndef __dbl2_monomial_systems_h__
#define __dbl2_monomial_systems_h__

void make_real2_exponentials
 ( int dim, int  deg, double **shi, double **slo );
/*
 * DESCRIPTION :
 *   Returns the expansions of exp(c*x) for random coefficients c,
 *   for c in the union of the intervals [-2, -1] and [1, 2].
 *
 * ON ENTRY :
 *   dim      number of power series;
 *   deg      truncation degree;
 *   shi      space for dim arrays of size deg+1;
 *   slo      space for dim arrays of size deg+1.
 *
 * ON RETURN :
 *   shi      high doubles of the series expansions;
 *   slo      low doubles of the series expansions. */

void make_complex2_exponentials
 ( int dim, int deg,
   double **srehi, double **srelo, double **simhi, double **simlo );
/*
 * DESCRIPTION :
 *   Returns dim expansions of exp(x) truncated at degree deg,
 *   for random complex values of x on the complex unit circle.
 *
 * ON ENTRY :
 *   dim      number of power series;
 *   deg      truncation degree;
 *   srehi    space for dim arrays of size deg+1;
 *   srelo    space for dim arrays of size deg+1;
 *   simhi    space for dim arrays of size deg+1;
 *   simlo    space for dim arrays of size deg+1.
 *
 * ON RETURN :
 *   srehi    high doubles of the real parts of the dim power series;
 *   srelo    low doubles of the real parts of the dim power series;
 *   simhi    high doubles of the imaginary parts of the dim power series;
 *   simlo    low doubles of the imaginary parts of the dim power series. */

void evaluate_real2_monomials
 ( int dim, int deg, int **rowsA,
   double **shi, double **slo, double **rhshi, double **rhslo );
/*
 * DESCRIPTION :
 *   Evaluates the monomials defined in the rows of a matrix at
 *   real series to make the right hand side of a monomial system.
 *
 * ON ENTRY :
 *   dim      dimension of the monomial system;
 *   deg      truncation degree of the series;
 *   rowsA    the rows of A have the exponents of the monomials;
 *   shi      high doubles of the coefficients of the series;
 *   slo      low doubles of the coefficients of the series;
 *   rhshi    space for dim arrays of size deg+1;
 *   rhslo    space for dim arrays of size deg+1.
 *
 * ON RETURN :
 *   rhshi    high doubles of the evaluated monomials;
 *   rhslo    low doubles of the evaluated monomials. */

void evaluate_complex2_monomials
 ( int dim, int deg, int **rowsA,
   double **srehi, double **srelo, double **simhi, double **simlo,
   double **rhsrehi, double **rhsrelo, double **rhsimhi, double **rhsimlo );
/*
 * DESCRIPTION :
 *   Evaluates the monomials defined in the rows of a matrix at
 *   complex series to make the right hand side of a monomial system.
 *
 * ON ENTRY :
 *   dim      dimension of the monomial system;
 *   deg      truncation degree of the series;
 *   rowsA    the rows of A have the exponents of the monomials;
 *   srehi    high doubles of the real parts of the series;
 *   srelo    low doubles of the real parts of the series;
 *   simhi    high doubles of the imaginary parts of the series;
 *   simlo    low doubles of the imaginary parts of the series;
 *   rhsrehi  space for dim arrays of size deg+1;
 *   rhsrelo  space for dim arrays of size deg+1;
 *   rhsimhi  space for dim arrays of size deg+1;
 *   rhsimlo  space for dim arrays of size deg+1.
 *
 * ON RETURN :
 *   rhsrehi  high doubles of the real parts of the evaluated monomials;
 *   rhsrelo  low doubles of the real parts of the evaluated monomials;
 *   rhsimhi  high doubles of the imaginary parts of the evaluated monomials;
 *   rhsimlo  low doubles of the imaginary parts of the evaluated monomials. */

void evaluate_real2_columns
 ( int dim, int deg, int nbrcol, int **nvr, int ***idx, int **rowsA,
   double **xhi, double **xlo, double **rhshi, double **rhslo, int vrblvl );
/*
 * DESCRIPTION :
 *   Evaluates the polynomials defined by the column representation
 *   at real series to make the right hand side of a system.
 *
 * ON ENTRY :
 *   dim      dimension of the monomial system;
 *   deg      truncation degree of the series;
 *   nbrcol   is the number of columns;
 *   nvr      nvr[[i][j] is the number of variables of the j-th monomial
 *            in the i-th column.
 *   idx      idx[i][j][k] is the index of the k-th variable which appears
 *            in the j-th monomial of the i-th column;
 *   rowsA    matrix of dimension dim where the rows of A 
 *            are used as work space during the evaluation;
 *   xhi      high double coefficients of the series;
 *   xlo      low double coefficients of the series;
 *   rhshi    space for dim arrays of size deg+1;
 *   rhslo    space for dim arrays of size deg+1;
 *   vrblvl   is the verbose level, if > 1, then exponents are written.
 *
 * ON RETURN :
 *   rhshi    high doubles of the evaluated monomials;
 *   rhslo    low doubles of the evaluated monomials. */

void evaluate_complex2_columns
 ( int dim, int deg, int nbrcol, int **nvr, int ***idx, int **rowsA,
   double **xrehi, double **xrelo, double **ximhi, double **ximlo,
   double **rhsrehi, double **rhsrelo, double **rhsimhi, double **rhsimlo,
   int vrblvl );
/*
 * DESCRIPTION :
 *   Evaluates the polynomials defined by the column representation
 *   at real series to make the right hand side of a system.
 *
 * ON ENTRY :
 *   dim      dimension of the monomial system;
 *   deg      truncation degree of the series;
 *   nbrcol   is the number of columns;
 *   nvr      nvr[[i][j] is the number of variables of the j-th monomial
 *            in the i-th column.
 *   idx      idx[i][j][k] is the index of the k-th variable which appears
 *            in the j-th monomial of the i-th column;
 *   rowsA    matrix of dimension dim where the rows of A 
 *            are used as work space during the evaluation;
 *   xrehi    high double real parts of the coefficients of the series;
 *   xrelo    low double real parts of the coefficients of the series;
 *   ximhi    high double imaginary parts of the coefficients of the series;
 *   ximlo    low double imaginary parts of the coefficients of the series;
 *   rhsrehi  space for dim arrays of size deg+1;
 *   rhsrelo  space for dim arrays of size deg+1;
 *   rhsimhi  space for dim arrays of size deg+1;
 *   rhsimlo  space for dim arrays of size deg+1;
 *   vrblvl   is the verbose level, if > 1, then exponents are written.
 *
 * ON RETURN :
 *   rhsrehi  high doubles of the real parts of the evaluated monomials;
 *   rhsrelo  low doubles of the real parts of the evaluated monomials;
 *   rhsimhi  high doubles of the imaginary parts of the evaluated monomials;
 *   rhsimlo  low doubles of the imaginary parts of the evaluated monomials. */

#endif
