// The file dbl8_systems_kernels.cu defines the functions with prototypes in
// the file dbl8_systems_kernels.h.

#include <iostream>
#include <iomanip>
#ifdef winwalltime
#include "gettimeofday4win.h"
#else
#include <sys/time.h>
#endif
#include "write_gpu_timings.h"
#include "job_coordinates.h"
#include "octo_double_functions.h"
#include "dbl8_convolutions_host.h"
#include "dbl8_monomials_host.h"
#include "dbl8_polynomials_kernels.h"

using namespace std;

// The code in dbl8_evaldiffdata_to_output is an adaptation of the
// function dbl8_convoluted_data_to_output in dbl2_polynomials_kernels.cu.

void dbl8_evaldiffdata_to_output
 ( double *datahihihi, double *datalohihi,
   double *datahilohi, double *datalolohi,
   double *datahihilo, double *datalohilo,
   double *datahilolo, double *datalololo,
   double ***outputhihihi, double ***outputlohihi,
   double ***outputhilohi, double ***outputlolohi,
   double ***outputhihilo, double ***outputlohilo,
   double ***outputhilolo, double ***outputlololo,
   int dim, int nbr, int deg, int *nvr,
   int **idx, int *fstart, int *bstart, int *cstart, bool verbose )
{
   const int deg1 = deg+1;
   int ix0,ix1,ix2;

   for(int k=0; k<nbr; k++)
   {
      ix1 = fstart[k] + (nvr[k]-1)*deg1;
      
      if(verbose)
         cout << "monomial " << k << " update starts at " << ix1 << endl;

      for(int i=0; i<=deg; i++)
      {
         outputhihihi[k][dim][i] = datahihihi[ix1];
         outputlohihi[k][dim][i] = datalohihi[ix1];
         outputhilohi[k][dim][i] = datahilohi[ix1];
         outputlolohi[k][dim][i] = datalolohi[ix1];
         outputhihilo[k][dim][i] = datahihilo[ix1];
         outputlohilo[k][dim][i] = datalohilo[ix1];
         outputhilolo[k][dim][i] = datahilolo[ix1];
         outputlololo[k][dim][i] = datalololo[ix1++];
      }
      ix0 = idx[k][0];
      if(nvr[k] == 1)
      {
         ix1 = (1 + k)*deg1;
            
         for(int i=0; i<=deg; i++)
         {
            outputhihihi[k][ix0][i] = datahihihi[ix1];
            outputlohihi[k][ix0][i] = datalohihi[ix1];
            outputhilohi[k][ix0][i] = datahilohi[ix1];
            outputlolohi[k][ix0][i] = datalolohi[ix1];
            outputhihilo[k][ix0][i] = datahihilo[ix1];
            outputlohilo[k][ix0][i] = datalohilo[ix1];
            outputhilolo[k][ix0][i] = datahilolo[ix1];
            outputlololo[k][ix0][i] = datalololo[ix1++];
         }
      }
      else
      {                               // first and last derivative
         ix2 = nvr[k]-3;
         if(ix2 < 0) ix2 = 0;
         ix1 = bstart[k] + ix2*deg1;

         for(int i=0; i<=deg; i++)
         {
            outputhihihi[k][ix0][i] = datahihihi[ix1];
            outputlohihi[k][ix0][i] = datalohihi[ix1];
            outputhilohi[k][ix0][i] = datahilohi[ix1];
            outputlolohi[k][ix0][i] = datalolohi[ix1];
            outputhihilo[k][ix0][i] = datahihilo[ix1];
            outputlohilo[k][ix0][i] = datalohilo[ix1];
            outputhilolo[k][ix0][i] = datahilolo[ix1];
            outputlololo[k][ix0][i] = datalololo[ix1++];
         }
         ix2 = nvr[k]-2;
         ix1 = fstart[k] + ix2*deg1;
         ix0 = idx[k][ix2+1];

         for(int i=0; i<=deg; i++)
         {
            outputhihihi[k][ix0][i] = datahihihi[ix1];
            outputlohihi[k][ix0][i] = datalohihi[ix1];
            outputhilohi[k][ix0][i] = datahilohi[ix1];
            outputlolohi[k][ix0][i] = datalolohi[ix1];
            outputhihilo[k][ix0][i] = datahihilo[ix1];
            outputlohilo[k][ix0][i] = datalohilo[ix1];
            outputhilolo[k][ix0][i] = datahilolo[ix1];
            outputlololo[k][ix0][i] = datalololo[ix1++];
         }
         if(nvr[k] > 2)                   // all other derivatives
         {
            for(int j=1; j<nvr[k]-1; j++)
            {
               ix0 = idx[k][j];            // j-th variable in monomial k
               ix1 = cstart[k] + (j-1)*deg1;

               if(verbose)
                  cout << "monomial " << k << " derivative " << ix0
                       << " update starts at " << ix1 << endl;

               for(int i=0; i<=deg; i++)
               {
                  outputhihihi[k][ix0][i] = datahihihi[ix1];
                  outputlohihi[k][ix0][i] = datalohihi[ix1];
                  outputhilohi[k][ix0][i] = datahilohi[ix1];
                  outputlolohi[k][ix0][i] = datalolohi[ix1];
                  outputhihilo[k][ix0][i] = datahihilo[ix1];
                  outputlohilo[k][ix0][i] = datalohilo[ix1];
                  outputhilolo[k][ix0][i] = datahilolo[ix1];
                  outputlololo[k][ix0][i] = datalololo[ix1++];
               }
            }
         }
      }
   }
}

