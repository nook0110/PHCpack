// The file dbl4_systems_kernels.cu defines the functions with prototypes in
// the file dbl4_systems_kernels.h.

#include <iostream>
#include <iomanip>
#ifdef winwalltime
#include "gettimeofday4win.h"
#else
#include <sys/time.h>
#endif
#include "write_gpu_timings.h"
#include "job_coordinates.h"
#include "quad_double_functions.h"
#include "dbl4_convolutions_host.h"
#include "dbl4_monomials_host.h"
#include "dbl4_polynomials_kernels.h"

using namespace std;

// The code in dbl4_evaldiffdata_to_output is an adaptation of the
// function dbl4_convoluted_data_to_output in dbl2_polynomials_kernels.cu.

void dbl4_evaldiffdata_to_output
 ( double *datahihi, double *datalohi, double *datahilo, double *datalolo,
   double ***outputhihi, double ***outputlohi,
   double ***outputhilo, double ***outputlolo,
   int dim, int nbr, int deg, int *nvr,
   int **idx, int *fstart, int *bstart, int *cstart, int vrblvl )
{
   const int deg1 = deg+1;
   int ix0,ix1,ix2;

   for(int k=0; k<nbr; k++)
   {
      ix1 = fstart[k] + (nvr[k]-1)*deg1;
      
      if(vrblvl > 1)
         cout << "monomial " << k << " update starts at " << ix1 << endl;

      for(int i=0; i<=deg; i++)
      {
         outputhihi[k][dim][i] = datahihi[ix1];
         outputlohi[k][dim][i] = datalohi[ix1];
         outputhilo[k][dim][i] = datahilo[ix1];
         outputlolo[k][dim][i] = datalolo[ix1++];
      }
      ix0 = idx[k][0];
      if(nvr[k] == 1)
      {
         ix1 = (1 + k)*deg1;
            
         for(int i=0; i<=deg; i++)
         {
            outputhihi[k][ix0][i] = datahihi[ix1];
            outputlohi[k][ix0][i] = datalohi[ix1];
            outputhilo[k][ix0][i] = datahilo[ix1];
            outputlolo[k][ix0][i] = datalolo[ix1++];
         }
      }
      else if(nvr[k] > 1)
      {                               // first and last derivative
         ix2 = nvr[k]-3;
         if(ix2 < 0) ix2 = 0;
         ix1 = bstart[k] + ix2*deg1;

         for(int i=0; i<=deg; i++)
         {
            outputhihi[k][ix0][i] = datahihi[ix1];
            outputlohi[k][ix0][i] = datalohi[ix1];
            outputhilo[k][ix0][i] = datahilo[ix1];
            outputlolo[k][ix0][i] = datalolo[ix1++];
         }
         ix2 = nvr[k]-2;
         ix1 = fstart[k] + ix2*deg1;
         ix0 = idx[k][ix2+1];

         for(int i=0; i<=deg; i++)
         {
            outputhihi[k][ix0][i] = datahihi[ix1];
            outputlohi[k][ix0][i] = datalohi[ix1];
            outputhilo[k][ix0][i] = datahilo[ix1];
            outputlolo[k][ix0][i] = datalolo[ix1++];
         }
         if(nvr[k] > 2)                   // all other derivatives
         {
            for(int j=1; j<nvr[k]-1; j++)
            {
               ix0 = idx[k][j];            // j-th variable in monomial k
               ix1 = cstart[k] + (j-1)*deg1;

               if(vrblvl > 1)
                  cout << "monomial " << k << " derivative " << ix0
                       << " update starts at " << ix1 << endl;

               for(int i=0; i<=deg; i++)
               {
                  outputhihi[k][ix0][i] = datahihi[ix1];
                  outputlohi[k][ix0][i] = datalohi[ix1];
                  outputhilo[k][ix0][i] = datahilo[ix1];
                  outputlolo[k][ix0][i] = datalolo[ix1++];
               }
            }
         }
      }
   }
}

