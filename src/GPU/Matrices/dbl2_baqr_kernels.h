/* The file dbl2_baqr_kernels.h specifies functions for the
 * blocked accelerated QR in double double precision. */

#ifndef __dbl2_baqr_kernels_h__
#define __dbl2_baqr_kernels_h__

#define dd_shmemsize 1024
#define cdd_shmemsize 512

__global__ void dbl2_small_house
 ( double *x0hi, double *x0lo, double *x1hi, double *x1lo,
   int dim, int dimLog2,
   double *vhi, double *vlo, double *betahi, double *betalo );
/*
 * DESCRIPTION :
 *   Computes the Householder vector of a vector x of dimension dim+1,
 *   with one block of dim threads, on real data.
 *
 * ON ENTRY :
 *   x0hi     high double of the first element of the vector x; 
 *   x0lo     low double of the first element of the vector x; 
 *   x1hi     array of dim doubles, with the high doubles of x;
 *   x1lo     array of dim doubles, with the low doubles of x;
 *   dim      the dimension of the vector must equal the block size;
 *   dimLog2  equals ceil(log2((double) dim), used in sum reduction;
 *   vhi      space allocated for dim+1 doubles;
 *   vlo      space allocated for dim+1 doubles.
 *
 * ON RETURN :
 *   vhi      high doubles of the Householder vector;
 *   vlo      low doubles of the Householder vector;
 *   betahi   the high double of 2/(transpose(v)*v);
 *   betalo   the low double of 2/(transpose(v)*v). */

__global__ void cmplx2_small_house
 ( double *x0rehi, double *x0relo, double *x0imhi, double *x0imlo,
   double *x1rehi, double *x1relo, double *x1imhi, double *x1imlo,
   int dim, int dimLog2,
   double *vrehi, double *vrelo, double *vimhi, double *vimlo,
   double *betahi, double *betalo );
/*
 * DESCRIPTION :
 *   Computes the Householder vector of a vector x of dimension dim+1,
 *   with one block of dim threads, on real data.
 *
 * ON ENTRY :
 *   x0rehi   high double of the real part of the first element of x; 
 *   x0relo   low double of the real part of the first element of x; 
 *   x0imhi   high double of the imaginary parts of the first element of x; 
 *   x0imlo   low double of the imaginary parts of the first element of x; 
 *   x1rehi   array of dim high doubles of the real parts of x;
 *   x1relo   array of dim low doubles of the real parts of x;
 *   x1imhi   array of dim high doubles of the imaginary parts of x;
 *   x1imlo   array of dim low doubles of the imaginary parts of x;
 *   dim      the dimension of the vector must equal the block size;
 *   dimLog2  equals ceil(log2((double) dim), used in sum reduction;
 *   vrehi    space allocated for dim+1 doubles;
 *   vrelo    space allocated for dim+1 doubles;
 *   vimhi    space allocated for dim+1 doubles.
 *   vimlo    space allocated for dim+1 doubles.
 *
 * ON RETURN :
 *   vrehi    high doubles of the real parts of the Householder vector;
 *   vrelo    low doubles of the real parts of the Householder vector;
 *   vimhi    high doubles of the imaginary parts of the Householder vector;
 *   vimlo    low doubles of the imaginary parts of the Householder vector;
 *   betahi   the high double of 2/(transpose(v)*v);
 *   betalo   the low double of 2/(transpose(v)*v). */

__global__ void dbl2_small_leftRupdate
 ( int nrows, int ncols, int szt, int k, double *Rhi, double *Rlo,
   double *vhi, double *vlo, double *betahi, double *betalo );
/*
 * DESCRIPTION :
 *   Updates the matrix R starting at column k
 *   with the Householder vector in v and beta, on real data,
 *   with a total of ncols - k threads in one block.
 *
 * ON ENTRY :
 *   nrows    number of rows of R;
 *   ncols    number of columns of R;
 *   szt      size of each block;
 *   k        index of the current column;
 *   Rhi      high doubles of an nrows-by-ncols matrix, stored column wise;
 *   Rlo      low doubles of an nrows-by-ncols matrix, stored column wise;
 *   vhi      high doubles of the Householder vector;
 *   vlo      low doubles of the Householder vector;
 *   betahi   the high double of 2/(transpose(v)*v);
 *   betalo   the low double of 2/(transpose(v)*v).
 *
 * ON RETURN :
 *   Rhi      high doubles of the updated matrix, which is trapezoidal;
 *   Rlo      low doubles of the updated matrix. */

__global__ void cmplx2_small_leftRupdate
 ( int nrows, int ncols, int szt, int k,
   double *Rrehi, double *Rrelo, double *Rimhi, double *Rimlo,
   double *vrehi, double *vrelo, double *vimhi, double *vimlo,
   double *betahi, double *betalo );
/*
 * DESCRIPTION :
 *   Updates the matrix R starting at column k
 *   with the Householder vector in v and beta, on complex data,
 *   with a total of ncols - k threads in one block.
 *
 * ON ENTRY :
 *   nrows    number of rows of R;
 *   ncols    number of columns of R;
 *   szt      size of each block;
 *   k        index of the current column;
 *   Rrehi    high doubles of the real parts of an nrows-by-ncols matrix,
 *            stored column wise;
 *   Rrelo    low doubles of the real parts of an nrows-by-ncols matrix,
 *            stored column wise;
 *   Rimhi    high doubles of the imaginary parts of an nrows-by-ncols matrix,
 *            stored column wise;
 *   Rimlo    low doubles of the imaginary parts of an nrows-by-ncols matrix,
 *            stored column wise.
 *
 * ON RETURN :
 *   Rrehi    high doubles of the real parts of the updated matrix,
 *            which is trapezoidal;
 *   Rrelo    low doubles of the real parts of the updated matrix;
 *   Rimhi    high doubles of the imaginary parts of the updated matrix;
 *   Rimlo    low doubles of the imaginary parts of the updated matrix. */

__global__ void dbl2_small_betaRTv
 ( int nrows, int ncols, int szt, int k,
   double *Rhi, double *Rlo, double *vhi, double *vlo,
   double *betahi, double *betalo, double *whi, double *wlo );
/*
 * DESCRIPTION :
 *   Computes the vector w = beta*R^T*v, on real data,
 *   with one block of ncols - k threads.
 *
 * ON ENTRY :
 *   nrows    number of rows of R;
 *   ncols    number of columns of R;
 *   szt      size of each block;
 *   k        index of the current column;
 *   Rhi      high doubles of an nrows-by-ncols matrix, stored column wise;
 *   Rlo      low doubles of an nrows-by-ncols matrix, stored column wise;
 *   vhi      high double of the Householder vector;
 *   vlo      low double of the Householder vector;
 *   betahi   high double of the beta corresponding with v;
 *   betalo   low double of the beta corresponding with v;
 *   whi      space for ncols numbers;
 *   wlo      space for ncols numbers;
 *
 * ON RETURN :
 *   whi      high doubles of beta*R^T*v in the first ncols-k numbers;
 *   wlo      low doubles of beta*R^T*v in the first ncols-k numbers. */

__global__ void dbl2_medium_subvbetaRTv
 ( int nrows, int ncols, int szt, int k,
   double *Rhi, double *Rlo, double *vhi, double *vlo,
   double *betahi, double *betalo, double *whi, double *wlo );
/*
 * DESCRIPTION :
 *   Applies the Householder vector to update R, on real data.
 *
 * REQUIRED : nrows - k > szt as multiple blocks are used.
 *
 * ON ENTRY :
 *   nrows    number of rows of R;
 *   ncols    number of columns of R;
 *   szt      size of each block;
 *   k        index of the current column;
 *   Rhi      high doubles of an nrows-by-ncols matrix, stored column wise;
 *   Rlo      low doubles of an nrows-by-ncols matrix, stored column wise;
 *   vhi      high double of the Householder vector;
 *   vlo      low double of the Householder vector;
 *   betahi   high double of the beta corresponding with v;
 *   betalo   low double of the beta corresponding with v;
 *   whi      high doubles of beta*R^T*v;
 *   wlo      low doubles of beta*R^T*v.
 *
 * ON RETURN :
 *   Rhi      high doubles of the updated trapezoidal matrix;
 *   Rlo      low doubles of the updated trapezoidal matrix. */

__global__ void dbl2_VB_to_W
 ( int nrows, int ncols, double *Bhi, double *Blo,
   double *Vhi, double *Vlo, double *Whi, double *Wlo );
/*
 * DESCRIPTION :
 *   Computes the W in the WY representation of the Householder
 *   transformations defined by V and B, on real data,
 *   with one block of nrows threads.
 *
 * ON ENTRY :
 *   nrows    number of rows in the matrices V, Y, and W;
 *   ncols    equals the size of one tile, or equivalently,
 *            is the number of elements in B,
 *            and the number of columns in V, Y, and W;
 *   Bhi      Bhi[i] is the high double of the i-th beta computed by house;
 *   Blo      Blo[i] is the low doubles of the i-th beta computed by house;
 *   Vhi      Vhi[nrows*i] is the start of the high doubles of the i-th
 *            Householder vector, with i zeros inserted so V is trapezoidal;
 *   Vlo      Vlo[nrows*i] is the start of the low doubles of the i-th
 *            Householder vector, with i zeros inserted so V is trapezoidal;
 *   Whi      space for ncols columns with rows from 0 to nrows-1;
 *   Wlo      space for ncols columns with rows from 0 to nrows-1.
 *
 * ON RETURN :
 *   Whi      high doubles of the W matrix in the WY representation;
 *   Wlo      low doubles of the W matrix in the WY representation. */

__global__ void cmplx2_VB_to_W
 ( int nrows, int ncols, double *Bhi, double *Blo,
   double *Vrehi, double *Vrelo, double *Vimhi, double *Vimlo,
   double *Wrehi, double *Wrelo, double *Wimhi, double *Wimlo );
/*
 * DESCRIPTION :
 *   Computes the W in the WY representation of the Householder
 *   transformations defined by V and B, on complex data,
 *   with one block of nrows threads.
 *
 * ON ENTRY :
 *   nrows    number of rows in the matrices V, Y, and W;
 *   ncols    equals the size of one tile, or equivalently,
 *            is the number of elements in B,
 *            and the number of columns in V, Y, and W;
 *   Bhi      Bhi[i] is the high double of the i-th beta computed by house;
 *   Blo      Blo[i] is the low double of the i-th beta computed by house;
 *   Vrehi    Vrehi[nrows*i] is the start of the high doubles
 *            of the real parts of the i-th Householder vector,
 *            with i zeros inserted so V is trapezoidal;
 *   Vrelo    Vrelo[nrows*i] is the start of the low doubles
 *            of the real parts of the i-th Householder vector,
 *            with i zeros inserted so V is trapezoidal;
 *   Vimhi    Vimhi[nrows*i] is the start of the high doubles
 *            of the imaginary parts of the i-th Householder vector,
 *            with i zeros inserted so V is trapezoidal;
 *   Vimlo    Vimlo[nrows*i] is the start of the low doubles
 *            of the imaginary parts of the i-th Householder vector,
 *            with i zeros inserted so V is trapezoidal;
 *   Wrehi    space for ncols columns with rows from 0 to nrows-1;
 *   Wrelo    space for ncols columns with rows from 0 to nrows-1;
 *   Wimhi    space for ncols columns with rows from 0 to nrows-1;
 *   Wimlo    space for ncols columns with rows from 0 to nrows-1.
 *
 * ON RETURN :
 *   Wrehi    high doubles of the real parts of the W matrix;
 *   Wrelo    low doubles of the real parts of the W matrix;
 *   Wimhi    high doubles of the imaginary parts of the W matrix;
 *   Wimlo    low doubles of the imaginary parts of the W matrix. */

__global__ void dbl2_beta_times_V
 ( int nrows, int szt, double *Bhi, double *Blo,
   double *Vhi, double *Vlo, double *Whi, double *Wlo );
/*
 * DESCRIPTION :
 *   Computes the first vector in the W representation of the Householder
 *   transformations, multiplying B[0] with the first vector of V,
 *   and flipping the sign, with multiple blocks of threads, on real data.
 *
 * ON ENTRY :
 *   nrows    number of rows in V and W;
 *   szt      size of one tile and the number of threads in a block;
 *   Bhi      Bhi[i] is the high double of the i-th beta computed by house;
 *   Blo      Blo[i] is the low double of the i-th beta computed by house;
 *   Vhi      Vhi[nrows*i] is the start of the high doubles of the i-th
 *            Householder vector, with i zeros inserted so V is trapezoidal;
 *   Vlo      Vlo[nrows*i] is the start of the low doubles of the i-th
 *            Householder vector, with i zeros inserted so V is trapezoidal;
 *   Whi      space for the high doubles of the W matrix;
 *   Wlo      space for the low doubles of the W matrix.
 *
 * ON RETURN :
 *   Whi      the first nrows numbers store the high doubles of the
 *            first vector of the W matrix in the WY representation;
 *   Wlo      the first nrows numbers store the low doubles of the
 *            first vector of the W matrix in the WY representation. */

