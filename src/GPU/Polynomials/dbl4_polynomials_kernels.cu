// The file dbl4_polynomials_kernels.cu defines the kernels with prototypes
// in dbl4_polynomials_kernels.h.

#include <iostream>
#include <iomanip>
#ifdef winwalltime
#include "gettimeofday4win.h"
#else
#include <sys/time.h>
#endif
#include "job_coordinates.h"
#include "quad_double_functions.h"
#ifdef gpufun
#include "double_double_gpufun.cu"
#include "quad_double_gpufun.cu"
#endif
#include "dbl4_polynomials_kernels.h"
#include "write_gpu_timings.h"

// The constant qd_shmemsize is the bound on the shared memory size.

#define qd_shmemsize 192

using namespace std;

__global__ void dbl4_padded_convjobs
 ( double *datahihi, double *datalohi, double *datahilo, double *datalolo,
   int *in1idx, int *in2idx, int *outidx, int dim )
{
   const int bdx = blockIdx.x;           // index to the convolution job
   const int tdx = threadIdx.x;          // index to the output of the job
   const int idx1 = in1idx[bdx] + tdx;
   const int idx2 = in2idx[bdx] + tdx;
   const int idx3 = outidx[bdx] + tdx;

   __shared__ double xvhihi[qd_shmemsize];
   __shared__ double xvlohi[qd_shmemsize];
   __shared__ double xvhilo[qd_shmemsize];
   __shared__ double xvlolo[qd_shmemsize];
   __shared__ double yvhihi[2*qd_shmemsize];
   __shared__ double yvlohi[2*qd_shmemsize];
   __shared__ double yvhilo[2*qd_shmemsize];
   __shared__ double yvlolo[2*qd_shmemsize];
   __shared__ double zvhihi[qd_shmemsize];
   __shared__ double zvlohi[qd_shmemsize];
   __shared__ double zvhilo[qd_shmemsize];
   __shared__ double zvlolo[qd_shmemsize];

   double prdhihi,prdlohi,prdhilo,prdlolo;
   int ydx = dim + tdx;

   xvhihi[tdx] = datahihi[idx1];  // loading first input
   xvlohi[tdx] = datalohi[idx1]; 
   xvhilo[tdx] = datahilo[idx1]; 
   xvlolo[tdx] = datalolo[idx1]; 
   yvhihi[tdx] = 0.0;             // padded with zeros
   yvlohi[tdx] = 0.0;
   yvhilo[tdx] = 0.0;
   yvlolo[tdx] = 0.0;
   yvhihi[ydx] = datahihi[idx2];  // loading second input
   yvlohi[ydx] = datalohi[idx2];
   yvhilo[ydx] = datahilo[idx2];
   yvlolo[ydx] = datalolo[idx2];

   __syncthreads();

   // zv[tdx] = xv[0]*yv[tdx];
   qdg_mul( xvhihi[0],   xvlohi[0],   xvhilo[0],   xvlolo[0],
            yvhihi[ydx], yvlohi[ydx], yvhilo[ydx], yvlolo[ydx],
           &zvhihi[tdx],&zvlohi[tdx],&zvhilo[tdx],&zvlolo[tdx]);
   __syncthreads();

   for(int i=1; i<dim; i++) // zv[tdx] = zv[tdx] + xv[i]*yv[dim+tdx-i];
   {
      ydx = dim + tdx - i;

      qdg_mul( xvhihi[i],  xvlohi[i],  xvhilo[i],  xvlolo[i],
               yvhihi[ydx],yvlohi[ydx],yvhilo[ydx],yvlolo[ydx],
              &prdhihi,  &prdlohi,   &prdhilo,   &prdlolo);
      __syncthreads();

      qdg_inc(&zvhihi[tdx],&zvlohi[tdx],&zvhilo[tdx],&zvlolo[tdx],
              prdhihi,     prdlohi,     prdhilo,     prdlolo);
      __syncthreads();
   }
   __syncthreads();

   datahihi[idx3] = zvhihi[tdx]; // storing the output
   datalohi[idx3] = zvlohi[tdx];
   datahilo[idx3] = zvhilo[tdx];
   datalolo[idx3] = zvlolo[tdx];
}

/*
__global__ void cmplx4_padded_convjobs
 ( double *datarehihi, double *datarelohi,
   double *datarehilo, double *datarelolo,
   double *dataimhihi, double *dataimlohi,
   double *dataimhilo, double *dataimlolo,
   int *in1idx, int *in2idx, int *outidx, int dim )
{
   const int bdx = blockIdx.x;           // index to the convolution job
   const int tdx = threadIdx.x;          // index to the output of the job
   const int idx1 = in1idx[bdx] + tdx;
   const int idx2 = in2idx[bdx] + tdx;
   const int idx3 = outidx[bdx] + tdx;

   __shared__ double xvrehihi[qd_shmemsize];
   __shared__ double xvrelohi[qd_shmemsize];
   __shared__ double xvrehilo[qd_shmemsize];
   __shared__ double xvrelolo[qd_shmemsize];
   __shared__ double xvimhihi[qd_shmemsize];
   __shared__ double xvimlohi[qd_shmemsize];
   __shared__ double xvimhilo[qd_shmemsize];
   __shared__ double xvimlolo[qd_shmemsize];
   __shared__ double yvrehihi[2*qd_shmemsize];
   __shared__ double yvrelohi[2*qd_shmemsize];
   __shared__ double yvrehilo[2*qd_shmemsize];
   __shared__ double yvrelolo[2*qd_shmemsize];
   __shared__ double yvimhihi[2*qd_shmemsize];
   __shared__ double yvimlohi[2*qd_shmemsize];
   __shared__ double yvimhilo[2*qd_shmemsize];
   __shared__ double yvimlolo[2*qd_shmemsize];
   __shared__ double zvrehihi[qd_shmemsize];
   __shared__ double zvrelohi[qd_shmemsize];
   __shared__ double zvrehilo[qd_shmemsize];
   __shared__ double zvrelolo[qd_shmemsize];
   __shared__ double zvimhihi[qd_shmemsize];
   __shared__ double zvimlohi[qd_shmemsize];
   __shared__ double zvimhilo[qd_shmemsize];
   __shared__ double zvimlolo[qd_shmemsize];

   double prodhihi,prodlohi,prodhilo,prodlolo;
   int ydx = dim + tdx;

   xvrehihi[tdx] = datarehihi[idx1];  // loading first input
   xvrelohi[tdx] = datarelohi[idx1]; 
   xvrehilo[tdx] = datarehilo[idx1]; 
   xvrelolo[tdx] = datarelolo[idx1]; 
   xvimhihi[tdx] = dataimhihi[idx1];
   xvimlohi[tdx] = dataimlohi[idx1];
   xvimhilo[tdx] = dataimhilo[idx1]; 
   xvimlolo[tdx] = dataimlolo[idx1]; 
   yvrehihi[tdx] = 0.0;           // padded with zeros
   yvrelohi[tdx] = 0.0;
   yvrehilo[tdx] = 0.0;
   yvrelolo[tdx] = 0.0;
   yvimhihi[tdx] = 0.0;
   yvimlohi[tdx] = 0.0;
   yvimhilo[tdx] = 0.0;
   yvimlolo[tdx] = 0.0;
   yvrehihi[ydx] = datarehihi[idx2];  // loading second input
   yvrelohi[ydx] = datarelohi[idx2];
   yvrehilo[ydx] = datarehilo[idx2];
   yvrelolo[ydx] = datarelolo[idx2];
   yvimhihi[ydx] = dataimhihi[idx2];
   yvimlohi[ydx] = dataimlohi[idx2];
   yvimhilo[ydx] = dataimhilo[idx2];
   yvimlolo[ydx] = dataimlolo[idx2];

   __syncthreads();

   // zv[tdx] = xv[0]*yv[tdx];
   qdg_mul( xvrehihi[0],   xvrelohi[0],   xvrehilo[0],   xvrelolo[0],
            yvrehihi[ydx], yvrelohi[ydx], yvrehilo[ydx], yvrelolo[ydx],
           &zvrehihi[tdx],&zvrelohi[tdx],&zvrehilo[tdx],&zvrelolo[tdx]);
   __syncthreads();
   qdg_mul( xvimhihi[0],  xvimlohi[0],  xvimhilo[0],  xvimlolo[0],
            yvimhihi[ydx],yvimlohi[ydx],yvimhilo[ydx],yvimlolo[ydx],
           &prodhihi,    &prodlohi,    &prodhilo,    &prodlolo);
   __syncthreads();
   qdg_minus(&prodhihi,&prodlohi,&prodhilo,&prodlolo);
   qdg_inc(&zvrehihi[tdx],&zvrelohi[tdx],&zvrehilo[tdx],&zvrelolo[tdx],
             prodhihi,     prodlohi,      prodhilo,      prodlolo);
   __syncthreads();

   qdg_mul( xvrehihi[0],   xvrelohi[0],   xvrehilo[0],   xvrelolo[0],
            yvimhihi[ydx], yvimlohi[ydx], yvimhilo[ydx], yvimlolo[ydx],
           &zvimhihi[tdx],&zvimlohi[tdx],&zvimhilo[tdx],&zvimlolo[tdx]);
   __syncthreads();
   qdg_mul( xvimhihi[0],  xvimlohi[0],  xvimhilo[0],  xvimlolo[0],
            yvrehihi[ydx],yvrelohi[ydx],yvrehilo[ydx],yvrelolo[ydx],
           &prodhihi,    &prodlohi,    &prodhilo,    &prodlolo);
   __syncthreads();
   qdg_inc(&zvimhihi[tdx],&zvimlohi[tdx],&zvimhilo[tdx],&zvimlolo[tdx],
            prodhihi,      prodlohi,      prodhilo,      prodlolo);
   __syncthreads();

   for(int i=1; i<dim; i++) // zv[tdx] = zv[tdx] + xv[i]*yv[dim+tdx-i];
   {
      ydx = dim + tdx - i;

      qdg_mul( xvrehihi[i],  xvrelohi[i],  xvrehilo[i],  xvrelolo[i],
               yvrehihi[ydx],yvrelohi[ydx],yvrehilo[ydx],yvrelolo[ydx],
              &prodhihi,    &prodlohi,    &prodhilo,    &prodlolo);
      __syncthreads();
      qdg_inc(&zvrehihi[tdx],&zvrelohi[tdx],&zvrehilo[tdx],&zvrelolo[tdx],
               prodhihi,      prodlohi,      prodhilo,      prodlolo);
      __syncthreads();
      qdg_mul( xvimhihi[i],  xvimlohi[i],  xvimhilo[i],  xvimlolo[i],
               yvimhihi[ydx],yvimlohi[ydx],yvimhilo[ydx],yvimlolo[ydx],
              &prodhihi,    &prodlohi,    &prodhilo,    &prodlolo);
      __syncthreads();
      qdg_minus(&prodhihi,&prodlohi,&prodhilo,&prodlolo);
      qdg_inc(&zvrehihi[tdx],&zvrelohi[tdx],&zvrehilo[tdx],&zvrelolo[tdx],
               prodhihi,      prodlohi,      prodhilo,      prodlolo);
      __syncthreads();

      qdg_mul( xvrehihi[i],  xvrelohi[i],  xvrehilo[i],  xvrelolo[i],
               yvimhihi[ydx],yvimlohi[ydx],yvimhilo[ydx],yvimlolo[ydx],
              &prodhihi,    &prodlohi,    &prodhilo,    &prodlolo);
      __syncthreads();
      qdg_inc(&zvimhihi[tdx],&zvimlohi[tdx],&zvimhilo[tdx],&zvimlolo[tdx],
                prodhihi,     prodlohi,      prodhilo,      prodlolo);
      __syncthreads();
      qdg_mul( xvimhihi[i],  xvimlohi[i],  xvimhilo[i],  xvimlolo[i],
               yvrehihi[ydx],yvrelohi[ydx],yvrehilo[ydx],yvrelolo[ydx],
              &prodhihi,    &prodlohi,    &prodhilo,    &prodlolo);
      __syncthreads();
      qdg_inc(&zvimhihi[tdx],&zvimlohi[tdx],&zvimhilo[tdx],&zvimlolo[tdx],
               prodhihi,      prodlohi,      prodhilo,      prodlolo);
      __syncthreads();
   }
   __syncthreads();

   datarehihi[idx3] = zvrehihi[tdx]; // storing the output
   datarelohi[idx3] = zvrelohi[tdx];
   datarehilo[idx3] = zvrehilo[tdx];
   datarelolo[idx3] = zvrelolo[tdx];
   dataimhihi[idx3] = zvimhihi[tdx]; 
   dataimlohi[idx3] = zvimlohi[tdx]; 
   dataimhilo[idx3] = zvimhilo[tdx];
   dataimlolo[idx3] = zvimlolo[tdx];
   __syncthreads();
}
*/

