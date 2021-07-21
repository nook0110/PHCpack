/* The file dbl_baqr_kernels.cu defines the functions with prototypes in
 * the file dbl_baqr_kernels.h. */

#include <iostream>
#include <iomanip>
#ifdef winwalltime
#include "wingettimeofday.h"
#else
#include <sys/time.h>
#endif
#include "dbl_baqr_kernels.h"

using namespace std;

__global__ void dbl_small_house
 ( double *x0, double *x1, int dim, int dimLog2, double *v, double *beta )
{
   const int j = threadIdx.x;

   __shared__ double shv[d_shmemsize];
   __shared__ double prd[d_shmemsize];

   bool stopflag = false;
   double mu,v0,v0p2;

   shv[j] = x1[j];              // reading of vector into shared memory
   prd[j] = shv[j]*shv[j];      // for the 2-norm computation

   v[j+1] = shv[j];             // copies x to v, in case beta is zero
   if(j == 0) v[0] = 1.0;

   __syncthreads();
   int powTwo = 1;                          // sum reduction
   for(int k=0; k < dimLog2; k++)
   {
      if((j%(powTwo*2)) == 0)
         if(j+powTwo < dim) prd[j] = prd[j] + prd[j+powTwo];
      powTwo = powTwo*2;
      __syncthreads();
   }
   // thread 0 computes the sqrt of the inner product, others wait
   if(j == 0)
   {
      if(prd[0] == 0.0)                    // prd[0] is sigma of house
      {
         *beta = 0.0; stopflag = true;
      }
   }
   __syncthreads();
   if(stopflag) return;                    // case when sigma is zero
   if(j == 0)                              // thread zero sets beta
   {
      mu = sqrt((*x0)*(*x0) + prd[0]);
      if(*x0 <= 0.0)
         v0 = *x0 - mu;
      else
         v0 = -prd[0]/(*x0 + mu);

      v0p2 = v0*v0;
      *beta = 2.0*v0p2/(prd[0] + v0p2);
      prd[0] = v0;                         // v0 needed for normalization
   }
   __syncthreads();
   shv[j] = shv[j]/prd[0];
   v[j+1] = shv[j];
   if(j == 0) v[0] = 1.0;
}

__global__ void dbl_factors_leftRupdate
 ( int nrows, int ncols, int szt, int k, double *R, double *v, double *beta )
{
   const int bdx = blockIdx.x;           // index of block
   const int tdx = threadIdx.x;          // index of thread in block
   const int idx = bdx*szt + tdx;        // global thread index
   const int Roffset = (k+bdx)*szt + k;
   int Rcolidx;
   double w,Rtdx;

   __shared__ double shv[d_shmemsize]; // slice of v

   if(idx < nrows - k)   // nrows - k threads in all blocks work
   {
      shv[tdx] = v[tdx];
      __syncthreads();
      w = 0.0;

      for(int i=0; i<nrows-k; i++)   // loop through rows of R
      {
         Rtdx = R[Roffset + i + tdx*nrows];
         w = w + Rtdx*shv[i];
      }
      w = (*beta)*w;
      __syncthreads();
      for(int i=0; i<nrows-k; i++)   // update i-th row of R
      {
         Rcolidx = Roffset + i + tdx*nrows;
         Rtdx = R[Rcolidx];
         Rtdx = Rtdx - shv[i]*w;
         __syncthreads();
         R[Rcolidx] = Rtdx;
      }
   }
}

__global__ void dbl_small_leftRupdate
 ( int nrows, int ncols, int szt, int k, double *R, double *v, double *beta )
{
   const int tdx = threadIdx.x;          // index of thread in block
   const int Roffset = k*nrows + k;
   int Rcolidx;
   double w,Rtdx;

   __shared__ double shv[d_shmemsize]; // slice of v

   shv[tdx] = v[tdx];
   __syncthreads();
   w = 0.0;

   for(int i=0; i<nrows-k; i++)   // loop through rows of R
   {
      Rtdx = R[Roffset + i + tdx*nrows];
      w = w + Rtdx*shv[i];
   }
   w = (*beta)*w;
   __syncthreads();
   for(int i=0; i<nrows-k; i++)   // update i-th row of R
   {
      Rcolidx = Roffset + i + tdx*nrows;
      Rtdx = R[Rcolidx];
      Rtdx = Rtdx - shv[i]*w;
      __syncthreads();
      if(tdx < ncols-k) R[Rcolidx] = Rtdx;
   }
}