void cmplx4_evaldiffdata_to_output
 ( double *datarehihi, double *datarelohi,
   double *datarehilo, double *datarelolo,
   double *dataimhihi, double *dataimlohi,
   double *dataimhilo, double *dataimlolo,
   double ***outputrehihi, double ***outputrelohi,
   double ***outputrehilo, double ***outputrelolo,
   double ***outputimhihi, double ***outputimlohi,
   double ***outputimhilo, double ***outputimlolo,
   int dim, int nbr, int deg, int *nvr,
   int **idx, int *fstart, int *bstart, int *cstart, int vrblvl )
{
   const int deg1 = deg+1;
   int ix0,ix1,ix2;

   for(int k=0; k<nbr; k++)
   {
      ix1 = fstart[k] + (nvr[k]-1)*deg1;
      
      if(vrblvl > 1)
         cout << "monomial " << k << " update starts at " << ix1 << endl;

      for(int i=0; i<=deg; i++)
      {
         outputrehihi[k][dim][i] = datarehihi[ix1];
         outputrelohi[k][dim][i] = datarelohi[ix1];
         outputrehilo[k][dim][i] = datarehilo[ix1];
         outputrelolo[k][dim][i] = datarelolo[ix1];
         outputimhihi[k][dim][i] = dataimhihi[ix1];
         outputimlohi[k][dim][i] = dataimlohi[ix1];
         outputimhilo[k][dim][i] = dataimhilo[ix1];
         outputimlolo[k][dim][i] = dataimlolo[ix1++];
      }
      ix0 = idx[k][0];
      if(nvr[k] == 1)
      {
         ix1 = (1 + k)*deg1;
            
         for(int i=0; i<=deg; i++)
         {
            outputrehihi[k][ix0][i] = datarehihi[ix1];
            outputrelohi[k][ix0][i] = datarelohi[ix1];
            outputrehilo[k][ix0][i] = datarehilo[ix1];
            outputrelolo[k][ix0][i] = datarelolo[ix1];
            outputimhihi[k][ix0][i] = dataimhihi[ix1];
            outputimlohi[k][ix0][i] = dataimlohi[ix1];
            outputimhilo[k][ix0][i] = dataimhilo[ix1];
            outputimlolo[k][ix0][i] = dataimlolo[ix1++];
         }
      }
      else if(nvr[k] > 1)
      {                               // first and last derivative
         ix2 = nvr[k]-3;
         if(ix2 < 0) ix2 = 0;
         ix1 = bstart[k] + ix2*deg1;

         for(int i=0; i<=deg; i++)
         {
            outputrehihi[k][ix0][i] = datarehihi[ix1];
            outputrelohi[k][ix0][i] = datarelohi[ix1];
            outputrehilo[k][ix0][i] = datarehilo[ix1];
            outputrelolo[k][ix0][i] = datarelolo[ix1];
            outputimhihi[k][ix0][i] = dataimhihi[ix1];
            outputimlohi[k][ix0][i] = dataimlohi[ix1];
            outputimhilo[k][ix0][i] = dataimhilo[ix1];
            outputimlolo[k][ix0][i] = dataimlolo[ix1++];
         }
         ix2 = nvr[k]-2;
         ix1 = fstart[k] + ix2*deg1;
         ix0 = idx[k][ix2+1];

         for(int i=0; i<=deg; i++)
         {
            outputrehihi[k][ix0][i] = datarehihi[ix1];
            outputrelohi[k][ix0][i] = datarelohi[ix1];
            outputrehilo[k][ix0][i] = datarehilo[ix1];
            outputrelolo[k][ix0][i] = datarelolo[ix1];
            outputimhihi[k][ix0][i] = dataimhihi[ix1];
            outputimlohi[k][ix0][i] = dataimlohi[ix1];
            outputimhilo[k][ix0][i] = dataimhilo[ix1];
            outputimlolo[k][ix0][i] = dataimlolo[ix1++];
         }
         if(nvr[k] > 2)                   // all other derivatives
         {
            for(int j=1; j<nvr[k]-1; j++)
            {
               ix0 = idx[k][j];            // j-th variable in monomial k
               ix1 = cstart[k] + (j-1)*deg1;

               if(vrblvl > 1)
                  cout << "monomial " << k << " derivative " << ix0
                       << " update starts at " << ix1 << endl;

               for(int i=0; i<=deg; i++)
               {
                  outputrehihi[k][ix0][i] = datarehihi[ix1];
                  outputrelohi[k][ix0][i] = datarelohi[ix1];
                  outputrehilo[k][ix0][i] = datarehilo[ix1];
                  outputrelolo[k][ix0][i] = datarelolo[ix1];
                  outputimhihi[k][ix0][i] = dataimhihi[ix1];
                  outputimlohi[k][ix0][i] = dataimlohi[ix1];
                  outputimhilo[k][ix0][i] = dataimhilo[ix1];
                  outputimlolo[k][ix0][i] = dataimlolo[ix1++];
               }
            }
         }
      }
   }
}

// The code for GPU_dbl4_mon_evaldiff is an adaptation of the
// function GPU_dbl4_poly_evaldiff of dbl_polynomials_kernels.cu.