__global__ void cmplx4_padded_convjobs
 ( double *datarehihi, double *datarelohi,
   double *datarehilo, double *datarelolo,
   double *dataimhihi, double *dataimlohi,
   double *dataimhilo, double *dataimlolo,
   int *in1idx, int *in2idx, int *outidx, int dim )
{
   const int bdx = blockIdx.x;           // index to the convolution job
   const int tdx = threadIdx.x;          // index to the output of the job
   const int idx1 = in1idx[bdx] + tdx;
   const int idx2 = in2idx[bdx] + tdx;
   const int idx3 = outidx[bdx] + tdx;

   __shared__ double xvrehihi[qd_shmemsize];
   __shared__ double xvrelohi[qd_shmemsize];
   __shared__ double xvrehilo[qd_shmemsize];
   __shared__ double xvrelolo[qd_shmemsize];
   __shared__ double xvimhihi[qd_shmemsize];
   __shared__ double xvimlohi[qd_shmemsize];
   __shared__ double xvimhilo[qd_shmemsize];
   __shared__ double xvimlolo[qd_shmemsize];
   __shared__ double yvrehihi[2*qd_shmemsize];
   __shared__ double yvrelohi[2*qd_shmemsize];
   __shared__ double yvrehilo[2*qd_shmemsize];
   __shared__ double yvrelolo[2*qd_shmemsize];
   __shared__ double yvimhihi[2*qd_shmemsize];
   __shared__ double yvimlohi[2*qd_shmemsize];
   __shared__ double yvimhilo[2*qd_shmemsize];
   __shared__ double yvimlolo[2*qd_shmemsize];
   __shared__ double zvrehihi[qd_shmemsize];
   __shared__ double zvrelohi[qd_shmemsize];
   __shared__ double zvrehilo[qd_shmemsize];
   __shared__ double zvrelolo[qd_shmemsize];
   __shared__ double zvimhihi[qd_shmemsize];
   __shared__ double zvimlohi[qd_shmemsize];
   __shared__ double zvimhilo[qd_shmemsize];
   __shared__ double zvimlolo[qd_shmemsize];

   double xrhihi,xihihi,yrhihi,yihihi,zrhihi,zihihi,acchihi;
   double xrlohi,xilohi,yrlohi,yilohi,zrlohi,zilohi,acclohi;
   double xrhilo,xihilo,yrhilo,yihilo,zrhilo,zihilo,acchilo;
   double xrlolo,xilolo,yrlolo,yilolo,zrlolo,zilolo,acclolo;
   int ydx = dim + tdx;

   xvrehihi[tdx] = datarehihi[idx1];  // loading first input
   xvrelohi[tdx] = datarelohi[idx1]; 
   xvrehilo[tdx] = datarehilo[idx1]; 
   xvrelolo[tdx] = datarelolo[idx1]; 
   xvimhihi[tdx] = dataimhihi[idx1];
   xvimlohi[tdx] = dataimlohi[idx1];
   xvimhilo[tdx] = dataimhilo[idx1]; 
   xvimlolo[tdx] = dataimlolo[idx1]; 
   yvrehihi[tdx] = 0.0;           // padded with zeros
   yvrelohi[tdx] = 0.0;
   yvrehilo[tdx] = 0.0;
   yvrelolo[tdx] = 0.0;
   yvimhihi[tdx] = 0.0;
   yvimlohi[tdx] = 0.0;
   yvimhilo[tdx] = 0.0;
   yvimlolo[tdx] = 0.0;
   yvrehihi[ydx] = datarehihi[idx2];  // loading second input
   yvrelohi[ydx] = datarelohi[idx2];
   yvrehilo[ydx] = datarehilo[idx2];
   yvrelolo[ydx] = datarelolo[idx2];
   yvimhihi[ydx] = dataimhihi[idx2];
   yvimlohi[ydx] = dataimlohi[idx2];
   yvimhilo[ydx] = dataimhilo[idx2];
   yvimlolo[ydx] = dataimlolo[idx2];

   __syncthreads();

   // z[tdx] = x[0]*y[tdx]
   xrhihi = xvrehihi[0]; xrlohi = xvrelohi[0];
   xrhilo = xvrehilo[0]; xrlolo = xvrelolo[0];
   xihihi = xvimhihi[0]; xilohi = xvimlohi[0];
   xihilo = xvimhilo[0]; xilolo = xvimlolo[0];
   yrhihi = yvrehihi[ydx]; yrlohi = yvrelohi[ydx];
   yrhilo = yvrehilo[ydx]; yrlolo = yvrelolo[ydx];
   yihihi = yvimhihi[ydx]; yilohi = yvimlohi[ydx];
   yihilo = yvimhilo[ydx]; yilolo = yvimlolo[ydx];

   __syncthreads();

   qdg_mul(xrhihi,xrlohi,xrhilo,xrlolo,
           yrhihi,yrlohi,yrhilo,yrlolo,
           &zrhihi,&zrlohi,&zrhilo,&zrlolo);       // zr = xr*yr
   __syncthreads();
   qdg_mul(xihihi,xilohi,xihilo,xilolo,
           yihihi,yilohi,yihilo,yilolo,
           &acchihi,&acclohi,&acchilo,&acclolo);   // acc = xi*yi
   __syncthreads();
   qdg_minus(&acchihi,&acclohi,&acchilo,&acclolo);
   qdg_inc(&zrhihi,&zrlohi,&zrhilo,&zrlolo,
           acchihi,acclohi,acchilo,acclolo);       // zr = xr*yr - xi*yi
   __syncthreads();
   qdg_mul(xrhihi,xrlohi,xrhilo,xrlolo,
           yihihi,yilohi,yihilo,yilolo,
           &zihihi,&zilohi,&zihilo,&zilolo);       // zi = xr*yi
   __syncthreads();
   qdg_mul(xihihi,xilohi,xihilo,xilolo,
           yrhihi,yrlohi,yrhilo,yrlolo,
           &acchihi,&acclohi,&acchilo,&acclolo);   // acc = xi*yr
   __syncthreads();
   qdg_inc(&zihihi,&zilohi,&zihilo,&zilolo,
           acchihi,acclohi,acchilo,acclolo);       // zr = xr*yr + xi*yi
   __syncthreads();

   zvrehihi[tdx] = zrhihi; zvrelohi[tdx] = zrlohi;
   zvrehilo[tdx] = zrhilo; zvrelolo[tdx] = zrlolo;
   zvimhihi[tdx] = zihihi; zvimlohi[tdx] = zilohi;
   zvimhilo[tdx] = zihilo; zvimlolo[tdx] = zilolo;

   __syncthreads();

   for(int i=1; i<dim; i++) // z[tdx] = z[tdx] + x[i]*y[tdx-i]
   {
      ydx = dim + tdx - i;
      xrhihi = xvrehihi[i]; xrlohi = xvrelohi[i];
      xrhilo = xvrehilo[i]; xrlolo = xvrelolo[i];
      xihihi = xvimhihi[i]; xilohi = xvimlohi[i];
      xihilo = xvimhilo[i]; xilolo = xvimlolo[i];
      yrhihi = yvrehihi[ydx]; yrlohi = yvrelohi[ydx];
      yrhilo = yvrehilo[ydx]; yrlolo = yvrelolo[ydx];
      yihihi = yvimhihi[ydx]; yilohi = yvimlohi[ydx];
      yihilo = yvimhilo[ydx]; yilolo = yvimlolo[ydx];

      __syncthreads();

      qdg_mul(xrhihi,xrlohi,xrhilo,xrlolo,
              yrhihi,yrlohi,yrhilo,yrlolo,
              &zrhihi,&zrlohi,&zrhilo,&zrlolo);       // zr = xr*yr
      __syncthreads();
      qdg_mul(xihihi,xilohi,xihilo,xilolo,
              yihihi,yilohi,yihilo,yilolo,
              &acchihi,&acclohi,&acchilo,&acclolo);   // acc = xi*yi
      __syncthreads();
      qdg_minus(&acchihi,&acclohi,&acchilo,&acclolo);
      qdg_inc(&zrhihi,&zrlohi,&zrhilo,&zrlolo,
              acchihi,acclohi,acchilo,acclolo);       // zr = xr*yr - xi*yi
      __syncthreads();
      qdg_mul(xrhihi,xrlohi,xrhilo,xrlolo,
              yihihi,yilohi,yihilo,yilolo,
              &zihihi,&zilohi,&zihilo,&zilolo);       // zi = xr*yi
      __syncthreads();
      qdg_mul(xihihi,xilohi,xihilo,xilolo,
              yrhihi,yrlohi,yrhilo,yrlolo,
              &acchihi,&acclohi,&acchilo,&acclolo);   // acc = xi*yr
      __syncthreads();
      qdg_inc(&zihihi,&zilohi,&zihilo,&zilolo,
              acchihi,acclohi,acchilo,acclolo);       // zr = xr*yr + xi*yi
      __syncthreads();
      qdg_inc(&zvrehihi[tdx],&zvrelohi[tdx],&zvrehilo[tdx],&zvrelolo[tdx],
              zrhihi,zrlohi,zrhilo,zrlolo);           // zvre[k] += zr;
      __syncthreads();
      qdg_inc(&zvimhihi[tdx],&zvimlohi[tdx],&zvimhilo[tdx],&zvimlolo[tdx],
              zihihi,zilohi,zihilo,zilolo);           // zvim[k] += zi;
      __syncthreads();
   }
   __syncthreads();

   datarehihi[idx3] = zvrehihi[tdx]; // storing the output
   datarelohi[idx3] = zvrelohi[tdx];
   datarehilo[idx3] = zvrehilo[tdx];
   datarelolo[idx3] = zvrelolo[tdx];
   dataimhihi[idx3] = zvimhihi[tdx]; 
   dataimlohi[idx3] = zvimlohi[tdx]; 
   dataimhilo[idx3] = zvimhilo[tdx];
   dataimlolo[idx3] = zvimlolo[tdx];
   __syncthreads();
}

