// The file dbl2_systems_kernels.h specifies functions to define
// memory transfers ad kernel launches to evaluate and differentiate
// monomials with common factors in double double precision.

#ifndef __dbl2_systems_kernels_h__
#define __dbl2_systems_kernels_h__

#include "convolution_jobs.h"

void dbl2_evaldiffdata_to_output
 ( double *datahi, double *datalo, double ***outputhi, double ***outputlo,
   int dim, int nbr, int deg, int *nvr,
   int **idx, int *fstart, int *bstart, int *cstart, bool verbose );
/*
 * DESCRIPTION :
 *   Extracts the real data computed on the device to the output.
 *
 * ON ENTRY :
 *   datahi   high doubles of coefficients of all monomials and input series, 
 *            computed forward, backward, and cross products;
 *   datalo   low doubles of coefficients of all monomials and input series, 
 *            computed forward, backward, and cross products;
 *   outputhi has space for the high double values and all derivatives;
 *   outputlo has space for the low double values and all derivatives;
 *   dim      total number of variables;
 *   nbr      number of monomials, excluding the constant term;
 *   deg      truncation degree of the series;
 *   nvr      nvr[k] is the number of variables for monomial k;
 *   idx      idx[k] has as many indices as the value of nvr[k],
 *            idx[k][i] defines the place of the i-th variable,
 *            with input values in input[idx[k][i]];
 *   fstart   fstart[k] has the start position of the forward products
 *            for the k-th monomial;
 *   bstart   fstart[k] has the start position of the backward products
 *            for the k-th monomial;
 *   cstart   fstart[k] has the start position of the cross products
 *            for the k-th monomial;
 *   verbose  if true, writes extra information.
 *
 * ON RETURN :
 *   outputhi has in outputhi[i][dim] the highest double value
 *            of the i-th monomial, and
 *            outputhi[i][k] has the highest double value of
 *            the k-th derivative of the i-th monomial;
 *   outputlo has in outputlo[i][dim] the lowest double value
 *            of the i-th monomial, and
 *            outputlo[i][k] has the lowest double value of
 *            the k-th derivative of the i-th monomial. */

void cmplx2_evaldiffdata_to_output
 ( double *datarehi, double *datarelo, double *dataimhi, double *dataimlo,
   double ***outputrehi, double ***outputrelo,
   double ***outputimhi, double ***outputimlo,
   int dim, int nbr, int deg, int *nvr,
   int **idx, int *fstart, int *bstart, int *cstart, bool verbose );
/*
 * DESCRIPTION :
 *   Extracts the complex data computed on the device to the output.
 *
 * ON ENTRY :
 *   datarehi are the high doubles of the real parts of the input, 
 *            computed forward, backward, and cross products;
 *   datarelo are the low doubles of the real parts of the input, 
 *            computed forward, backward, and cross products;
 *   dataimhi are the high doubles of the imaginary parts of the input, 
 *            computed forward, backward, and cross products;
 *   dataimlo are the low doubles of the imaginary parts of the input, 
 *            computed forward, backward, and cross products;
 *   outputrehi has space for the value and all derivatives;
 *   outputrelo has space for the value and all derivatives;
 *   outputimhi has space for the value and all derivatives;
 *   outputimlo has space for the value and all derivatives;
 *   dim      total number of variables;
 *   nbr      number of monomials, excluding the constant term;
 *   deg      truncation degree of the series;
 *   nvr      nvr[k] is the number of variables for monomial k;
 *   idx      idx[k] has as many indices as the value of nvr[k],
 *            idx[k][i] defines the place of the i-th variable,
 *            with input values in input[idx[k][i]];
 *   fstart   fstart[k] has the start position of the forward products
 *            for the k-th monomial;
 *   bstart   fstart[k] has the start position of the backward products
 *            for the k-th monomial;
 *   cstart   fstart[k] has the start position of the cross products
 *            for the k-th monomial;
 *   verbose  if true, writes extra information.
 *
 * ON RETURN :
 *   outputrehi, in outputrehi[i][dim] are the high doubles of the real parts
 *            of the value of the i-th monomial, and outputrehi[i][k] has the
 *            high doubles of the real parts of the value of
 *            the k-th derivative of the i-th monomial;
 *   outputrelo, in outputrelo[i][dim] are the low doubles of the real parts
 *            of the value of the i-th monomial, and outputrelo[i][k] has the
 *            low doubles of the real parts of the value of
 *            the k-th derivative of the i-th monomial;
 *   outputimhi, in outputrehi[i][dim] are the high doubles of the imaginary
 *            parts of the value of the i-th monomial, and outputimhi[i][k]
 *            has the high doubles of the imaginary parts of the value of
 *            the k-th derivative of the i-th monomial;
 *   outputimlo, in outputrelo[i][dim] are the low doubles of the imaginary
 *            parts of the value of the i-th monomial, and outputimlo[i][k]
 *            has the low doubles of the imaginary parts of the value of
 *            the k-th derivative of the i-th monomial. */