__global__ void cmplx2_beta_times_V
 ( int nrows, int szt, double *Bhi, double *Blo,
   double *Vrehi, double *Vrelo, double *Vimhi, double *Vimlo,
   double *Wrehi, double *Wrelo, double *Wimhi, double *Wimlo );
/*
 * DESCRIPTION :
 *   Computes the first vector in the W representation of the Householder
 *   transformations, multiplying B[0] with the first vector of V,
 *   and flipping the sign, with multiple blocks of threads, on real data.
 *
 * ON ENTRY :
 *   nrows    number of rows in V and W;
 *   szt      size of one tile and the number of threads in a block;
 *   Bhi      Bhi[i] is the high double of the i-th beta computed by house;
 *   Blo      Blo[i] is the low double of the i-th beta computed by house;
 *   Vrehi    Vrehi[nrows*i] is the start of the high doubles of the real
 *            parts of the i-th Householder vector, with i zeros inserted;
 *   Vrelo    Vrelo[nrows*i] is the start of the low doubles of the real
 *            parts of the i-th Householder vector, with i zeros inserted;
 *   Vimhi    Vimhi[nrows*i] is the start of the high doubles of the imaginary
 *            parts of the i-th Householder vector, with i zeros inserted;
 *   Vimlo    Vimlo[nrows*i] is the start of the low doubles of the imaginary
 *            parts of the i-th Householder vector, with i zeros inserted;
 *   Wrehi    space for the high doubles of the real parts of the W matrix;
 *   Wrelo    space for the low doubles of the real parts of the W matrix;
 *   Wimhi    space for the high doubles of the imaginary parts of W;
 *   Wimlo    space for the low doubles of the imaginary parts of the W.
 *
 * ON RETURN :
 *   Wrehi    the first nrows numbers store the high doubles of the real
 *            parts of the first vector of the W the WY representation;
 *   Wrelo    the first nrows numbers store the low doubles of the real
 *            parts of the first vector of the W the WY representation;
 *   Wimhi    the first nrows numbers store the high doubles of the imaginary
 *            parts of the first vector of the W the WY representation;
 *   Wimlo    the first nrows numbers store the low doubles of the imaginary
 *            parts of the first vector of the W the WY representation. */

__global__ void dbl2_initialize_WYT
 ( int dim, int szt, double *Vhi, double *Vlo,
   double *Whi, double *Wlo, double *WYThi, double *WYTlo );
/*
 * DESCRIPTION :
 *   Initializes the matrix YWT with the product of the first dim products
 *   of W with Y elements with multiple blocks of szt threads,
 *   on real data.
 *
 * ON ENTRY :
 *   dim      number of rows and columns in WYT;
 *   szt      number of threads in one block;
 *   Vhi      the first dim numbers define the high doubles of
 *            the first Householder vector;
 *   Vlo      the first dim numbers define the low doubles of
 *            the first Householder vector;
 *   Whi      the first dim numbers define the high doubles of
 *            the first column in the W matrix;
 *   Wlo      the first dim numbers define the low doubles of
 *            the first column in the W matrix;
 *   WYThi    space for a dim-by-dim matrix;
 *   WYTlo    space for a dim-by-dim matrix.
 *
 * ON RETURN :
 *   WYThi    high doubles of w*y^T,
 *            where y and w are the first columns of V and W;
 *   WYTlo    low doubles of w*y^T,
 *            where y and w are the first columns of V and W. */

__global__ void cmplx2_initialize_WYT
 ( int dim, int szt,
   double *Vrehi, double *Vrelo, double *Vimhi, double *Vimlo,
   double *Wrehi, double *Wrelo, double *Wimhi, double *Wimlo,
   double *WYTrehi, double *WYTrelo, double *WYTimhi, double *WYTimlo );
/*
 * DESCRIPTION :
 *   Initializes the matrix YWT with the product of the first dim products
 *   of W with Y elements with multiple blocks of szt threads,
 *   on real data.
 *
 * ON ENTRY :
 *   dim      number of rows and columns in WYT;
 *   szt      number of threads in one block;
 *   Vrehi    the first dim numbers define the high doubles of
 *            the real parts of the first Householder vector;
 *   Vrelo    the first dim numbers define the low doubles of
 *            the real parts of the first Householder vector;
 *   Vimhi    the first dim numbers define the high doubles of
 *            the imaginary parts of the first Householder vector;
 *   Vimlo    the first dim numbers define the low doubles of
 *            the imaginary parts of the first Householder vector;
 *   Wrehi    the first dim numbers define the high doubles of
 *            the real parts of the first column in the W matrix;
 *   Wrelo    the first dim numbers define the low doubles of
 *            the real parts of the first column in the W matrix;
 *   Wimhi    the first dim numbers define the high doubles of
 *            the imaginary parts of the first column in the W matrix;
 *   Wimlo    the first dim numbers define the low doubles of
 *            the imaginary parts of the first column in the W matrix;
 *   WYTrehi  space for a dim-by-dim matrix;
 *   WYTrelo  space for a dim-by-dim matrix;
 *   WYTimhi  space for a dim-by-dim matrix;
 *   WYTimlo  space for a dim-by-dim matrix.
 *
 * ON RETURN :
 *   WYTrehi  high doubles of the real part of w*y^T,
 *            where y and w are the first columns of V and W;
 *   WYTrelo  low doubles of the real part of w*y^T,
 *            where y and w are the first columns of V and W;
 *   WYTimhi  high doubles of the imaginary part of w*y^T,
 *            where y and w are the first columns of V and W;
 *   WYTimlo  low doubles of the imaginary part of w*y^T,
 *            where y and w are the first columns of V and W. */

__global__ void dbl2_update_WYT
 ( int dim, int szt, double *Vhi, double *Vlo, double *Whi, double *Wlo,
   double *WYThi, double *WYTlo );
/*
 * DESCRIPTION :
 *   Updates the matrix WYT with the product of the first dim products
 *   of W with Y elements with multiple blocks of szt threads,
 *   on real data.
 *
 * ON ENTRY :
 *   dim      number of rows and columns in YWT;
 *   szt      number of threads in one block;
 *   Vhi      the first dim numbers define the high doubles
 *            of the next Householder vector;
 *   Vlo      the first dim numbers define the low doubles
 *            of the next Householder vector;
 *   Whi      the first dim numbers define the high doubles
 *            of the next column in the W matrix;
 *   Wlo      the first dim numbers define the low doubles
 *            of the next column in the W matrix;
 *   WYThi    dim-by-dim matrix with the high doubles for WYT;
 *   WYTlo    dim-by-dim matrix with the low doubles for WYT.
 *
 * ON RETURN :
 *   WYThi    high doubles of the updated matrix W*Y^T;
 *   WYTlo    low doubles of the updated matrix W*Y^T. */

__global__ void cmplx2_update_WYH
 ( int dim, int szt,
   double *Vrehi, double *Vrelo, double *Vimhi, double *Vimlo,
   double *Wrehi, double *Wrelo, double *Wimhi, double *Wimlo,
   double *WYHrehi, double *WYHrelo, double *WYHimhi, double *WYHimlo );
/*
 * DESCRIPTION :
 *   Updates the matrix YWT with the product of the first dim products
 *   of W with Y elements with multiple blocks of szt threads,
 *   on complex data.
 *
 * ON ENTRY :
 *   dim      number of rows and columns in WYT;
 *   szt      number of threads in one block;
 *   Vrehi    the first dim numbers define the high doubles of
 *            the real parts of the first Householder vector;
 *   Vrelo    the first dim numbers define the low doubles of
 *            the real parts of the first Householder vector;
 *   Vimhi    the first dim numbers define the high doubles of
 *            the imaginary parts of the first Householder vector;
 *   Vimlo    the first dim numbers define the low doubles of
 *            the imaginary parts of the first Householder vector;
 *   Wrehi    the first dim numbers define the high doubles of
 *            the real parts of the first column in the W matrix;
 *   Wrelo    the first dim numbers define the low doubles of
 *            the real parts of the first column in the W matrix;
 *   Wimhi    the first dim numbers define the high doubles of
 *            the imaginary parts of the first column in the W matrix;
 *   Wimlo    the first dim numbers define the low doubles of
 *            the imaginary parts of the first column in the W matrix;
 *   WYHrehi  dim-by-dim matrix with the high doubles of the real
 *            parts of W*Y^H;
 *   WYHrelo  dim-by-dim matrix with the low doubles of the imaginary
 *            parts of W*Y^H;
 *   WYHimhi  dim-by-dim matrix with the high doubles of the real
 *            parts of W*Y^H;
 *   WYHimlo  dim-by-dim matrix with the low doubles of the imaginary
 *            parts of W*Y^H.
 *
 * ON RETURN :
 *   WYHrehi  high doubles of the real parts of the updated W*Y^H,
 *            where y and w are the first columns of V and W;
 *   WYHrelo  low doubles of the real parts of the updated W*Y^H,
 *            where y and w are the first columns of V and W;
 *   WYHimhi  high doubles of the imaginary parts of the updated W*Y^H,
 *            where y and w are the first columns of V and W;
 *   WYHimlo  low doubles of the imaginary part of the updated W*Y^H,
 *            where y and w are the first columns of V and W. */

__global__ void dbl2_beta_next_W
 ( int nrows, int szt, double *Bhi, double *Blo, double *Vhi, double *Vlo,
   double *Whi, double *Wlo, double *WYThi, double *WYTlo );
/*
 * DECRIPTION :
 *   Computes the next column in the W matrix, with multiple blocks,
 *   on real data.
 *
 * ON ENTRY :
 *   nrows    number of rows in V, W, and the dimension of WYT;
 *   szt      number of threads in one block;
 *   Bhi      high double of the beta with the next Householder vector;
 *   Blo      low double of the beta with the next Householder vector;
 *   Vhi      the first dim numbers define the high doubles
 *            of the next Householder vector;
 *   Vlo      the first dim numbers define the low doubles
 *            of the next Householder vector;
 *   Whi      the first dim numbers define the high doubles
 *            of the next column in the W matrix;
 *   Wlo      the first dim numbers define the low doubles
 *            of the next column in the W matrix;
 *   WYThi    dim-by-dim matrix with the high doubles for WYT;
 *   WYTlo    dim-by-dim matrix with the low doubles for WYT.
 *
 * ON RETURN :
 *   Whi      the high doubles of the next column of W;
 *   Wlo      the low doubles of the next column of W. */

__global__ void cmplx2_beta_next_W
 ( int nrows, int szt, double *Bhi, double *Blo,
   double *Vrehi, double *Vrelo, double *Vimhi, double *Vimlo,
   double *Wrehi, double *Wrelo, double *Wimhi, double *Wimlo,
   double *WYHrehi, double *WYHrelo, double *WYHimhi, double *WYHimlo );
/*
 * DECRIPTION :
 *   Computes the next column in the W matrix, with multiple blocks,
 *   on real data.
 *
 * ON ENTRY :
 *   nrows    number of rows in V, W, and the dimension of WYT;
 *   szt      number of threads in one block;
 *   Bhi      high double of the beta with the next Householder vector;
 *   Blo      low double of the beta with the next Householder vector;
 *   Vrehi    the first dim numbers define the high doubles of
 *            the real parts of the next Householder vector;
 *   Vrelo    the next dim numbers define the low doubles of
 *            the real parts of the next Householder vector;
 *   Vimhi    the next dim numbers define the high doubles of
 *            the imaginary parts of the next Householder vector;
 *   Vimlo    the next dim numbers define the low doubles of
 *            the imaginary parts of the next Householder vector;
 *   Wrehi    the next dim numbers define the high doubles of
 *            the real parts of the next column in the W matrix;
 *   Wrelo    the next dim numbers define the low doubles of
 *            the real parts of the next column in the W matrix;
 *   Wimhi    the next dim numbers define the high doubles of
 *            the imaginary parts of the next column in the W matrix;
 *   Wimlo    the next dim numbers define the low doubles of
 *            the imaginary parts of the next column in the W matrix;
 *   WYHrehi  dim-by-dim matrix with the high doubles of the real
 *            parts of W*Y^H;
 *   WYHrelo  dim-by-dim matrix with the low doubles of the imaginary
 *            parts of W*Y^H;
 *   WYHimhi  dim-by-dim matrix with the high doubles of the real
 *            parts of W*Y^H;
 *   WYHimlo  dim-by-dim matrix with the low doubles of the imaginary
 *            parts of W*Y^H.
 *
 * ON RETURN :
 *   Wrehi    high doubles of the real parts of the next column of W;
 *   Wrelo    low doubles of the real parts of the next column of W;
 *   Wimhi    high doubles of the imaginary parts of the next column of W;
 *   Wimlo    low doubles of the imaginary parts of the next column of W. */