void GPU_dbl4_mon_evaldiff
 ( int szt, int dim, int nbr, int deg, int *nvr, int **idx,
   double **cffhihi, double **cfflohi, double **cffhilo, double **cfflolo,
   double **inputhihi, double **inputlohi,
   double **inputhilo, double **inputlolo,
   double ***outputhihi, double ***outputlohi,
   double ***outputhilo, double ***outputlolo, ConvolutionJobs cnvjobs,
   double *cnvlapms, double *elapsedms, double *walltimesec, int vrblvl )
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

   if(vrblvl > 1)
      write_coefficient_indices
         (totalcff,nbr,fsums,fstart,bsums,bstart,csums,cstart);

   double *datahihi_h = new double[totalcff];        // data on host
   double *datalohi_h = new double[totalcff];
   double *datahilo_h = new double[totalcff];
   double *datalolo_h = new double[totalcff];

   int ix = 0;
   for(int i=0; i<deg1; i++)
   {
      datahihi_h[ix]   = 0.0; // cst[i]; no constant
      datalohi_h[ix  ] = 0.0; 
      datahilo_h[ix]   = 0.0; 
      datalolo_h[ix++] = 0.0;
   }
   for(int i=0; i<nbr; i++)
      for(int j=0; j<deg1; j++)
      {
         datahihi_h[ix]   = cffhihi[i][j];
         datalohi_h[ix]   = cfflohi[i][j];
         datahilo_h[ix]   = cffhilo[i][j];
         datalolo_h[ix++] = cfflolo[i][j];
      }

   for(int i=0; i<dim; i++)
      for(int j=0; j<deg1; j++)
      {
         datahihi_h[ix]   = inputhihi[i][j];
         datalohi_h[ix]   = inputlohi[i][j];
         datahilo_h[ix]   = inputhilo[i][j];
         datalolo_h[ix++] = inputlolo[i][j];
      }

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

   cudaEvent_t start,stop;           // to measure time spent by kernels 
   cudaEventCreate(&start);
   cudaEventCreate(&stop);
   *cnvlapms = 0.0;
   float milliseconds;
   struct timeval begintime,endtime; // wall clock time of computations
   bool verbose = (vrblvl > 1);

   gettimeofday(&begintime,0);
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
      // if(deg1 == szt)
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
            (datahihi_d,datalohi_d,datahilo_d,datalolo_d,
             in1ix_d,in2ix_d,outix_d,deg1);
         cudaEventRecord(stop);
         cudaEventSynchronize(stop);
         cudaEventElapsedTime(&milliseconds,start,stop);
         *cnvlapms += milliseconds;

         cudaFree(in1ix_d); cudaFree(in2ix_d); cudaFree(outix_d);
      }
      free(in1ix_h); free(in2ix_h); free(outix_h);
   }
   gettimeofday(&endtime,0);
   cudaMemcpy(datahihi_h,datahihi_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(datalohi_h,datalohi_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(datahilo_h,datahilo_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(datalolo_h,datalolo_d,szdata,cudaMemcpyDeviceToHost);
   *elapsedms = *cnvlapms;
   long seconds = endtime.tv_sec - begintime.tv_sec;
   long microseconds = endtime.tv_usec - begintime.tv_usec;
   *walltimesec = seconds + microseconds*1.0e-6;

   dbl4_evaldiffdata_to_output
      (datahihi_h,datalohi_h,datahilo_h,datalolo_h,
       outputhihi,outputlohi,outputhilo,outputlolo,
       dim,nbr,deg,nvr,idx,fstart,bstart,cstart,vrblvl);

   if(vrblvl > 0)
      write_GPU_timings(*cnvlapms,0.0,*elapsedms,*walltimesec);

   cudaFree(datahihi_d); cudaFree(datalohi_d);
   cudaFree(datahilo_d); cudaFree(datalolo_d);

   free(datahihi_h); free(datalohi_h);
   free(datahilo_h); free(datalolo_h);

   free(fstart); free(bstart); free(cstart);
   free(fsums); free(bsums); free(csums);
}

void GPU_cmplx4_mon_evaldiff
 ( int szt, int dim, int nbr, int deg, int *nvr, int **idx,
   double **cffrehihi, double **cffrelohi,
   double **cffrehilo, double **cffrelolo,
   double **cffimhihi, double **cffimlohi,
   double **cffimhilo, double **cffimlolo,
   double **inputrehihi, double **inputrelohi,
   double **inputrehilo, double **inputrelolo,
   double **inputimhihi, double **inputimlohi,
   double **inputimhilo, double **inputimlolo,
   double ***outputrehihi, double ***outputrelohi,
   double ***outputrehilo, double ***outputrelolo,
   double ***outputimhihi, double ***outputimlohi,
   double ***outputimhilo, double ***outputimlolo, ConvolutionJobs cnvjobs,
   double *cnvlapms, double *elapsedms, double *walltimesec, int vrblvl )
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

   if(vrblvl > 1)
      write_coefficient_indices
         (totalcff,nbr,fsums,fstart,bsums,bstart,csums,cstart);

   double *datarehihi_h = new double[totalcff];   // real data on host
   double *datarelohi_h = new double[totalcff];
   double *datarehilo_h = new double[totalcff];
   double *datarelolo_h = new double[totalcff];
   double *dataimhihi_h = new double[totalcff];   // imaginary data on host
   double *dataimlohi_h = new double[totalcff];
   double *dataimhilo_h = new double[totalcff];
   double *dataimlolo_h = new double[totalcff];

   int ix = 0;
   for(int i=0; i<deg1; i++)
   {
      datarehihi_h[ix]   = 0.0; // cst[i]; no constant
      datarelohi_h[ix]   = 0.0;
      datarehilo_h[ix]   = 0.0;
      datarelolo_h[ix]   = 0.0;
      dataimhihi_h[ix]   = 0.0;
      dataimlohi_h[ix]   = 0.0;
      dataimhilo_h[ix]   = 0.0;
      dataimlolo_h[ix++] = 0.0;
   }
   for(int i=0; i<nbr; i++)
      for(int j=0; j<deg1; j++)
      {
         datarehihi_h[ix]   = cffrehihi[i][j];
         datarelohi_h[ix]   = cffrelohi[i][j];
         datarehilo_h[ix]   = cffrehilo[i][j];
         datarelolo_h[ix]   = cffrelolo[i][j];
         dataimhihi_h[ix]   = cffimhihi[i][j];
         dataimlohi_h[ix]   = cffimlohi[i][j];
         dataimhilo_h[ix]   = cffimhilo[i][j];
         dataimlolo_h[ix++] = cffimlolo[i][j];
      }
   for(int i=0; i<dim; i++)
      for(int j=0; j<deg1; j++)
      {
         datarehihi_h[ix]   = inputrehihi[i][j];
         datarelohi_h[ix]   = inputrelohi[i][j];
         datarehilo_h[ix]   = inputrehilo[i][j];
         datarelolo_h[ix]   = inputrelolo[i][j];
         dataimhihi_h[ix]   = inputimhihi[i][j];
         dataimlohi_h[ix]   = inputimlohi[i][j];
         dataimhilo_h[ix]   = inputimhilo[i][j];
         dataimlolo_h[ix++] = inputimlolo[i][j];
      }

   double *datarehihi_d;                        // device real data
   double *datarelohi_d;
   double *datarehilo_d;
   double *datarelolo_d;
   double *dataimhihi_d;                        // device imag data
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

   cudaEvent_t start,stop;           // to measure time spent by kernels 
   cudaEventCreate(&start);
   cudaEventCreate(&stop);
   *cnvlapms = 0.0;
   float milliseconds;
   struct timeval begintime,endtime; // wall clock time of computations
   bool verbose = (vrblvl > 1);

   gettimeofday(&begintime,0);
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
      // if(deg1 == szt)
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
            (datarehihi_d,datarelohi_d,datarehilo_d,datarelolo_d,
             dataimhihi_d,dataimlohi_d,dataimhilo_d,dataimlolo_d,
             in1ix_d,in2ix_d,outix_d,deg1);
         cudaEventRecord(stop);
         cudaEventSynchronize(stop);
         cudaEventElapsedTime(&milliseconds,start,stop);
         *cnvlapms += milliseconds;

         cudaFree(in1ix_d); cudaFree(in2ix_d); cudaFree(outix_d);
      }
      free(in1ix_h); free(in2ix_h); free(outix_h);
   }
   gettimeofday(&endtime,0);
   cudaMemcpy(datarehihi_h,datarehihi_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(datarelohi_h,datarelohi_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(datarehilo_h,datarehilo_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(datarelolo_h,datarelolo_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(dataimhihi_h,dataimhihi_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(dataimlohi_h,dataimlohi_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(dataimhilo_h,dataimhilo_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(dataimlolo_h,dataimlolo_d,szdata,cudaMemcpyDeviceToHost);
   *elapsedms = *cnvlapms;
   long seconds = endtime.tv_sec - begintime.tv_sec;
   long microseconds = endtime.tv_usec - begintime.tv_usec;
   *walltimesec = seconds + microseconds*1.0e-6;

   cmplx4_evaldiffdata_to_output
      (datarehihi_h,datarelohi_h,datarehilo_h,datarelolo_h,
       dataimhihi_h,dataimlohi_h,dataimhilo_h,dataimlolo_h,
       outputrehihi,outputrelohi,outputrehilo,outputrelolo,
       outputimhihi,outputimlohi,outputimhilo,outputimlolo,
       dim,nbr,deg,nvr,idx,fstart,bstart,cstart,vrblvl);

   if(vrblvl > 0)
      write_GPU_timings(*cnvlapms,0.0,*elapsedms,*walltimesec);

   cudaFree(datarehihi_d); cudaFree(datarelohi_d);
   cudaFree(datarehilo_d); cudaFree(datarelolo_d);
   cudaFree(dataimhihi_d); cudaFree(dataimlohi_d);
   cudaFree(dataimhilo_d); cudaFree(dataimlolo_d);

   free(datarehihi_h); free(datarelohi_h);
   free(datarehilo_h); free(datarelolo_h);
   free(dataimhihi_h); free(dataimlohi_h);
   free(dataimhilo_h); free(dataimlolo_h);

   free(fstart); free(bstart); free(cstart);
   free(fsums); free(bsums); free(csums);
}

void GPU_dbl4_evaluate_monomials
 ( int dim, int deg, int szt, int nbt,
   int *nvr, int **idx, int **exp, int *nbrfac, int **expfac,
   double **cffhihi, double **cfflohi, double **cffhilo, double **cfflolo,
   double *acchihi, double *acclohi, double *acchilo, double *acclolo,
   double **inputhihi, double **inputlohi,
   double **inputhilo, double **inputlolo,
   double ***outputhihi, double ***outputlohi,
   double ***outputhilo, double ***outputlolo, int vrblvl )
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
                  CPU_dbl4_product
                     (deg,inputhihi[idxvar],inputlohi[idxvar],
                          inputhilo[idxvar],inputlolo[idxvar],
                      cffhihi[i],cfflohi[i],cffhilo[i],cfflolo[i],
                      acchihi,acclohi,acchilo,acclolo);

                  for(int L=0; L<=deg; L++)
                  {
                     cffhihi[i][L] = acchihi[L];
                     cfflohi[i][L] = acclohi[L];
                     cffhilo[i][L] = acchilo[L];
                     cfflolo[i][L] = acclolo[L];
                  }
               }
            }
         }
      }
   }
   if(vrblvl > 1)
   {
      for(int i=0; i<dim; i++)
      {
         cout << "coefficients for monomial " << i << " :" << endl;
         for(int j=0; j<=deg; j++)
         {
            cout << cffhihi[i][j] << "  " << cfflohi[i][j] << endl;
            cout << cffhilo[i][j] << "  " << cfflolo[i][j] << endl;
         }
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
         for(int j=0; j<=deg; j++)
         {
            cout << inputhihi[i][j] << "  " << inputlohi[i][j] << endl;
            cout << inputhilo[i][j] << "  " << inputlolo[i][j] << endl;
         }
      }
   }
   // for(int i=0; i<dim; i++)
   //    CPU_dbl_evaldiff(dim,nvr[i],deg,idx[i],cff[i],input,output[i]);

   bool verbose = (vrblvl > 1);
   double cnvlapms,elapsedms,walltimesec;

   ConvolutionJobs jobs(dim);

   jobs.make(dim,nvr,idx,verbose);

   if(verbose)
   {
      for(int k=0; k<jobs.get_depth(); k++)
      {
         cout << "jobs at layer " << k << " :" << endl;
         for(int i=0; i<jobs.get_layer_count(k); i++)
            cout << jobs.get_job(k,i) << endl;
      }
      cout << "dimension : " << dim << endl;
      cout << "number of monomials : " << dim << endl;
      cout << "number of convolution jobs : " << jobs.get_count() << endl;
      cout << "number of layers : " << jobs.get_depth() << endl;
      cout << "frequency of layer counts :" << endl;
      int checksum = 0;
      for(int i=0; i<jobs.get_depth(); i++)
      {
         cout << i << " : " << jobs.get_layer_count(i) << endl;
         checksum = checksum + jobs.get_layer_count(i); 
      }
      cout << "layer count sum : " << checksum << endl;
   }
   GPU_dbl4_mon_evaldiff
      (szt,dim,dim,deg,nvr,idx,cffhihi,cfflohi,cffhilo,cfflolo,
       inputhihi,inputlohi,inputhilo,inputlolo,
       outputhihi,outputlohi,outputhilo,outputlolo,jobs,
       &cnvlapms,&elapsedms,&walltimesec,vrblvl);

   if(vrblvl > 1)
   {
      for(int i=0; i<dim; i++)
      {
         cout << "output series for monomial " << i << " :" << endl;
         for(int j=0; j<=deg; j++)
         {
            cout << outputhihi[i][dim][j] << "  "
                 << outputlohi[i][dim][j] << endl;
            cout << outputhilo[i][dim][j] << "  "
                 << outputlolo[i][dim][j] << endl;
         }
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
               double acchihi,acclohi,acchilo,acclolo;

               // multiply derivative w.r.t. idxvar with factor
               for(int k=0; k<=deg; k++)
               {
                  // output[i][idxvar][k] = factor*output[i][idxvar][k];
                  qdf_mul(outputhihi[i][idxvar][k],outputlohi[i][idxvar][k],
                          outputhilo[i][idxvar][k],outputlolo[i][idxvar][k],
                          factor,0.0,0.0,0.0,
                          &acchihi,&acclohi,&acchilo,&acclolo);
                  outputhihi[i][idxvar][k] = acchihi;
                  outputlohi[i][idxvar][k] = acclohi;
                  outputhilo[i][idxvar][k] = acchilo;
                  outputlolo[i][idxvar][k] = acclolo;
               }
            }
         }
      }
   }
}