__global__ void dbl4_update_addjobs
 ( double *datahihi, double *datalohi, double *datahilo, double *datalolo,
   int *in1idx, int *in2idx, int *outidx, int dim )
{
   const int bdx = blockIdx.x;           // index to the convolution job
   const int tdx = threadIdx.x;          // index to the output of the job
   const int idx1 = in1idx[bdx] + tdx;
   const int idx2 = in2idx[bdx] + tdx;
   const int idx3 = outidx[bdx] + tdx;

   __shared__ double xvhihi[qd_shmemsize];
   __shared__ double xvlohi[qd_shmemsize];
   __shared__ double xvhilo[qd_shmemsize];
   __shared__ double xvlolo[qd_shmemsize];
   __shared__ double yvhihi[qd_shmemsize];
   __shared__ double yvlohi[qd_shmemsize];
   __shared__ double yvhilo[qd_shmemsize];
   __shared__ double yvlolo[qd_shmemsize];
   __shared__ double zvhihi[qd_shmemsize];
   __shared__ double zvlohi[qd_shmemsize];
   __shared__ double zvhilo[qd_shmemsize];
   __shared__ double zvlolo[qd_shmemsize];

   xvhihi[tdx] = datahihi[idx1];  // loading first input
   xvlohi[tdx] = datalohi[idx1];
   xvhilo[tdx] = datahilo[idx1];
   xvlolo[tdx] = datalolo[idx1];
   yvhihi[tdx] = datahihi[idx2];  // loading second input
   yvlohi[tdx] = datalohi[idx2];
   yvhilo[tdx] = datahilo[idx2];
   yvlolo[tdx] = datalolo[idx2];

   // zv[tdx] = xv[tdx] + yv[tdx];

   __syncthreads();

   qdg_add( xvhihi[tdx], xvlohi[tdx], xvhilo[tdx], xvlolo[tdx],
            yvhihi[tdx], yvlohi[tdx], yvhilo[tdx], yvlolo[tdx],
           &zvhihi[tdx],&zvlohi[tdx],&zvhilo[tdx],&zvlolo[tdx]);

   __syncthreads();

   datahihi[idx3] = zvhihi[tdx]; // storing the output
   datalohi[idx3] = zvlohi[tdx];
   datahilo[idx3] = zvhilo[tdx];
   datalolo[idx3] = zvlolo[tdx];
}

__global__ void cmplx4_update_addjobs
 ( double *datarehihi, double *datarelohi,
   double *datarehilo, double *datarelolo,
   double *dataimhihi, double *dataimlohi,
   double *dataimhilo, double *dataimlolo,
   int *in1idx, int *in2idx, int *outidx, int dim )
{
   const int bdx = blockIdx.x;           // index to the addition job
   const int tdx = threadIdx.x;          // index to the output of the job
   const int idx1 = in1idx[bdx] + tdx;
   const int idx2 = in2idx[bdx] + tdx;
   const int idx3 = outidx[bdx] + tdx;

   __shared__ double xvrehihi[qd_shmemsize];
   __shared__ double xvrelohi[qd_shmemsize];
   __shared__ double xvrehilo[qd_shmemsize];
   __shared__ double xvrelolo[qd_shmemsize];
   __shared__ double xvimhihi[qd_shmemsize];
   __shared__ double xvimlohi[qd_shmemsize];
   __shared__ double xvimhilo[qd_shmemsize];
   __shared__ double xvimlolo[qd_shmemsize];
   __shared__ double yvrehihi[qd_shmemsize];
   __shared__ double yvrelohi[qd_shmemsize];
   __shared__ double yvrehilo[qd_shmemsize];
   __shared__ double yvrelolo[qd_shmemsize];
   __shared__ double yvimhihi[qd_shmemsize];
   __shared__ double yvimlohi[qd_shmemsize];
   __shared__ double yvimhilo[qd_shmemsize];
   __shared__ double yvimlolo[qd_shmemsize];
   __shared__ double zvrehihi[qd_shmemsize];
   __shared__ double zvrelohi[qd_shmemsize];
   __shared__ double zvrehilo[qd_shmemsize];
   __shared__ double zvrelolo[qd_shmemsize];
   __shared__ double zvimhihi[qd_shmemsize];
   __shared__ double zvimlohi[qd_shmemsize];
   __shared__ double zvimhilo[qd_shmemsize];
   __shared__ double zvimlolo[qd_shmemsize];

   xvrehihi[tdx] = datarehihi[idx1];  // loading first input
   xvrelohi[tdx] = datarelohi[idx1];
   xvrehilo[tdx] = datarehilo[idx1];
   xvrelolo[tdx] = datarelolo[idx1];
   xvimhihi[tdx] = dataimhihi[idx1];
   xvimlohi[tdx] = dataimlohi[idx1];
   xvimhilo[tdx] = dataimhilo[idx1];
   xvimlolo[tdx] = dataimlolo[idx1];
   yvrehihi[tdx] = datarehihi[idx2];  // loading second input
   yvrelohi[tdx] = datarelohi[idx2];
   yvrehilo[tdx] = datarehilo[idx2];
   yvrelolo[tdx] = datarelolo[idx2];
   yvimhihi[tdx] = dataimhihi[idx2];
   yvimlohi[tdx] = dataimlohi[idx2];
   yvimhilo[tdx] = dataimhilo[idx2];
   yvimlolo[tdx] = dataimlolo[idx2];

   // zv[tdx] = xv[tdx] + yv[tdx];

   qdg_add(xvrehihi[tdx],xvrelohi[tdx],xvrehilo[tdx],xvrelolo[tdx],
           yvrehihi[tdx],yvrelohi[tdx],yvrehilo[tdx],yvrelolo[tdx],
           &zvrehihi[tdx],&zvrelohi[tdx],&zvrehilo[tdx],&zvrelolo[tdx]);
   __syncthreads();

   qdg_add(xvimhihi[tdx],xvimlohi[tdx],xvimhilo[tdx],xvimlolo[tdx],
           yvimhihi[tdx],yvimlohi[tdx],yvimhilo[tdx],yvimlolo[tdx],
           &zvimhihi[tdx],&zvimlohi[tdx],&zvimhilo[tdx],&zvimlolo[tdx]);
   __syncthreads();

   datarehihi[idx3] = zvrehihi[tdx]; // storing the output
   datarelohi[idx3] = zvrelohi[tdx];
   datarehilo[idx3] = zvrehilo[tdx];
   datarelolo[idx3] = zvrelolo[tdx];
   dataimhihi[idx3] = zvimhihi[tdx];
   dataimlohi[idx3] = zvimlohi[tdx];
   dataimhilo[idx3] = zvimhilo[tdx];
   dataimlolo[idx3] = zvimlolo[tdx];
}