__global__ void dbl2_small_WYT
 ( int nrows, int szt, double *Whi, double *Wlo, double *Vhi, double *Vlo,
   double *WYThi, double *WYTlo );
/*
 * DESCRIPTION :
 *   Multiplies W with V^T into the matrix WYT, on real data.
 *   Computes Y*W^T, swapping W with Y in the input arguments.
 *
 * ON ENTRY :
 *   nrows    number of rows of all matrices;
 *   szt      number of columns in W and Y,
 *            equals the number of threads in a block;
 *   Whi      high doubles of the W matrix in the WY representation;
 *   Wlo      low doubles of the W matrix in the WY representation;
 *   Vhi      the columns of V are high doubles of the Householder vectors;
 *   Vlo      the columns of V are low doubles of the Householder vectors;
 *   WYThi    space for an nrows-by-nrows matrix,
 *            with extra padding for when nrows > szt;
 *   WYTlo    space for an nrows-by-nrows matrix,
 *            with extra padding for when nrows > szt.
 *
 * ON RETURN :
 *   WYThi    high doubles of the product of W with Y^T;
 *   WYTlo    low doubles of the product of W with Y^T. */

__global__ void cmplx2_small_WYT
 ( int nrows, int szt,
   double *Wrehi, double *Wrelo, double *Wimhi, double *Wimlo,
   double *Yrehi, double *Yrelo, double *Yimhi, double *Yimlo,
   double *WYTrehi, double *WYTrelo, double *WYTimhi, double *WYTimlo );
/*
 * DESCRIPTION :
 *   Multiplies W with Y^T into the matrix WYT, on complex data.
 *   Computes Y*W^T, swapping W with Y in the input arguments.
 *
 * ON ENTRY :
 *   nrows    number of rows of all matrices;
 *   szt      number of columns in W and Y,
 *            equals the number of threads in a block;
 *   Wrehi    high doubles of the real parts of the W matrix;
 *   Wrelo    low doubles of the real parts of the W matrix;
 *   Wimhi    high doubles of the imaginary parts of the W matrix;
 *   Wimlo    low doubles of the imaginary parts of the W matrix;
 *   Yrehi    high doubles of the real parts of the columns of Y;
 *   Yrelo    low doubles of the real parts of the columns of Y;
 *   Yimhi    high doubles of the imaginary parts of the columns of Y;
 *   Yimlo    low doubles of the imaginary parts of the columns of Y;
 *   WYTrehi  space for an nrows-by-nrows matrix,
 *            with extra padding for when nrows > szt;
 *   WYTrelo  space for an nrows-by-nrows matrix,
 *            with extra padding for when nrows > szt;
 *   WYTimhi  space for an nrows-by-nrows matrix,
 *            with extra padding for when nrows > szt;
 *   WYTimlo  space for an nrows-by-nrows matrix,
 *            with extra padding for when nrows > szt.
 *
 * ON RETURN :
 *   WYTre    high doubles of the real parts of W*Y^T;
 *   WYTre    low doubles of the real parts of W*Y^T;
 *   WYTim    high doubles of the imaginary parts of W*Y^T;
 *   WYTim    low doubles of the imaginary parts of W*Y^T. */

__global__ void dbl2_small_QWYT
 ( int dim, int rowdim, int szt, int coloff,
   double *Qhi, double *Qlo, double *WYThi, double *WYTlo,
   double *QWYThi, double *QWYTlo );
/*
 * DESCRIPTION :
 *   Multiplies Q with WYT into the matrix QWYT, on real data.
 *
 * ON ENTRY :
 *   dim      number of rows and columns of the Q matrix;
 *   rowdim   number of rows and columns of the WYT matrix;
 *   szt      the number of threads in a block;
 *   coloff   offset for the column index in QWYT;
 *   Qhi      high doubles of the current orthogonal matrix;
 *   Qlo      low doubles of the current orthogonal matrix;
 *   WYThi    high doubles of the product of W with Y^T;
 *   WYTlo    low doubles of the product of W with Y^T;
 *   QWYThi   space for a dim-by-dim matrix;
 *   QWYTlo   space for a dim-by-dim matrix.
 *
 * ON RETURN :
 *   QWYThi   high doubles of the product of Q with QWYT;
 *   QWYTlo   low doubles of the product of Q with QWYT. */

__global__ void cmplx2_small_QWYT
 ( int dim, int rowdim, int szt, int coloff,
   double *Qrehi, double *Qrelo, double *Qimhi, double *Qimlo,
   double *WYTrehi, double *WYTrelo, double *WYTimhi, double *WYTimlo,
   double *QWYTrehi, double *QWYTrelo, double *QWYTimhi, double *QWYTimlo );
/*
 * DESCRIPTION :
 *   Multiplies Q with WYT into the matrix QWYT, on complex data.
 *
 * ON ENTRY :
 *   dim      number of rows and columns of the Q matrix;
 *   rowdim   number of rows and columns of the WYT matrix;
 *   szt      the number of threads in a block;
 *   coloff   offset for the column index in QWYT;
 *   Qrehi    high doubles of the real parts of Q;
 *   Qrelo    low double of the real parts of Q;
 *   Qimhi    high doubles of the imaginary parts of Q;
 *   Qimlo    low doubles of the imaginary parts of Q;
 *   WYTrehi  high doubles of the real parts of W*Y^T;
 *   WYTrelo  low doubles of the real parts of W*Y^T;
 *   WYTimhi  high doubles of the imaginary parts of W*Y^T;
 *   WYTimlo  low doubles of the imaginary parts of W*Y^T;
 *   QWYTrehi has space for a dim-by-dim matrix;
 *   QWYTrelo has space for a dim-by-dim matrix;
 *   QWYTimhi has space for a dim-by-dim matrix;
 *   QWYTimlo has space for a dim-by-dim matrix.
 *
 * ON RETURN :
 *   QWYTrehi are the high doubles of the real parts of Q*W*Y^T;
 *   QWYTrelo are the low doubles of the real parts of Q*W*Y^T;
 *   QWYTimhi are the high doubles of the imaginary parts of Q*W*Y^T;
 *   QWYTimlo are the low doubles of the imaginary parts of Q*W*Y^T. */

__global__ void dbl2_small_YWTC
 ( int nrows, int ncols, int rowdim, int coldim, int szt,
   int rowoff, int coloff, double *YWThi, double *YWTlo,
   double *Chi, double *Clo, double *YWTChi, double *YWTClo );
/*
 * DESCRIPTION :
 *   Multiplies YWT with C into the matrix YWTC, on real data.
 *
 * ON ENTRY :
 *   nrows    total number of rows, nrows = rowdim + rowoff;
 *   ncols    total number of colums, ncols = coldim + coloff;
 *   rowdim   number of rows minus the row offset;
 *   coldim   number of columns minus the column offset;
 *   szt      the number of threads in a block;
 *   rowoff   offset for the row index in C;
 *   coloff   offset for the column index in C;
 *   Chi      high doubles of the current matrix to be reduced;
 *   Clo      low doubles of the current matrix to be reduced;
 *   YWThi    high doubles of the product of Y with W^T;
 *   YWTlo    low doubles of the product of Y with W^T;
 *   YWTChi   space for a rowdim-by-coldim matrix;
 *   YWTClo   space for a rowdim-by-coldim matrix.
 *
 * ON RETURN :
 *   YWTChi   high doubles of the product of YWT with C;
 *   YWTClo   low doubles of the product of YWT with C. */

__global__ void cmplx2_small_YWTC
 ( int nrows, int ncols, int rowdim, int coldim, int szt,
   int rowoff, int coloff,
   double *YWTrehi, double *YWTrelo, double *YWTimhi, double *YWTimlo,
   double *Crehi, double *Crelo, double *Cimhi, double *Cimlo,
   double *YWTCrehi, double *YWTCrelo, double *YWTCimhi, double *YWTCimlo );
/*
 * DESCRIPTION :
 *   Multiplies YWT with C into the matrix YWTC, on complex data.
 *
 * ON ENTRY :
 *   nrows    total number of rows, nrows = rowdim + rowoff;
 *   ncols    total number of colums, ncols = coldim + coloff;
 *   rowdim   number of rows minus the row offset;
 *   coldim   number of columns minus the column offset;
 *   szt      the number of threads in a block;
 *   rowoff   offset for the row index in C;
 *   coloff   offset for the column index in C;
 *   Crehi    high doubles of the real parts of the matrix to be reduced;
 *   Crelo    low doubles of the real parts of the matrix to be reduced;
 *   Cimhi    high doubles of the imaginary parts of the matrix to be reduced;
 *   Cimlo    low doubles of the imaginary parts of the matrix to be reduced;
 *   YWTrehi  high doubles of the real parts of Y*W^T;
 *   YWTrelo  low doubles of the real parts of Y*W^T;
 *   YWTimhi  high doubles of the imaginary parts of Y*W^T;
 *   YWTimlo  low doubles of the imaginary parts of Y*W^T;
 *   YWTCrehi has space for a rowdim-by-coldim matrix;
 *   YWTCrelo has space for a rowdim-by-coldim matrix;
 *   YWTCimhi has space for a rowdim-by-coldim matrix.
 *   YWTCimlo has space for a rowdim-by-coldim matrix.
 *
 * ON RETURN :
 *   YWTCrehi are the high doubles of the real parts of YWT*C;
 *   YWTCrelo are the low doubles of the real parts of YWT*C;
 *   YWTCimhi are the high doubles of the imaginary parts of YWT*C;
 *   YWTCimlo are the low doubles of the imaginary parts of YWT*C. */

__global__ void dbl2_small_Qupdate
 ( int dim, int rowdim, int szt, int coloff,
   double *Qhi, double *Qlo, double *QWYThi, double *QWYTlo );
/*
 * DESCRIPTION :
 *   Updates Q by adding QWYT, on real data.
 *
 * ON ENTRY :
 *   dim      number of rows and columns of all matrices;
 *   szt      the number of threads in a block;
 *   coloff   offset for the column index in QWYT;
 *   Qhi      high doubles of the current orthogonal matrix;
 *   Qlo      low doubles of the current orthogonal matrix;
 *   QWYThi   space for a dim-by-dim matrix;
 *   QWYTlo   space for a dim-by-dim matrix.
 *
 * ON RETURN :
 *   Qhi      high doubles of Q + QWYT;
 *   Qlo      low doubles of Q + QWYT. */

__global__ void cmplx2_small_Qupdate
 ( int dim, int rowdim, int szt, int coloff,
   double *Qrehi, double *Qrelo, double *Qimhi, double *Qimlo,
   double *QWYTrehi, double *QWYTrelo, double *QWYTimhi, double *QWYTimlo );
/*
 * DESCRIPTION :
 *   Updates Q by adding QWYT, on complex data.
 *
 * ON ENTRY :
 *   dim      number of rows and columns of all matrices;
 *   rowdim   dimension minus the column offset;
 *   szt      the number of threads in a block;
 *   coloff   offset for the column index in QWYT;
 *   Qrehi    high doubles of the real parts of Q;
 *   Qrelo    low doubles of the real parts of Q;
 *   Qimhi    high doubles of the imaginary parts of Q;
 *   Qimlo    low doubles of the imaginary parts of Q;
 *   QWYTre   space for a dim-by-dim matrix;
 *   QWYTre   space for a dim-by-dim matrix;
 *   QWYTim   space for a dim-by-dim matrix;
 *   QWYTim   space for a dim-by-dim matrix.
 *
 * ON RETURN :
 *   Qrehi    high doubles of the real parts of Q + QWYT;
 *   Qrelo    low doubles of the real parts of Q + QWYT;
 *   Qimhi    high doubles of the imaginary parts Q + QWYT;
 *   Qimlo    low doubles of the imaginary parts Q + QWYT. */

__global__ void dbl2_small_R_add_YWTC
 ( int nrows, int coldim, int szt, int rowoff, int coloff,
   double *Rhi, double *Rlo, double *YWTChi, double *YWTClo );
/*
 * DESCRIPTION :
 *   Updates R by adding YWTC, on real data.
 *
 * ON ENTRY :
 *   nrows    total number of rows in R and YWTC;
 *   coldim   number of columns minus the column offset;
 *   szt      the number of threads in a block;
 *   rowoff   offset for the row index in R;
 *   coloff   offset for the column index in R;
 *   Rhi      high doubles of the current matrix to be reduced;
 *   Rlo      low doubles of the current matrix to be reduced;
 *   YWTChi   high doubles of the product of YWT with C;
 *   YWTClo   low doubles of the product of YWT with C.
 *
 * ON RETURN :
 *   Rhi      high doubles of R + YWTC;
 *   Rlo      low doubles of R + YWTC. */