__global__ void dbl_VB_to_W
 ( int nrows, int ncols, double *B, double *V, double *W )
{
   const int tdx = threadIdx.x;        // index of thread in block
   double wrk,pk,mypk,zi;

   __shared__ double shv[d_shmemsize]; // one work vector
   __shared__ double shw[d_shmemsize]; // the other work vector
   __shared__ double shp[d_shmemsize]; // to share Y^T*v

   shv[tdx] = V[tdx];
   wrk = -B[0]*shv[tdx];               // first column of W
   W[tdx] = wrk;

   for(int j=1; j<ncols; j++)          // compute column j of W
   {
      shv[tdx] = V[j*nrows + tdx];     // j-th Householder vector
      for(int k=0; k<j; k++)
      {
         pk = 0.0;                     // k-th component of Y^T*v
         shw[tdx] = V[k*nrows + tdx];  // load V[k][i]
         shp[tdx] = shw[tdx]*shv[tdx]; // V[k][i]*v[i]
         __syncthreads();
         for(int i=0; i<nrows; i++) pk = pk + shp[i];
         if(tdx == k) mypk = pk;
      }
      __syncthreads();
      shp[tdx] = mypk;                 // share p[k]
      __syncthreads();
      zi = 0.0;                        // i-th component of W*p
      for(int k=0; k<j; k++)
      {
         shw[tdx] = W[k*nrows + tdx];  // load W[k][i]
         zi = zi + shw[tdx]*shp[k];
      }
      zi = zi + shv[tdx];
      wrk = -B[j]*zi;
      W[j*nrows + tdx] = wrk;          // wrk is assigned to W[j][tdx]
      __syncthreads();
   }
}

__global__ void dbl_small_WYT
 ( int nrows, int szt, double *W, double *Y, double *WYT )
{
   const int bdx = blockIdx.x;           // index of block
   const int tdx = threadIdx.x;          // index of thread in block
   const int offset = bdx*szt;           // offset in result
   // const int row = 0; // offset/nrows;
   // const int col = 0; // offset%nrows; // thread 0 computes WYT[row][col]

   double result = 0.0;
   double a,b;

   for(int k=0; k<szt; k++)
   {
      a = W[k*nrows + tdx];
      __syncthreads();
      b = Y[k*nrows + tdx];
      __syncthreads();
      result = result + a*b;
   }
   __syncthreads();
   WYT[offset+tdx] = result;
}

void GPU_dbl_small_house
 ( int nrows, int ncols, int szt, int nbt,
   int colidx, int nrows1, int k, int L,
   double *x0_d, double *A_h, double *A_d,
   double *v_h, double *V_d, double *beta_h, double *beta_d,
   double *lapms, bool verbose )
{
   int nrLog2 = ceil(log2((double) nrows1));
   int rowidx = colidx*(nrows+1);       // start of number in A_h

   if(verbose)
   {
      cout << "nrows : " << nrows
           << "  ncols : " << ncols
           << "  szt : " << szt
           << "  nbt : " << nbt << endl;
      cout << "k : " << k 
           << "  L : " << L
           << "  nrows1 : " << nrows1
           << "  colidx : " << colidx
           << "  rowidx : " << rowidx << endl;
   }

   cudaEvent_t start,stop;           // to measure time spent by kernels 
   cudaEventCreate(&start);
   cudaEventCreate(&stop);
   float milliseconds;

   cudaMemcpy(x0_d,&A_h[rowidx],sizeof(double),cudaMemcpyHostToDevice);

   cudaEventRecord(start);
   dbl_small_house<<<1,nrows1>>>
      (x0_d,&A_d[rowidx+1],nrows1,nrLog2,&V_d[L*nrows+L],&beta_d[L]);
   cudaEventRecord(stop);
   cudaEventSynchronize(stop);
   cudaEventElapsedTime(&milliseconds,start,stop);
   *lapms += milliseconds;
 
   if(verbose)
   {
      const size_t szhouse = nrows*sizeof(double);

      cudaMemcpy(&beta_h[L],&beta_d[L],sizeof(double),cudaMemcpyDeviceToHost);
      cudaMemcpy(v_h,&V_d[L*nrows],szhouse,cudaMemcpyDeviceToHost);
      cout << scientific << setprecision(16)
           << "beta[" << L << "] : " << beta_h[L] << endl;
      for(int i=0; i<nrows; i++)
         cout << "v[" << i << "] : " << v_h[i] << endl;
   }
}

