/* The file dbl_matrices_kernels specifies functions on vectors and matrices
 * of series truncated to the same degree in double precision. */

#ifndef __dbl_matrices_kernels_h__
#define __dbl_matrices_kernels_h__

#define d_shmemsize 256

__global__ void dbl_convolutions ( double *x, double *y, int deg1 );
/*
 * DESCRIPTION :
 *   Makes all convolutions in the inner product of the vector x with y.
 *
 * ON ENTRY :
 *   x        coefficients of the series in the first vector;
 *   y        coefficients of the series in the second vector;
 *   deg1     number of coefficients in each series.
 *
 * ON RETURN :
 *   x        coefficient of the product of the series in x with y. */

__global__ void cmplx_convolutions
 ( double *xre, double *xim, double *yre, double *yim, int deg1 );
/*
 * DESCRIPTION :
 *   Makes all convolutions in the inner product of the vector x with y.
 *
 * ON ENTRY :
 *   xre      real parts of series coefficients in the first vector;
 *   xim      imaginary parts of series coefficients in the first vector;
 *   yre      real parts of series coefficients in the second vector;
 *   yim      imaginary parts of series coefficients in the second vector;
 *   deg1     number of coefficients in each series.
 *
 * ON RETURN :
 *   xre      real parts of the coefficients of the inner product;
 *   xim      imaginary parts of the coefficients of the inner product. */

__global__ void dbl_additions ( double *x, int lag, int shf, int deg1 );
/*
 * DESCRIPTION :
 *   Sums two series in x with distance apart as defined by lag,
 *   in the execution of a sum reduction.
 *
 * ON ENTRY :
 *   x        deg1 coefficients of dim series;
 *   lag      defines distance between two series;
 *   shf      shift for an odd number of series;
 *   deg1     number of coefficients in all series.
 *
 * ON RETURN :
 *   x        the first deg1 numbers are the coefficients of the sum,
 *            at the end of the sum reduction. */

__global__ void cmplx_additions
 ( double *xre, double *xim, int lag, int shf, int deg1 );
/*
 * DESCRIPTION :
 *   Sums two series in x with distance apart as defined by lag,
 *   in the execution of a sum reduction.
 *
 * ON ENTRY :
 *   xre      real parts of deg1 coefficients of dim series;
 *   xim      imaginary parts of deg1 coefficients of dim series;
 *   lag      defines distance between two series;
 *   shf      shift for an odd number of series;
 *   deg1     number of coefficients in all series.
 *
 * ON RETURN :
 *   xre      the first deg1 numbers are the real parts of the
 *            coefficients of the sum, at the end of the sum reduction;
 *   xim      the first deg1 numbers are the imaginary parts of the
 *            coefficients of the sum, at the end of the sum reduction. */

void GPU_dbl_inner_product
 ( int BS, int dim, int deg, double **x, double **y, double *z,
   int mode, bool verbose );
/*
 * DESCRIPTION :
 *   Computes the product of two real vectors x and y of power series
 *   and assigns the result to z.
 *
 * ON ENTRY :
 *   BS       number of threads in a block, must equal deg+1; 
 *   dim      dimension of the vectors x and y;
 *   deg      truncation degree of the series;
 *   x        dim series truncated to degree deg;
 *   y        dim series truncated to degree deg;
 *   z        space for deg+1 doubles;
 *   mode     if 1, then the addition happens on the CPU,
 *            otherwise the addition kernel is called;
 *   verbose  is the verbose flag.
 *
 * ON RETURN :
 *   z        the sum of all x[k]*y[k] for k from 0 to dim-1,
 *            as a power series truncated to the degree deg. */

void GPU_cmplx_inner_product
 ( int BS, int dim, int deg,
   double **xre, double **xim, double **yre, double **yim,
   double *zre, double *zim, int mode, bool verbose );
/*
 * DESCRIPTION :
 *   Computes the product of two complex vectors x and y of power series
 *   and assigns the result to z.
 *
 * ON ENTRY :
 *   BS       number of threads in a block, must equal deg+1; 
 *   dim      dimension of the vectors x and y;
 *   deg      truncation degree of the series;
 *   xre      real parts of dim series truncated to degree deg;
 *   xim      imaginary parts of dim series truncated to degree deg;
 *   yre      real parts of dim series truncated to degree deg;
 *   yim      imaginary parts of dim series truncated to degree deg;
 *   zre      space for deg+1 doubles;
 *   zim      space for deg+1 doubles;
 *   mode     if 1, then the addition happens on the CPU,
 *            otherwise the addition kernel is called;
 *   verbose  is the verbose flag.
 *
 * ON RETURN :
 *   zre      the real part of the sum of all x[k]*y[k],
 *            for k from 0 to dim-1,
 *            as a power series truncated to the degree deg;
 *   zim      the imaginary part of the sum of all x[k]*y[k],
 *            for k from 0 to dim-1,
 *            as a power series truncated to the degree deg. */

#endif