void dbl_convoluted_data4_to_output
 ( double *datahihi, double *datalohi, double *datahilo, double *datalolo,
   double **outputhihi, double **outputlohi,
   double **outputhilo, double **outputlolo,
   int dim, int nbr, int deg, int *nvr,
   int **idx, int *fstart, int *bstart, int *cstart, bool verbose )
{
   const int deg1 = deg+1;
   int ix0,ix1,ix2;

   for(int i=0; i<=deg; i++) // output[dim][i] = data[i];
   {
      outputhihi[dim][i] = datahihi[i];
      outputlohi[dim][i] = datalohi[i];
      outputhilo[dim][i] = datahilo[i];
      outputlolo[dim][i] = datalolo[i];
   }
   for(int i=0; i<dim; i++)
      for(int j=0; j<=deg; j++) // output[i][j] = 0.0;
      {
         outputhihi[i][j] = 0.0;
         outputlohi[i][j] = 0.0;
         outputhilo[i][j] = 0.0;
         outputlolo[i][j] = 0.0;
      }

   for(int k=0; k<nbr; k++)
   {
      ix1 = fstart[k] + (nvr[k]-1)*deg1;
      
      if(verbose)
         cout << "monomial " << k << " update starts at " << ix1 << endl;

      for(int i=0; i<=deg; i++) // output[dim][i] += data[ix1++];
         qdf_inc(&outputhihi[dim][i],&outputlohi[dim][i],
                 &outputhilo[dim][i],&outputlolo[dim][i],
                    datahihi[ix1],      datalohi[ix1],
                    datahilo[ix1],      datalolo[ix1++]);
     
      ix0 = idx[k][0];
      if(nvr[k] == 1)
      {
         ix1 = (1 + k)*deg1;
            
         for(int i=0; i<=deg; i++) // output[ix0][i] += data[ix1++];
            qdf_inc(&outputhihi[ix0][i],&outputlohi[ix0][i],
                    &outputhilo[ix0][i],&outputlolo[ix0][i],
                       datahihi[ix1],      datalohi[ix1],
                       datahilo[ix1],      datalolo[ix1++]);
      }
      else
      {                               // update first and last derivative
         ix2 = nvr[k]-3;
         if(ix2 < 0) ix2 = 0;
         ix1 = bstart[k] + ix2*deg1;

         for(int i=0; i<=deg; i++) // output[ix0][i] += data[ix1++];
            qdf_inc(&outputhihi[ix0][i],&outputlohi[ix0][i],
                    &outputhilo[ix0][i],&outputlolo[ix0][i],
                       datahihi[ix1],      datalohi[ix1],
                       datahilo[ix1],      datalolo[ix1++]);

         ix2 = nvr[k]-2;
         ix1 = fstart[k] + ix2*deg1;
         ix0 = idx[k][ix2+1];

         for(int i=0; i<=deg; i++) // output[ix0][i] += data[ix1++];
            qdf_inc(&outputhihi[ix0][i],&outputlohi[ix0][i],
                    &outputhilo[ix0][i],&outputlolo[ix0][i],
                       datahihi[ix1],      datalohi[ix1],
                       datahilo[ix1],      datalolo[ix1++]);
 
         if(nvr[k] > 2)                   // update all other derivatives
         {
            for(int j=1; j<nvr[k]-1; j++)
            {
               ix0 = idx[k][j];            // j-th variable in monomial k
               ix1 = cstart[k] + (j-1)*deg1;

               if(verbose)
                  cout << "monomial " << k << " derivative " << ix0
                       << " update starts at " << ix1 << endl;

               for(int i=0; i<=deg; i++) // output[ix0][i] += data[ix1++];
                  qdf_inc(&outputhihi[ix0][i],&outputlohi[ix0][i],
                          &outputhilo[ix0][i],&outputlolo[ix0][i],
                             datahihi[ix1],      datalohi[ix1],
                             datahilo[ix1],      datalolo[ix1++]);
            }
         }
      }
   }
}

void cmplx_convoluted_data4_to_output
 ( double *datarehihi, double *datarelohi,
   double *datarehilo, double *datarelolo,
   double *dataimhihi, double *dataimlohi,
   double *dataimhilo, double *dataimlolo,
   double **outputrehihi, double **outputrelohi,
   double **outputrehilo, double **outputrelolo,
   double **outputimhihi, double **outputimlohi,
   double **outputimhilo, double **outputimlolo,
   int dim, int nbr, int deg, int *nvr,
   int **idx, int *fstart, int *bstart, int *cstart, bool verbose )
{
   const int deg1 = deg+1;
   int ix0,ix1,ix2;

   for(int i=0; i<=deg; i++) // output[dim][i] = data[i];
   {
      outputrehihi[dim][i] = datarehihi[i];
      outputrelohi[dim][i] = datarelohi[i];
      outputrehilo[dim][i] = datarehilo[i];
      outputrelolo[dim][i] = datarelolo[i];
      outputimhihi[dim][i] = dataimhihi[i];
      outputimlohi[dim][i] = dataimlohi[i];
      outputimhilo[dim][i] = dataimhilo[i];
      outputimlolo[dim][i] = dataimlolo[i];
   }
   for(int i=0; i<dim; i++)
      for(int j=0; j<=deg; j++) // output[i][j] = 0.0;
      {
         outputrehihi[i][j] = 0.0;
         outputrelohi[i][j] = 0.0;
         outputrehilo[i][j] = 0.0;
         outputrelolo[i][j] = 0.0;
         outputimhihi[i][j] = 0.0;
         outputimlohi[i][j] = 0.0;
         outputimhilo[i][j] = 0.0;
         outputimlolo[i][j] = 0.0;
      }

   for(int k=0; k<nbr; k++)
   {
      ix1 = fstart[k] + (nvr[k]-1)*deg1;
      
      if(verbose)
         cout << "monomial " << k << " update starts at " << ix1 << endl;

      for(int i=0; i<=deg; i++) // output[dim][i] += data[ix1++];
      {
         qdf_inc(&outputrehihi[dim][i],&outputrelohi[dim][i],
                 &outputrehilo[dim][i],&outputrelolo[dim][i],
                 datarehihi[ix1],datarelohi[ix1],
                 // datarehilo[ix1],datarelolo[ix1++]);
                 datarehilo[ix1],datarelolo[ix1]);
         qdf_inc(&outputimhihi[dim][i],&outputimlohi[dim][i],
                 &outputimhilo[dim][i],&outputimlolo[dim][i],
                 dataimhihi[ix1],dataimlohi[ix1],
                 dataimhilo[ix1],dataimlolo[ix1++]);
      }
      ix0 = idx[k][0];
      if(nvr[k] == 1)
      {
         ix1 = (1 + k)*deg1;
            
         for(int i=0; i<=deg; i++) // output[ix0][i] += data[ix1++];
         {
            qdf_inc(&outputrehihi[ix0][i],&outputrelohi[ix0][i],
                    &outputrehilo[ix0][i],&outputrelolo[ix0][i],
                    datarehihi[ix1],datarelohi[ix1],
                    // datarehilo[ix1],datarelolo[ix1++]);
                    datarehilo[ix1],datarelolo[ix1]);
            qdf_inc(&outputimhihi[ix0][i],&outputimlohi[ix0][i],
                    &outputimhilo[ix0][i],&outputimlolo[ix0][i],
                    dataimhihi[ix1],dataimlohi[ix1],
                    dataimhilo[ix1],dataimlolo[ix1++]);
         }
      }
      else
      {                               // update first and last derivative
         ix2 = nvr[k]-3;
         if(ix2 < 0) ix2 = 0;
         ix1 = bstart[k] + ix2*deg1;

         for(int i=0; i<=deg; i++) // output[ix0][i] += data[ix1++];
         {
            qdf_inc(&outputrehihi[ix0][i],&outputrelohi[ix0][i],
                    &outputrehilo[ix0][i],&outputrelolo[ix0][i],
                    datarehihi[ix1],datarelohi[ix1],
                    // datarehilo[ix1],datarelolo[ix1++]);
                    datarehilo[ix1],datarelolo[ix1]);
            qdf_inc(&outputimhihi[ix0][i],&outputimlohi[ix0][i],
                    &outputimhilo[ix0][i],&outputimlolo[ix0][i],
                    dataimhihi[ix1],dataimlohi[ix1],
                    dataimhilo[ix1],dataimlolo[ix1++]);
         }
         ix2 = nvr[k]-2;
         ix1 = fstart[k] + ix2*deg1;
         ix0 = idx[k][ix2+1];

         for(int i=0; i<=deg; i++) // output[ix0][i] += data[ix1++];
         {
            qdf_inc(&outputrehihi[ix0][i],&outputrelohi[ix0][i],
                    &outputrehilo[ix0][i],&outputrelolo[ix0][i],
                    datarehihi[ix1],datarelohi[ix1],
                    // datarehilo[ix1],datarelolo[ix1++]);
                    datarehilo[ix1],datarelolo[ix1]);
            qdf_inc(&outputimhihi[ix0][i],&outputimlohi[ix0][i],
                    &outputimhilo[ix0][i],&outputimlolo[ix0][i],
                    dataimhihi[ix1],dataimlohi[ix1],
                    dataimhilo[ix1],dataimlolo[ix1++]);
         }
         if(nvr[k] > 2)                   // update all other derivatives
         {
            for(int j=1; j<nvr[k]-1; j++)
            {
               ix0 = idx[k][j];            // j-th variable in monomial k
               ix1 = cstart[k] + (j-1)*deg1;

               if(verbose)
                  cout << "monomial " << k << " derivative " << ix0
                       << " update starts at " << ix1 << endl;

               for(int i=0; i<=deg; i++) // output[ix0][i] += data[ix1++];
               {
                  qdf_inc(&outputrehihi[ix0][i],&outputrelohi[ix0][i],
                          &outputrehilo[ix0][i],&outputrelolo[ix0][i],
                          datarehihi[ix1],datarelohi[ix1],
                          // datarehilo[ix1],datarelolo[ix1++]);
                          datarehilo[ix1],datarelolo[ix1]);
                  qdf_inc(&outputimhihi[ix0][i],&outputimlohi[ix0][i],
                          &outputimhilo[ix0][i],&outputimlolo[ix0][i],
                          dataimhihi[ix1],dataimlohi[ix1],
                          dataimhilo[ix1],dataimlolo[ix1++]);
               }
            }
         }
      }
   }
}

