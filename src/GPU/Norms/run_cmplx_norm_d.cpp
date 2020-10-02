/* This is the main program to run manual tests,
   with four input parameters at the command line.

For example, typing at the command prompt
  ./run_cmplx_norm_d 64 64 1 2
computes the norm once with 64 threads in a block,
of a vector of dimension 64, on both GPU and CPU,
and applies this norm to normalize a random vector.
As all complex numbers are on the complex unit circle,
the 2-norm of a vector of dimension 64 equals 8.
If the dimension is 256, then the 2-norm is 16.

Including the vector_types.h is needed for the include of
the headers for the cmplx_norm_kernels. */

#include <ctime>
#include <iostream>
#include <iomanip>
#include <cstdlib>
#include <cmath>
#include <vector_types.h>
#include "cmplx_norm_kernels.h"
#include "cmplx_norm_host.h"
#include "random_vectors.h"

using namespace std;

int parse_arguments
 ( int argc, char *argv[], int *blocksize, int *dim, int *freq, int *mode );
/*
   Parses the argc arguments on the command line in argv[].
   Returns 0 if four numbers are given, 1 otherwise for failure.

   ON RETURN :
     blocksize  the block size, number of threads in a block;
     dim        dimension of the vectors;
     freq       frequency of the runs;
     mode       execution mode is 0, 1, or 2
                0 : GPU run, no output,
                1 : CPU run, no output,
                2 : both GPU and CPU run with output. */

int main ( int argc, char *argv[] )
{
   // initialization of the execution parameters

   int BS,dim,freq,mode;
   if(parse_arguments(argc,argv,&BS,&dim,&freq,&mode) == 1) return 1;

   int timevalue;
   if(mode == 2)
      timevalue = time(NULL); // no fixed seed to verify correctness
   else
      timevalue = 1287178355; // fixed seed for timings
   srand(timevalue);

   double* vre_host = new double[dim];   // real parts of vector on the host
   double* vim_host = new double[dim];   // imaginary parts on host
   double* wre_host = new double[dim];   // a copy for normalization
   double* wim_host = new double[dim];
   double* vre_device = new double[dim]; // real parts of vector on the device
   double* vim_device = new double[dim]; // imaginary parts on device

   random_complex_vectors(dim,vre_host,vim_host,vre_device,vim_device);

   double vnorm_device,wnorm_device;
   double vnorm_host,wnorm_host;

   if(mode==0 || mode==2) // GPU computation of the norm
   {
      GPU_norm(vre_device,vim_device,dim,1,BS,&vnorm_device);
      GPU_norm(vre_device,vim_device,dim,freq,BS,&wnorm_device);
   }

   if(mode==1 || mode==2) // CPU computation of the norm
      for(int i=0; i<=freq; i++)
      {
         CPU_norm(vre_host,vim_host,dim,&vnorm_host);
         make_copy(dim,vre_host,vim_host,wre_host,wim_host);
         CPU_normalize(wre_host,wim_host,dim,vnorm_host);
         CPU_norm(wre_host,wim_host,dim,&wnorm_host);
      }

   if(mode == 2) // GPU vs CPU correctness verification
   {
      cout << scientific << setprecision(16);
      cout << "GPU norm : " << vnorm_device << endl;
      cout << "GPU norm after normalization : " << wnorm_device << endl;
      cout << "CPU norm : " << vnorm_host << endl;
      cout << "CPU norm after normalization : " << wnorm_host << endl;
   }

   return 0;
}

int parse_arguments
 ( int argc, char *argv[], int *blocksize, int *dim, int *freq, int *mode )
{
   if(argc < 5)
   {
      cout << argv[0] << " needs four parameters, for example:" << endl;
      cout << argv[0] << " blocksize dim freq mode" << endl;
      cout << " where blocksize is the number of threads in a block," << endl;
      cout << "       dim is the dimension of the problem," << endl;
      cout << "       freq is the number of repeated runs, and" << endl;
      cout << "       mode is 0, 1, or 2 for execution mode." << endl;
      cout << "Please try again ..." << endl;

      return 1;
   }
   else
   {
      *blocksize = atoi(argv[1]);  // number of threads in a block
      *dim = atoi(argv[2]);        // dimension
      *freq = atoi(argv[3]);       // number of repeated runs
      *mode = atoi(argv[4]);       // execution mode

      return 0;
   }
}