void cmplx8_evaldiffdata_to_output
 ( double *datarehihihi, double *datarelohihi,
   double *datarehilohi, double *datarelolohi,
   double *datarehihilo, double *datarelohilo,
   double *datarehilolo, double *datarelololo,
   double *dataimhihihi, double *dataimlohihi,
   double *dataimhilohi, double *dataimlolohi,
   double *dataimhihilo, double *dataimlohilo,
   double *dataimhilolo, double *dataimlololo,
   double ***outputrehihihi, double ***outputrelohihi,
   double ***outputrehilohi, double ***outputrelolohi,
   double ***outputrehihilo, double ***outputrelohilo,
   double ***outputrehilolo, double ***outputrelololo,
   double ***outputimhihihi, double ***outputimlohihi,
   double ***outputimhilohi, double ***outputimlolohi,
   double ***outputimhihilo, double ***outputimlohilo,
   double ***outputimhilolo, double ***outputimlololo,
   int dim, int nbr, int deg, int *nvr,
   int **idx, int *fstart, int *bstart, int *cstart, bool verbose )
{
   const int deg1 = deg+1;
   int ix0,ix1,ix2;

   for(int k=0; k<nbr; k++)
   {
      ix1 = fstart[k] + (nvr[k]-1)*deg1;
      
      if(verbose)
         cout << "monomial " << k << " update starts at " << ix1 << endl;

      for(int i=0; i<=deg; i++)
      {
         outputrehihihi[k][dim][i] = datarehihihi[ix1];
         outputrelohihi[k][dim][i] = datarelohihi[ix1];
         outputrehilohi[k][dim][i] = datarehilohi[ix1];
         outputrelolohi[k][dim][i] = datarelolohi[ix1];
         outputrehihilo[k][dim][i] = datarehihilo[ix1];
         outputrelohilo[k][dim][i] = datarelohilo[ix1];
         outputrehilolo[k][dim][i] = datarehilolo[ix1];
         outputrelololo[k][dim][i] = datarelololo[ix1];
         outputimhihihi[k][dim][i] = dataimhihihi[ix1];
         outputimlohihi[k][dim][i] = dataimlohihi[ix1];
         outputimhilohi[k][dim][i] = dataimhilohi[ix1];
         outputimlolohi[k][dim][i] = dataimlolohi[ix1];
         outputimhihilo[k][dim][i] = dataimhihilo[ix1];
         outputimlohilo[k][dim][i] = dataimlohilo[ix1];
         outputimhilolo[k][dim][i] = dataimhilolo[ix1];
         outputimlololo[k][dim][i] = dataimlololo[ix1++];
      }
      ix0 = idx[k][0];
      if(nvr[k] == 1)
      {
         ix1 = (1 + k)*deg1;
            
         for(int i=0; i<=deg; i++)
         {
            outputrehihihi[k][ix0][i] = datarehihihi[ix1];
            outputrelohihi[k][ix0][i] = datarelohihi[ix1];
            outputrehilohi[k][ix0][i] = datarehilohi[ix1];
            outputrelolohi[k][ix0][i] = datarelolohi[ix1];
            outputrehihilo[k][ix0][i] = datarehihilo[ix1];
            outputrelohilo[k][ix0][i] = datarelohilo[ix1];
            outputrehilolo[k][ix0][i] = datarehilolo[ix1];
            outputrelololo[k][ix0][i] = datarelololo[ix1];
            outputimhihihi[k][ix0][i] = dataimhihihi[ix1];
            outputimlohihi[k][ix0][i] = dataimlohihi[ix1];
            outputimhilohi[k][ix0][i] = dataimhilohi[ix1];
            outputimlolohi[k][ix0][i] = dataimlolohi[ix1];
            outputimhihilo[k][ix0][i] = dataimhihilo[ix1];
            outputimlohilo[k][ix0][i] = dataimlohilo[ix1];
            outputimhilolo[k][ix0][i] = dataimhilolo[ix1];
            outputimlololo[k][ix0][i] = dataimlololo[ix1++];
         }
      }
      else
      {                               // first and last derivative
         ix2 = nvr[k]-3;
         if(ix2 < 0) ix2 = 0;
         ix1 = bstart[k] + ix2*deg1;

         for(int i=0; i<=deg; i++)
         {
            outputrehihihi[k][ix0][i] = datarehihihi[ix1];
            outputrelohihi[k][ix0][i] = datarelohihi[ix1];
            outputrehilohi[k][ix0][i] = datarehilohi[ix1];
            outputrelolohi[k][ix0][i] = datarelolohi[ix1];
            outputrehihilo[k][ix0][i] = datarehihilo[ix1];
            outputrelohilo[k][ix0][i] = datarelohilo[ix1];
            outputrehilolo[k][ix0][i] = datarehilolo[ix1];
            outputrelololo[k][ix0][i] = datarelololo[ix1];
            outputimhihihi[k][ix0][i] = dataimhihihi[ix1];
            outputimlohihi[k][ix0][i] = dataimlohihi[ix1];
            outputimhilohi[k][ix0][i] = dataimhilohi[ix1];
            outputimlolohi[k][ix0][i] = dataimlolohi[ix1];
            outputimhihilo[k][ix0][i] = dataimhihilo[ix1];
            outputimlohilo[k][ix0][i] = dataimlohilo[ix1];
            outputimhilolo[k][ix0][i] = dataimhilolo[ix1];
            outputimlololo[k][ix0][i] = dataimlololo[ix1++];
         }
         ix2 = nvr[k]-2;
         ix1 = fstart[k] + ix2*deg1;
         ix0 = idx[k][ix2+1];

         for(int i=0; i<=deg; i++)
         {
            outputrehihihi[k][ix0][i] = datarehihihi[ix1];
            outputrelohihi[k][ix0][i] = datarelohihi[ix1];
            outputrehilohi[k][ix0][i] = datarehilohi[ix1];
            outputrelolohi[k][ix0][i] = datarelolohi[ix1];
            outputrehihilo[k][ix0][i] = datarehihilo[ix1];
            outputrelohilo[k][ix0][i] = datarelohilo[ix1];
            outputrehilolo[k][ix0][i] = datarehilolo[ix1];
            outputrelololo[k][ix0][i] = datarelololo[ix1];
            outputimhihihi[k][ix0][i] = dataimhihihi[ix1];
            outputimlohihi[k][ix0][i] = dataimlohihi[ix1];
            outputimhilohi[k][ix0][i] = dataimhilohi[ix1];
            outputimlolohi[k][ix0][i] = dataimlolohi[ix1];
            outputimhihilo[k][ix0][i] = dataimhihilo[ix1];
            outputimlohilo[k][ix0][i] = dataimlohilo[ix1];
            outputimhilolo[k][ix0][i] = dataimhilolo[ix1];
            outputimlololo[k][ix0][i] = dataimlololo[ix1++];
         }
         if(nvr[k] > 2)                   // all other derivatives
         {
            for(int j=1; j<nvr[k]-1; j++)
            {
               ix0 = idx[k][j];            // j-th variable in monomial k
               ix1 = cstart[k] + (j-1)*deg1;

               if(verbose)
                  cout << "monomial " << k << " derivative " << ix0
                       << " update starts at " << ix1 << endl;

               for(int i=0; i<=deg; i++)
               {
                  outputrehihihi[k][ix0][i] = datarehihihi[ix1];
                  outputrelohihi[k][ix0][i] = datarelohihi[ix1];
                  outputrehilohi[k][ix0][i] = datarehilohi[ix1];
                  outputrelolohi[k][ix0][i] = datarelolohi[ix1];
                  outputrehihilo[k][ix0][i] = datarehihilo[ix1];
                  outputrelohilo[k][ix0][i] = datarelohilo[ix1];
                  outputrehilolo[k][ix0][i] = datarehilolo[ix1];
                  outputrelololo[k][ix0][i] = datarelololo[ix1];
                  outputimhihihi[k][ix0][i] = dataimhihihi[ix1];
                  outputimlohihi[k][ix0][i] = dataimlohihi[ix1];
                  outputimhilohi[k][ix0][i] = dataimhilohi[ix1];
                  outputimlolohi[k][ix0][i] = dataimlolohi[ix1];
                  outputimhihilo[k][ix0][i] = dataimhihilo[ix1];
                  outputimlohilo[k][ix0][i] = dataimlohilo[ix1];
                  outputimhilolo[k][ix0][i] = dataimhilolo[ix1];
                  outputimlololo[k][ix0][i] = dataimlololo[ix1++];
               }
            }
         }
      }
   }
}