__global__ void cmplx2_small_R_add_YWTC
 ( int nrows, int coldim, int szt, int rowoff, int coloff,
   double *Rrehi, double *Rrelo, double *Rimhi, double *Rimlo, 
   double *YWTCrehi, double *YWTCrelo, double *YWTCimhi, double *YWTCimlo );
/*
 * DESCRIPTION :
 *   Updates R by adding YWTC, on complex data.
 *
 * ON ENTRY :
 *   nrows    total number of rows in R and YWTC;
 *   coldim   number of columns minus the column offset;
 *   szt      the number of threads in a block;
 *   rowoff   offset for the row index in R;
 *   coloff   offset for the column index in R;
 *   Rrehi    high doubles of the real parts of the matrix to be reduced;
 *   Rrelo    low doubles of the real parts of the matrix to be reduced;
 *   Rimhi    high doubles of the imaginary parts of the  matrix to be reduced;
 *   Rimlo    low doubles of the imaginary parts of the  matrix to be reduced;
 *   YWTCrehi are the high doubles of the real parts of YWT*C.
 *   YWTCrelo are the low doubles of the real parts of YWT*C.
 *   YWTCimhi are the high doubles of the imaginary parts of YWT*C.
 *   YWTCimlo are the low doubles of the imaginary parts of YWT*C.
 *
 * ON RETURN :
 *   Rrehi    high doubles of the real parts of R + YWTC;
 *   Rrelo    low doubles of the real parts of R + YWTC;
 *   Rimhi    high doubles of the imaginary parts R + YWTC;
 *   Rimlo    low doubles of the imaginary parts R + YWTC. */

void GPU_dbl2_small_house
 ( int nrows, int ncols, int szt, int nbt,
   int colidx, int nrows1, int k, int L,
   double *Ahi_h, double *Alo_h, double *Ahi_d, double *Alo_d,
   double *vhi_h, double *vlo_h, double *Vhi_d, double *Vlo_d,
   double *betahi_h, double *betalo_h, double *betahi_d, double *betalo_d,
   double *lapms, bool verbose=true );
/*
 * DESCRIPTION :
 *   Calls the kernel to compute the Householder vector for small
 *   enough matrices for the vector to fit entirely in shared memory.
 *
 * ON ENTRY :
 *   nrows    number of rows in the matrix A;
 *   ncols    number of columns in the matrix A;
 *   szt      size of one tile;
 *   nbt      number of tiles, szt*nbt = ncols;
 *   colidx   global index of the current column;
 *   nrows1   number of threads in the block equals the number
 *            of elements computed in the Householder vector;
 *   L        local index of the column in the current tile;
 *   Ahi_h    high doubles of the matrix on the host;
 *   Alo_h    low doubles of the matrix on the host;
 *   Ahi_d    high doubles of the matrix on the device;
 *   Alo_d    low doubles of the matrix on the device;
 *   vhi_h    space for the current Householder vector;
 *   vlo_h    space for the current Householder vector;
 *   Vhi_d    space for the Householder vectors on the device;
 *   Vlo_d    space for the Householder vectors on the device;
 *   betahi_h has space for the high doubles of the betas if verbose;
 *   betalo_h has space for the low doubles of the betas if verbose;
 *   betahi_d has space on the device for the high doubles of the betas;
 *   betalo_d has space on the device for the low doubles of the betas;
 *   verbose  is the verbose flag.
 *
 * ON RETURN :
 *   vhi_h    high doubles of the next Householder vector on the host,
 *            if verbose;
 *   vlo_h    low doubles of the next Householder vector on the host,
 *            if verbose;
 *   Vhi_d    high doubles of the next computed Householder vector;
 *   Vlo_d    low doubles of the next computed Householder vector;
 *   betahi_h has the updated vector of the high doubles of the betas,
 *            if verbose;
 *   betalo_h has the updated vector of low doubles of the betas,
 *            if verbose;
 *   betahi_d has the high double of the next beta constant;
 *   betalo_d has the low double of the next beta constant;
 *   lapms    elapsed time spent by the kernel. */

void GPU_cmplx2_small_house
 ( int nrows, int ncols, int szt, int nbt,
   int colidx, int nrows1, int k, int L,
   double *Arehi_h, double *Arelo_h, double *Aimhi_h, double *Aimlo_h,
   double *Arehi_d, double *Arelo_d, double *Aimhi_d, double *Aimlo_d,
   double *vrehi_h, double *vrelo_h, double *vimhi_h, double *vimlo_h,
   double *Vrehi_d, double *Vrelo_d, double *Vimhi_d, double *Vimlo_d,
   double *betahi_h, double *betalo_h, double *betahi_d, double *betalo_d,
   double *lapms, bool verbose=true );
/*
 * DESCRIPTION :
 *   Calls the kernel to compute the Householder vector for small
 *   enough matrices for the vector to fit entirely in shared memory.
 *
 * ON ENTRY :
 *   nrows    number of rows in the matrix A;
 *   ncols    number of columns in the matrix A;
 *   szt      size of one tile;
 *   nbt      number of tiles, szt*nbt = ncols;
 *   colidx   global index of the current column;
 *   nrows1   number of threads in the block equals the number
 *            of elements computed in the Householder vector;
 *   L        local index of the column in the current tile;
 *   Arehi_h  high doubles of the real parts of the matrix on the host;
 *   Arelo_h  low doubles of the real parts of the matrix on the host;
 *   Aimhi_h  high doubles of the imaginary parts of the matrix on the host;
 *   Aimlo_h  low doubles of the imaginary parts of the matrix on the host;
 *   Arehi_d  high doubles of the real parts of the matrix on the device;
 *   Arelo_d  low doubles of the real parts of the matrix on the device;
 *   Aimhi_d  high doubles of the imaginary parts of the matrix on the device;
 *   Aimlo_d  low doubles of the imaginary parts of the matrix on the device;
 *   vrehi_h  has space for the high doubles of the real parts
 *            of the current Householder vector;
 *   vrelo_h  has space for the low doubles of the real parts
 *            of the current Householder vector;
 *   vimhi_h  has space for the high doubles of the imaginary parts
 *            of the current Householder vector;
 *   vimlo_h  has space for the low doubles of the imaginary parts
 *            of the current Householder vector;
 *   Vrehi_d  has space for the high doubles of the real parts
 *            of the Householder vectors on the device;
 *   Vrelo_d  has space for the low doubles of the real parts
 *            of the Householder vectors on the device;
 *   Vimhi_d  has space for the high doubles of the imaginary parts
 *            of the Householder vectors on the device;
 *   Vimlo_d  has space for the low doubles of the imaginary parts
 *            of the Householder vectors on the device;
 *   betahi_h has space for the high doubles of betas if verbose;
 *   betalo_h has space for the low doubles of betas if verbose;
 *   betahi_d has space on the device for the high doubles of the betas;
 *   betalo_d has space on the device for the low doubles of the betas;
 *   verbose  is the verbose flag.
 *
 * ON RETURN :
 *   v_h      the next Householder vector on the host, if verbose;
 *   v_h      the next Householder vector on the host, if verbose;
 *   Vre_d    real parts of the next computed Householder vector;
 *   Vre_d    real parts of the next computed Householder vector;
 *   Vim_d    imaginary parts of the next computed Householder vector;
 *   Vim_d    imaginary parts of the next computed Householder vector;
 *   betahi_h has the high doubles of the updated vector of betas, if verbose;
 *   betalo_h has the low doubles of the updated vector of betas, if verbose;
 *   betahi_d has the high doubles of the next beta constant;
 *   betalo_d has the low doubles of the next beta constant;
 *   lapms    elapsed time spent by the kernel. */

void GPU_dbl2_small_leftRupdate
 ( int nrows, int ncols, int szt, int colidx, int k, int L,
   double *Ahi_h, double *Alo_h, double *Ahi_d, double *Alo_d,
   double *Vhi_d, double *Vlo_d,
   double *betahi_h, double *betalo_h, double *betahi_d, double *betalo_d,
   double *lapms, bool verbose=true );
/*
 * DESCRIPTION :
 *   Calls the kernel to update one tile.
 *   Wraps the timer and the print statements if verbose.
 *   If verbose, then the reduced matrix is returned on the host.
 *
 * ON ENTRY :
 *   nrows    number of rows in the matrix A;
 *   ncols    number of columns in the matrix A;
 *   szt      size of one tile;
 *   colidx   global index of the current column;
 *   k        index of the current tile;
 *   L        local index of the column in the current tile;
 *   Ahi_h    high doubles of the matrix on the host;
 *   Alo_h    low doubles of the matrix on the host;
 *   Ahi_d    high doubles of the matrix on the device;
 *   Alo_d    low doubles of the matrix on the device;
 *   Vhi_d    space allocated for the Householder vectors on the device;
 *   Vlo_d    space allocated for the Householder vectors on the device;
 *   betahi_h has space allocated for the betas if verbose;
 *   betalo_h has space allocated for the betas if verbose;
 *   betahi_d has space allocated on the device for the betas;
 *   betalo_d has space allocated on the device for the betas;
 *   verbose  is the verbose flag.
 *
 * ON RETURN :
 *   Ahi_d    high doubles of the reduced matrix on the device;
 *   Alo_d    low doubles of the reduced matrix on the device;
 *   Ahi_h    high doubles of the reduced matrix on the host, if verbose;
 *   Alo_h    low doubles of the reduced matrix on the host, if verbose;
 *   lapms    elapsed time spent by the kernel. */

void GPU_cmplx2_small_leftRupdate
 ( int nrows, int ncols, int szt, int colidx, int k, int L,
   double *Arehi_h, double *Arelo_h, double *Aimhi_h, double *Aimlo_h,
   double *Arehi_d, double *Arelo_d, double *Aimhi_d, double *Aimlo_d,
   double *Vrehi_d, double *Vrelo_d, double *Vimhi_d, double *Vimlo_d,
   double *betahi_h, double *betalo_h, double *betahi_d, double *betalo_d,
   double *lapms, bool verbose=true );
/*
 * DESCRIPTION :
 *   Calls the kernel to update one tile.
 *   Wraps the timer and the print statements if verbose.
 *   If verbose, then the reduced matrix is returned on the host.
 *
 * ON ENTRY :
 *   nrows    number of rows in the matrix A;
 *   ncols    number of columns in the matrix A;
 *   szt      size of one tile;
 *   colidx   global index of the current column;
 *   k        index of the current tile;
 *   L        local index of the column in the current tile;
 *   Arehi_h  high doubles of the real parts of the matrix on the host;
 *   Arelo_h  low doubles of the real parts of the matrix on the host;
 *   Aimhi_h  high doubles of the imaginary parts of the matrix on the host;
 *   Aimlo_h  low doubles of the imaginary parts of the matrix on the host;
 *   Arehi_d  high doubles of the real parts of the matrix on the device;
 *   Arelo_d  low doubles of the real parts of the matrix on the device;
 *   Aimhi_d  high doubles of the imaginary parts of the matrix on the device;
 *   Aimlo_d  low doubles of the imaginary parts of the matrix on the device;
 *   Vrehi_d  has space for the high doubles of the real parts
 *            of the Householder vectors on the device;
 *   Vrelo_d  has space for the low doubles of the real parts
 *            of the Householder vectors on the device;
 *   Vimhi_d  has space for the high doubles of the imaginary parts
 *            of the Householder vectors on the device;
 *   Vimlo_d  has space for the low doubles of the imaginary parts
 *            of the Householder vectors on the device;
 *   betahi_h has space for the high doubles of the betas if verbose;
 *   betalo_h has space for the low doubles of the betas if verbose;
 *   betahi_d has space on the device for the high doubles of the betas;
 *   betalo_d has space on the device for the low doubles of the betas;
 *   verbose  is the verbose flag.
 *
 * ON RETURN :
 *   Vrehi_d  high doubles of the real parts of the Householder vectors
 *            on the device;
 *   Vrelo_d  low doubles of the real parts of the Householder vectors
 *            on the device;
 *   Vimhi_d  high doubles of the imaginary parts of the Householder vectors
 *            on the device;
 *   Vimlo_d  low doubles of the imaginary parts of the Householder vectors
 *            on the device;
 *   betahi_h has the vector of high doubles of the betas, if verbose;
 *   betalo_h has the vector of low doubles of the betas, if verbose;
 *   betahi_d has the high doubles of the next beta constant;
 *   betalo_d has the low doubles of the next beta constant;
 *   lapms    elapsed time spent by the kernel. */