void GPU_dbl_small_leftRupdate
 ( int nrows, int ncols, int szt, int colidx, int L,
   double *A_h, double *A_d, double *V_d, double *beta_h, double *beta_d,
   double *lapms, bool verbose )
{
   cudaEvent_t start,stop;           // to measure time spent by kernels 
   cudaEventCreate(&start);
   cudaEventCreate(&stop);
   float milliseconds;

   cudaEventRecord(start);
   dbl_small_leftRupdate<<<1,nrows-colidx>>>
      (nrows,ncols,szt,colidx,A_d,&V_d[L*nrows+L],&beta_d[L]);
   cudaEventRecord(stop);
   cudaEventSynchronize(stop);
   cudaEventElapsedTime(&milliseconds,start,stop);
   *lapms += milliseconds;

   if(verbose)
   {
      const int dim = nrows*ncols;
      const size_t sznum = dim*sizeof(double);

      cudaMemcpy(A_h,A_d,sznum,cudaMemcpyDeviceToHost);
      cout << "the matrix after the update :" << endl;
      for(int i=0; i<nrows; i++)
         for(int j=0; j<ncols; j++)
            cout << "A_d[" << i << "][" << j << "] : "
                 << A_h[j*nrows+i] << endl;
   }
}

void GPU_dbl_VB_to_W
 ( int nrows, int ncols, int szt,
   double *V_h, double *V_d, double *W_h, double *W_d,
   double *beta_h, double *beta_d, double *lapms, bool verbose )
{
   cudaEvent_t start,stop;           // to measure time spent by kernels 
   cudaEventCreate(&start);
   cudaEventCreate(&stop);
   float milliseconds;

   cudaEventRecord(start);
   dbl_VB_to_W<<<1,nrows>>>(nrows,ncols,beta_d,V_d,W_d);
   cudaEventRecord(stop);
   cudaEventSynchronize(stop);
   cudaEventElapsedTime(&milliseconds,start,stop);
   *lapms += milliseconds;

   if(verbose)
   {
      const size_t szbeta = szt*sizeof(double);
      const size_t szhouse = nrows*sizeof(double);
      const size_t szVandW = szt*szhouse;

      cudaMemcpy(beta_h,beta_d,szbeta,cudaMemcpyDeviceToHost);
      cout << "the betas :" << endl;
      for(int j=0; j<szt; j++)
         cout << "beta[" << j << "] : " << beta_h[j] << endl;
      cudaMemcpy(V_h,V_d,szVandW,cudaMemcpyDeviceToHost);
      cout << "the columns of the V matrix :" << endl;
      int ix = 0;
      for(int j=0; j<szt; j++) 
         for(int i=0; i<nrows; i++) 
            cout << "V[" << i << "][" << j << "] : " << V_h[ix++] << endl;
      cudaMemcpy(W_h,W_d,szVandW,cudaMemcpyDeviceToHost);
      cout << "the columns of the W matrix :" << endl;
      ix = 0;
      for(int j=0; j<szt; j++) 
         for(int i=0; i<nrows; i++) 
            cout << "W[" << i << "][" << j << "] : " << W_h[ix++] << endl;
   }
}

void GPU_dbl_small_WYT
 ( int nrows, int szt, double *W_d, double *Y_d, double *WYT_d,
   double *WYT_h, double *lapms, bool verbose )
{
   cudaEvent_t start,stop;           // to measure time spent by kernels 
   cudaEventCreate(&start);
   cudaEventCreate(&stop);
   float milliseconds;

   cudaEventRecord(start);
   // dbl_small_WYT<<<nrows*nrows/szt,szt>>>(nrows,szt,W_d,Y_d,WYT_d);
   dbl_small_WYT<<<1,szt>>>(nrows,szt,W_d,Y_d,WYT_d);
   cudaEventRecord(stop);
   cudaEventSynchronize(stop);
   cudaEventElapsedTime(&milliseconds,start,stop);
   *lapms += milliseconds;

   if(verbose)
   {
      const size_t szmat = nrows*nrows*sizeof(double);

      cudaMemcpy(WYT_h,WYT_d,szmat,cudaMemcpyDeviceToHost);

      cout << "the WYT matrix :" << endl;
      int ix = 0;
      for(int i=0; i<nrows; i++) 
         for(int j=0; j<nrows; j++) 
            cout << "WYT[" << i << "][" << j << "] : "
                 << WYT_h[ix++] << endl;
   }
}