void GPU_cmplx4_evaluate_monomials
 ( int dim, int deg, int szt, int nbt,
   int *nvr, int **idx, int **exp, int *nbrfac, int **expfac,
   double **cffrehihi, double **cffrelohi,
   double **cffrehilo, double **cffrelolo,
   double **cffimhihi, double **cffimlohi,
   double **cffimhilo, double **cffimlolo,
   double *accrehihi, double *accrelohi,
   double *accrehilo, double *accrelolo,
   double *accimhihi, double *accimlohi,
   double *accimhilo, double *accimlolo,
   double **inputrehihi, double **inputrelohi,
   double **inputrehilo, double **inputrelolo,
   double **inputimhihi, double **inputimlohi, 
   double **inputimhilo, double **inputimlolo, 
   double ***outputrehihi, double ***outputrelohi, 
   double ***outputrehilo, double ***outputrelolo, 
   double ***outputimhihi, double ***outputimlohi,
   double ***outputimhilo, double ***outputimlolo, int vrblvl )
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
                  CPU_cmplx4_product
                     (deg,inputrehihi[idxvar],inputrelohi[idxvar],
                          inputrehilo[idxvar],inputrelolo[idxvar],
                          inputimhihi[idxvar],inputimlohi[idxvar],
                          inputimhilo[idxvar],inputimlolo[idxvar],
                      cffrehihi[i],cffrelohi[i],cffrehilo[i],cffrelolo[i],
                      cffimhihi[i],cffimlohi[i],cffimhilo[i],cffimlolo[i],
                      accrehihi,accrelohi,accrehilo,accrelolo,
                      accimhihi,accimlohi,accimhilo,accimlolo);

                  for(int L=0; L<=deg; L++)
                  {
                     cffrehihi[i][L] = accrehihi[L];
                     cffrelohi[i][L] = accrelohi[L];
                     cffrehilo[i][L] = accrehilo[L];
                     cffrelolo[i][L] = accrelolo[L];
                     cffimhihi[i][L] = accimhihi[L];
                     cffimlohi[i][L] = accimlohi[L];
                     cffimhilo[i][L] = accimhilo[L];
                     cffimlolo[i][L] = accimlolo[L];
                  }
               }
            }
         }
      }
   }
   if(vrblvl > 1)
   {
      for(int i=0; i<dim; i++)
      {
         cout << "coefficients for monomial " << i << " :" << endl;
         for(int j=0; j<=deg; j++)
            cout << cffrehihi[i][j] << "  " << cffrelohi[i][j] << endl << "  "
                 << cffrehilo[i][j] << "  " << cffrelolo[i][j] << endl << "  "
                 << cffimhihi[i][j] << "  " << cffimlohi[i][j] << endl << "  "
                 << cffimhilo[i][j] << "  " << cffimlolo[i][j] << endl;
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
         for(int j=0; j<=deg; j++)
            cout << inputrehihi[i][j] << "  " << inputrelohi[i][j] << endl
                 << "  "
                 << inputrehilo[i][j] << "  " << inputrelolo[i][j] << endl
                 << "  "
                 << inputimhihi[i][j] << "  " << inputimlohi[i][j] << endl
                 << "  "
                 << inputimhilo[i][j] << "  " << inputimlolo[i][j] << endl;
      }
   }
   bool verbose = (vrblvl > 1);
   double cnvlapms,elapsedms,walltimesec;

   ConvolutionJobs jobs(dim);

   jobs.make(dim,nvr,idx,verbose);

   if(verbose)
   {
      for(int k=0; k<jobs.get_depth(); k++)
      {
         cout << "jobs at layer " << k << " :" << endl;
         for(int i=0; i<jobs.get_layer_count(k); i++)
            cout << jobs.get_job(k,i) << endl;
      }
      cout << "dimension : " << dim << endl;
      cout << "number of monomials : " << dim << endl;
      cout << "number of convolution jobs : " << jobs.get_count() << endl;
      cout << "number of layers : " << jobs.get_depth() << endl;
      cout << "frequency of layer counts :" << endl;
      int checksum = 0;
      for(int i=0; i<jobs.get_depth(); i++)
      {
         cout << i << " : " << jobs.get_layer_count(i) << endl;
         checksum = checksum + jobs.get_layer_count(i); 
      }
      cout << "layer count sum : " << checksum << endl;
   }
   GPU_cmplx4_mon_evaldiff
      (szt,dim,dim,deg,nvr,idx,
       cffrehihi,cffrelohi,cffrehilo,cffrelolo,
       cffimhihi,cffimlohi,cffimhilo,cffimlolo,
       inputrehihi,inputrelohi,inputrehilo,inputrelolo,
       inputimhihi,inputimlohi,inputimhilo,inputimlolo,
       outputrehihi,outputrelohi,outputrehilo,outputrelolo,
       outputimhihi,outputimlohi,outputimhilo,outputimlolo,jobs,
       &cnvlapms,&elapsedms,&walltimesec,vrblvl);

   if(vrblvl > 1)
   {
      for(int i=0; i<dim; i++)
      {
         cout << "output series for monomial " << i << " :" << endl;
         for(int j=0; j<=deg; j++)
            cout << outputrehihi[i][dim][j] << "  "
                 << outputrelohi[i][dim][j] << endl << "  " 
                 << outputrehilo[i][dim][j] << "  "
                 << outputrelolo[i][dim][j] << endl << "  " 
                 << outputimhihi[i][dim][j] << "  "
                 << outputimlohi[i][dim][j] << endl << "  "
                 << outputimhilo[i][dim][j] << "  "
                 << outputimlolo[i][dim][j] << endl;
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
               double fac = (double) exp[i][j];
               double acchihi,acclohi,acchilo,acclolo;

               // multiply derivative w.r.t. idxvar with factor
               for(int k=0; k<=deg; k++)
               {
                  // outputre[i][idxvar][k] = fac*outputre[i][idxvar][k];
                  qdf_mul(outputrehihi[i][idxvar][k],
                          outputrelohi[i][idxvar][k],
                          outputrehilo[i][idxvar][k],
                          outputrelolo[i][idxvar][k],fac,0.0,0.0,0.0,
                          &acchihi,&acclohi,&acchilo,&acclolo);
                  outputrehihi[i][idxvar][k] = acchihi;
                  outputrelohi[i][idxvar][k] = acclohi;
                  outputrehilo[i][idxvar][k] = acchilo;
                  outputrelolo[i][idxvar][k] = acclolo;
                  // outputim[i][idxvar][k] = fac*outputim[i][idxvar][k];
                  qdf_mul(outputimhihi[i][idxvar][k],
                          outputimlohi[i][idxvar][k],
                          outputimhilo[i][idxvar][k],
                          outputimlolo[i][idxvar][k],fac,0.0,0.0,0.0,
                          &acchihi,&acclohi,&acchilo,&acclolo);
                  outputimhihi[i][idxvar][k] = acchihi;
                  outputimlohi[i][idxvar][k] = acclohi;
                  outputimhilo[i][idxvar][k] = acchilo;
                  outputimlolo[i][idxvar][k] = acclolo;
               }
            }
         }
      }
   }
}