void GPU_dbl2_mon_evaldiff
 ( int szt, int dim, int nbr, int deg, int *nvr, int **idx,
   double **cffhi, double **cfflo, double **inputhi, double **inputlo,
   double ***outputhi, double ***outputlo, ConvolutionJobs cnvjobs,
   double *cnvlapms, double *elapsedms, double *walltimesec, bool verbose );
/*
 * DESCRIPTION :
 *   Evaluates and differentiates a monomial system.
 *   Computes the convolutions in the order as defined by jobs,
 *   on real data.
 *
 * ON ENTRY :
 *   szt      number of threads in a block, must equal deg + 1;
 *   dim      total number of variables;
 *   nbr      number of monomials, excluding the constant term;
 *   deg      truncation degree of the series;
 *   nvr      nvr[k] holds the number of variables in monomial k;
 *   idx      idx[k] has as many indices as the value of nvr[k],
 *            idx[k][i] defines the place of the i-th variable,
 *            with input values in input[idx[k][i]];
 *   cffhi    cffhi[k] has deg+1 doubles for the high doubles of 
 *            the coefficient series of monomial k;
 *   cfflo    cfflo[k] has deg+1 doubles for the low doubles of 
 *            the coefficient series of monomial k;
 *   inputhi  has the high doubles of the coefficients of the series
 *            for all variables in the polynomial;
 *   inputlo  has the low doubles of the coefficients of the series
 *            for all variables in the polynomial;
 *   outputhi has space allocated for the high double values and derivatives;
 *   outputlo has space allocated for the low double values and derivatives;
 *   cnvjobs  convolution jobs organized in layers;
 *   verbose  if true, then extra output about the setup is written.
 *
 * ON RETURN :
 *   outputhi has the high doubles of the output,
 *            outputhi[k], for k from 0 to dim-1, has the high double of
 *            the derivative with respect to the variable k;
 *            outputhi[dim] has the high double value of the polynomial;
 *   outputlo has the low doubles of the output,
 *            outputlo[k], for k from 0 to dim-1, has the low double of
 *            the derivative with respect to the variable k;
 *            outputlo[dim] has the low double value of the polynomial;
 *   cnvlapms is the elapsed time spent by all convolution kernels,
 *            expressed in milliseconds;
 *   addlapms is the elapsed time spent by all addition kernels,
 *            expressed in milliseconds;
 *   elapsedms is the elapsed time spent by all kernels,
 *            expressed in milliseconds;
 *   walltimesec is the elapsed wall clock time for all computations
 *            (excluding memory copies) in seconds. */

void GPU_cmplx2_mon_evaldiff
 ( int szt, int dim, int nbr, int deg, int *nvr, int **idx,
   double **cffrehi, double **cffrelo, double **cffimhi, double **cffimlo,
   double **inputrehi, double **inputrelo,
   double **inputimhi, double **inputimlo,
   double ***outputrehi, double ***outputrelo,
   double ***outputimhi, double ***outputimlo, ConvolutionJobs cnvjobs,
   double *cnvlapms, double *elapsedms, double *walltimesec, bool verbose );
