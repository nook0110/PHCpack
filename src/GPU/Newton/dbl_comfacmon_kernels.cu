// The file dbl_comfacmon_kernels.cu defines the functions with prototypes in
// the file dbl_comfacmon_kernels.h.

#include <iostream>
#include <iomanip>
// #ifdef winwalltime
// #include "wingettimeofday.h"
// #else
#ifndef winwalltime
#include <sys/time.h>
#endif
#include "write_gpu_timings.h"
#include "job_coordinates.h"
#include "dbl_convolutions_host.h"
#include "dbl_monomials_host.h"
#include "dbl_polynomials_kernels.h"

using namespace std;

// The code for GPU_dbl_mon_evaldiff is an adaptation of the
// function GPU_dbl_poly_evaldiff of dbl_polynomials_kernels.cu.

void GPU_dbl_mon_evaldiff
 ( int szt, int dim, int nbr, int deg, int *nvr, int **idx,
   double **cff, double **input, double **output,
   ConvolutionJobs cnvjobs,
   double *cnvlapms, double *addlapms, double *elapsedms,
   double *walltimesec, bool verbose )
{
   const int deg1 = deg+1;
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

   double *data_h = new double[totalcff];        // data on host
   int ix = 0;
   for(int i=0; i<deg1; i++) data_h[ix++] = 0.0; // cst[i]; no constant
   for(int i=0; i<nbr; i++)
      for(int j=0; j<deg1; j++) data_h[ix++] = cff[i][j];
   for(int i=0; i<dim; i++)
      for(int j=0; j<deg1; j++) data_h[ix++] = input[i][j];

   double *data_d;                               // device data
   const size_t szdata = totalcff*sizeof(double);
   cudaMalloc((void**)&data_d,szdata);
   cudaMemcpy(data_d,data_h,szdata,cudaMemcpyHostToDevice);

   cudaEvent_t start,stop;           // to measure time spent by kernels 
   cudaEventCreate(&start);
   cudaEventCreate(&stop);
   *cnvlapms = 0.0;
   float milliseconds;
   // struct timeval begintime,endtime; // wall clock time of computations

   // gettimeofday(&begintime,0);
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
      if(deg1 == szt)
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
            cout << "launching " << jobnbr << " blocks of " << szt
                 << " threads ..." << endl;
         
         cudaEventRecord(start);
         dbl_padded_convjobs<<<jobnbr,szt>>>
            (data_d,in1ix_d,in2ix_d,outix_d,deg1);
         cudaEventRecord(stop);
         cudaEventSynchronize(stop);
         cudaEventElapsedTime(&milliseconds,start,stop);
         *cnvlapms += milliseconds;
      }
      free(in1ix_h); free(in2ix_h); free(outix_h);
   }
   // gettimeofday(&endtime,0);
   cudaMemcpy(data_h,data_d,szdata,cudaMemcpyDeviceToHost);
   *elapsedms = *cnvlapms;
   // long seconds = endtime.tv_sec - begintime.tv_sec;
   // long microseconds = endtime.tv_usec - begintime.tv_usec;
   // *walltimesec = seconds + microseconds*1.0e-6;

   dbl_convoluted_data_to_output
      (data_h,output,dim,nbr,deg,nvr,idx,fstart,bstart,cstart,verbose);

   // if(verbose)
   //    write_GPU_timings(*cnvlapms,*addlapms,*elapsedms,*walltimesec);
}

void GPU_dbl_evaluate_monomials
 ( int dim, int deg, int szt, int nbt,
   int *nvr, int **idx, int **exp, int *nbrfac,
   int **expfac, double **cff, double *acc, double **input,
   double ***output, int vrblvl )
{
   for(int i=0; i<dim; i++) // common factors in the coefficients
   {
      if(nbrfac[i] > 0) // there are common factors in monomial i
      {
         for(int j=0; j<nvr[i]; j++) // run over all exponents
         {
            if(expfac[i][j] > 0) // the j-th exponent with variable idx[i][j]
            {
               int idxvar = idx[i][j];

               for(int k=0; k<expfac[i][j]; k++)
               {
                  CPU_dbl_product(deg,input[idxvar],cff[i],acc);
                  for(int L=0; L<=deg; L++) cff[i][L] = acc[L];
               }
            }
         }
      }
   }
   if(vrblvl > 0)
   {
      for(int i=0; i<dim; i++)
      {
         cout << "coefficients for monomial " << i << " :" << endl;
         for(int j=0; j<=deg; j++) cout << cff[i][j] << endl;
      }
      cout << "dim : " << dim << "  nvr :";
      for(int i=0; i<dim; i++) cout << " " << nvr[i];
      cout << endl;
      cout << "deg : " << deg;
      for(int i=0; i<dim; i++) 
      {
         cout << "  idx[" << i << "] :";
         for(int j=0; j<nvr[i]; j++) cout << " " << idx[i][j];
      }
      cout << endl;
      for(int i=0; i<dim; i++)
      {
         cout << "input series for variable " << i << " :" << endl;
         for(int j=0; j<=deg; j++) cout << input[i][j] << endl;
      }
   }
   for(int i=0; i<dim; i++)
      CPU_dbl_evaldiff(dim,nvr[i],deg,idx[i],cff[i],input,output[i]);

   if(vrblvl > 0)
   {
      for(int i=0; i<dim; i++)
      {
         cout << "output series for monomial " << i << " :" << endl;
         for(int j=0; j<=deg; j++) cout << output[i][dim][j] << endl;
      }
   }

   for(int i=0; i<dim; i++) // multiply derivatives with the powers
   {
      if(nbrfac[i] > 0) // there are common factors in monomial i
      {
         for(int j=0; j<nvr[i]; j++) // run over all exponents
         {
            if(expfac[i][j] > 0) // the j-th exponent with variable idx[i][j]
            {
               int idxvar = idx[i][j];
               double factor = (double) exp[i][j];

               // multiply derivative w.r.t. idxvar with factor
               for(int k=0; k<=deg; k++)
                  output[i][idxvar][k] = factor*output[i][idxvar][k];
            }
         }
      }
   }
}