// The code for GPU_dbl8_mon_evaldiff is an adaptation of the
// function GPU_dbl8_poly_evaldiff of dbl_polynomials_kernels.cu.

void GPU_dbl8_mon_evaldiff
 ( int szt, int dim, int nbr, int deg, int *nvr, int **idx,
   double **cffhihihi, double **cfflohihi,
   double **cffhilohi, double **cfflolohi,
   double **cffhihilo, double **cfflohilo,
   double **cffhilolo, double **cfflololo,
   double **inputhihihi, double **inputlohihi,
   double **inputhilohi, double **inputlolohi,
   double **inputhihilo, double **inputlohilo,
   double **inputhilolo, double **inputlololo,
   double ***outputhihihi, double ***outputlohihi,
   double ***outputhilohi, double ***outputlolohi,
   double ***outputhihilo, double ***outputlohilo,
   double ***outputhilolo, double ***outputlololo, ConvolutionJobs cnvjobs,
   double *cnvlapms, double *elapsedms, double *walltimesec, bool verbose )
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

   double *datahihihi_h = new double[totalcff];        // data on host
   double *datalohihi_h = new double[totalcff];
   double *datahilohi_h = new double[totalcff];
   double *datalolohi_h = new double[totalcff];
   double *datahihilo_h = new double[totalcff];
   double *datalohilo_h = new double[totalcff];
   double *datahilolo_h = new double[totalcff];
   double *datalololo_h = new double[totalcff];

   int ix = 0;
   for(int i=0; i<deg1; i++)
   {
      datahihihi_h[ix]   = 0.0; // cst[i]; no constant
      datalohihi_h[ix]   = 0.0; 
      datahilohi_h[ix]   = 0.0; 
      datalolohi_h[ix]   = 0.0;
      datahihilo_h[ix]   = 0.0;
      datalohilo_h[ix]   = 0.0; 
      datahilolo_h[ix]   = 0.0; 
      datalololo_h[ix++] = 0.0;
   }
   for(int i=0; i<nbr; i++)
      for(int j=0; j<deg1; j++)
      {
         datahihihi_h[ix]   = cffhihihi[i][j];
         datalohihi_h[ix]   = cfflohihi[i][j];
         datahilohi_h[ix]   = cffhilohi[i][j];
         datalolohi_h[ix]   = cfflolohi[i][j];
         datahihilo_h[ix]   = cffhihilo[i][j];
         datalohilo_h[ix]   = cfflohilo[i][j];
         datahilolo_h[ix]   = cffhilolo[i][j];
         datalololo_h[ix++] = cfflololo[i][j];
      }

   for(int i=0; i<dim; i++)
      for(int j=0; j<deg1; j++)
      {
         datahihihi_h[ix]   = inputhihihi[i][j];
         datalohihi_h[ix]   = inputlohihi[i][j];
         datahilohi_h[ix]   = inputhilohi[i][j];
         datalolohi_h[ix]   = inputlolohi[i][j];
         datahihilo_h[ix]   = inputhihilo[i][j];
         datalohilo_h[ix]   = inputlohilo[i][j];
         datahilolo_h[ix]   = inputhilolo[i][j];
         datalololo_h[ix++] = inputlololo[i][j];
      }

   double *datahihihi_d;                               // device data
   double *datalohihi_d;
   double *datahilohi_d;
   double *datalolohi_d;
   double *datahihilo_d;
   double *datalohilo_d;
   double *datahilolo_d;
   double *datalololo_d;
   const size_t szdata = totalcff*sizeof(double);
   cudaMalloc((void**)&datahihihi_d,szdata);
   cudaMalloc((void**)&datalohihi_d,szdata);
   cudaMalloc((void**)&datahilohi_d,szdata);
   cudaMalloc((void**)&datalolohi_d,szdata);
   cudaMalloc((void**)&datahihilo_d,szdata);
   cudaMalloc((void**)&datalohilo_d,szdata);
   cudaMalloc((void**)&datahilolo_d,szdata);
   cudaMalloc((void**)&datalololo_d,szdata);
   cudaMemcpy(datahihihi_d,datahihihi_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(datalohihi_d,datalohihi_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(datahilohi_d,datahilohi_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(datalolohi_d,datalolohi_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(datahihilo_d,datahihilo_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(datalohilo_d,datalohilo_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(datahilolo_d,datahilolo_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(datalololo_d,datalololo_h,szdata,cudaMemcpyHostToDevice);

   cudaEvent_t start,stop;           // to measure time spent by kernels 
   cudaEventCreate(&start);
   cudaEventCreate(&stop);
   *cnvlapms = 0.0;
   float milliseconds;
   struct timeval begintime,endtime; // wall clock time of computations

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
         dbl8_padded_convjobs<<<jobnbr,deg1>>>
            (datahihihi_d,datalohihi_d,datahilohi_d,datalolohi_d,
             datahihilo_d,datalohilo_d,datahilolo_d,datalololo_d,
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
   cudaMemcpy(datahihihi_h,datahihihi_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(datalohihi_h,datalohihi_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(datahilohi_h,datahilohi_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(datalolohi_h,datalolohi_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(datahihilo_h,datahihilo_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(datalohilo_h,datalohilo_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(datahilolo_h,datahilolo_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(datalololo_h,datalololo_d,szdata,cudaMemcpyDeviceToHost);
   *elapsedms = *cnvlapms;
   long seconds = endtime.tv_sec - begintime.tv_sec;
   long microseconds = endtime.tv_usec - begintime.tv_usec;
   *walltimesec = seconds + microseconds*1.0e-6;

   dbl8_evaldiffdata_to_output
      (datahihihi_h,datalohihi_h,datahilohi_h,datalolohi_h,
       datahihilo_h,datalohilo_h,datahilolo_h,datalololo_h,
       outputhihihi,outputlohihi,outputhilohi,outputlolohi,
       outputhihilo,outputlohilo,outputhilolo,outputlololo,
       dim,nbr,deg,nvr,idx,fstart,bstart,cstart,verbose);

   if(verbose)
      write_GPU_timings(*cnvlapms,0.0,*elapsedms,*walltimesec);

   cudaFree(datahihihi_d); cudaFree(datalohihi_d);
   cudaFree(datahilohi_d); cudaFree(datalolohi_d);
   cudaFree(datahihilo_d); cudaFree(datalohilo_d);
   cudaFree(datahilolo_d); cudaFree(datalololo_d);

   free(datahihihi_h); free(datalohihi_h);
   free(datahilohi_h); free(datalolohi_h);
   free(datahihilo_h); free(datalohilo_h);
   free(datahilolo_h); free(datalololo_h);

   free(fstart); free(bstart); free(cstart);
   free(fsums); free(bsums); free(csums);
}

void GPU_cmplx8_mon_evaldiff
 ( int szt, int dim, int nbr, int deg, int *nvr, int **idx,
   double **cffrehihihi, double **cffrelohihi,
   double **cffrehilohi, double **cffrelolohi,
   double **cffrehihilo, double **cffrelohilo,
   double **cffrehilolo, double **cffrelololo,
   double **cffimhihihi, double **cffimlohihi,
   double **cffimhilohi, double **cffimlolohi,
   double **cffimhihilo, double **cffimlohilo,
   double **cffimhilolo, double **cffimlololo,
   double **inputrehihihi, double **inputrelohihi,
   double **inputrehilohi, double **inputrelolohi,
   double **inputrehihilo, double **inputrelohilo,
   double **inputrehilolo, double **inputrelololo,
   double **inputimhihihi, double **inputimlohihi,
   double **inputimhilohi, double **inputimlolohi,
   double **inputimhihilo, double **inputimlohilo,
   double **inputimhilolo, double **inputimlololo,
   double ***outputrehihihi, double ***outputrelohihi,
   double ***outputrehilohi, double ***outputrelolohi,
   double ***outputrehihilo, double ***outputrelohilo,
   double ***outputrehilolo, double ***outputrelololo,
   double ***outputimhihihi, double ***outputimlohihi,
   double ***outputimhilohi, double ***outputimlolohi,
   double ***outputimhihilo, double ***outputimlohilo,
   double ***outputimhilolo, double ***outputimlololo,
   ConvolutionJobs cnvjobs,
   double *cnvlapms, double *elapsedms, double *walltimesec, bool verbose )
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

   double *datarehihihi_h = new double[totalcff]; // real data on host
   double *datarelohihi_h = new double[totalcff];
   double *datarehilohi_h = new double[totalcff];
   double *datarelolohi_h = new double[totalcff];
   double *datarehihilo_h = new double[totalcff]; 
   double *datarelohilo_h = new double[totalcff];
   double *datarehilolo_h = new double[totalcff];
   double *datarelololo_h = new double[totalcff];
   double *dataimhihihi_h = new double[totalcff]; // imaginary data on host
   double *dataimlohihi_h = new double[totalcff];
   double *dataimhilohi_h = new double[totalcff];
   double *dataimlolohi_h = new double[totalcff];
   double *dataimhihilo_h = new double[totalcff];
   double *dataimlohilo_h = new double[totalcff];
   double *dataimhilolo_h = new double[totalcff];
   double *dataimlololo_h = new double[totalcff];

   int ix = 0;
   for(int i=0; i<deg1; i++)
   {
      datarehihihi_h[ix]   = 0.0; // cst[i]; no constant
      datarelohihi_h[ix]   = 0.0;
      datarehilohi_h[ix]   = 0.0;
      datarelolohi_h[ix]   = 0.0;
      datarehihilo_h[ix]   = 0.0;
      datarelohilo_h[ix]   = 0.0;
      datarehilolo_h[ix]   = 0.0;
      datarelololo_h[ix]   = 0.0;
      dataimhihihi_h[ix]   = 0.0;
      dataimlohihi_h[ix]   = 0.0;
      dataimhilohi_h[ix]   = 0.0;
      dataimlolohi_h[ix]   = 0.0;
      dataimhihilo_h[ix]   = 0.0;
      dataimlohilo_h[ix]   = 0.0;
      dataimhilolo_h[ix]   = 0.0;
      dataimlololo_h[ix++] = 0.0;
   }
   for(int i=0; i<nbr; i++)
      for(int j=0; j<deg1; j++)
      {
         datarehihihi_h[ix]   = cffrehihihi[i][j];
         datarelohihi_h[ix]   = cffrelohihi[i][j];
         datarehilohi_h[ix]   = cffrehilohi[i][j];
         datarelolohi_h[ix]   = cffrelolohi[i][j];
         datarehihilo_h[ix]   = cffrehihilo[i][j];
         datarelohilo_h[ix]   = cffrelohilo[i][j];
         datarehilolo_h[ix]   = cffrehilolo[i][j];
         datarelololo_h[ix]   = cffrelololo[i][j];
         dataimhihihi_h[ix]   = cffimhihihi[i][j];
         dataimlohihi_h[ix]   = cffimlohihi[i][j];
         dataimhilohi_h[ix]   = cffimhilohi[i][j];
         dataimlolohi_h[ix]   = cffimlolohi[i][j];
         dataimhihilo_h[ix]   = cffimhihilo[i][j];
         dataimlohilo_h[ix]   = cffimlohilo[i][j];
         dataimhilolo_h[ix]   = cffimhilolo[i][j];
         dataimlololo_h[ix++] = cffimlololo[i][j];
      }
   for(int i=0; i<dim; i++)
      for(int j=0; j<deg1; j++)
      {
         datarehihihi_h[ix]   = inputrehihihi[i][j];
         datarelohihi_h[ix]   = inputrelohihi[i][j];
         datarehilohi_h[ix]   = inputrehilohi[i][j];
         datarelolohi_h[ix]   = inputrelolohi[i][j];
         datarehihilo_h[ix]   = inputrehihilo[i][j];
         datarelohilo_h[ix]   = inputrelohilo[i][j];
         datarehilolo_h[ix]   = inputrehilolo[i][j];
         datarelololo_h[ix]   = inputrelololo[i][j];
         dataimhihihi_h[ix]   = inputimhihihi[i][j];
         dataimlohihi_h[ix]   = inputimlohihi[i][j];
         dataimhilohi_h[ix]   = inputimhilohi[i][j];
         dataimlolohi_h[ix]   = inputimlolohi[i][j];
         dataimhihilo_h[ix]   = inputimhihilo[i][j];
         dataimlohilo_h[ix]   = inputimlohilo[i][j];
         dataimhilolo_h[ix]   = inputimhilolo[i][j];
         dataimlololo_h[ix++] = inputimlololo[i][j];
      }

   double *datarehihihi_d;                   // device real data
   double *datarelohihi_d;
   double *datarehilohi_d;
   double *datarelolohi_d;
   double *datarehihilo_d;
   double *datarelohilo_d;
   double *datarehilolo_d;
   double *datarelololo_d;
   double *dataimhihihi_d;                   // device imag data
   double *dataimlohihi_d;
   double *dataimhilohi_d;
   double *dataimlolohi_d;
   double *dataimhihilo_d;
   double *dataimlohilo_d;
   double *dataimhilolo_d;
   double *dataimlololo_d;
   const size_t szdata = totalcff*sizeof(double);
   cudaMalloc((void**)&datarehihihi_d,szdata);
   cudaMalloc((void**)&datarelohihi_d,szdata);
   cudaMalloc((void**)&datarehilohi_d,szdata);
   cudaMalloc((void**)&datarelolohi_d,szdata);
   cudaMalloc((void**)&datarehihilo_d,szdata);
   cudaMalloc((void**)&datarelohilo_d,szdata);
   cudaMalloc((void**)&datarehilolo_d,szdata);
   cudaMalloc((void**)&datarelololo_d,szdata);
   cudaMalloc((void**)&dataimhihihi_d,szdata);
   cudaMalloc((void**)&dataimlohihi_d,szdata);
   cudaMalloc((void**)&dataimhilohi_d,szdata);
   cudaMalloc((void**)&dataimlolohi_d,szdata);
   cudaMalloc((void**)&dataimhihilo_d,szdata);
   cudaMalloc((void**)&dataimlohilo_d,szdata);
   cudaMalloc((void**)&dataimhilolo_d,szdata);
   cudaMalloc((void**)&dataimlololo_d,szdata);
   cudaMemcpy(datarehihihi_d,datarehihihi_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(datarelohihi_d,datarelohihi_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(datarehilohi_d,datarehilohi_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(datarelolohi_d,datarelolohi_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(datarehihilo_d,datarehihilo_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(datarelohilo_d,datarelohilo_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(datarehilolo_d,datarehilolo_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(datarelololo_d,datarelololo_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(dataimhihihi_d,dataimhihihi_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(dataimlohihi_d,dataimlohihi_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(dataimhilohi_d,dataimhilohi_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(dataimlolohi_d,dataimlolohi_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(dataimhihilo_d,dataimhihilo_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(dataimlohilo_d,dataimlohilo_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(dataimhilolo_d,dataimhilolo_h,szdata,cudaMemcpyHostToDevice);
   cudaMemcpy(dataimlololo_d,dataimlololo_h,szdata,cudaMemcpyHostToDevice);

   cudaEvent_t start,stop;           // to measure time spent by kernels 
   cudaEventCreate(&start);
   cudaEventCreate(&stop);
   *cnvlapms = 0.0;
   float milliseconds;
   struct timeval begintime,endtime; // wall clock time of computations

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

         cmplx8_padded_convjobs<<<jobnbr,deg1>>>
            (datarehihihi_d,datarelohihi_d,datarehilohi_d,datarelolohi_d,
             datarehihilo_d,datarelohilo_d,datarehilolo_d,datarelololo_d,
             dataimhihihi_d,dataimlohihi_d,dataimhilohi_d,dataimlolohi_d,
             dataimhihilo_d,dataimlohilo_d,dataimhilolo_d,dataimlololo_d,
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
   cudaMemcpy(datarehihihi_h,datarehihihi_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(datarelohihi_h,datarelohihi_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(datarehilohi_h,datarehilohi_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(datarelolohi_h,datarelolohi_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(datarehihilo_h,datarehihilo_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(datarelohilo_h,datarelohilo_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(datarehilolo_h,datarehilolo_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(datarelololo_h,datarelololo_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(dataimhihihi_h,dataimhihihi_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(dataimlohihi_h,dataimlohihi_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(dataimhilohi_h,dataimhilohi_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(dataimlolohi_h,dataimlolohi_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(dataimhihilo_h,dataimhihilo_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(dataimlohilo_h,dataimlohilo_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(dataimhilolo_h,dataimhilolo_d,szdata,cudaMemcpyDeviceToHost);
   cudaMemcpy(dataimlololo_h,dataimlololo_d,szdata,cudaMemcpyDeviceToHost);
   *elapsedms = *cnvlapms;
   long seconds = endtime.tv_sec - begintime.tv_sec;
   long microseconds = endtime.tv_usec - begintime.tv_usec;
   *walltimesec = seconds + microseconds*1.0e-6;

   cmplx8_evaldiffdata_to_output
      (datarehihihi_h,datarelohihi_h,datarehilohi_h,datarelolohi_h,
       datarehihilo_h,datarelohilo_h,datarehilolo_h,datarelololo_h,
       dataimhihihi_h,dataimlohihi_h,dataimhilohi_h,dataimlolohi_h,
       dataimhihilo_h,dataimlohilo_h,dataimhilolo_h,dataimlololo_h,
       outputrehihihi,outputrelohihi,outputrehilohi,outputrelolohi,
       outputrehihilo,outputrelohilo,outputrehilolo,outputrelololo,
       outputimhihihi,outputimlohihi,outputimhilohi,outputimlolohi,
       outputimhihilo,outputimlohilo,outputimhilolo,outputimlololo,
       dim,nbr,deg,nvr,idx,fstart,bstart,cstart,verbose);

   if(verbose)
      write_GPU_timings(*cnvlapms,0.0,*elapsedms,*walltimesec);

   cudaFree(datarehihihi_d); cudaFree(datarelohihi_d);
   cudaFree(datarehilohi_d); cudaFree(datarelolohi_d);
   cudaFree(datarehihilo_d); cudaFree(datarelohilo_d);
   cudaFree(datarehilolo_d); cudaFree(datarelololo_d);
   cudaFree(dataimhihihi_d); cudaFree(dataimlohihi_d);
   cudaFree(dataimhilohi_d); cudaFree(dataimlolohi_d);
   cudaFree(dataimhihilo_d); cudaFree(dataimlohilo_d);
   cudaFree(dataimhilolo_d); cudaFree(dataimlololo_d);

   free(datarehihihi_h); free(datarelohihi_h);
   free(datarehilohi_h); free(datarelolohi_h);
   free(datarehihilo_h); free(datarelohilo_h);
   free(datarehilolo_h); free(datarelololo_h);
   free(dataimhihihi_h); free(dataimlohihi_h);
   free(dataimhilohi_h); free(dataimlolohi_h);
   free(dataimhihilo_h); free(dataimlohilo_h);
   free(dataimhilolo_h); free(dataimlololo_h);

   free(fstart); free(bstart); free(cstart);
   free(fsums); free(bsums); free(csums);
}

void GPU_dbl8_evaluate_monomials
 ( int dim, int deg, int szt, int nbt,
   int *nvr, int **idx, int **exp, int *nbrfac, int **expfac,
   double **cffhihihi, double **cfflohihi,
   double **cffhilohi, double **cfflolohi,
   double **cffhihilo, double **cfflohilo,
   double **cffhilolo, double **cfflololo,
   double *acchihihi, double *acclohihi, double *acchilohi, double *acclolohi,
   double *acchihilo, double *acclohilo, double *acchilolo, double *acclololo,
   double **inputhihihi, double **inputlohihi,
   double **inputhilohi, double **inputlolohi,
   double **inputhihilo, double **inputlohilo,
   double **inputhilolo, double **inputlololo,
   double ***outputhihihi, double ***outputlohihi,
   double ***outputhilohi, double ***outputlolohi,
   double ***outputhihilo, double ***outputlohilo,
   double ***outputhilolo, double ***outputlololo, int vrblvl )
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
                  CPU_dbl8_product
                     (deg,inputhihihi[idxvar],inputlohihi[idxvar],
                          inputhilohi[idxvar],inputlolohi[idxvar],
                          inputhihilo[idxvar],inputlohilo[idxvar],
                          inputhilolo[idxvar],inputlololo[idxvar],
                      cffhihihi[i],cfflohihi[i],cffhilohi[i],cfflolohi[i],
                      cffhihilo[i],cfflohilo[i],cffhilolo[i],cfflololo[i],
                      acchihihi,acclohihi,acchilohi,acclolohi,
                      acchihilo,acclohilo,acchilolo,acclololo);

                  for(int L=0; L<=deg; L++)
                  {
                     cffhihihi[i][L] = acchihihi[L];
                     cfflohihi[i][L] = acclohihi[L];
                     cffhilohi[i][L] = acchilohi[L];
                     cfflolohi[i][L] = acclolohi[L];
                     cffhihilo[i][L] = acchihilo[L];
                     cfflohilo[i][L] = acclohilo[L];
                     cffhilolo[i][L] = acchilolo[L];
                     cfflololo[i][L] = acclololo[L];
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
            cout << cffhihihi[i][j] << "  " << cfflohihi[i][j] << endl;
            cout << cffhilohi[i][j] << "  " << cfflolohi[i][j] << endl;
            cout << cffhihilo[i][j] << "  " << cfflohilo[i][j] << endl;
            cout << cffhilolo[i][j] << "  " << cfflololo[i][j] << endl;
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
            cout << inputhihihi[i][j] << "  " << inputlohihi[i][j] << endl;
            cout << inputhilohi[i][j] << "  " << inputlolohi[i][j] << endl;
            cout << inputhihilo[i][j] << "  " << inputlohilo[i][j] << endl;
            cout << inputhilolo[i][j] << "  " << inputlololo[i][j] << endl;
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
   GPU_dbl8_mon_evaldiff
      (szt,dim,dim,deg,nvr,idx,
       cffhihihi,cfflohihi,cffhilohi,cfflolohi,
       cffhihilo,cfflohilo,cffhilolo,cfflololo,
       inputhihihi,inputlohihi,inputhilohi,inputlolohi,
       inputhihilo,inputlohilo,inputhilolo,inputlololo,
       outputhihihi,outputlohihi,outputhilohi,outputlolohi,
       outputhihilo,outputlohilo,outputhilolo,outputlololo,jobs,
       &cnvlapms,&elapsedms,&walltimesec,verbose);

   if(vrblvl > 1)
   {
      for(int i=0; i<dim; i++)
      {
         cout << "output series for monomial " << i << " :" << endl;
         for(int j=0; j<=deg; j++)
         {
            cout << outputhihihi[i][dim][j] << "  "
                 << outputlohihi[i][dim][j] << endl;
            cout << outputhilohi[i][dim][j] << "  "
                 << outputlolohi[i][dim][j] << endl;
            cout << outputhihilo[i][dim][j] << "  "
                 << outputlohilo[i][dim][j] << endl;
            cout << outputhilolo[i][dim][j] << "  "
                 << outputlololo[i][dim][j] << endl;
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
               double fac = (double) exp[i][j];
               double acchihihi,acclohihi,acchilohi,acclolohi;
               double acchihilo,acclohilo,acchilolo,acclololo;

               // multiply derivative w.r.t. idxvar with factor
               for(int k=0; k<=deg; k++)
               {
                  // output[i][idxvar][k] = factor*output[i][idxvar][k];
                  odf_mul(outputhihihi[i][idxvar][k],
                          outputlohihi[i][idxvar][k],
                          outputhilohi[i][idxvar][k],
                          outputlolohi[i][idxvar][k],
                          outputhihilo[i][idxvar][k],
                          outputlohilo[i][idxvar][k],
                          outputhilolo[i][idxvar][k],
                          outputlololo[i][idxvar][k],
                          fac,0.0,0.0,0.0,0.0,0.0,0.0,0.0,
                          &acchihihi,&acclohihi,&acchilohi,&acclolohi,
                          &acchihilo,&acclohilo,&acchilolo,&acclololo);
                  outputhihihi[i][idxvar][k] = acchihihi;
                  outputlohihi[i][idxvar][k] = acclohihi;
                  outputhilohi[i][idxvar][k] = acchilohi;
                  outputlolohi[i][idxvar][k] = acclolohi;
                  outputhihilo[i][idxvar][k] = acchihilo;
                  outputlohilo[i][idxvar][k] = acclohilo;
                  outputhilolo[i][idxvar][k] = acchilolo;
                  outputlololo[i][idxvar][k] = acclololo;
               }
            }
         }
      }
   }
}

void GPU_cmplx8_evaluate_monomials
 ( int dim, int deg, int szt, int nbt,
   int *nvr, int **idx, int **exp, int *nbrfac, int **expfac,
   double **cffrehihihi, double **cffrelohihi,
   double **cffrehilohi, double **cffrelolohi,
   double **cffrehihilo, double **cffrelohilo,
   double **cffrehilolo, double **cffrelololo,
   double **cffimhihihi, double **cffimlohihi,
   double **cffimhilohi, double **cffimlolohi,
   double **cffimhihilo, double **cffimlohilo,
   double **cffimhilolo, double **cffimlololo,
   double *accrehihihi, double *accrelohihi,
   double *accrehilohi, double *accrelolohi,
   double *accrehihilo, double *accrelohilo,
   double *accrehilolo, double *accrelololo,
   double *accimhihihi, double *accimlohihi,
   double *accimhilohi, double *accimlolohi,
   double *accimhihilo, double *accimlohilo,
   double *accimhilolo, double *accimlololo,
   double **inputrehihihi, double **inputrelohihi,
   double **inputrehilohi, double **inputrelolohi,
   double **inputrehihilo, double **inputrelohilo,
   double **inputrehilolo, double **inputrelololo,
   double **inputimhihihi, double **inputimlohihi, 
   double **inputimhilohi, double **inputimlolohi, 
   double **inputimhihilo, double **inputimlohilo, 
   double **inputimhilolo, double **inputimlololo, 
   double ***outputrehihihi, double ***outputrelohihi, 
   double ***outputrehilohi, double ***outputrelolohi, 
   double ***outputrehihilo, double ***outputrelohilo, 
   double ***outputrehilolo, double ***outputrelololo, 
   double ***outputimhihihi, double ***outputimlohihi,
   double ***outputimhilohi, double ***outputimlolohi,
   double ***outputimhihilo, double ***outputimlohilo,
   double ***outputimhilolo, double ***outputimlololo, int vrblvl )
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
                  CPU_cmplx8_product
                     (deg,inputrehihihi[idxvar],inputrelohihi[idxvar],
                          inputrehilohi[idxvar],inputrelolohi[idxvar],
                          inputrehihilo[idxvar],inputrelohilo[idxvar],
                          inputrehilolo[idxvar],inputrelololo[idxvar],
                          inputimhihihi[idxvar],inputimlohihi[idxvar],
                          inputimhilohi[idxvar],inputimlolohi[idxvar],
                          inputimhihilo[idxvar],inputimlohilo[idxvar],
                          inputimhilolo[idxvar],inputimlololo[idxvar],
                      cffrehihihi[i],cffrelohihi[i],
                      cffrehilohi[i],cffrelolohi[i],
                      cffrehihilo[i],cffrelohilo[i],
                      cffrehilolo[i],cffrelololo[i],
                      cffimhihihi[i],cffimlohihi[i],
                      cffimhilohi[i],cffimlolohi[i],
                      cffimhihilo[i],cffimlohilo[i],
                      cffimhilolo[i],cffimlololo[i],
                      accrehihihi,accrelohihi,accrehilohi,accrelolohi,
                      accrehihilo,accrelohilo,accrehilolo,accrelololo,
                      accimhihihi,accimlohihi,accimhilohi,accimlolohi,
                      accimhihilo,accimlohilo,accimhilolo,accimlololo);

                  for(int L=0; L<=deg; L++)
                  {
                     cffrehihihi[i][L] = accrehihihi[L];
                     cffrelohihi[i][L] = accrelohihi[L];
                     cffrehilohi[i][L] = accrehilohi[L];
                     cffrelolohi[i][L] = accrelolohi[L];
                     cffrehihilo[i][L] = accrehihilo[L];
                     cffrelohilo[i][L] = accrelohilo[L];
                     cffrehilolo[i][L] = accrehilolo[L];
                     cffrelololo[i][L] = accrelololo[L];
                     cffimhihihi[i][L] = accimhihihi[L];
                     cffimlohihi[i][L] = accimlohihi[L];
                     cffimhilohi[i][L] = accimhilohi[L];
                     cffimlolohi[i][L] = accimlolohi[L];
                     cffimhihilo[i][L] = accimhihilo[L];
                     cffimlohilo[i][L] = accimlohilo[L];
                     cffimhilolo[i][L] = accimhilolo[L];
                     cffimlololo[i][L] = accimlololo[L];
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
            cout << cffrehihihi[i][j] << "  " << cffrelohihi[i][j] << endl
                 << "  "
                 << cffrehilohi[i][j] << "  " << cffrelolohi[i][j] << endl
                 << "  "
                 << cffrehihilo[i][j] << "  " << cffrelohilo[i][j] << endl
                 << "  "
                 << cffrehilolo[i][j] << "  " << cffrelololo[i][j] << endl
                 << "  "
                 << cffimhihihi[i][j] << "  " << cffimlohihi[i][j] << endl
                 << "  "
                 << cffimhilohi[i][j] << "  " << cffimlolohi[i][j] << endl
                 << "  "
                 << cffimhihilo[i][j] << "  " << cffimlohilo[i][j] << endl
                 << "  "
                 << cffimhilolo[i][j] << "  " << cffimlololo[i][j] << endl;
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
            cout << inputrehihihi[i][j] << "  " << inputrelohihi[i][j] << endl
                 << "  "
                 << inputrehilohi[i][j] << "  " << inputrelolohi[i][j] << endl
                 << "  "
                 << inputrehihilo[i][j] << "  " << inputrelohilo[i][j] << endl
                 << "  "
                 << inputrehilolo[i][j] << "  " << inputrelololo[i][j] << endl
                 << "  "
                 << inputimhihihi[i][j] << "  " << inputimlohihi[i][j] << endl
                 << "  "
                 << inputimhilohi[i][j] << "  " << inputimlolohi[i][j] << endl
                 << "  "
                 << inputimhihilo[i][j] << "  " << inputimlohilo[i][j] << endl
                 << "  "
                 << inputimhilolo[i][j] << "  " << inputimlololo[i][j] << endl;
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
   GPU_cmplx8_mon_evaldiff
      (szt,dim,dim,deg,nvr,idx,
       cffrehihihi,cffrelohihi,cffrehilohi,cffrelolohi,
       cffrehihilo,cffrelohilo,cffrehilolo,cffrelololo,
       cffimhihihi,cffimlohihi,cffimhilohi,cffimlolohi,
       cffimhihilo,cffimlohilo,cffimhilolo,cffimlololo,
       inputrehihihi,inputrelohihi,inputrehilohi,inputrelolohi,
       inputrehihilo,inputrelohilo,inputrehilolo,inputrelololo,
       inputimhihihi,inputimlohihi,inputimhilohi,inputimlolohi,
       inputimhihilo,inputimlohilo,inputimhilolo,inputimlololo,
       outputrehihihi,outputrelohihi,outputrehilohi,outputrelolohi,
       outputrehihilo,outputrelohilo,outputrehilolo,outputrelololo,
       outputimhihihi,outputimlohihi,outputimhilohi,outputimlolohi,
       outputimhihilo,outputimlohilo,outputimhilolo,outputimlololo,jobs,
       &cnvlapms,&elapsedms,&walltimesec,verbose);

   if(vrblvl > 1)
   {
      for(int i=0; i<dim; i++)
      {
         cout << "output series for monomial " << i << " :" << endl;
         for(int j=0; j<=deg; j++)
            cout << outputrehihihi[i][dim][j] << "  "
                 << outputrelohihi[i][dim][j] << endl << "  " 
                 << outputrehilohi[i][dim][j] << "  "
                 << outputrelolohi[i][dim][j] << endl << "  " 
                 << outputrehihilo[i][dim][j] << "  "
                 << outputrelohilo[i][dim][j] << endl << "  " 
                 << outputrehilolo[i][dim][j] << "  "
                 << outputrelololo[i][dim][j] << endl << "  " 
                 << outputimhihihi[i][dim][j] << "  "
                 << outputimlohihi[i][dim][j] << endl << "  "
                 << outputimhilohi[i][dim][j] << "  "
                 << outputimlolohi[i][dim][j] << endl << "  "
                 << outputimhihilo[i][dim][j] << "  "
                 << outputimlohilo[i][dim][j] << endl << "  "
                 << outputimhilolo[i][dim][j] << "  "
                 << outputimlololo[i][dim][j] << endl;
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
               double acchihihi,acclohihi,acchilohi,acclolohi;
               double acchihilo,acclohilo,acchilolo,acclololo;

               // multiply derivative w.r.t. idxvar with factor
               for(int k=0; k<=deg; k++)
               {
                  // outputre[i][idxvar][k] = fac*outputre[i][idxvar][k];
                  odf_mul(outputrehihihi[i][idxvar][k],
                          outputrelohihi[i][idxvar][k],
                          outputrehilohi[i][idxvar][k],
                          outputrelolohi[i][idxvar][k],
                          outputrehihilo[i][idxvar][k],
                          outputrelohilo[i][idxvar][k],
                          outputrehilolo[i][idxvar][k],
                          outputrelololo[i][idxvar][k],
                          fac,0.0,0.0,0.0,0.0,0.0,0.0,0.0,
                          &acchihihi,&acclohihi,&acchilohi,&acclolohi,
                          &acchihilo,&acclohilo,&acchilolo,&acclololo);
                  outputrehihihi[i][idxvar][k] = acchihihi;
                  outputrelohihi[i][idxvar][k] = acclohihi;
                  outputrehilohi[i][idxvar][k] = acchilohi;
                  outputrelolohi[i][idxvar][k] = acclolohi;
                  outputrehihilo[i][idxvar][k] = acchihilo;
                  outputrelohilo[i][idxvar][k] = acclohilo;
                  outputrehilolo[i][idxvar][k] = acchilolo;
                  outputrelololo[i][idxvar][k] = acclololo;
                  // outputim[i][idxvar][k] = fac*outputim[i][idxvar][k];
                  odf_mul(outputimhihihi[i][idxvar][k],
                          outputimlohihi[i][idxvar][k],
                          outputimhilohi[i][idxvar][k],
                          outputimlolohi[i][idxvar][k],
                          outputimhihilo[i][idxvar][k],
                          outputimlohilo[i][idxvar][k],
                          outputimhilolo[i][idxvar][k],
                          outputimlololo[i][idxvar][k],
                          fac,0.0,0.0,0.0,0.0,0.0,0.0,0.0,
                          &acchihihi,&acclohihi,&acchilohi,&acclolohi,
                          &acchihilo,&acclohilo,&acchilolo,&acclololo);
                  outputimhihihi[i][idxvar][k] = acchihihi;
                  outputimlohihi[i][idxvar][k] = acclohihi;
                  outputimhilohi[i][idxvar][k] = acchilohi;
                  outputimlolohi[i][idxvar][k] = acclolohi;
                  outputimhihilo[i][idxvar][k] = acchihilo;
                  outputimlohilo[i][idxvar][k] = acclohilo;
                  outputimhilolo[i][idxvar][k] = acchilolo;
                  outputimlololo[i][idxvar][k] = acclololo;
               }
            }
         }
      }
   }
}