/*
 * DESCRIPTION :
 *   Evaluates and differentiates a monomial system.
 *   Computes the convolutions in the order as defined by jobs,
 *   on complex data.
 *
 * ON ENTRY :
 *   szt      number of threads in a block, must equal deg + 1;
 *   dim      total number of variables;
 *   nbr      number of monomials, excluding the constant term;
 *   deg      truncation degree of the series;
 *   nvr      nvr[k] holds the number of variables in monomial k;
 *   idx      idx[k] has as many indices as the value of nvr[k],
 *            idx[k][i] defines the place of the i-th variable,
 *            with input values in input[idx[k][i]];
 *   cffrehi  cffrehi[k] has deg+1 high doubles of the real parts for
 *            the coefficient series of monomial k;
 *   cffrelo  cffrelo[k] has deg+1 low doubles of the real parts for
 *            the coefficient series of monomial k;
 *   cffimhi  cffimhi[k] has deg+1 high doubles of the imaginary parts for
 *            the coefficient series of monomial k;
 *   cffimlo  cffimlo[k] has deg+1 low doubles of the imaginary parts for
 *            the coefficient series of monomial k;
 *   inputrehi are the high doubles of the real parts of the coefficients
 *            of the series for all variables in the polynomial;
 *   inputrelo are the low doubles of the real parts of the coefficients
 *            of the series for all variables in the polynomial;
 *   inputimhi are the high doubles of the imaginary parts of the coefficients
 *            of the series for all variables in the polynomial;
 *   inputimlo are the low doubles of the imaginary parts of the coefficients
 *            of the series for all variables in the polynomial;
 *   outputrehi has space for the high doubles of the real parts
 *            of the value and all derivatives;
 *   outputrelo has space for the low doubles of the real parts
 *            of the value and all derivatives;
 *   outputimhi has space for the high doubles of the imaginary parts
 *            of value and all derivatives;
 *   outputimlo has space for the low doubles of the imaginary parts
 *            of value and all derivatives;
 *   cnvjobs  convolution jobs organized in layers;
 *   verbose  if true, then extra output about the setup is written.
 *
 * ON RETURN :
 *   outputrehi has the high doubles of the real parts of derivatives
 *            and the value, outputrehi[k], for k from 0 to dim-1,
 *            has the high doubles of the real part of the derivative
 *            with respect to the variable k; outputrehi[dim] has the
 *            high doubles of the real part of the value;
 *   outputrelo has the low doubles of the real parts of derivatives
 *            and the value, outputrelo[k], for k from 0 to dim-1,
 *            has the low doubles of the real part of the derivative
 *            with respect to the variable k; outputrelo[dim] has the
 *            low doubles of the real part of the value;
 *   outputimhi has the high doubles of the imaginary parts of derivatives
 *            and the value, outputimhi[k], for k from 0 to dim-1, has the
 *            high doubles of the imaginary part of the derivative
 *            with respect to the variable k; outputimhi[dim] has the high
 *            doubles of the imaginary part of the value;
 *   outputimlo has the low doubles of the imaginary parts of derivatives
 *            and the value, outputimlo[k], for k from 0 to dim-1, has the
 *            low doubles of the imaginary part of the derivative
 *            with respect to the variable k; outputimlo[dim] has the low
 *            doubles of the imaginary part of the value;
 *   cnvlapms is the elapsed time spent by all convolution kernels,
 *            expressed in milliseconds;
 *   addlapms is the elapsed time spent by all addition kernels,
 *            expressed in milliseconds;
 *   elapsedms is the elapsed time spent by all kernels,
 *            expressed in milliseconds;
 *   walltimesec is the elapsed wall clock time for all computations
 *            (excluding memory copies) in seconds. */

void GPU_dbl2_evaluate_monomials
 ( int dim, int deg, int szt, int nbt,
   int *nvr, int **idx, int **exp, int *nbrfac, int **expfac,
   double **cffhi, double **cfflo, double *acchi, double *acclo,
   double **inputhi, double **inputlo, double ***outputhi, double ***outputlo,
   int vrblvl );
/*
 * DESCRIPTION :
 *   Evaluates monomials at power series.
 *
 * ON ENTRY :
 *   dim      number of monomials;
 *   deg      degree of the power series;
 *   szt      size of each block of threads;
 *   nbt      number of thread blocks;
 *   nvr      nvr[i] is the number of variables in the i-th monomial;
 *   idx      idx[i] are the indices of the variables in monomial i;
 *   exp      exp[i] are the exponents of the variables in monomial i;
 *   nbrfac   nbrfac[i] are the number of exponents > 1 in monomial i;
 *   expfac   expfac[i] are the exponents in the i-th polynomial
 *            that are larger than one, minus one in the factor,
 *            if exp[i][k] > 1, then expfac[i][k] = exp[i][k] - 1;
 *   cffhi    high doubles of the coefficients of the monomials;
 *   cfflo    low doubles of the coefficients of the monomials;
 *   acchi    space to accumulate one power series of degree deg;
 *   acclo    space to accumulate one power series of degree deg;
 *   inputhi  high doubles of the coefficients of the series of degree deg,
 *            for dim variables;
 *   inputlo  low doubles of the coefficients of the series of degree deg,
 *            for dim variables;
 *   outputhi has space for the high doubles of the output;
 *   outputlo has space for the low doubles of the output;
 *   vrblvl   is the verbose level.
 *
 * ON RETURN :
 *   cffhi    has the high doubles of the evaluated common factors;
 *   cfflo    has the low doubles of the evaluated common factors;
 *   outputhi has the high doubles of the output,
 *            outputhi[k], for k from 0 to dim-1, has the high double of
 *            the derivative with respect to the variable k;
 *            outputhi[dim] has the high double value of the polynomial;
 *   outputlo has the low doubles of the output,
 *            outputlo[k], for k from 0 to dim-1, has the low double of
 *            the derivative with respect to the variable k;
 *            outputlo[dim] has the low double value of the polynomial. */