void GPU_dbl4_evaluate_columns
 ( int dim, int deg, int nbrcol, int szt, int nbt, int **nvr, int ***idx,
   double ***cffhihi, double ***cfflohi,
   double ***cffhilo, double ***cfflolo,
   double **inputhihi, double **inputlohi, 
   double **inputhilo, double **inputlolo, 
   double ***outputhihi, double ***outputlohi,
   double ***outputhilo, double ***outputlolo,
   double **funvalhihi, double **funvallohi,
   double **funvalhilo, double **funvallolo,
   double ***jacvalhihi, double ***jacvallohi,
   double ***jacvalhilo, double ***jacvallolo, int vrblvl )
{
   const int degp1 = deg+1;

   for(int i=0; i<dim; i++)
      for(int j=0; j<degp1; j++)
      {
         funvalhihi[i][j] = 0.0; funvallohi[i][j] = 0.0;
         funvalhilo[i][j] = 0.0; funvallolo[i][j] = 0.0;
      }
   funvalhihi[dim-1][0] = -1.0; // constant of last eq in cyclic dim-roots

   for(int k=0; k<degp1; k++)  // the Jacobian is linearized
      for(int i=0; i<dim; i++)
         for(int j=0; j<dim; j++)
         {
            jacvalhihi[k][i][j] = 0.0; jacvallohi[k][i][j] = 0.0;
            jacvalhilo[k][i][j] = 0.0; jacvallolo[k][i][j] = 0.0;
         }

   if(vrblvl > 1)
   {
      for(int i=0; i<nbrcol; i++)
      {
         cout << "coefficients for column " << i << " :" << endl;
         for(int j=0; j<dim; j++)
         {
            cout << "coefficients for monomial " << j << " :" << endl;
            for(int k=0; k<=deg; k++)
               cout << cffhihi[i][j][k] << "  " << cfflohi[i][j][k] << endl
                    << "  "
                    << cffhilo[i][j][k] << "  " << cfflolo[i][j][k] << endl;
         }
      }
      cout << "dim : " << dim << endl;
      for(int i=0; i<nbrcol; i++)
      {
         for(int j=0; j<dim; j++)
         {
            cout << "nvr[" << i << "][" << j << "] : " << nvr[i][j] << " :";
            cout << "  idx[" << i << "][" << j << "] :";
            for(int k=0; k<nvr[i][j]; k++) cout << " " << idx[i][j][k];
            cout << endl;
         }
      }
      for(int i=0; i<dim; i++)
      {
         cout << "input series for variable " << i << " :" << endl;
         for(int j=0; j<=deg; j++)
            cout << inputhihi[i][j] << "  " << inputlohi[i][j] << endl
                 << "  "
                 << inputhilo[i][j] << "  " << inputlolo[i][j] << endl;
      }
   }
   bool verbose = (vrblvl > 1);
   double cnvlapms,elapsedms,walltimesec;

   for(int i=0; i<nbrcol; i++)
   {
      ConvolutionJobs jobs(dim);

      jobs.make(dim,nvr[i],idx[i],verbose);

      if(verbose)
      {
         for(int k=0; k<jobs.get_depth(); k++)
         {
            cout << "jobs at layer " << k << " :" << endl;
            for(int j=0; j<jobs.get_layer_count(k); j++)
               cout << jobs.get_job(k,j) << endl;
         }
         cout << "dimension : " << dim << endl;
         cout << "number of monomials : " << dim << endl;
         cout << "number of convolution jobs : " << jobs.get_count() << endl;
         cout << "number of layers : " << jobs.get_depth() << endl;
         cout << "frequency of layer counts :" << endl;
         int checksum = 0;
         for(int j=0; j<jobs.get_depth(); j++)
         {
            cout << j << " : " << jobs.get_layer_count(j) << endl;
            checksum = checksum + jobs.get_layer_count(j); 
         }
         cout << "layer count sum : " << checksum << endl;
      }
      GPU_dbl4_mon_evaldiff
         (szt,dim,dim,deg,nvr[i],idx[i],
          cffhihi[i],cfflohi[i],cffhilo[i],cfflolo[i],
          inputhihi,inputlohi,inputhilo,inputlolo,
          outputhihi,outputlohi,outputhilo,outputlolo,jobs,
          &cnvlapms,&elapsedms,&walltimesec,vrblvl);

      for(int j=0; j<dim; j++)
         if(nvr[i][j] > 0)       // update values
         {
            for(int L=0; L<degp1; L++) // funval[j][L] += output[j][dim][L];
            {
               qdf_inc(&funvalhihi[j][L],&funvallohi[j][L],
                       &funvalhilo[j][L],&funvallolo[j][L],
                       outputhihi[j][dim][L],outputlohi[j][dim][L],
                       outputhilo[j][dim][L],outputlolo[j][dim][L]);
            }

            int *indexes = idx[i][j];      // indices of the variables
            for(int k=0; k<nvr[i][j]; k++) // derivative w.r.t. idx[i][j][k]
            {                              // has j-th coefficient
               int idxval = indexes[k];
               for(int L=0; L<degp1; L++) 
               {
                  // jacval[L][j][idxval] += output[j][idxval][L];
                  qdf_inc(&jacvalhihi[L][j][idxval],&jacvallohi[L][j][idxval],
                          &jacvalhilo[L][j][idxval],&jacvallolo[L][j][idxval],
                          outputhihi[j][idxval][L],outputlohi[j][idxval][L],
                          outputhilo[j][idxval][L],outputlolo[j][idxval][L]);
               }
            }
         }
   }
   if(vrblvl > 1)
   {
      for(int i=0; i<dim; i++)
      {
         cout << "output series for monomial " << i << " :" << endl;
         for(int j=0; j<=deg; j++)
            cout << funvalhihi[i][j] << "  " << funvallohi[i][j] << endl
                 << "  "
                 << funvalhilo[i][j] << "  " << funvallolo[i][j] << endl;
      }
   }
}