void dbl_added_data4_to_output
 ( double *datahihi, double *datalohi, double *datahilo, double *datalolo,
   double **outputhihi, double **outputlohi,
   double **outputhilo, double **outputlolo,
   int dim, int nbr, int deg, int *nvr,
   int **idx, int *fstart, int *bstart, int *cstart,
   AdditionJobs jobs, bool verbose )
{
   const int deg1 = deg + 1;
   const int lastmon = nbr-1;
   const int lastidx = nvr[lastmon]-1;
   int ix;

   ix = fstart[lastmon] + lastidx*deg1;

   if(verbose)
      cout << "Updating value starting at " << ix << " in data." << endl;

   for(int i=0; i<=deg; i++) // output[dim][i] = data[ix++];
   {
      outputhihi[dim][i] = datahihi[ix];
      outputlohi[dim][i] = datalohi[ix];
      outputhilo[dim][i] = datahilo[ix];
      outputlolo[dim][i] = datalolo[ix++];
   }
   int cnt = jobs.get_differential_count(0);
   if(cnt == 0) // it could be there is no first variable anywhere ...
   {
      for(int i=0; i<=deg; i++) // output[0][i] = 0.0;
      {
         outputhihi[0][i] = 0.0;
         outputlohi[0][i] = 0.0;
         outputhilo[0][i] = 0.0;
         outputlolo[0][i] = 0.0;
      }
   }
   else
   {
      int ix0 = jobs.get_differential_index(0,cnt);
      int ix2 = nvr[ix0]-3;
      if(ix2 < 0) ix2 = 0; // on GPU, one backward item less

      ix = bstart[ix0] + ix2*deg1;
      
      if(verbose)
         cout << "Updating derivative 0 at " << ix << " in data." << endl;

      for(int i=0; i<=deg; i++) // output[0][i] = data[ix++];
      {
         outputhihi[0][i] = datahihi[ix];
         outputlohi[0][i] = datalohi[ix];
         outputhilo[0][i] = datahilo[ix];
         outputlolo[0][i] = datalolo[ix++];
      }
      for(int k=1; k<dim; k++) // updating all other derivatives
      {
         int cnt = jobs.get_differential_count(k);
         if(cnt == 0) // it could be there is no variable k anywhere ...
         {
            for(int i=0; i<=deg; i++) // output[k][i] = 0.0;
            {
               outputhihi[k][i] = 0.0;
               outputlohi[k][i] = 0.0;
               outputhilo[k][i] = 0.0;
               outputlolo[k][i] = 0.0;
            }
         }
         else
         {
            int ix0 = jobs.get_differential_index(k,cnt);
   
            if(idx[ix0][0] == k) // k is first variable of monomial
            {
               int ix2 = nvr[ix0]-3;
               if(ix2 < 0) ix2 = 0;

               if(verbose)
                  cout << "Updating derivative " << k 
                       << " at " << ix << " in data." << endl;

               ix = bstart[ix0] + ix2*deg1;

               for(int i=0; i<=deg; i++) // output[k][i] = data[ix++];
               {
                  outputhihi[k][i] = datahihi[ix];
                  outputlohi[k][i] = datalohi[ix];
                  outputhilo[k][i] = datahilo[ix];
                  outputlolo[k][i] = datalolo[ix++];
               }
            }
            else if(idx[ix0][nvr[ix0]-1] == k) // k is last variable
            {
               int ix2 = nvr[ix0]-2;
   
               if(verbose)
                  cout << "Updating derivative " << k 
                       << " at " << ix << " in data." << endl;

               ix = fstart[ix0] + ix2*deg1;

               for(int i=0; i<=deg; i++) // output[k][i] = data[ix++];
               {
                  outputhihi[k][i] = datahihi[ix];
                  outputlohi[k][i] = datalohi[ix];
                  outputhilo[k][i] = datahilo[ix];
                  outputlolo[k][i] = datalolo[ix++];
               }
            }
            else // derivative is in some cross product
            {
               int ix2 = jobs.position(nvr[ix0],idx[ix0],k) - 1;
   
               if(verbose)
                  cout << "Updating derivative " << k 
                       << " at " << ix << " in data." << endl;

               ix = cstart[ix0] + ix2*deg1;

               for(int i=0; i<=deg; i++) // output[k][i] = data[ix++];
               {
                  outputhihi[k][i] = datahihi[ix];
                  outputlohi[k][i] = datalohi[ix];
                  outputhilo[k][i] = datahilo[ix];
                  outputlolo[k][i] = datalolo[ix++];
               }
            }
         }
      }
   }
}