void GPU_dbl2_medium_leftRupdate
 ( int nrows, int ncols, int szt, int colidx, int k, int L,
   double *Ahi_h, double *Alo_h, double *Ahi_d, double *Alo_d,
   double *Vhi_d, double *Vlo_d,
   double *betahi_h, double *betalo_h, double *betahi_d, double *betalo_d,
   double *whi_h, double *wlo_h, double *whi_d, double *wlo_d,
   double *lapms, bool verbose=true );
/*
 * DESCRIPTION :
 *   Calls the kernels to update one tile.
 *   Wraps the timer and the print statements if verbose.
 *   If verbose, then the reduced matrix is returned on the host.
 *
 * REQUIRED : nrows - colidx > szt.
 *
 * ON ENTRY :
 *   nrows    number of rows in the matrix A;
 *   ncols    number of columns in the matrix A;
 *   szt      size of one tile;
 *   colidx   global index of the current column;
 *   k        index of the current tile;
 *   L        local index of the column in the current tile;
 *   Ahi_h    high doubles of the matrix on the host;
 *   Alo_h    low doubles of the matrix on the host;
 *   Ahi_d    high doubles of the matrix on the device;
 *   Alo_d    low doubles of the matrix on the device;
 *   Vhi_d    space for the high doubles of the Householder vectors,
 *            on the device;
 *   Vlo_d    space for the low doubles of the Householder vectors,
 *            on the device;
 *   betahi_h has space for the high doubles of the betas if verbose;
 *   betalo_h has space for the low doubles of the betas if verbose;
 *   betahi_d has space on the device for the high doubles of the betas;
 *   betalo_d has space on the device for the low doubles of the betas;
 *   whi_h    space for the high doubles of beta*R^T*v on the host,
 *            if verbose;
 *   wlo_h    space for the high doubles of beta*R^T*v on the host,
 *            if verbose;
 *   whi_d    space for the high doubles of beta*R^T*v plus szt padding;
 *   wlo_d    space for the low doubles of beta*R^T*v plus szt padding;
 *   verbose  is the verbose flag.
 *
 * ON RETURN :
 *   Vhi_d    contains the high doubles of the Householder vectors,
 *            on the device;
 *   Vlo_d    contains the low doubles of the Householder vectors,
 *            on the device;
 *   betahi_h is the vector of the high doubles of betas, if verbose;
 *   betalo_h is the vector of the low doubles of betas, if verbose;
 *   betahi_d has the high double of the next beta constant;
 *   betalo_d has the low double of the next beta constant;
 *   whi_h    stores the high doubles of beta*R^T*v, if verbose;
 *   wlo_h    stores the low doubles of beta*R^T*v, if verbose;
 *   lapms    elapsed time spent by the kernel. */

void GPU_dbl2_VB_to_W
 ( int nrows, int ncols, int szt,
   double *Vhi_h, double *Vlo_h, double *Vhi_d, double *Vlo_d,
   double *Whi_h, double *Wlo_h, double *Whi_d, double *Wlo_d,
   double *betahi_h, double *betalo_h, double *betahi_d, double *betalo_d,
   double *lapms, bool verbose=true );
/*
 * DESCRIPTION :
 *   Calls the kernel to compute the W in the WY representation.
 *   Wraps the timer and the print statements if verbose.
 *   If verbose, then the W matrix is returned on the host.
 *
 * ON ENTRY :
 *   nrows    number of rows in the matrices V, Y, and W;
 *   ncols    equals the size of one tile, or equivalently,
 *            is the number of elements in B,
 *            and the number of columns in V, Y, and W;
 *   Vhi_h    space for the Householder vectors, if verbose;
 *   Vlo_h    space for the Householder vectors, if verbose;
 *   Vhi_d    space for V on the device;
 *   Vlo_d    space for V on the device;
 *   Whi_h    space for the W matrix, if verbose;
 *   Wlo_h    space for the W matrix, if verbose;
 *   Whi_d    space for W on the device;
 *   Wlo_d    space for W on the device;
 *   betahi_h has space for the betas if verbose;
 *   betalo_h has space for the betas if verbose;
 *   betahi_d has space on the device for the betas;
 *   betalo_d has space on the device for the betas;
 *   verbose  is the verbose flag.
 *
 * ON RETURN :
 *   Vhi_h    equals the high doubles of the Y matrix, if verbose;
 *   Vlo_h    equals the low doubles of the Y matrix, if verbose;
 *   Vhi_d    high doubles of the Y matrix on the device;
 *   Vlo_d    low doubles of the Y matrix on the device;
 *   Whi_d    high doubles of the W matrix in the WY representation,
 *            on the device;
 *   Wlo_d    low doubles of the W matrix in the WY representation,
 *            on the device;
 *   Whi_h    high doubles of the W matrix in the WY representation,
 *            if verbose;
 *   Wlo_h    low doubles of the W matrix in the WY representation,
 *            if verbose;
 *   lapms    elapsed time spent by the kernel. */

void GPU_cmplx2_VB_to_W
 ( int nrows, int ncols, int szt,
   double *Vrehi_h, double *Vrelo_h, double *Vimhi_h, double *Vimlo_h,
   double *Vrehi_d, double *Vrelo_d, double *Vimhi_d, double *Vimlo_d,
   double *Wrehi_h, double *Wrelo_h, double *Wimhi_h, double *Wimlo_h,
   double *Wrehi_d, double *Wrelo_d, double *Wimhi_d, double *Wimlo_d,
   double *betahi_h, double *betalo_h, double *betahi_d, double *betalo_d,
   double *lapms, bool verbose=true );
/*
 * DESCRIPTION :
 *   Calls the kernel to compute the W in the WY representation.
 *   Wraps the timer and the print statements if verbose.
 *   If verbose, then the W matrix is returned on the host.
 *
 * ON ENTRY :
 *   nrows    number of rows in the matrices V, Y, and W;
 *   ncols    equals the size of one tile, or equivalently,
 *            is the number of elements in B,
 *            and the number of columns in V, Y, and W;
 *   Vrehi_h  has space for the high doubles of the real parts
 *            of the Householder vectors, if verbose;
 *   Vrelo_h  has space for the low doubles of the real parts
 *            of the Householder vectors, if verbose;
 *   Vimhi_h  has space for the high doubles of the imaginary parts
 *            of the Householder vectors, if verbose;
 *   Vimlo_h  has space for the low doubles of the imaginary parts
 *            of the Householder vectors, if verbose;
 *   Vrehi_d  has space for the high doubles of the the real parts of V
 *            on the device;
 *   Vrelo_d  has space for the low doubles of the real parts of V
 *            on the device;
 *   Vimhi_d  has space for the high doubles of the imaginary parts of V
 *            on the device;
 *   Vimlo_d  has space for the low doubles of the imaginary parts of V
 *            on the device;
 *   Wrehi_h  has space for the high doubles of the real parts of W,
 *            if verbose;
 *   Wrelo_h  has space for the low doubles of the real parts of W,
 *            if verbose;
 *   Wimhi_h  has space for the high doubles of the imaginary parts of W,
 *            if verbose;
 *   Wimlo_h  has space for the low doubles of the imaginary parts of W,
 *            if verbose;
 *   Wrehi_d  has space for the high doubles of the real parts of W,
 *            on the device;
 *   Wrelo_d  has space for the low doubles of the real parts of W,
 *            on the device;
 *   Wimhi_d  has space for the high doubles of the imaginary parts of W,
 *            on the device;
 *   Wimlo_d  has space for the low doubles of the imaginary parts of W,
 *            on the device;
 *   betahi_h has space for the high doubles of the betas if verbose;
 *   betalo_h has space for the low doubles of the betas if verbose;
 *   betahi_d has space on the device for the high doubles of the betas;
 *   betalo_d has space on the device for the low doubles of the betas;
 *   verbose  is the verbose flag.
 *
 * ON RETURN :
 *   Vrehi_h  equals the high doubles of the real parts of the Y matrix,
 *            if verbose;
 *   Vrelo_h  equals the low doubles of the real parts of the Y matrix,
 *            if verbose;
 *   Vimhi_h  equals the high doubles of the imaginary parts of the Y matrix,
 *            if verbose;
 *   Vimlo_h  equals the low doubles of the imaginary parts of the Y matrix,
 *            if verbose;
 *   Vrehi_d  has the high doubles of the real parts of the Y matrix,
 *            on the device;
 *   Vrelo_d  has the low doubles of the real parts of the Y matrix,
 *            on the device;
 *   Vimhi_d  has the high doubles of the imaginary parts of the Y matrix,
 *            on the device;
 *   Vimlo_d  has the low doubles of the imaginary parts of the Y matrix,
 *            on the device;
 *   Wrehi_d  has the high doubles of the real parts of the W matrix,
 *            on the device;
 *   Wrelo_d  has the low doubles of the real parts of the W matrix,
 *            on the device;
 *   Wimhi_d  has the high doubles of the imaginary parts of the W matrix,
 *            on the device;
 *   Wimlo_d  has the low doubles of the imaginary parts of the W matrix,
 *            on the device;
 *   Wrehi_h  has the high doubles of the real parts of the W matrix,
 *            if verbose;
 *   Wrelo_h  has the low doubles of the real parts of the W matrix,
 *            if verbose;
 *   Wimhi_h  has the high doubles of the imaginary parts of the W matrix,
 *            if verbose;
 *   Wimlo_h  has the low doubles of the imaginary parts of the W matrix,
 *            if verbose;
 *   lapms    elapsed time spent by the kernel. */

void GPU_dbl2_medium_VB_to_W
 ( int nrows, int ncols, int szt, int idx,
   double *Vhi_h, double *Vlo_h, double *Vhi_d, double *Vlo_d,
   double *Whi_h, double *Wlo_h, double *Whi_d, double *Wlo_d,
   double *WYThi_h, double *WYTlo_h, double *WYThi_d, double *WYTlo_d,
   double *betahi_h, double *betalo_h, double *betahi_d, double *betalo_d,
   double *lapms, long int *add, long int *mul, long int *div,
   bool verbose=true );
/*
 * DESCRIPTION :
 *   Calls the kernel to compute the W in the WY representation,
 *   on real data.
 *   Wraps the timer and the print statements if verbose.
 *   If verbose, then the W matrix is returned on the host.
 *
 * ON ENTRY :
 *   nrows    number of rows in the matrices V, Y, and W;
 *   ncols    equals the size of one tile, or equivalently,
 *            is the number of elements in B,
 *            and the number of columns in V, Y, and W;
 *   szt      size of one tile and the number of threads in a block;
 *   idx      index of the current tile;
 *   Vhi_h    high doubles of the Householder vectors, if verbose;
 *   Vlo_h    low doubles of the Householder vectors, if verbose;
 *   Vhi_d    high doubles of the Householder vectors on the device;
 *   Vlo_d    low doubles of the Householder vectors on the device;
 *   Whi_h    space for the high doubles of the W matrix, if verbose;
 *   Wlo_h    space for the low doubles of the W matrix, if verbose;
 *   Whi_d    space for high doubles of W on the device;
 *   Wlo_d    space for low doubles of W on the device;
 *   WYThi_h  space for the high doubles of W*Y^T, if verbose;
 *   WYTlo_h  space for the low doubles of W*Y^T, if verbose;
 *   WYThi_d  space for the high doubles of W*Y^T, on the device;
 *   WYTlo_d  space for the low doubles of W*Y^T, on the device;
 *   betahi_h has space for the betas if verbose;
 *   betalo_h has space for the betas if verbose;
 *   betahi_d has space on the device for the betas;
 *   betalo_d has space on the device for the betas;
 *   add      current number of additions and subtractions;
 *   mul      current number of multiplications;
 *   div      current number of divisions;
 *   verbose  is the verbose flag.
 *
 * ON RETURN :
 *   Vhi_h    high doubles of the Y matrix, if verbose;
 *   Vlo_h    low doubles of the Y matrix, if verbose;
 *   Vhi_d    high doubles of the Y matrix on the device;
 *   Vlo_d    low doubles of the Y matrix on the device;
 *   Whi_d    high doubles of the W matrix, on the device;
 *   Wlo_d    low doubles of the W matrix, on the device;
 *   Whi_h    high doubles of the W matrix, if verbose;
 *   Wlo_h    low doubles of the W matrix, if verbose;
 *   WYThi_h  high doubles of W*Y^T, if verbose;
 *   WYTlo_h  low doubles of W*Y^T, if verbose;
 *   WYThi_d  high doubles of W*Y^T, on the device;
 *   WYTlo_d  low doubles of W*Y^T, on the device;
 *   lapms    elapsed time spent by the kernel;
 *   add      accumulated number of additions and subtractions;
 *   mul      accumulated number of multiplications;
 *   div      accumulated number of divisions. */