void GPU_cmplx4_evaluate_columns
 ( int dim, int deg, int nbrcol, int szt, int nbt, int **nvr, int ***idx, 
   double ***cffrehihi, double ***cffrelohi,
   double ***cffrehilo, double ***cffrelolo,
   double ***cffimhihi, double ***cffimlohi, 
   double ***cffimhilo, double ***cffimlolo, 
   double **inputrehihi, double **inputrelohi,
   double **inputrehilo, double **inputrelolo,
   double **inputimhihi, double **inputimlohi,
   double **inputimhilo, double **inputimlolo,
   double ***outputrehihi, double ***outputrelohi,
   double ***outputrehilo, double ***outputrelolo,
   double ***outputimhihi, double ***outputimlohi, 
   double ***outputimhilo, double ***outputimlolo, 
   double **funvalrehihi, double **funvalrelohi,
   double **funvalrehilo, double **funvalrelolo,
   double **funvalimhihi, double **funvalimlohi,
   double **funvalimhilo, double **funvalimlolo,
   double ***jacvalrehihi, double ***jacvalrelohi,
   double ***jacvalrehilo, double ***jacvalrelolo,
   double ***jacvalimhihi, double ***jacvalimlohi,
   double ***jacvalimhilo, double ***jacvalimlolo, int vrblvl )
{
   const int degp1 = deg+1;

   for(int i=0; i<dim; i++)
      for(int j=0; j<degp1; j++)
      {
         funvalrehihi[i][j] = 0.0; funvalrelohi[i][j] = 0.0;
         funvalrehilo[i][j] = 0.0; funvalrelolo[i][j] = 0.0;
         funvalimhihi[i][j] = 0.0; funvalimlohi[i][j] = 0.0;
         funvalimhilo[i][j] = 0.0; funvalimlolo[i][j] = 0.0;
      }
   funvalrehihi[dim-1][0] = -1.0; // constant of last eq in cyclic dim-roots

   for(int k=0; k<degp1; k++)  // the Jacobian is linearized
      for(int i=0; i<dim; i++)
         for(int j=0; j<dim; j++)
         {
            jacvalrehihi[k][i][j] = 0.0; jacvalrelohi[k][i][j] = 0.0;
            jacvalrehilo[k][i][j] = 0.0; jacvalrelolo[k][i][j] = 0.0;
            jacvalimhihi[k][i][j] = 0.0; jacvalimlohi[k][i][j] = 0.0;
            jacvalimhilo[k][i][j] = 0.0; jacvalimlolo[k][i][j] = 0.0;
         }

   if(vrblvl > 1)
   {
      for(int i=0; i<nbrcol; i++)
      {
         cout << "coefficients for column " << i << " :" << endl;
         for(int j=0; j<dim; j++)
         {
            cout << "coefficients for monomial " << j << " :" << endl;
            for(int k=0; k<=deg; k++)
               cout << cffrehihi[i][j][k] << "  "
                    << cffrelohi[i][j][k] << endl << "  "
                    << cffrehilo[i][j][k] << "  "
                    << cffrelolo[i][j][k] << endl << "  "
                    << cffimhihi[i][j][k] << "  "
                    << cffimlohi[i][j][k] << endl << "  "
                    << cffimhilo[i][j][k] << "  "
                    << cffimlolo[i][j][k] << endl;
         }
      }
      cout << "dim : " << dim << endl;
      for(int i=0; i<nbrcol; i++)
      {
         for(int j=0; j<dim; j++)
         {
            cout << "nvr[" << i << "][" << j << "] : " << nvr[i][j] << " :";
            cout << "  idx[" << i << "][" << j << "] :";
            for(int k=0; k<nvr[i][j]; k++) cout << " " << idx[i][j][k];
            cout << endl;
         }
      }
      for(int i=0; i<dim; i++)
      {
         cout << "input series for variable " << i << " :" << endl;
         for(int j=0; j<=deg; j++)
            cout << inputrehihi[i][j] << "  " << inputrelohi[i][j] << endl
                 << "  "
                 << inputrehilo[i][j] << "  " << inputrelolo[i][j] << endl
                 << "  "
                 << inputimhihi[i][j] << "  " << inputimlohi[i][j] << endl
                 << "  "
                 << inputimhilo[i][j] << "  " << inputimlolo[i][j] << endl;
      }
   }
   bool verbose = (vrblvl > 1);
   double cnvlapms,elapsedms,walltimesec;

   for(int i=0; i<nbrcol; i++)
   {
      ConvolutionJobs jobs(dim);

      jobs.make(dim,nvr[i],idx[i],verbose);

      if(verbose)
      {
         for(int k=0; k<jobs.get_depth(); k++)
         {
            cout << "jobs at layer " << k << " :" << endl;
            for(int j=0; j<jobs.get_layer_count(k); j++)
               cout << jobs.get_job(k,j) << endl;
         }
         cout << "dimension : " << dim << endl;
         cout << "number of monomials : " << dim << endl;
         cout << "number of convolution jobs : " << jobs.get_count() << endl;
         cout << "number of layers : " << jobs.get_depth() << endl;
         cout << "frequency of layer counts :" << endl;
         int checksum = 0;
         for(int j=0; j<jobs.get_depth(); j++)
         {
            cout << j << " : " << jobs.get_layer_count(j) << endl;
            checksum = checksum + jobs.get_layer_count(j); 
         }
         cout << "layer count sum : " << checksum << endl;
      }
      GPU_cmplx4_mon_evaldiff
         (szt,dim,dim,deg,nvr[i],idx[i],
          cffrehihi[i],cffrelohi[i],cffrehilo[i],cffrelolo[i],
          cffimhihi[i],cffimlohi[i],cffimhilo[i],cffimlolo[i],
          inputrehihi,inputrelohi,inputrehilo,inputrelolo,
          inputimhihi,inputimlohi,inputimhilo,inputimlolo,
          outputrehihi,outputrelohi,outputrehilo,outputrelolo,
          outputimhihi,outputimlohi,outputimhilo,outputimlolo,jobs,
          &cnvlapms,&elapsedms,&walltimesec,vrblvl);

      for(int j=0; j<dim; j++)
         if(nvr[i][j] > 0)       // update values
         {
            for(int L=0; L<degp1; L++)
            {
               // funvalre[j][L] += outputre[j][dim][L];
               // funvalim[j][L] += outputim[j][dim][L];
               qdf_inc(&funvalrehihi[j][L],&funvalrelohi[j][L],
                       &funvalrehilo[j][L],&funvalrelolo[j][L],
                       outputrehihi[j][dim][L],outputrelohi[j][dim][L],
                       outputrehilo[j][dim][L],outputrelolo[j][dim][L]);
               qdf_inc(&funvalimhihi[j][L],&funvalimlohi[j][L],
                       &funvalimhilo[j][L],&funvalimlolo[j][L],
                       outputimhihi[j][dim][L],outputimlohi[j][dim][L],
                       outputimhilo[j][dim][L],outputimlolo[j][dim][L]);
            }

            int *indexes = idx[i][j];      // indices of the variables
            for(int k=0; k<nvr[i][j]; k++) // derivative w.r.t. idx[i][j][k]
            {                              // has j-th coefficient
               int idxval = indexes[k];
               for(int L=0; L<degp1; L++) 
               {
                  // jacvalre[L][j][idxval] += outputre[j][idxval][L];
                  // jacvalim[L][j][idxval] += outputim[j][idxval][L];
                  qdf_inc(&jacvalrehihi[L][j][idxval],
                          &jacvalrelohi[L][j][idxval],
                          &jacvalrehilo[L][j][idxval],
                          &jacvalrelolo[L][j][idxval],
                          outputrehihi[j][idxval][L],
                          outputrelohi[j][idxval][L],
                          outputrehilo[j][idxval][L],
                          outputrelolo[j][idxval][L]);
                  qdf_inc(&jacvalimhihi[L][j][idxval],
                          &jacvalimlohi[L][j][idxval],
                          &jacvalimhilo[L][j][idxval],
                          &jacvalimlolo[L][j][idxval],
                          outputimhihi[j][idxval][L],
                          outputimlohi[j][idxval][L],
                          outputimhilo[j][idxval][L],
                          outputimlolo[j][idxval][L]);
               }
            }
         }
   }
   if(vrblvl > 1)
   {
      for(int i=0; i<dim; i++)
      {
         cout << "output series for polynomial " << i << " :" << endl;
         for(int j=0; j<=deg; j++)
            cout << funvalrehihi[i][j] << "  " << funvalrelohi[i][j] << endl
                 << "  "
                 << funvalrehilo[i][j] << "  " << funvalrelolo[i][j] << endl
                 << "  "
                 << funvalimhihi[i][j] << "  " << funvalimlohi[i][j] << endl
                 << "  "
                 << funvalimhilo[i][j] << "  " << funvalimlolo[i][j] << endl;
      }
   }
}