void GPU_cmplx2_evaluate_monomials
 ( int dim, int deg, int szt, int nbt,
   int *nvr, int **idx, int **exp, int *nbrfac, int **expfac,
   double **cffrehi, double **cffrelo, double **cffimhi, double **cffimlo,
   double *accrehi, double *accrelo, double *accimhi, double *accimlo,
   double **inputrehi, double **inputrelo,
   double **inputimhi, double **inputimlo, 
   double ***outputrehi, double ***outputrelo, 
   double ***outputimhi, double ***outputimlo, int vrblvl );
/*
 * DESCRIPTION :
 *   Evaluates monomials at power series.
 *
 * ON ENTRY :
 *   dim       number of monomials;
 *   deg       degree of the power series;
 *   szt       size of each block of threads;
 *   nbt       number of thread blocks;
 *   nvr       nvr[i] is the number of variables in the i-th monomial;
 *   idx       idx[i] are the indices of the variables in monomial i;
 *   exp       exp[i] are the exponents of the variables in monomial i;
 *   nbrfac    nbrfac[i] are the number of exponents > 1 in monomial i;
 *   expfac    expfac[i] are the exponents in the i-th polynomial
 *             that are larger than one, minus one in the factor,
 *             if exp[i][k] > 1, then expfac[i][k] = exp[i][k] - 1;
 *   cffrehi   high doubles of the real parts of the coefficients
 *   cffrelo   low doubles of the real parts of the coefficients
 *   cffimhi   high doubles of the imaginary parts of the coefficients;
 *   cffimlo   low doubles of the imaginary parts of the coefficients;
 *   accrehi   space to accumulate one series of degree deg;
 *   accrelo   space to accumulate one series of degree deg;
 *   accimhi   space to accumulate one  series of degree deg;
 *   accimlo   space to accumulate one  series of degree deg;
 *   inputrehi has the high doubles of the real parts of coefficients of
 *             the series of degree deg, for dim variables;
 *   inputrelo has the low doubles of the real parts of coefficients of
 *             the series of degree deg, for dim variables;
 *   inputimhi has the high doubles of the imaginary parts of coefficients of
 *             the series of degree deg, for dim variables;
 *   inputimlo has the low doubles of the imaginary parts of coefficients of
 *             the series of degree deg, for dim variables;
 *   outputrehi has space for high doubles of the real parts of the output;
 *   outputrelo has space for low doubles of the real parts of the output;
 *   outputimhi has space for the high doubles of the imag parts of the output;
 *   outputimlo has space for the low doubles of the imag parts of the output;
 *   vrblvl    is the verbose level.
 *
 * ON RETURN :
 *   cffrehi   has the high doubles of the real parts
 *             of the evaluated common factors;
 *   cffrelo   has the low doubles of the real parts
 *             of the evaluated common factors;
 *   cffimhi   has the high doubles of the imaginary parts
 *             of the evaluated common factors;
 *   cffimlo   has the low doubles of the imaginary parts
 *             of the evaluated common factors;
 *   outputrehi has the high doubles of the real parts of the evaluated
 *             and differentiated monomials, outputrehi[i][dim] has the
 *             high doubles of the real part of the value of the input
 *             at the i-th monomial, and for k in range 0..nvr[i]-1:
 *             outputrehi[i][idx[k]] has the high doubles of the real parts
 *             of the derivative w.r.t. idx[k];
 *   outputrelo has the low doubles of the real parts of the evaluated
 *             and differentiated monomials, outputrelo[i][dim] has the
 *             low doubles of the real part of the value of the input
 *             at the i-th monomial, and for k in range 0..nvr[i]-1:
 *             outputrelo[i][idx[k]] has the low doubles of the real parts
 *             of the derivative w.r.t. idx[k];
 *   outputimhi has the high doubles of the imaginary parts of the evaluated
 *             and differentiated monomials, outputimhi[i][dim] has the high
 *             doubles of the imaginary part of the value of the input 
 *             at the i-th monomial, and for k in range 0..nvr[i]-1:
 *             outputimhi[i][idx[k]] has the high doubles of the imaginary
 *             parts of te derivative w.r.t. idx[k];
 *   outputimlo has the low doubles of the imaginary parts of the evaluated
 *             and differentiated monomials, outputimlo[i][dim] has the low
 *             doubles of the imaginary part of the value of the input 
 *             at the i-th monomial, and for k in range 0..nvr[i]-1:
 *             outputimlo[i][idx[k]] has the low doubles of the imaginary
 *             parts of te derivative w.r.t. idx[k]. */

#endif