void cmplx_added_data4_to_output
 ( double *datarehihi, double *datarelohi,
   double *datarehilo, double *datarelolo,
   double *dataimhihi, double *dataimlohi,
   double *dataimhilo, double *dataimlolo,
   double **outputrehihi, double **outputrelohi,
   double **outputrehilo, double **outputrelolo,
   double **outputimhihi, double **outputimlohi,
   double **outputimhilo, double **outputimlolo,
   int dim, int nbr, int deg, int *nvr,
   int **idx, int *fstart, int *bstart, int *cstart, AdditionJobs jobs,
   bool verbose )
{
   const int deg1 = deg + 1;
   const int lastmon = nbr-1;
   const int lastidx = nvr[lastmon]-1;
   int ix;

   ix = fstart[lastmon] + lastidx*deg1;

   if(verbose)
      cout << "Updating value starting at " << ix << " in data." << endl;

   for(int i=0; i<=deg; i++) // output[dim][i] = data[ix++];
   {
      outputrehihi[dim][i] = datarehihi[ix];
      outputrelohi[dim][i] = datarelohi[ix];
      outputrehilo[dim][i] = datarehilo[ix];
      outputrelolo[dim][i] = datarelolo[ix];
      outputimhihi[dim][i] = dataimhihi[ix];
      outputimlohi[dim][i] = dataimlohi[ix];
      outputimhilo[dim][i] = dataimhilo[ix];
      outputimlolo[dim][i] = dataimlolo[ix++];
   }
   int cnt = jobs.get_differential_count(0);
   if(cnt == 0) // it could be there is no first variable anywhere ...
   {
      for(int i=0; i<=deg; i++) // output[0][i] = 0.0;
      {
         outputrehihi[0][i] = 0.0; outputrelohi[0][i] = 0.0;
         outputrehilo[0][i] = 0.0; outputrelolo[0][i] = 0.0;
         outputimhihi[0][i] = 0.0; outputimlohi[0][i] = 0.0; 
         outputimhilo[0][i] = 0.0; outputimlolo[0][i] = 0.0;
      }
   }
   else
   {
      int ix0 = jobs.get_differential_index(0,cnt);
      int ix2 = nvr[ix0]-3;
      if(ix2 < 0) ix2 = 0; // on GPU, one backward item less

      ix = bstart[ix0] + ix2*deg1;
      
      if(verbose)
         cout << "Updating derivative 0 at " << ix << " in data." << endl;

      for(int i=0; i<=deg; i++) // output[0][i] = data[ix++];
      {
         outputrehihi[0][i] = datarehihi[ix];
         outputrelohi[0][i] = datarelohi[ix];
         outputrehilo[0][i] = datarehilo[ix];
         outputrelolo[0][i] = datarelolo[ix];
         outputimhihi[0][i] = dataimhihi[ix];
         outputimlohi[0][i] = dataimlohi[ix];
         outputimhilo[0][i] = dataimhilo[ix];
         outputimlolo[0][i] = dataimlolo[ix++];
      }
      for(int k=1; k<dim; k++) // updating all other derivatives
      {
         int cnt = jobs.get_differential_count(k);
         if(cnt == 0) // it could be there is no variable k anywhere ...
         {
            for(int i=0; i<=deg; i++) // output[k][i] = 0.0;
            {
               outputrehihi[k][i] = 0.0; outputrelohi[k][i] = 0.0;
               outputrehilo[k][i] = 0.0; outputrelolo[k][i] = 0.0;
               outputimhihi[k][i] = 0.0; outputimlohi[k][i] = 0.0;
               outputimhilo[k][i] = 0.0; outputimlolo[k][i] = 0.0;
            }
         }
         else
         {
            int ix0 = jobs.get_differential_index(k,cnt);
   
            if(idx[ix0][0] == k) // k is first variable of monomial
            {
               int ix2 = nvr[ix0]-3;
               if(ix2 < 0) ix2 = 0;

               if(verbose)
                  cout << "Updating derivative " << k 
                       << " at " << ix << " in data." << endl;

               ix = bstart[ix0] + ix2*deg1;

               for(int i=0; i<=deg; i++) // output[k][i] = data[ix++];
               {
                  outputrehihi[k][i] = datarehihi[ix];
                  outputrelohi[k][i] = datarelohi[ix];
                  outputrehilo[k][i] = datarehilo[ix];
                  outputrelolo[k][i] = datarelolo[ix];
                  outputimhihi[k][i] = dataimhihi[ix];
                  outputimlohi[k][i] = dataimlohi[ix];
                  outputimhilo[k][i] = dataimhilo[ix];
                  outputimlolo[k][i] = dataimlolo[ix++];
               }
            }
            else if(idx[ix0][nvr[ix0]-1] == k) // k is last variable
            {
               int ix2 = nvr[ix0]-2;
   
               if(verbose)
                  cout << "Updating derivative " << k 
                       << " at " << ix << " in data." << endl;

               ix = fstart[ix0] + ix2*deg1;

               for(int i=0; i<=deg; i++) // output[k][i] = data[ix++];
               {
                  outputrehihi[k][i] = datarehihi[ix];
                  outputrelohi[k][i] = datarelohi[ix];
                  outputrehilo[k][i] = datarehilo[ix];
                  outputrelolo[k][i] = datarelolo[ix];
                  outputimhihi[k][i] = dataimhihi[ix];
                  outputimlohi[k][i] = dataimlohi[ix];
                  outputimhilo[k][i] = dataimhilo[ix];
                  outputimlolo[k][i] = dataimlolo[ix++];
               }
            }
            else // derivative is in some cross product
            {
               int ix2 = jobs.position(nvr[ix0],idx[ix0],k) - 1;
   
               if(verbose)
                  cout << "Updating derivative " << k 
                       << " at " << ix << " in data." << endl;

               ix = cstart[ix0] + ix2*deg1;

               for(int i=0; i<=deg; i++) // output[k][i] = data[ix++];
               {
                  outputrehihi[k][i] = datarehihi[ix];
                  outputrelohi[k][i] = datarelohi[ix];
                  outputrehilo[k][i] = datarehilo[ix];
                  outputrelolo[k][i] = datarelolo[ix];
                  outputimhihi[k][i] = dataimhihi[ix];
                  outputimlohi[k][i] = dataimlohi[ix];
                  outputimhilo[k][i] = dataimhilo[ix];
                  outputimlolo[k][i] = dataimlolo[ix++];
               }
            }
         }
      }
   }
}

void dbl4_data_setup
 ( int dim, int nbr, int deg,
   double *datahihi, double *datalohi, double *datahilo, double *datalolo,
   double *csthihi, double *cstlohi, double *csthilo, double *cstlolo,
   double **cffhihi, double **cfflohi, double **cffhilo, double **cfflolo,
   double **inputhihi, double **inputlohi,
   double **inputhilo, double **inputlolo )
{
   const int deg1 = deg+1;
   int ix = 0;

   for(int i=0; i<deg1; i++)
   {
      datahihi[ix]   = csthihi[i];
      datalohi[ix]   = cstlohi[i];
      datahilo[ix]   = csthilo[i];
      datalolo[ix++] = cstlolo[i];
   }
   for(int i=0; i<nbr; i++)
      for(int j=0; j<deg1; j++)
      {
         datahihi[ix]   = cffhihi[i][j];
         datalohi[ix]   = cfflohi[i][j];
         datahilo[ix]   = cffhilo[i][j];
         datalolo[ix++] = cfflolo[i][j];
      }
   for(int i=0; i<dim; i++)
      for(int j=0; j<deg1; j++)
      {
         datahihi[ix]   = inputhihi[i][j];
         datalohi[ix]   = inputlohi[i][j];
         datahilo[ix]   = inputhilo[i][j];
         datalolo[ix++] = inputlolo[i][j];
      }
}

void cmplx4_data_setup
 ( int dim, int nbr, int deg,
   double *datarehihi, double *datarelohi,
   double *datarehilo, double *datarelolo,
   double *dataimhihi, double *dataimlohi,
   double *dataimhilo, double *dataimlolo,
   double *cstrehihi, double *cstrelohi,
   double *cstrehilo, double *cstrelolo,
   double *cstimhihi, double *cstimlohi,
   double *cstimhilo, double *cstimlolo,
   double **cffrehihi, double **cffrelohi,
   double **cffrehilo, double **cffrelolo,
   double **cffimhihi, double **cffimlohi,
   double **cffimhilo, double **cffimlolo,
   double **inputrehihi, double **inputrelohi,
   double **inputrehilo, double **inputrelolo,
   double **inputimhihi, double **inputimlohi,
   double **inputimhilo, double **inputimlolo )
{
   const int deg1 = deg+1;
   int ix = 0;

   for(int i=0; i<deg1; i++)
   {
      datarehihi[ix]   = cstrehihi[i];
      datarelohi[ix]   = cstrelohi[i];
      datarehilo[ix]   = cstrehilo[i];
      datarelolo[ix]   = cstrelolo[i];
      dataimhihi[ix]   = cstimhihi[i];
      dataimlohi[ix]   = cstimlohi[i];
      dataimhilo[ix]   = cstimhilo[i];
      dataimlolo[ix++] = cstimlolo[i];
   }
   for(int i=0; i<nbr; i++)
      for(int j=0; j<deg1; j++)
      {
         datarehihi[ix]   = cffrehihi[i][j];
         datarelohi[ix]   = cffrelohi[i][j];
         datarehilo[ix]   = cffrehilo[i][j];
         datarelolo[ix]   = cffrelolo[i][j];
         dataimhihi[ix]   = cffimhihi[i][j];
         dataimlohi[ix]   = cffimlohi[i][j];
         dataimhilo[ix]   = cffimhilo[i][j];
         dataimlolo[ix++] = cffimlolo[i][j];
      }
   for(int i=0; i<dim; i++)
      for(int j=0; j<deg1; j++)
      {
         datarehihi[ix]   = inputrehihi[i][j];
         datarelohi[ix]   = inputrelohi[i][j];
         datarehilo[ix]   = inputrehilo[i][j];
         datarelolo[ix]   = inputrelolo[i][j];
         dataimhihi[ix]   = inputimhihi[i][j];
         dataimlohi[ix]   = inputimlohi[i][j];
         dataimhilo[ix]   = inputimhilo[i][j];
         dataimlolo[ix++] = inputimlolo[i][j];
      }
}

void dbl4_convolution_jobs
 ( int dim, int nbr, int deg, int *nvr, ConvolutionJobs cnvjobs,
   int *fstart, int *bstart, int *cstart,
   double *datahihi, double *datalohi, double *datahilo, double *datalolo,
   double *cnvlapms, bool verbose )
{
   const int deg1 = deg+1;

   cudaEvent_t start,stop;           // to measure time spent by kernels
   cudaEventCreate(&start);
   cudaEventCreate(&stop);
   *cnvlapms = 0.0;
   float milliseconds;

   for(int k=0; k<cnvjobs.get_depth(); k++)
   {
      const int jobnbr = cnvjobs.get_layer_count(k);
      int *in1ix_h = new int[jobnbr];
      int *in2ix_h = new int[jobnbr];
      int *outix_h = new int[jobnbr];

      if(verbose) cout << "preparing convolution jobs at layer "
                       << k << " ..." << endl;

      convjobs_coordinates(cnvjobs,k,in1ix_h,in2ix_h,outix_h,dim,nbr,deg,nvr,
                           fstart,bstart,cstart,verbose);
      // if(deg1 == BS)
      {
         int *in1ix_d; // first input on device
         int *in2ix_d; // second input on device
         int *outix_d; // output indices on device
         const size_t szjobidx = jobnbr*sizeof(int);
         cudaMalloc((void**)&in1ix_d,szjobidx);
         cudaMalloc((void**)&in2ix_d,szjobidx);
         cudaMalloc((void**)&outix_d,szjobidx);
         cudaMemcpy(in1ix_d,in1ix_h,szjobidx,cudaMemcpyHostToDevice);
         cudaMemcpy(in2ix_d,in2ix_h,szjobidx,cudaMemcpyHostToDevice);
         cudaMemcpy(outix_d,outix_h,szjobidx,cudaMemcpyHostToDevice);

         if(verbose)
            cout << "launching " << jobnbr << " blocks of " << deg1
                 << " threads ..." << endl;

         cudaEventRecord(start);
         dbl4_padded_convjobs<<<jobnbr,deg1>>>
            (datahihi,datalohi,datahilo,datalolo,
             in1ix_d,in2ix_d,outix_d,deg1);
         cudaEventRecord(stop);
         cudaEventSynchronize(stop);
         cudaEventElapsedTime(&milliseconds,start,stop);
         *cnvlapms += milliseconds;
      }
      free(in1ix_h); free(in2ix_h); free(outix_h);
   }
}