void GPU_cmplx2_medium_VB_to_W
 ( int nrows, int ncols, int szt, int idx,
   double *Vrehi_h, double *Vrelo_h, double *Vimhi_h, double *Vimlo_h,
   double *Vrehi_d, double *Vrelo_d, double *Vimhi_d, double *Vimlo_d,
   double *Wrehi_h, double *Wrelo_h, double *Wimhi_h, double *Wimlo_h,
   double *Wrehi_d, double *Wrelo_d, double *Wimhi_d, double *Wimlo_d,
   double *WYHrehi_h, double *WYHrelo_h, double *WYHimhi_h, double *WYHimlo_h,
   double *WYHrehi_d, double *WYHrelo_d, double *WYHimhi_d, double *WYHimlo_d,
   double *betahi_h, double *betalo_h, double *betahi_d, double *betalo_d,
   double *lapms, long int *add, long int *mul, long int *div,
   bool verbose=true );
/*
 * DESCRIPTION :
 *   Calls the kernel to compute the W in the WY representation,
 *   on complex data.
 *   Wraps the timer and the print statements if verbose.
 *   If verbose, then the W matrix is returned on the host.
 *
 * ON ENTRY :
 *   nrows    number of rows in the matrices V, Y, and W;
 *   ncols    equals the size of one tile, or equivalently,
 *            is the number of elements in B,
 *            and the number of columns in V, Y, and W;
 *   szt      size of one tile and the number of threads in a block;
 *   idx      index of the current tile;
 *   Vrehi_h  high doubles of the real parts
 *            of the Householder vectors, if verbose;
 *   Vrelo_h  low doubles of the real parts
 *            of the Householder vectors, if verbose;
 *   Vimhi_h  high doubles of the imaginary parts
 *            of the Householder vectors, if verbose;
 *   Vimlo_h  low doubles of the imaginary parts
 *            of the Householder vectors, if verbose;
 *   Vrehi_d  high doubles of the the real parts of V, on the device;
 *   Vrelo_d  low doubles of the real parts of V, on the device;
 *   Vimhi_d  high doubles of the imaginary parts of V, on the device;
 *   Vimlo_d  low doubles of the imaginary parts of V, on the device;
 *   Wrehi_h  has space for the high doubles of the real parts of W,
 *            if verbose;
 *   Wrelo_h  has space for the low doubles of the real parts of W,
 *            if verbose;
 *   Wimhi_h  has space for the high doubles of the imaginary parts of W,
 *            if verbose;
 *   Wimlo_h  has space for the low doubles of the imaginary parts of W,
 *            if verbose;
 *   Wrehi_d  has space for the high doubles of the real parts of W,
 *            on the device;
 *   Wrelo_d  has space for the low doubles of the real parts of W,
 *            on the device;
 *   Wimhi_d  has space for the high doubles of the imaginary parts of W,
 *            on the device;
 *   Wimlo_d  has space for the low doubles of the imaginary parts of W,
 *            on the device;
 *   WYHrehi_h has space for the high doubles of the real parts of W*Y^H,
 *            if verbose;
 *   WYHrelo_h has space for the low doubles of the real parts of W*Y^H,
 *            if verbose;
 *   WYHimhi_h has space for the high doubles of the imaginary parts of W*Y^H,
 *            if verbose;
 *   WYHimlo_h has space for the low doubles of the imaginary parts of W*Y^H,
 *            if verbose;
 *   WYHrehi_d has space for the high doubles of the real parts of W*Y^H,
 *            on the device;
 *   WYHrelo_d has space for the low doubles of the real parts of W*Y^H,
 *            on the device;
 *   WYHimhi_d has space for the high doubles of the imaginary parts of W*Y^H,
 *            on the device;
 *   WYHimlo_d has space for the low doubles of the imaginary parts of W*Y^H,
 *            on the device;
 *   betahi_h has space for the betas if verbose;
 *   betalo_h has space for the betas if verbose;
 *   betahi_d has space on the device for the betas;
 *   betalo_d has space on the device for the betas;
 *   add      current number of additions and subtractions;
 *   mul      current number of multiplications;
 *   div      current number of divisions;
 *   verbose  is the verbose flag.
 *
 * ON RETURN :
 *   Vrehi_h  high doubles of the real parts of the Y matrix, if verbose;
 *   Vrelo_h  low doubles of the real parts of the Y matrix, if verbose;
 *   Vimhi_h  high doubles of the imaginary parts of the Y matrix, if verbose;
 *   Vimlo_h  low doubles of the imaginary parts of the Y matrix, if verbose;
 *   Vrehi_d  high doubles of the real parts of the Y matrix on the device;
 *   Vrelo_d  low doubles of the real parts of the Y matrix on the device;
 *   Vimhi_d  high doubles of the imaginary parts of the Y matrix,
 *            on the device;
 *   Vimlo_d  low doubles of the imaginary parts of the Y matrix,
 *            on the device;
 *   Wrehi_d  high doubles of the the real parts of W, on the device;
 *   Wrelo_d  low doubles of the the real parts of W, on the device;
 *   Wimhi_d  high doubles of the imaginary parts of W, on the device;
 *   Wimlo_d  low doubles of the imaginary parts of W, on the device;
 *   Wrehi_h  high doubles of the real parts of W, if verbose;
 *   Wrelo_h  low doubles of the real parts of W, if verbose;
 *   Wimhi_h  high doubles of the imaginary parts of W, if verbose;
 *   Wimlo_h  low doubles of the imaginary parts of W, if verbose;
 *   WYHrehi_h has the high doubles of the real parts of W*Y^H,
 *            if verbose;
 *   WYHrelo_h has the low doubles of the real parts of W*Y^H,
 *            if verbose;
 *   WYHimhi_h has the high doubles of the imaginary parts of W*Y^H,
 *            if verbose;
 *   WYHimlo_h has the low doubles of the imaginary parts of W*Y^H,
 *            if verbose;
 *   WYHrehi_d has the high doubles of the real parts of W*Y^H,
 *            on the device;
 *   WYHrelo_d has the low doubles of the real parts of W*Y^H,
 *            on the device;
 *   WYHimhi_d has the high doubles of the imaginary parts of W*Y^H,
 *            on the device;
 *   WYHimlo_d has the low doubles of the imaginary parts of W*Y^H,
 *            on the device;
 *   lapms    elapsed time spent by the kernel;
 *   add      accumulated number of additions and subtractions;
 *   mul      accumulated number of multiplications;
 *   div      accumulated number of divisions. */

void GPU_dbl2_small_WYT
 ( int nrows, int szt,
   double *Whi_d, double *Wlo_d, double *Yhi_d, double *Ylo_d,
   double *WYThi_d, double *WYTlo_d, double *WYThi_h, double *WYTlo_h,
   double *lapms, bool verbose=true );
/*
 * DESCRIPTION :
 *   Calls the kernel to compute W*Y^T.
 *   Wraps the timer and the print statements if verbose.
 *   If verbose, then the W*Y^T matrix is returned.
 *
 * ON ENTRY :
 *   nrows    number of rows in all matrices;
 *   szt      size of one tile and the number of threads in a block;
 *   Whi_d    high doubles of the matrix W in the WY representation;
 *   Wlo_d    low doubles of the matrix W in the WY representation;
 *   Yhi_d    high doubles of the matrix of Householder vectors;
 *   Ylo_d    low doubles of the matrix of Householder vectors;
 *   WYThi_d  space for an nrows-by-nrows matrix on the device;
 *   WYTlo_d  space for an nrows-by-nrows matrix on the device;
 *   WYThi_h  space for an nrows-by-nrows matrix on the host, if verbose;
 *   WYTlo_h  space for an nrows-by-nrows matrix on the host, if verbose;
 *   verbose  is the verbose flag.
 *
 * ON RETURN :
 *   WYThi_d  high doubles of the product W*Y^T on the device;
 *   WYTlo_d  low doubles of the product W*Y^T on the device;
 *   WYThi_h  high doubles of the product W*Y^T, if verbose;
 *   WYTlo_h  low doubles of the product W*Y^T, if verbose;
 *   lapms    elapsed time spent by the kernel. */

void GPU_cmplx2_small_WYT
 ( int nrows, int szt,
   double *Wrehi_d, double *Wrelo_d, double *Wimhi_d, double *Wimlo_d,
   double *Yrehi_d, double *Yrelo_d, double *Yimhi_d, double *Yimlo_d,
   double *WYTrehi_d, double *WYTrelo_d, double *WYTimhi_d, double *WYTimlo_d,
   double *WYTrehi_h, double *WYTrelo_h, double *WYTimhi_h, double *WYTimlo_h,
   double *lapms, bool verbose=true );
/*
 * DESCRIPTION :
 *   Calls the kernel to compute W*Y^T.
 *   Wraps the timer and the print statements if verbose.
 *   If verbose, then the W*Y^T matrix is returned.
 *
 * ON ENTRY :
 *   nrows    number of rows in all matrices;
 *   szt      size of one tile and the number of threads in a block;
 *   Wrehi_d  has the high doubles of the real parts of the matrix W;
 *   Wrelo_d  has the low doubles of the real parts of the matrix W;
 *   Wimhi_d  has the high doubles of the imaginary parts of the matrix W;
 *   Wimlo_d  has the low doubles of the imaginary parts of the matrix W;
 *   Yrehi_d  has the high doubles of the matrix of the real parts
 *            of the Householder vectors;
 *   Yrelo_d  has the low doubles of the matrix of the real parts
 *            of the Householder vectors;
 *   Yimhi_d  has the high doubles of the matrix of the imaginary parts
 *            of the Householder vectors;
 *   Yimlo_d  has the low doubles of the matrix of the imaginary parts
 *            of the Householder vectors;
 *   WYTrehi_d has space for an nrows-by-nrows matrix on the device;
 *   WYTrelo_d has space for an nrows-by-nrows matrix on the device;
 *   WYTimhi_d has space for an nrows-by-nrows matrix on the device;
 *   WYTimlo_d has space for an nrows-by-nrows matrix on the device;
 *   WYTrehi_h has space for an nrows-by-nrows matrix on the host, if verbose;
 *   WYTrelo_h has space for an nrows-by-nrows matrix on the host, if verbose;
 *   WYTimhi_h has space for an nrows-by-nrows matrix on the host, if verbose;
 *   WYTimlo_h has space for an nrows-by-nrows matrix on the host, if verbose;
 *   verbose  is the verbose flag.
 *
 * ON RETURN :
 *   WYTrehi_d are the high doubles of the real parts of the product W*Y^T
 *            on the device;
 *   WYTrelo_d are the low doubles of the real parts of the product W*Y^T
 *            on the device;
 *   WYTimhi_d are the high doubles of the imaginary parts
 *            of the product W*Y^T on the device;
 *   WYTimlo_d are the low doubles of the imaginary parts
 *            of the product W*Y^T on the device;
 *   WYTrehi_h are the high doubles of the real parts of the product W*Y^T,
 *            if verbose;
 *   WYTrelo_h are the low doubles of the real parts of the product W*Y^T,
 *            if verbose;
 *   WYTimhi_h are the high doubles of the imaginary parts
 *            of the product W*Y^T, if verbose;
 *   WYTimlo_h are the low doubles of the imaginary parts
 *            of the product W*Y^T, if verbose;
 *   lapms    elapsed time spent by the kernel. */

void GPU_dbl2_small_YWT
 ( int nrows, int szt, int idx,
   double *Yhi_d, double *Ylo_d, double *Whi_d, double *Wlo_d,
   double *YWThi_d, double *YWTlo_d, double *YWThi_h, double *YWTlo_h,
   double *lapms, bool verbose=true );
/*
 * DESCRIPTION :
 *   Calls the kernel to compute W*Y^T.
 *   Wraps the timer and the print statements if verbose.
 *   If verbose, then the W*Y^T matrix is returned.
 *
 * ON ENTRY :
 *   nrows    number of rows in all matrices;
 *   szt      size of one tile and the number of threads in a block;
 *   idx      index of the current tile;
 *   Yhi_d    high doubles of the matrix of Householder vectors;
 *   Ylo_d    low doubles of the matrix of Householder vectors;
 *   Whi_d    high doubles of the matrix W in the WY representation;
 *   Wlo_d    low doubles of the matrix W in the WY representation;
 *   YWThi_d  space for an nrows-by-nrows matrix on the device;
 *   YWTlo_d  space for an nrows-by-nrows matrix on the device;
 *   YWThi_h  space for an nrows-by-nrows matrix on the host, if verbose;
 *   YWTlo_h  space for an nrows-by-nrows matrix on the host, if verbose;
 *   verbose  is the verbose flag.
 *
 * ON RETURN :
 *   YWThi_d  high doubles of the product Y*W^T on the device;
 *   YWTlo_d  low doubles of the product Y*W^T on the device;
 *   YWThi_h  high doubles of the product Y*W^T, if verbose;
 *   YWTlo_h  low doubles of the product Y*W^T, if verbose;
 *   lapms    elapsed time spent by the kernel. */

