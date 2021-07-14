// The file dbl_factors_testers.h specifies test functions
// on matrix factorizations in double precision.

#ifndef __dbl_factors_testers_h__
#define __dbl_factors_testers_h__

void test_factors_real_lufac ( void );
/*
 * DESCRIPTION :
 *   Prompts for a dimension and tests the LU factorization on real data. */

void test_factors_cmplx_lufac ( void );
/*
 * DESCRIPTION :
 *   Prompts for a dimension and tests the LU factorization
 *   on complex data. */

void test_real_qr_factors
 ( int nrows, int ncols, double **A, double **Q, double **R, int verbose );
/*
 * DESCRIPTION :
 *   Computes the errors of |Q^T*A - R| and |Q^T*Q - I|, for real data.
 *
 * ON ENTRY :
 *   nrows    number of rows in A, in R, and in Q;
 *   ncols    number of columns in A and in R;
 *   A        an nrows-by-ncols matrix;
 *   Q        an nrows-by-nrows matrix;
 *   R        an nrows-by-ncols matrix;
 *   verbose  is the verbose level. */

void test_cmplx_qr_factors
 ( int nrows, int ncols, double **Are, double **Aim,
   double **Qre, double **Qim, double **Rre, double **Rim, int verbose );
/*
 * DESCRIPTION :
 *   Computes the errors of |Q^T*A - R| and |Q^T*Q - I|, for complex data.
 *
 * ON ENTRY :
 *   nrows    number of rows in A, in R, and in Q;
 *   ncols    number of columns in A and in R;
 *   Are      real parts of an nrows-by-ncols matrix;
 *   Aim      imaginary parts of an nrows-by-ncols matrix;
 *   Qre      real parts of an nrows-by-nrows matrix;
 *   Qim      imaginary parts of an nrows-by-nrows matrix;
 *   Rre      real parts of an nrows-by-ncols matrix;
 *   Rim      imaginary parts of an nrows-by-ncols matrix;
 *   verbose  is the verbose level. */

void test_factors_real_houseqr ( void );
/*
 * DESCRIPTION :
 *   Prompts for dimensions and tests the QR decomposition
 *   with Householder matrices on real data. */

void test_factors_cmplx_houseqr ( void );
/*
 * DESCRIPTION :
 *   Prompts for dimensions and tests the QR decomposition
 *   with Householder matrices on complex data. */

#endif