void cmplx4_convolution_jobs
 ( int dim, int nbr, int deg, int *nvr, ConvolutionJobs cnvjobs,
   int *fstart, int *bstart, int *cstart,
   double *datarehihi, double *datarelohi,
   double *datarehilo, double *datarelolo,
   double *dataimhihi, double *dataimlohi,
   double *dataimhilo, double *dataimlolo,
   double *cnvlapms, bool verbose )
{
   const int deg1 = deg+1;

   cudaEvent_t start,stop;           // to measure time spent by kernels
   cudaEventCreate(&start);
   cudaEventCreate(&stop);
   *cnvlapms = 0.0;
   float milliseconds;

   for(int k=0; k<cnvjobs.get_depth(); k++)
   {
      const int jobnbr = cnvjobs.get_layer_count(k);
      int *in1ix_h = new int[jobnbr];
      int *in2ix_h = new int[jobnbr];
      int *outix_h = new int[jobnbr];

      if(verbose) cout << "preparing convolution jobs at layer "
                       << k << " ..." << endl;

      convjobs_coordinates(cnvjobs,k,in1ix_h,in2ix_h,outix_h,dim,nbr,deg,nvr,
                           fstart,bstart,cstart,verbose);
      // if(deg1 == BS)
      {
         int *in1ix_d; // first input on device
         int *in2ix_d; // second input on device
         int *outix_d; // output indices on device
         const size_t szjobidx = jobnbr*sizeof(int);
         cudaMalloc((void**)&in1ix_d,szjobidx);
         cudaMalloc((void**)&in2ix_d,szjobidx);
         cudaMalloc((void**)&outix_d,szjobidx);
         cudaMemcpy(in1ix_d,in1ix_h,szjobidx,cudaMemcpyHostToDevice);
         cudaMemcpy(in2ix_d,in2ix_h,szjobidx,cudaMemcpyHostToDevice);
         cudaMemcpy(outix_d,outix_h,szjobidx,cudaMemcpyHostToDevice);

         if(verbose)
            cout << "launching " << jobnbr << " blocks of " << deg1
                 << " threads ..." << endl;

         cudaEventRecord(start);
         cmplx4_padded_convjobs<<<jobnbr,deg1>>>
            (datarehihi,datarelohi,datarehilo,datarelolo,
             dataimhihi,dataimlohi,dataimhilo,dataimlolo,
             in1ix_d,in2ix_d,outix_d,deg1);
         cudaEventRecord(stop);
         cudaEventSynchronize(stop);
         cudaEventElapsedTime(&milliseconds,start,stop);
         *cnvlapms += milliseconds;
      }
      free(in1ix_h); free(in2ix_h); free(outix_h);
   }
}

void dbl4_addition_jobs
 ( int dim, int nbr, int deg, int *nvr, AdditionJobs addjobs,
   int *fstart, int *bstart, int *cstart,
   double *datahihi, double *datalohi, double *datahilo, double *datalolo,
   double *addlapms, bool verbose )
{
   const int deg1 = deg+1;

   cudaEvent_t start,stop;           // to measure time spent by kernels
   cudaEventCreate(&start);
   cudaEventCreate(&stop);
   *addlapms = 0.0;
   float milliseconds;

   for(int k=0; k<addjobs.get_depth(); k++)
   {
      const int jobnbr = addjobs.get_layer_count(k);
      int *in1ix_h = new int[jobnbr];
      int *in2ix_h = new int[jobnbr];
      int *outix_h = new int[jobnbr];

      if(verbose) cout << "preparing addition jobs at layer "
                       << k << " ..." << endl;

      addjobs_coordinates(addjobs,k,in1ix_h,in2ix_h,outix_h,dim,nbr,deg,nvr,
                          fstart,bstart,cstart,verbose);
      // if(deg1 == BS)
      {
         int *in1ix_d; // first input on device
         int *in2ix_d; // second input on device
         int *outix_d; // output indices on device
         const size_t szjobidx = jobnbr*sizeof(int);
         cudaMalloc((void**)&in1ix_d,szjobidx);
         cudaMalloc((void**)&in2ix_d,szjobidx);
         cudaMalloc((void**)&outix_d,szjobidx);
         cudaMemcpy(in1ix_d,in1ix_h,szjobidx,cudaMemcpyHostToDevice);
         cudaMemcpy(in2ix_d,in2ix_h,szjobidx,cudaMemcpyHostToDevice);
         cudaMemcpy(outix_d,outix_h,szjobidx,cudaMemcpyHostToDevice);

         if(verbose)
            cout << "launching " << jobnbr << " blocks of " << deg1
                 << " threads ..." << endl;

         cudaEventRecord(start);
         dbl4_update_addjobs<<<jobnbr,deg1>>>
            (datahihi,datalohi,datahilo,datalolo,
             in1ix_d,in2ix_d,outix_d,deg1);
         cudaEventRecord(stop);
         cudaEventSynchronize(stop);
         cudaEventElapsedTime(&milliseconds,start,stop);
         *addlapms += milliseconds;
      }
      free(in1ix_h); free(in2ix_h); free(outix_h);
   }
}

void cmplx4_addition_jobs
 ( int dim, int nbr, int deg, int *nvr, AdditionJobs addjobs,
   int *fstart, int *bstart, int *cstart,
   double *datarehihi, double *datarelohi,
   double *datarehilo, double *datarelolo,
   double *dataimhihi, double *dataimlohi,
   double *dataimhilo, double *dataimlolo,
   double *addlapms, bool verbose )
{
   const int deg1 = deg+1;

   cudaEvent_t start,stop;           // to measure time spent by kernels
   cudaEventCreate(&start);
   cudaEventCreate(&stop);
   *addlapms = 0.0;
   float milliseconds;

   for(int k=0; k<addjobs.get_depth(); k++)
   {
      const int jobnbr = addjobs.get_layer_count(k);
      int *in1ix_h = new int[jobnbr];
      int *in2ix_h = new int[jobnbr];
      int *outix_h = new int[jobnbr];

      if(verbose) cout << "preparing addition jobs at layer "
                       << k << " ..." << endl;

      addjobs_coordinates(addjobs,k,in1ix_h,in2ix_h,outix_h,dim,nbr,deg,nvr,
                          fstart,bstart,cstart,verbose);
      // if(deg1 == BS)
      {
         int *in1ix_d; // first input on device
         int *in2ix_d; // second input on device
         int *outix_d; // output indices on device
         const size_t szjobidx = jobnbr*sizeof(int);
         cudaMalloc((void**)&in1ix_d,szjobidx);
         cudaMalloc((void**)&in2ix_d,szjobidx);
         cudaMalloc((void**)&outix_d,szjobidx);
         cudaMemcpy(in1ix_d,in1ix_h,szjobidx,cudaMemcpyHostToDevice);
         cudaMemcpy(in2ix_d,in2ix_h,szjobidx,cudaMemcpyHostToDevice);
         cudaMemcpy(outix_d,outix_h,szjobidx,cudaMemcpyHostToDevice);

         if(verbose)
            cout << "launching " << jobnbr << " blocks of " << deg1
                 << " threads ..." << endl;

         cudaEventRecord(start);
         cmplx4_update_addjobs<<<jobnbr,deg1>>>
            (datarehihi,datarelohi,datarehilo,datarelolo,
             dataimhihi,dataimlohi,dataimhilo,dataimlolo,
             in1ix_d,in2ix_d,outix_d,deg1);
         cudaEventRecord(stop);
         cudaEventSynchronize(stop);
         cudaEventElapsedTime(&milliseconds,start,stop);
         *addlapms += milliseconds;
      }
      free(in1ix_h); free(in2ix_h); free(outix_h);
   }
}