void GPU_dbl2_small_QWYT
 ( int dim, int szt, int idx, double *Qhi_d, double *Qlo_d,
   double *WYThi_d, double *WYTlo_d, double *QWYThi_d, double *QWYTlo_d,
   double *QWYThi_h, double *QWYTlo_h, double *Qhi_h, double *Qlo_h,
   double *lapms, bool verbose=true );
/*
 * DESCRIPTION :
 *   Calls the kernel to compute Q*WYT.
 *   Wraps the timer and the print statement if verbose.
 *   If verbose, then the Q*WYT matrix is returned.
 *
 * ON ENTRY :
 *   dim      number of rows and columns in Q and WYT;
 *   szt      size of one tile and the number of threads in a block;
 *   idx      index of the current tile;
 *   Qhi_d    high doubles of a dim-by-dim matrix, on the device;
 *   Qlo_d    low doubles of a dim-by-dim matrix, on the device;
 *   WYThi_d  high doubles of the product W*Y^T, on the device;
 *   WYTlo_d  low doubles of the product W*Y^T, on the device;
 *   QWYThi_d has space for the product Q*WYT, on the device;
 *   QWYTlo_d has space for the product Q*WYT, on the device;
 *   QWYThi_h has space for the product Q*WYT, on the host, if verbose;
 *   QWYTlo_h has space for the product Q*WYT, on the host, if verbose;
 *   Qhi_h    if verbose, then used to print Q before the product;
 *   Qlo_h    if verbose, then used to print Q before the product;
 *   verbose  is the verbose flag.
 *
 * ON RETURN :
 *   QWYThi_d has the high doubles of the product Q*WYT on the device;
 *   QWYTlo_d has the low doubles of the product Q*WYT on the device;
 *   QWYThi_h has the high doubles of the product Q*WYT, if verbose;
 *   QWYTlo_h has the low doubles of the product Q*WYT, if verbose;
 *   lapms    elapsed time spent by the kernel. */

void GPU_cmplx2_small_QWYT
 ( int dim, int szt, int idx,
   double *Qrehi_d, double *Qrelo_d, double *Qimhi_d, double *Qimlo_d,
   double *WYTrehi_d, double *WYTrelo_d, double *WYTimhi_d, double *WYTimlo_d,
   double *QWYTrehi_d, double *QWYTrelo_d,
   double *QWYTimhi_d, double *QWYTimlo_d,
   double *QWYTrehi_h, double *QWYTrelo_h,
   double *QWYTimhi_h, double *QWYTimlo_h,
   double *Qrehi_h, double *Qrelo_h, double *Qimhi_h, double *Qimlo_h,
   double *lapms, bool verbose=true );
/*
 * DESCRIPTION :
 *   Calls the kernel to compute Q*WYT.
 *   Wraps the timer and the print statement if verbose.
 *   If verbose, then the Q*WYT matrix is returned.
 *
 * ON ENTRY :
 *   dim      number of rows and columns in Q and WYT;
 *   szt      size of one tile and the number of threads in a block;
 *   idx      index of the current tile;
 *   Qrehi_d  high doubles of the real parts of a dim-by-dim matrix,
 *            on the device;
 *   Qrelo_d  low doubles of the real parts of a dim-by-dim matrix,
 *            on the device;
 *   Qimhi_d  high doubles of the imaginary parts of a dim-by-dim matrix,
 *            on the device;
 *   Qimlo_d  low doubles of the imaginary parts of a dim-by-dim matrix,
 *            on the device;
 *   WYTrehi_d are the high doubles of the real parts of W*Y^T, on the device;
 *   WYTrelo_d are the low doubles of real parts of W*Y^T, on the device;
 *   WYTimhi_d are the high doubles of the imaginary parts of W*Y^T,
 *            on the device;
 *   WYTimlo_d are the low doubles of the imaginary parts of W*Y^T,
 *            on the device;
 *   QWYTrehi_d has space for the high doubles of the real parts for Q*WYT,
 *            on the device;
 *   QWYTrelo_d has space for the low doubles of the real parts for Q*WYT,
 *            on the device;
 *   QWYTimhi_d has space for the high doubles of the imaginary parts of Q*WYT,
 *            on the device;
 *   QWYTimlo_d has space for the low doubles of the imaginary parts of Q*WYT,
 *            on the device;
 *   QWYTrehi_h has space for the high doubles of the real parts of Q*WYT,
 *            on the host, if verbose;
 *   QWYTrelo_h has space for the low doubles of the real parts of Q*WYT,
 *            on the host, if verbose;
 *   QWYTimhi_h has space for the high doubles of the imaginary parts of Q*WYT,
 *            on the host, if verbose;
 *   QWYTimlo_h has space for the low doubles of the imaginary parts of Q*WYT,
 *            on the host, if verbose;
 *   Qrehi_h  if verbose, then used to print the high doubles
 *            of the real parts of Q;
 *   Qrelo_h  if verbose, then used to print the low doubles
 *            of the real parts of Q;
 *   Qimhi_h  if verbose, then used to print the high doubles
 *            of the imaginary parts of Q;
 *   Qimlo_h  if verbose, then used to print the low doubles
 *            of the imaginary parts of Q;
 *   verbose  is the verbose flag.
 *
 * ON RETURN :
 *   QWYTrehi_d are the high doubles of the real parts of Q*WYT on the device;
 *   QWYTrelo_d are the low doubles of the real parts of Q*WYT on the device;
 *   QWYTimhi_d are the high doubles of the imaginary parts of Q*WYT,
 *            on the device;
 *   QWYTimlo_d are the low doubles of the imaginary parts of Q*WYT,
 *            on the device;
 *   QWYTrehi_h are the high doubles of the real parts of Q*WYT, if verbose;
 *   QWYTrelo_h are the low doubles of the real parts of Q*WYT, if verbose;
 *   QWYTimhi_h are the high doubles of the imaginary parts of Q*WYT,
 *            if verbose;
 *   QWYTimlo_h are the low doubles of the imaginary parts of Q*WYT,
 *            if verbose;
 *   lapms    elapsed time spent by the kernel. */

void GPU_dbl2_small_YWTC
 ( int nrows, int ncols, int szt, int idx, double *YWThi_d, double *YWTlo_d,
   double *Chi_d, double *Clo_d, double *YWTChi_d, double *YWTClo_d,
   double *YWTChi_h, double *YWTClo_h, double *lapms, bool verbose=true );
/*
 * DESCRIPTION :
 *   Calls the kernel to compute YWT*C.
 *   Wraps the timer and the print statement if verbose.
 *   If verbose, then the YWT*C matrix is returned.
 *
 * ON ENTRY :
 *   nrows    number of rows of the matrices C, YWT, YWTC,
 *            and the number of columns of the matrix YWT;
 *   ncols    number of columns of the matrix C;
 *   szt      size of one tile and the number of threads in a block;
 *   idx      index of the current tile;
 *   YWThi_d  high doubles of the product Y*W^T, on the device;
 *   YWTlo_d  low doubles of the product Y*W^T, on the device;
 *   Chi_d    high doubles of an nrows-by-ncols matrix, on the device;
 *   Clo_d    low doubles of an nrows-by-ncols matrix, on the device;
 *   YWTChi_d has space for the product YWT*C, on the device;
 *   YWTClo_d has space for the product YWT*C, on the device;
 *   YWTChi_h has space for the product YWT*C, on the host, if verbose;
 *   YWTClo_h has space for the product YWT*C, on the host, if verbose;
 *   verbose  is the verbose flag.
 *
 * ON RETURN :
 *   YWTChi_d has the high doubles of the product YWT*C on the device;
 *   YWTClo_d has the low doubles of the product YWT*C on the device;
 *   YWTChi_h has the high doubles of the product YWT*C, if verbose;
 *   YWTClo_h has the low doubles of the product YWT*C, if verbose;
 *   lapms    elapsed time spent by the kernel. */

void GPU_cmplx2_small_YWTC
 ( int nrows, int ncols, int szt, int idx,
   double *YWTrehi_d, double *YWTrelo_d, double *YWTimhi_d, double *YWTimlo_d,
   double *Crehi_d, double *Crelo_d, double *Cimhi_d, double *Cimlo_d,
   double *YWTCrehi_d, double *YWTCrelo_d,
   double *YWTCimhi_d, double *YWTCimlo_d,
   double *YWTCrehi_h, double *YWTCrelo_h,
   double *YWTCimhi_h, double *YWTCimlo_h,
   double *lapms, bool verbose=true );
/*
 * DESCRIPTION :
 *   Calls the kernel to compute YWT*C.
 *   Wraps the timer and the print statement if verbose.
 *   If verbose, then the YWT*C matrix is returned.
 *
 * ON ENTRY :
 *   nrows    number of rows of the matrices C, YWT, YWTC,
 *            and the number of columns of the matrix YWT;
 *   ncols    number of columns of the matrix C;
 *   szt      size of one tile and the number of threads in a block;
 *   idx      index of the current tile;
 *   YWTrehi_d are the high doubles of the real parts of Y*W^T, on the device;
 *   YWTrelo_d are the low doubles of the real parts of Y*W^T, on the device;
 *   YWTimhi_d are the high doubles of the imaginary parts of Y*W^T,
 *            on the device;
 *   YWTimlo_d are the low doubles of the imaginary parts of Y*W^T,
 *            on the device;
 *   Crehi_d  high doubles of the real parts of an nrows-by-ncols matrix,
 *            on the device;
 *   Crelo_d  low doubles of the real parts of an nrows-by-ncols matrix,
 *            on the device;
 *   Cimhi_d  high doubles of the imaginary parts of an nrows-by-ncols matrix,
 *            on the device;
 *   Cimlo_d  low doubles of the imaginary parts of an nrows-by-ncols matrix,
 *            on the device;
 *   YWTCrehi_d has space for the high doubles of the real parts of YWT*C,
 *            on the device;
 *   YWTCrelo_d has space for the low doubles of the real parts of YWT*C,
 *            on the device;
 *   YWTCimhi_d has space for the high doubles of the imaginary parts of YWT*C,
 *            on the device;
 *   YWTCimlo_d has space for the low doubles of the imaginary parts of YWT*C,
 *            on the device;
 *   YWTCrehi_h has space for the high doubles of the real parts of YWT*C,
 *            on the host, if verbose;
 *   YWTCrelo_h has space for the low doubles of the real parts of YWT*C,
 *            on the host, if verbose;
 *   YWTCimhi_h has space for the high doubles of the imaginary parts of YWT*C,
 *            on the host, if verbose;
 *   YWTCimlo_h has space for the low doubles of the imaginary parts of YWT*C,
 *            on the host, if verbose;
 *   verbose  is the verbose flag.
 *
 * ON RETURN :
 *   YWTCrehi_d are the high doubles of the real parts of YWT*C on the device;
 *   YWTCrelo_d are the low doubles of the real parts of YWT*C on the device;
 *   YWTCimhi_d are the high doubles of the imaginary parts of YWT*C,
 *            on the device;
 *   YWTCimlo_d are the low doubles of the imaginary parts of YWT*C,
 *            on the device;
 *   YWTCrehi_h are the high doubles of the real parts of YWT*C, if verbose;
 *   YWTCrelo_h are the low doubles of the real parts of YWT*C, if verbose;
 *   YWTCimhi_h are the high doubles of the imaginary parts of YWT*C,
 *            if verbose;
 *   YWTCimlo_h are the low doubles of the imaginary parts of YWT*C,
 *            if verbose;
 *   lapms    elapsed time spent by the kernel. */

void GPU_dbl2_small_Qupdate
 ( int dim, int szt, int idx,
   double *Qhi_d, double *Qlo_d, double *QWYThi_d, double *QWYTlo_d,
   double *Qhi_h, double *Qlo_h, double *lapms, bool verbose=true );
/*
 * DESCRIPTION :
 *   Calls the kernel to update Q as Q + QWYT.
 *   Wraps the timer and the print statement if verbose.
 *   If verbose, then the updated Q is returned.
 *
 * ON ENTRY :
 *   dim      number of rows and columns in Q,
 *            number of rows in QWYT;
 *   szt      size of one tile and the number of threads in a block;
 *   idx      index of the current tile;
 *   Qhi_d    a dim-by-dim matrix, on the device;
 *   Qlo_d    a dim-by-dim matrix, on the device;
 *   QWYThi_d has the high doubles of the product Q*W*Y^T, on the device;
 *   QWYTlo_d has the low doubles of the product Q*W*Y^T, on the device;
 *   verbose  is the verbose flag.
 *
 * ON RETURN :
 *   Qhi_d    high doubles of the updated Q on the device;
 *   Qlo_d    low doubles of the updated Q on the device;
 *   Qhi_h    high doubles of the updated Q, if verbose;
 *   Qlo_h    low doubles of the updated Q, if verbose;
 *   lapms    elapsed time spent by the kernel. */