void GPU_dbl_blocked_houseqr
 ( int nrows, int ncols, int szt, int nbt,
   double **A, double **Q, double **R,
   double *houselapms, double *tileRlapms, double *vb2Wlapms,
   double *WYTlapms, double *walltimesec, bool verbose )
{
   const int dim = nrows*ncols;         // total number of doubles
   const int nrows2 = nrows*nrows;
   double *A_h = new double[dim];       // matrix A on the host
   double *A_d;                         // matrix on the device
   double *v_h = new double[nrows];     // Householder vector on host
   double *x0_d;                        // first element for house on device
   double *beta_h = new double[szt];    // beta on the host
   double *beta_d;                      // beta on the device
   double *V_h = new double[nrows*szt]; // matrix of Householder vectors
   double *V_d;                         // Householder vectors on device
   double *W_h = new double[nrows*szt]; // the W matrix on the host
   double *W_d;                         // the W matrix 
   double *WYT_h = new double[nrows2];  // W times Y^T on host
   double *WYT_d;                       // W times Y^T on device

   int ix=0;                            // copy the columns of A to A_h
   for(int j=0; j<ncols; j++)   
      for(int i=0; i<nrows; i++) A_h[ix++] = A[i][j];

   const size_t sznum = dim*sizeof(double);
   cudaMalloc((void**)&A_d,sznum);
   cudaMemcpy(A_d,A_h,sznum,cudaMemcpyHostToDevice);
   cudaMalloc((void**)&x0_d,sizeof(double));

   const size_t szbeta = szt*sizeof(double);
   cudaMalloc((void**)&beta_d,szbeta);
   for(int i=0; i<szt; i++) beta_h[i] = 0.0;
   cudaMemcpy(beta_d,beta_h,szbeta,cudaMemcpyHostToDevice);

   const size_t szhouse = nrows*sizeof(double);
   const size_t szVandW = szt*szhouse;
   cudaMalloc((void**)&V_d,szVandW);
   ix = 0;
   for(int i=0; i<nrows*szt; i++) V_h[ix++] = 0.0; 
   V_h[--ix] = 1.0; // initialize last vector for square tiles
   cudaMemcpy(V_d,V_h,szVandW,cudaMemcpyHostToDevice);
   cudaMalloc((void**)&W_d,szVandW);

   const size_t szWYT = nrows2*sizeof(double);
   cudaMalloc((void**)&WYT_d,szWYT);

   *houselapms = 0.0;
   *tileRlapms = 0.0;
   *vb2Wlapms = 0.0;
   struct timeval begintime,endtime; // wall clock time of computations

   gettimeofday(&begintime,0);

   for(int k=0; k<nbt; k++)       // k runs over the number of blocks
   {
      int colidx,nrows1;

      for(int L=0; L<szt; L++)  // L runs over the columns in one block
      {
         colidx = k*szt + L;              // index of the current column
         nrows1 = nrows - colidx - 1;     // #rows in Householder vector - 1
         if(nrows1 > 0)
         {
            GPU_dbl_small_house
               (nrows,ncols,szt,nbt,colidx,nrows1,k,L,
                x0_d,A_h,A_d,v_h,V_d,beta_h,beta_d,houselapms,verbose);

            GPU_dbl_small_leftRupdate
               (nrows,ncols,szt,colidx,L,A_h,A_d,V_d,beta_h,beta_d,
                tileRlapms,verbose);
         }
      }
      GPU_dbl_VB_to_W
         (nrows,ncols,szt,V_h,V_d,W_h,W_d,beta_h,beta_d,vb2Wlapms,verbose);

      GPU_dbl_small_WYT(nrows,szt,W_d,V_d,WYT_d,WYT_h,WYTlapms,verbose);
   }
   gettimeofday(&endtime,0);
   long seconds = endtime.tv_sec - begintime.tv_sec;
   long microseconds = endtime.tv_usec - begintime.tv_usec;
   *walltimesec = seconds + microseconds*1.0e-6;

   free(A_h); free(v_h); free(V_h); free(W_h); free(WYT_h);
}