void GPU_dbl4_poly_evaldiff
 ( int BS, int dim, int nbr, int deg, int *nvr, int **idx,
   double *csthihi, double *cstlohi, double *csthilo, double *cstlolo,
   double **cffhihi, double **cfflohi, double **cffhilo, double **cfflolo,
   double **inputhihi, double **inputlohi,
   double **inputhilo, double **inputlolo,
   double **outputhihi, double **outputlohi,
   double **outputhilo, double **outputlolo,
   ConvolutionJobs cnvjobs, AdditionJobs addjobs,
   double *cnvlapms, double *addlapms, double *elapsedms,
   double *walltimesec, bool verbose )
{
   const int totalcff = coefficient_count(dim,nbr,deg,nvr);

   int *fstart = new int[nbr];
   int *bstart = new int[nbr];
   int *cstart = new int[nbr];
   int *fsums = new int[nbr];
   int *bsums = new int[nbr];
   int *csums = new int[nbr];

   coefficient_indices
      (dim,nbr,deg,nvr,fsums,bsums,csums,fstart,bstart,cstart);
   if(verbose)
      write_coefficient_indices
         (totalcff,nbr,fsums,fstart,bsums,bstart,csums,cstart);

   double *datahihi_h = new double[totalcff];        // data on host
   double *datalohi_h = new double[totalcff];
   double *datahilo_h = new double[totalcff];
   double *datalolo_h = new double[totalcff];

   dbl4_data_setup
      (dim,nbr,deg,datahihi_h,datalohi_h,datahilo_h,datalolo_h,
       csthihi,cstlohi,csthilo,cstlolo,cffhihi,cfflohi,cffhilo,cfflolo,
       inputhihi,inputlohi,inputhilo,inputlolo);

   double *datahihi_d;                               // device data
   double *datalohi_d;
   double *datahilo_d;
   double *datalolo_d;
   const size_t szdata = totalcff*sizeof(double);
   cudaMalloc((void**)&datahihi_d,szdata);
   cudaMalloc((void**)&datalohi_d,szdata);
   cudaMalloc((void**)&datahilo_d,szdata);
   cudaMalloc((void**)&datalolo_d,szdata);
   cudaMemcpy(datahihi_d,datahihi_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(datalohi_d,datalohi_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(datahilo_d,datahilo_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(datalolo_d,datalolo_h,szdata,cudaMemcpyHostToDevice);

   struct timeval begintime,endtime; // wall clock time of computations
   gettimeofday(&begintime,0);

   dbl4_convolution_jobs
      (dim,nbr,deg,nvr,cnvjobs,fstart,bstart,cstart,
       datahihi_d,datalohi_d,datahilo_d,datalolo_d,cnvlapms,verbose);

   dbl4_addition_jobs
      (dim,nbr,deg,nvr,addjobs,fstart,bstart,cstart,
       datahihi_d,datalohi_d,datahilo_d,datalolo_d,addlapms,verbose);

   gettimeofday(&endtime,0);
   cudaMemcpy(datahihi_h,datahihi_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(datalohi_h,datalohi_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(datahilo_h,datahilo_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(datalolo_h,datalolo_d,szdata,cudaMemcpyDeviceToHost);
   *elapsedms = *cnvlapms + *addlapms;
   long seconds = endtime.tv_sec - begintime.tv_sec;
   long microseconds = endtime.tv_usec - begintime.tv_usec;
   *walltimesec = seconds + microseconds*1.0e-6;

   // dbl_convoluted_data2_to_output
   //   (datahihi_h,datalohi_h,datahilo_h,datalolo_h,
   //    outputhihi,outputlohi,outputhilo,outputlolo,
   //    dim,nbr,deg,nvr,idx,fstart,bstart,cstart,verbose);
   dbl_added_data4_to_output
      (datahihi_h,datalohi_h,datahilo_h,datalolo_h,
       outputhihi,outputlohi,outputhilo,outputlolo,
       dim,nbr,deg,nvr,idx,fstart,bstart,cstart,addjobs,verbose);
   if(verbose)
   {
      cout << fixed << setprecision(2);
      cout << "Time spent by convolution kernels : ";
      cout << *cnvlapms << " milliseconds." << endl;
      cout << "Time spent by addition kernels    : ";
      cout << *addlapms << " milliseconds." << endl;
      cout << "Time spent by all kernels         : ";
      cout << *elapsedms << " milliseconds." << endl;
      cout << "Total wall clock computation time : ";
      cout << fixed << setprecision(3) << *walltimesec
           << " seconds." << endl;
      cout << scientific << setprecision(16);
   }
}

void GPU_cmplx4_poly_evaldiff
 ( int BS, int dim, int nbr, int deg, int *nvr, int **idx,
   double *cstrehihi, double *cstrelohi,
   double *cstrehilo, double *cstrelolo,
   double *cstimhihi, double *cstimlohi,
   double *cstimhilo, double *cstimlolo,
   double **cffrehihi, double **cffrelohi,
   double **cffrehilo, double **cffrelolo,
   double **cffimhihi, double **cffimlohi,
   double **cffimhilo, double **cffimlolo,
   double **inputrehihi, double **inputrelohi,
   double **inputrehilo, double **inputrelolo,
   double **inputimhihi, double **inputimlohi,
   double **inputimhilo, double **inputimlolo,
   double **outputrehihi, double **outputrelohi,
   double **outputrehilo, double **outputrelolo,
   double **outputimhihi, double **outputimlohi,
   double **outputimhilo, double **outputimlolo,
   ConvolutionJobs cnvjobs, AdditionJobs addjobs,
   double *cnvlapms, double *addlapms, double *elapsedms,
   double *walltimesec, bool verbose )
{
   const int totalcff = coefficient_count(dim,nbr,deg,nvr);

   int *fstart = new int[nbr];
   int *bstart = new int[nbr];
   int *cstart = new int[nbr];
   int *fsums = new int[nbr];
   int *bsums = new int[nbr];
   int *csums = new int[nbr];

   coefficient_indices
      (dim,nbr,deg,nvr,fsums,bsums,csums,fstart,bstart,cstart);
   if(verbose)
      write_coefficient_indices
         (totalcff,nbr,fsums,fstart,bsums,bstart,csums,cstart);

   double *datarehihi_h = new double[totalcff];      // data on host
   double *datarelohi_h = new double[totalcff];
   double *datarehilo_h = new double[totalcff];
   double *datarelolo_h = new double[totalcff];
   double *dataimhihi_h = new double[totalcff]; 
   double *dataimlohi_h = new double[totalcff]; 
   double *dataimhilo_h = new double[totalcff];
   double *dataimlolo_h = new double[totalcff];

   cmplx4_data_setup
      (dim,nbr,deg,
       datarehihi_h,datarelohi_h,datarehilo_h,datarelolo_h,
       dataimhihi_h,dataimlohi_h,dataimhilo_h,dataimlolo_h,
       cstrehihi,cstrelohi,cstrehilo,cstrelolo,
       cstimhihi,cstimlohi,cstimhilo,cstimlolo,
       cffrehihi,cffrelohi,cffrehilo,cffrelolo,
       cffimhihi,cffimlohi,cffimhilo,cffimlolo,
       inputrehihi,inputrelohi,inputrehilo,inputrelolo,
       inputimhihi,inputimlohi,inputimhilo,inputimlolo);

   double *datarehihi_d;                               // device data
   double *datarelohi_d;
   double *datarehilo_d;
   double *datarelolo_d;
   double *dataimhihi_d;
   double *dataimlohi_d;
   double *dataimhilo_d;
   double *dataimlolo_d;
   const size_t szdata = totalcff*sizeof(double);
   cudaMalloc((void**)&datarehihi_d,szdata);
   cudaMalloc((void**)&datarelohi_d,szdata);
   cudaMalloc((void**)&datarehilo_d,szdata);
   cudaMalloc((void**)&datarelolo_d,szdata);
   cudaMalloc((void**)&dataimhihi_d,szdata);
   cudaMalloc((void**)&dataimlohi_d,szdata);
   cudaMalloc((void**)&dataimhilo_d,szdata);
   cudaMalloc((void**)&dataimlolo_d,szdata);
   cudaMemcpy(datarehihi_d,datarehihi_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(datarelohi_d,datarelohi_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(datarehilo_d,datarehilo_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(datarelolo_d,datarelolo_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(dataimhihi_d,dataimhihi_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(dataimlohi_d,dataimlohi_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(dataimhilo_d,dataimhilo_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(dataimlolo_d,dataimlolo_h,szdata,cudaMemcpyHostToDevice);

   struct timeval begintime,endtime; // wall clock time of computations

   gettimeofday(&begintime,0);

   cmplx4_convolution_jobs
      (dim,nbr,deg,nvr,cnvjobs,fstart,bstart,cstart,
       datarehihi_d,datarelohi_d,datarehilo_d,datarelolo_d,
       dataimhihi_d,dataimlohi_d,dataimhilo_d,dataimlolo_d,
       cnvlapms,verbose);

   cmplx4_addition_jobs
      (dim,nbr,deg,nvr,addjobs,fstart,bstart,cstart,
       datarehihi_d,datarelohi_d,datarehilo_d,datarelolo_d,
       dataimhihi_d,dataimlohi_d,dataimhilo_d,dataimlolo_d,
       addlapms,verbose);

   gettimeofday(&endtime,0);
   cudaMemcpy(datarehihi_h,datarehihi_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(datarelohi_h,datarelohi_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(datarehilo_h,datarehilo_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(datarelolo_h,datarelolo_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(dataimhihi_h,dataimhihi_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(dataimlohi_h,dataimlohi_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(dataimhilo_h,dataimhilo_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(dataimlolo_h,dataimlolo_d,szdata,cudaMemcpyDeviceToHost);
   *elapsedms = *cnvlapms + *addlapms;
   long seconds = endtime.tv_sec - begintime.tv_sec;
   long microseconds = endtime.tv_usec - begintime.tv_usec;
   *walltimesec = seconds + microseconds*1.0e-6;

   // cmplx_convoluted_data4_to_output
   //    (datarehihi_h,datarelohi_h,datarehilo_h,datarelolo_h,
   //     dataimhihi_h,dataimlohi_h,dataimhilo_h,dataimlolo_h,
   //     outputrehihi,outputrelohi,outputrehilo,outputrelolo,
   //     outputimhihi,outputimlohi,outputimhilo,outputimlolo,
   //     dim,nbr,deg,nvr,idx,fstart,bstart,cstart,verbose);
   cmplx_added_data4_to_output
      (datarehihi_h,datarelohi_h,datarehilo_h,datarelolo_h,
       dataimhihi_h,dataimlohi_h,dataimhilo_h,dataimlolo_h,
       outputrehihi,outputrelohi,outputrehilo,outputrelolo,
       outputimhihi,outputimlohi,outputimhilo,outputimlolo,
       dim,nbr,deg,nvr,idx,fstart,bstart,cstart,addjobs,verbose);

   if(verbose) write_GPU_timings(*cnvlapms,*addlapms,*elapsedms,*walltimesec);
}