void GPU_cmplx2_small_Qupdate
 ( int dim, int szt, int idx,
   double *Qrehi_d, double *Qrelo_d, double *Qimhi_d, double *Qimlo_d,
   double *QWYTrehi_d, double *QWYTrelo_d,
   double *QWYTimhi_d, double *QWYTimlo_d,
   double *Qrehi_h, double *Qrelo_h, double *Qimhi_h, double *Qimlo_h,
   double *lapms, bool verbose=true );
/*
 * DESCRIPTION :
 *   Calls the kernel to update Q as Q + QWYT.
 *   Wraps the timer and the print statement if verbose.
 *   If verbose, then the updated Q is returned.
 *
 * ON ENTRY :
 *   dim      number of rows and columns in Q,
 *            number of rows in QWYT;
 *   rowdim   number of columns in QWYT;
 *   szt      size of one tile and the number of threads in a block;
 *   idx      index of the current tile;
 *   Qrehi_d  high doubles of the real parts of Q, on the device;
 *   Qrelo_d  low doubles of the real parts of Q, on the device;
 *   Qimhi_d  high doubles of the imaginary parts of Q, on the device;
 *   Qimlo_d  low doubles of the imaginary parts of Q, on the device;
 *   QWYTrehi_d are the high doubles of the real parts of Q*W*Y^T,
 *            on the device;
 *   QWYTrelo_d are the low doubles of the real parts of Q*W*Y^T,
 *            on the device;
 *   QWYTimhi_d are the high doubles of the imaginary parts of Q*W*Y^T,
 *            on the device;
 *   QWYTimlo_d are the low doubles of the imaginary parts of Q*W*Y^T,
 *            on the device;
 *   verbose  is the verbose flag.
 *
 * ON RETURN :
 *   Qrehi_d  high doubles of the real parts of the updated Q on the device;
 *   Qrelo_d  low doubles of the real parts of the updated Q on the device;
 *   Qimhi_d  high doubles of the imaginary parts of the updated Q,
 *            on the device;
 *   Qimlo_d  low doubles of the imaginary parts of the updated Q,
 *            on the device;
 *   Qrehi_h  high doubles of the real parts of the updated Q, if verbose;
 *   Qrelo_h  low doubles of the real parts of the updated Q, if verbose;
 *   Qimhi_h  high doubles of the imaginary parts of the updated Q, if verbose;
 *   Qimlo_h  low doubles of the imaginary parts of the updated Q, if verbose;
 *   lapms    elapsed time spent by the kernel. */

void GPU_dbl2_small_R_add_YWTC
 ( int nrows, int ncols, int szt, int idx, double *Rhi_d, double *Rlo_d,
   double *YWTChi_d, double *YWTClo_d, double *Rhi_h, double *Rlo_h,
   double *lapms, bool verbose=true );
/*
 * DESCRIPTION :
 *   Calls the kernel to update R as R + YWTC.
 *   Wraps the timer and the print statement if verbose.
 *   If verbose, then the updated R is returned.
 *
 * ON ENTRY :
 *   nrows    total number of rows in R and YWTC;
 *   ncols    total number of columns in R and YWTC;
 *   szt      size of one tile and the number of threads in a block;
 *   idx      index of the current tile;
 *   Rhi_d    an nrows-by-ncols matrix, on the device;
 *   Rlo_d    an nrows-by-ncols matrix, on the device;
 *   YWTChi_d has the high doubles of the product Y*W^T*C, on the device;
 *   YWTClo_d has the low doubles of the product Y*W^T*C, on the device;
 *   verbose  is the verbose flag.
 *
 * ON RETURN :
 *   Rhi_d    high doubles of the updated R on the device;
 *   Rlo_d    low doubles of the updated R on the device;
 *   Rhi_h    high doubles of the updated R, if verbose;
 *   Rlo_h    low doubles of the updated R, if verbose;
 *   lapms    elapsed time spent by the kernel. */

void GPU_cmplx2_small_R_add_YWTC
 ( int nrows, int ncols, int szt, int idx,
   double *Rrehi_d, double *Rrelo_d, double *Rimhi_d, double *Rimlo_d,
   double *YWTCrehi_d, double *YWTCrelo_d,
   double *YWTCimhi_d, double *YWTCimlo_d,
   double *Rrehi_h, double *Rrelo_h, double *Rimhi_h, double *Rimlo_h,
   double *lapms, bool verbose=true );
/*
 * DESCRIPTION :
 *   Calls the kernel to update R as R + YWTC.
 *   Wraps the timer and the print statement if verbose.
 *   If verbose, then the updated R is returned.
 *
 * ON ENTRY :
 *   nrows    total number of rows in R and YWTC;
 *   ncols    total number of columns in R and YWTC;
 *   szt      size of one tile and the number of threads in a block;
 *   idx      index of the current tile;
 *   Rrehi_d  high doubles of the real parts of R, on the device;
 *   Rrelo_d  low doubles of the real parts of R, on the device;
 *   Rimhi_d  high doubles of the imaginary parts of R, on the device;
 *   Rimlo_d  low doubles of the imaginary parts of R, on the device;
 *   YWTCrehi_d are the high doubles of the real parts of Y*W^T*C,
 *            on the device;
 *   YWTCrelo_d are the low doubles of the real parts of Y*W^T*C,
 *            on the device;
 *   YWTCimhi_d are the high doubles of the imaginary parts of Y*W^T*C,
 *            on the device;
 *   YWTCimlo_d are the low doubles of the imaginary parts of Y*W^T*C,
 *            on the device;
 *   verbose  is the verbose flag.
 *
 * ON RETURN :
 *   Rrehi_d  high doubles of the real parts of the updated R on the device;
 *   Rrelo_d  low doubles of the real parts of the updated R on the device;
 *   Rimhi_d  high doubles of the imaginary parts of the updated R,
 *            on the device;
 *   Rimlo_d  low doubles of the imaginary parts of the updated R,
 *            on the device;
 *   Rrehi_h  high doubles of the real parts of the updated R, if verbose;
 *   Rrelo_h  low doubles of the real parts of the updated R, if verbose;
 *   Rimhi_h  high doubles of the imaginary parts of the updated R,
 *            if verbose;
 *   Rimlo_h  low doubles of the imaginary parts of the updated R,
 *            if verbose;
 *   lapms    elapsed time spent by the kernel. */

void GPU_dbl2_blocked_houseqr
 ( int nrows, int ncols, int szt, int nbt,
   double **Ahi, double **Alo, double **Qhi, double **Qlo,
   double **Rhi, double **Rlo,
   double *houselapms, double *tileRlapms, double *vb2Wlapms,
   double *WYTlapms, double *QWYTlapms, double *Qaddlapms,
   double *YWTlapms, double *YWTClapms, double *Raddlapms,
   double *walltimesec, bool verbose=true );
/*
 * DESCRIPTION :
 *   Applies Householder transformations in a blocked manner
 *   to compute a QR decomposition of A, on real data.
 *
 * REQUIRED : nrows >= ncols.
 *
 * ON ENTRY :
 *   nrows    number of rows of A;
 *   ncols    number of columns of A;
 *   szt      size of each block;
 *   nbt      number of tiles, ncols = szt*nbt;
 *   Ahi      high doubles of an nrows-by-ncols matrix,
 *            stored as nrows arrays of ncols numbers;
 *   Alo      low doubles of an nrows-by-ncols matrix,
 *            stored as nrows arrays of ncols numbers;
 *   Qhi      space for an nrows-by-nrows matrix;
 *   Qlo      space for an nrows-by-nrows matrix;
 *   Rhi      space for an nrows-by-ncols matrix;
 *   Rlo      space for an nrows-by-ncols matrix;
 *   verbose  is the verbose flag.
 *
 * ON RETURN :
 *   Qhi      high doubles of an orthogonal matrix, transpose(Q)*A = R;
 *   Qlo      low doubles of an orthogonal matrix, transpose(Q)*A = R;
 *   Rhi      high doubles of the reduced upper triangular form of A;
 *   Rlo      low doubles of the reduced upper triangular form of A;
 *   houselapms is the elapsed time spent by the kernel
 *            to compute the Householder vector and the beta;
 *   tileRlapms is the elapsed time spent by the kernel
 *            to reduce one tile;
 *   vb2Wlapms is the elapsed time spent by the kernel
 *            to compute the W representation;
 *   WYTlapms is the elapsed time spent by the kernel
 *            to compute the W*Y^T product;
 *   QWYTlapms is the elapsed time spent by the kernel
 *            to compute the Q*WYT product;
 *   Qaddlapms is the elapsed time spent by the kernel
 *            to compute Q by adding the Q*W*Y^T matrix;
 *   YWTlapms is the elapsed time spent by the kernel
 *            to compute the Y*W^T product;
 *   YWTClapms is the elapsed time spent by the kernel
 *            to compute the YWT*C product;
 *   Raddlapms is the elapsed time spent by the kernel
 *            to compute R by adding the Y*W^T*C matrix;
 *   walltimesec is the elapsed wall clock computation time. */

void GPU_cmplx2_blocked_houseqr
 ( int nrows, int ncols, int szt, int nbt,
   double **Arehi, double **Arelo, double **Aimhi, double **Aimlo,
   double **Qrehi, double **Qrelo, double **Qimhi, double **Qimlo,
   double **Rrehi, double **Rrelo, double **Rimhi, double **Rimlo,
   double *houselapms, double *tileRlapms, double *vb2Wlapms,
   double *WYTlapms, double *QWYTlapms, double *Qaddlapms,
   double *YWTlapms, double *YWTClapms, double *Raddlapms,
   double *walltimesec, bool verbose=true );
/*
 * DESCRIPTION :
 *   Applies Householder transformations in a blocked manner
 *   to compute a QR decomposition of A, on complex data.
 *
 * REQUIRED : nrows >= ncols.
 *
 * ON ENTRY :
 *   nrows    number of rows of A;
 *   ncols    number of columns of A;
 *   szt      size of each block;
 *   nbt      number of tiles, ncols = szt*nbt;
 *   Arehi    high doubles of the real parts of an nrows-by-ncols matrix,
 *            stored as nrows arrays of ncols numbers;
 *   Arelo    low doubles of the real parts of an nrows-by-ncols matrix,
 *            stored as nrows arrays of ncols numbers;
 *   Aimhi    high doubles of the imaginary parts of an nrows-by-ncols matrix,
 *            stored as nrows arrays of ncols numbers;
 *   Aimlo    low doubles of the imaginary parts of an nrows-by-ncols matrix,
 *            stored as nrows arrays of ncols numbers;
 *   Qrehi    space for an nrows-by-nrows matrix;
 *   Qrelo    space for an nrows-by-nrows matrix;
 *   Qimhi    space for an nrows-by-nrows matrix;
 *   Qimlo    space for an nrows-by-nrows matrix;
 *   Rrehi    space for an nrows-by-ncols matrix;
 *   Rrelo    space for an nrows-by-ncols matrix;
 *   Rimhi    space for an nrows-by-ncols matrix;
 *   Rimlo    space for an nrows-by-ncols matrix;
 *   verbose  is the verbose flag.
 *
 * ON RETURN :
 *   Qrehi    high doubles of the real parts of an orthogonal matrix Q,
 *            transpose(Q)*A = R;
 *   Qrelo    low doubles of the real parts of the orthogonal matrix Q,
 *   Qimhi    high doubles of the imaginary parts of the orthogonal matrix Q;
 *   Qimlo    low doubles of the imaginary parts of the orthogonal matrix Q;
 *   Rrehi    high doubles of the real parts of the reduced upper triangular
 *            form R of A;
 *   Rrelo    low doubles of the real parts of the reduced form R;
 *   Rimhi    high doubles of the imaginary parts of the reduced form R;
 *   Rimlo    low doubles of the imaginary parts of the reduced form R;
 *   houselapms is the elapsed time spent by the kernel
 *            to compute the Householder vector and the beta;
 *   tileRlapms is the elapsed time spent by the kernel
 *            to reduce one tile;
 *   vb2Wlapms is the elapsed time spent by the kernel
 *            to compute the W representation;
 *   WYTlapms is the elapsed time spent by the kernel
 *            to compute the W*Y^T product;
 *   QWYTlapms is the elapsed time spent by the kernel
 *            to compute the Q*WYT product;
 *   Qaddlapms is the elapsed time spent by the kernel
 *            to compute Q by adding the Q*W*Y^T matrix;
 *   YWTlapms is the elapsed time spent by the kernel
 *            to compute the Y*W^T product;
 *   YWTClapms is the elapsed time spent by the kernel
 *            to compute the YWT*C product;
 *   Raddlapms is the elapsed time spent by the kernel
 *            to compute R by adding the Y*W^T*C matrix;
 *   walltimesec is the elapsed wall clock computation time. */

#endif
