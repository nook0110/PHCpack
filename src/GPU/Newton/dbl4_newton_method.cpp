// The file dbl4_newton_method.cpp defines the functions with prototypes in
// the file dbl4_newton_method.h.

#include <iostream>
#include <iomanip>
#include <cstdlib>
#include <cmath>
#include <vector_types.h>
#include <time.h>
#ifdef winwalltime
#include "gettimeofday4win.h"
#else
#include <sys/time.h>
#endif
#include "unimodular_matrices.h"
#include "random_numbers.h"
#include "random_monomials.h"
#include "quad_double_functions.h"
#include "dbl4_convolutions_host.h"
#include "dbl4_monomials_host.h"
#include "dbl4_factorizations.h"
#include "dbl4_monomial_systems.h"
#include "dbl4_bals_host.h"
#include "dbl4_bals_kernels.h"
#include "dbl4_tail_kernels.h"
#include "dbl4_systems_host.h"
#include "dbl4_systems_kernels.h"
#include "dbl4_newton_testers.h"

using namespace std;

void dbl4_column_newton_qrstep
 ( int szt, int nbt, int dim, int deg, int nbrcol,
   int *tailidx_h, int *tailidx_d,
   int **nvr, int ***idx, int **exp, int *nbrfac, int **expfac,
   double **mbhihi, double **mblohi, double **mbhilo, double **mblolo,
   double dpr,
   double ***cffhihi, double ***cfflohi, double ***cffhilo, double ***cfflolo,
   double **acchihi, double **acclohi, double **acchilo, double **acclolo,
   double **inputhihi_h, double **inputlohi_h,
   double **inputhilo_h, double **inputlolo_h,
   double **inputhihi_d, double **inputlohi_d,
   double **inputhilo_d, double **inputlolo_d,
   double ***outputhihi_h, double ***outputlohi_h,
   double ***outputhilo_h, double ***outputlolo_h,
   double ***outputhihi_d, double ***outputlohi_d,
   double ***outputhilo_d, double ***outputlolo_d,
   double **funvalhihi_h, double **funvallohi_h,
   double **funvalhilo_h, double **funvallolo_h,
   double **funvalhihi_d, double **funvallohi_d,
   double **funvalhilo_d, double **funvallolo_d,
   double ***jacvalhihi_h, double ***jacvallohi_h,
   double ***jacvalhilo_h, double ***jacvallolo_h,
   double ***jacvalhihi_d, double ***jacvallohi_d,
   double ***jacvalhilo_d, double ***jacvallolo_d,
   double **rhshihi_h, double **rhslohi_h,
   double **rhshilo_h, double **rhslolo_h,
   double **rhshihi_d, double **rhslohi_d,
   double **rhshilo_d, double **rhslolo_d,
   double **urhshihi_h, double **urhslohi_h,
   double **urhshilo_h, double **urhslolo_h,
   double **urhshihi_d, double **urhslohi_d,
   double **urhshilo_d, double **urhslolo_d,
   double **solhihi_h, double **sollohi_h,
   double **solhilo_h, double **sollolo_h,
   double **solhihi_d, double **sollohi_d,
   double **solhilo_d, double **sollolo_d,
   double **Qhihi_h, double **Qlohi_h, double **Qhilo_h, double **Qlolo_h,
   double **Qhihi_d, double **Qlohi_d, double **Qhilo_d, double **Qlolo_d,
   double **Rhihi_h, double **Rlohi_h, double **Rhilo_h, double **Rlolo_h,
   double **Rhihi_d, double **Rlohi_d, double **Rhilo_d, double **Rlolo_d,
   double **workmathihi, double **workmatlohi,
   double **workmathilo, double **workmatlolo,
   double *workvechihi, double *workveclohi,
   double *workvechilo, double *workveclolo,
   double **resvechihi, double **resveclohi, 
   double **resvechilo, double **resveclolo, 
   double *resmaxhihi, double *resmaxlohi,
   double *resmaxhilo, double *resmaxlolo,
   bool *zeroQ_h, bool *noqr_h, bool *zeroQ_d, bool *noqr_d,
   int *upidx_h, int *bsidx_h, int *upidx_d, int *bsidx_d,
   double *totcnvlapsedms, double *totqrlapsedms, double *totqtblapsedms, 
   double *totbslapsedms, double *totupdlapsedms, double *totreslapsedms,
   int vrblvl, int mode )
{
   const int degp1 = deg+1;

   if((mode == 1) || (mode == 2))
   {
      if(vrblvl > 0)
         cout << "calling CPU_dbl4_evaluate_monomials ..." << endl;

      if(nbrcol == 1)
      {
         dbl4_unit_series_vector
            (dim,deg,cffhihi[0],cfflohi[0],cffhilo[0],cfflolo[0]);
         // The series coefficients accumulate common factors,
         // initially the coefficients are set to one.

         CPU_dbl4_evaluate_monomials
            (dim,deg,nvr[0],idx[0],exp,nbrfac,expfac,
             cffhihi[0],cfflohi[0],cffhilo[0],cfflolo[0],
             acchihi[0],acclohi[0],acchilo[0],acclolo[0],
             inputhihi_h,inputlohi_h,inputhilo_h,inputlolo_h,
             outputhihi_h,outputlohi_h,outputhilo_h,outputlolo_h,vrblvl);
      }
      else
         CPU_dbl4_evaluate_columns
            (dim,deg,nbrcol,nvr,idx,
             cffhihi,cfflohi,cffhilo,cfflolo,acchihi,acclohi,acchilo,acclolo,
             inputhihi_h,inputlohi_h,inputhilo_h,inputlolo_h,
             funvalhihi_h,funvallohi_h,funvalhilo_h,funvallolo_h,
             jacvalhihi_h,jacvallohi_h,jacvalhilo_h,jacvallolo_h,vrblvl);
   }
   if((mode == 0) || (mode == 2))
   {
      if(vrblvl > 0)
         cout << "calling GPU_dbl4_evaluate_monomials ..." << endl;

      if(nbrcol == 1)
      {
         dbl4_unit_series_vector
            (dim,deg,cffhihi[0],cfflohi[0],cffhilo[0],cfflolo[0]);
         // reset the coefficients

         GPU_dbl4_evaluate_monomials
            (dim,deg,szt,nbt,nvr[0],idx[0],exp,nbrfac,expfac,
             cffhihi[0],cfflohi[0],cffhilo[0],cfflolo[0],
             acchihi[0],acclohi[0],acchilo[0],acclolo[0],
             inputhihi_d,inputlohi_d,inputhilo_d,inputlolo_d,
             outputhihi_d,outputlohi_d,outputhilo_d,outputlolo_d,
             totcnvlapsedms,vrblvl);
      }
      else
         GPU_dbl4_evaluate_columns
            (dim,deg,nbrcol,szt,nbt,nvr,idx,
             cffhihi,cfflohi,cffhilo,cfflolo,
             inputhihi_d,inputlohi_d,inputhilo_d,inputlolo_d,
             outputhihi_d,outputlohi_d,outputhilo_d,outputlolo_d,
             funvalhihi_d,funvallohi_d,funvalhilo_d,funvallolo_d,
             jacvalhihi_d,jacvallohi_d,jacvalhilo_d,jacvallolo_d,
             totcnvlapsedms,vrblvl);
   }
   if((vrblvl > 0) && (mode == 2) && (nbrcol == 1))
   {
      double errsum = 0.0;

      cout << "comparing CPU with GPU evaluations ... " << endl;

      errsum = dbl4_error3sum(dim,dim+1,degp1,
                  outputhihi_h,outputlohi_h,outputhilo_h,outputlolo_h,
                  outputhihi_d,outputlohi_d,outputhilo_d,outputlolo_d,
                  "output",vrblvl);
      // first dim is the number of monomials,
      // dim+1 is number of variables for each derivative,
      // plus the last component with the function value

      cout << scientific << setprecision(3);
      cout << "sum of errors : " << errsum << endl;
   }
   if(vrblvl > 0) cout << "initializing the Jacobian ..." << endl;

   if((mode == 1) || (mode == 2))
   {
      if(nbrcol != 1)
         dbl4_define_rhs
            (dim,degp1,mbhihi,mblohi,mbhilo,mblolo,
             funvalhihi_h,funvallohi_h,funvalhilo_h,funvallolo_h,
             rhshihi_h,rhslohi_h,rhshilo_h,rhslolo_h,vrblvl);
      else
      {
         for(int i=0; i<degp1; i++) // initialize the Jacobian to zero
            for(int j=0; j<dim; j++) 
               for(int k=0; k<dim; k++)
               {
                  jacvalhihi_h[i][j][k] = 0.0; jacvallohi_h[i][j][k] = 0.0;
                  jacvalhilo_h[i][j][k] = 0.0; jacvallolo_h[i][j][k] = 0.0;
               }

         if(vrblvl > 0) cout << "linearizing the output ..." << endl;
         dbl4_linearize_evaldiff_output
            (dim,degp1,nvr[0],idx[0],mbhihi,mblohi,mbhilo,mblolo,dpr,
             outputhihi_h,outputlohi_h,outputhilo_h,outputlolo_h,
             funvalhihi_h,funvallohi_h,funvalhilo_h,funvallolo_h,
             rhshihi_h,rhslohi_h,rhshilo_h,rhslolo_h,
             jacvalhihi_h,jacvallohi_h,jacvalhilo_h,jacvallolo_h,vrblvl);
      }
   }
   if((mode == 0) || (mode == 2))
   {
      if(nbrcol != 1)
         dbl4_define_rhs
            (dim,degp1,mbhihi,mblohi,mbhilo,mblolo,
             funvalhihi_d,funvallohi_d,funvalhilo_d,funvallolo_d,
             rhshihi_d,rhslohi_d,rhshilo_d,rhslolo_d,vrblvl);
      else
      {
         for(int i=0; i<degp1; i++) // initialize the Jacobian to zero
            for(int j=0; j<dim; j++) 
               for(int k=0; k<dim; k++)
               {
                  jacvalhihi_d[i][j][k] = 0.0; jacvallohi_d[i][j][k] = 0.0;
                  jacvalhilo_d[i][j][k] = 0.0; jacvallolo_d[i][j][k] = 0.0;
               }

         if(vrblvl > 0) cout << "linearizing the output ..." << endl;
         dbl4_linearize_evaldiff_output
            (dim,degp1,nvr[0],idx[0],mbhihi,mblohi,mbhilo,mblolo,dpr,
             outputhihi_d,outputlohi_d,outputhilo_d,outputlolo_d,
             funvalhihi_d,funvallohi_d,funvalhilo_d,funvallolo_d,
             rhshihi_d,rhslohi_d,rhshilo_d,rhslolo_d,
             jacvalhihi_d,jacvallohi_d,jacvalhilo_d,jacvallolo_d,vrblvl);
      }
   }
   if((vrblvl > 0) && (mode == 2))
   {
      cout << scientific << setprecision(3);
      cout << "comparing CPU with GPU function values ... " << endl;
      double errsum = 0.0;
      errsum = dbl4_error2sum(dim,degp1,
                  funvalhihi_h,funvallohi_h,funvalhilo_h,funvallolo_h,
                  funvalhihi_d,funvallohi_d,funvalhilo_d,funvallolo_d,
                  "funval",vrblvl);
      cout << "sum of errors : " << errsum << endl;
      cout << "comparing CPU with GPU Jacobians ... " << endl;
      errsum = dbl4_error3sum(degp1,dim,dim,
                  jacvalhihi_h,jacvallohi_h,jacvalhilo_h,jacvallolo_h,
                  jacvalhihi_d,jacvallohi_d,jacvalhilo_d,jacvallolo_d,
                  "jacval",vrblvl);
      cout << "sum of errors : " << errsum << endl;
      cout << "comparing CPU with GPU right hand sides ... " << endl;
      errsum = dbl4_error2sum(degp1,dim,
                  rhshihi_h,rhslohi_h,rhshilo_h,rhslolo_h,
                  rhshihi_d,rhslohi_d,rhshilo_d,rhslolo_d,"rhs",vrblvl);
      cout << "sum of errors : " << errsum << endl;
   }
   if((mode == 1) || (mode == 2))
   {
      for(int i=0; i<degp1; i++) // save original rhs for residual
         for(int j=0; j<dim; j++)
         {
            urhshihi_h[i][j] = rhshihi_h[i][j];
            urhslohi_h[i][j] = rhslohi_h[i][j];
            urhshilo_h[i][j] = rhshilo_h[i][j];
            urhslolo_h[i][j] = rhslolo_h[i][j];
         }

      for(int i=0; i<degp1; i++) // initialize the solution to zero
         for(int j=0; j<dim; j++)
         {
            solhihi_h[i][j] = 0.0; sollohi_h[i][j] = 0.0;
            solhilo_h[i][j] = 0.0; sollolo_h[i][j] = 0.0;
         }
 
      if(vrblvl > 0) cout << "calling CPU_dbl4_qrbs_solve ..." << endl;

      int oldtail = *tailidx_h;
      int newtail = oldtail;

      CPU_dbl4_qrbs_solve
         (dim,degp1,oldtail,
          jacvalhihi_h,jacvallohi_h,jacvalhilo_h,jacvallolo_h,
          urhshihi_h,urhslohi_h,urhshilo_h,urhslolo_h,
          solhihi_h,sollohi_h,solhilo_h,sollolo_h,
          Qhihi_h,Qlohi_h,Qhilo_h,Qlolo_h,Rhihi_h,Rlohi_h,Rhilo_h,Rlolo_h,
          workvechihi,workveclohi,workvechilo,workveclolo,
          zeroQ_h,noqr_h,upidx_h,bsidx_h,&newtail,vrblvl);

      *tailidx_h = newtail;

      if(vrblvl > 0)
      {
         cout << "calling CPU_dbl4_linear_residue ..." << endl;

         CPU_dbl4_linear_residue
            (dim,degp1,*tailidx_h-1,
             jacvalhihi_h,jacvallohi_h,jacvalhilo_h,jacvallolo_h,
             rhshihi_h,rhslohi_h,rhshilo_h,rhslolo_h,
             solhihi_h,sollohi_h,solhilo_h,sollolo_h,
             resvechihi,resveclohi,resvechilo,resveclolo,
             resmaxhihi,resmaxlohi,resmaxhilo,resmaxlolo,vrblvl);

         cout << scientific << setprecision(3)
              << "maximum residual : " << *resmaxhihi << endl;
      }
      dbl4_update_series
         (dim,degp1,*tailidx_h-1,
          inputhihi_h,inputlohi_h,inputhilo_h,inputlolo_h,
          solhihi_h,sollohi_h,solhilo_h,sollolo_h,vrblvl);
   }
   if((mode == 0) || (mode == 2))
   {
      for(int i=0; i<degp1; i++) // save original rhs for residual
         for(int j=0; j<dim; j++)
         {
            urhshihi_d[i][j] = rhshihi_d[i][j];
            urhslohi_d[i][j] = rhslohi_d[i][j];
            urhshilo_d[i][j] = rhshilo_d[i][j];
            urhslolo_d[i][j] = rhslolo_d[i][j];
         }

      for(int i=0; i<degp1; i++) // initialize the solution to zero
         for(int j=0; j<dim; j++)
         {
            solhihi_d[i][j] = 0.0; sollohi_d[i][j] = 0.0;
            solhilo_d[i][j] = 0.0; sollolo_d[i][j] = 0.0;
         }
 
      if(vrblvl > 0) cout << "calling GPU_dbl4_bals_solve ..." << endl;

      int oldtail = *tailidx_d;
      int newtail = oldtail;

      GPU_dbl4_bals_solve
         (dim,degp1,szt,nbt,oldtail,
          jacvalhihi_d,jacvallohi_d,jacvalhilo_d,jacvallolo_d,
          Qhihi_d,Qlohi_d,Qhilo_d,Qlolo_d,Rhihi_d,Rlohi_d,Rhilo_d,Rlolo_d,
          urhshihi_d,urhslohi_d,urhshilo_d,urhslolo_d,
          solhihi_d,sollohi_d,solhilo_d,sollolo_d,zeroQ_d,noqr_d,
          upidx_d,bsidx_d,&newtail,totqrlapsedms,totqtblapsedms,
          totbslapsedms,totupdlapsedms,vrblvl);

      *tailidx_d = newtail;

      if(vrblvl > 0)
      {
         cout << "calling GPU_dbl4_linear_residue ..." << endl;

         double elapsedms = 0.0;
         long long int addcnt = 0;
         long long int mulcnt = 0;

         GPU_dbl4_linear_residue
            (dim,degp1,szt,nbt,*tailidx_d-1,
             jacvalhihi_d,jacvallohi_d,jacvalhilo_d,jacvallolo_d,
             rhshihi_d,rhslohi_d,rhshilo_d,rhslolo_d,
             solhihi_d,sollohi_d,solhilo_d,sollolo_d,
             resvechihi,resveclohi,resvechilo,resveclolo,
             resmaxhihi,resmaxlohi,resmaxhilo,resmaxlolo,
             &elapsedms,&addcnt,&mulcnt,vrblvl);

         cout << scientific << setprecision(3)
              << "maximum residual : " << *resmaxhihi;
         cout << fixed << setprecision(3)
              << "  total kernel time : " << elapsedms
              << " milliseconds" << endl;

         *totreslapsedms += elapsedms;
      }
      dbl4_update_series
         (dim,degp1,*tailidx_d-1,
          inputhihi_d,inputlohi_d,inputhilo_d,inputlolo_d,
          solhihi_d,sollohi_d,solhilo_d,sollolo_d,vrblvl);
   }
   if((vrblvl > 0) && (mode == 2))
   {
      double errsum = 0.0;
      cout << scientific << setprecision(3);
      cout << "comparing CPU with GPU matrices Q ... " << endl;
      errsum = dbl4_error2sum(dim,dim,
                  Qhihi_h,Qlohi_h,Qhilo_h,Qlolo_h,
                  Qhihi_d,Qlohi_d,Qhilo_d,Qlolo_d,"Q",vrblvl);
      cout << "sum of errors : " << errsum << endl;
      cout << "comparing CPU with GPU matrices R ... " << endl;
      errsum = dbl4_error2sum(dim,dim,
                  Rhihi_h,Rlohi_h,Rhilo_h,Rlolo_h,
                  Rhihi_d,Rlohi_d,Rhilo_d,Rlolo_d,"R",vrblvl);
      cout << "sum of errors : " << errsum << endl;
      cout << "comparing CPU with GPU updated rhs ... " << endl;
      errsum = dbl4_error2sum(degp1,dim,
                  urhshihi_h,urhslohi_h,urhshilo_h,urhslolo_h,
                  urhshihi_d,urhslohi_d,urhshilo_d,urhslolo_d,"urhs",vrblvl);
      cout << "sum of errors : " << errsum << endl;
      cout << "comparing CPU with GPU update to solutions ... " << endl;
      errsum = dbl4_error2sum(degp1,dim,
                  solhihi_h,sollohi_h,solhilo_h,sollolo_h,
                  solhihi_d,sollohi_d,solhilo_d,sollolo_d,"sol",vrblvl);
      cout << "sum of errors : " << errsum << endl;
      cout << "comparing CPU with GPU series ... " << endl;
      errsum = dbl4_error2sum(dim,degp1,
                  inputhihi_h,inputlohi_h,inputhilo_h,inputlolo_h,
                  inputhihi_d,inputlohi_d,inputhilo_d,inputlolo_d,
                  "input",vrblvl);
      cout << "sum of errors : " << errsum << endl;
   }
}

int test_dbl4_column_newton
 ( int szt, int nbt, int dim, int deg, int nbrcol,
   int **nvr, int ***idx, int **exp, int *nbrfac, int **expfac, int **rowsA,
   double dpr, int nbsteps, int mode, int vrblvl )
{
/*
 * 1. allocating input and output space for evaluation and differentiation
 */
   const int degp1 = deg+1;
   double **inputhihi_h = new double*[dim];
   double **inputlohi_h = new double*[dim];
   double **inputhilo_h = new double*[dim];
   double **inputlolo_h = new double*[dim];
   double **inputhihi_d = new double*[dim];
   double **inputlohi_d = new double*[dim];
   double **inputhilo_d = new double*[dim];
   double **inputlolo_d = new double*[dim];

   for(int i=0; i<dim; i++)
   {
      inputhihi_h[i] = new double[degp1];
      inputlohi_h[i] = new double[degp1];
      inputhilo_h[i] = new double[degp1];
      inputlolo_h[i] = new double[degp1];
      inputhihi_d[i] = new double[degp1];
      inputlohi_d[i] = new double[degp1];
      inputhilo_d[i] = new double[degp1];
      inputlolo_d[i] = new double[degp1];
   }
   // allocate memory for coefficients and the output
   double **acchihi = new double*[dim+1]; // accumulated power series
   double **acclohi = new double*[dim+1]; // in one column
   double **acchilo = new double*[dim+1];
   double **acclolo = new double*[dim+1];

   for(int i=0; i<=dim; i++)
   {
      acchihi[i] = new double[degp1];
      acclohi[i] = new double[degp1];
      acchilo[i] = new double[degp1];
      acclolo[i] = new double[degp1];
   }

   double ***cffhihi = new double**[nbrcol]; // coefficients of monomials
   double ***cfflohi = new double**[nbrcol];
   double ***cffhilo = new double**[nbrcol];
   double ***cfflolo = new double**[nbrcol];

   for(int i=0; i<nbrcol; i++)
   {
      cffhihi[i] = new double*[dim];
      cfflohi[i] = new double*[dim];
      cffhilo[i] = new double*[dim];
      cfflolo[i] = new double*[dim];

      for(int j=0; j<dim; j++)
      {
         cffhihi[i][j] = new double[degp1];
         cfflohi[i][j] = new double[degp1];
         cffhilo[i][j] = new double[degp1];
         cfflolo[i][j] = new double[degp1];
      }
   }
   double ***outputhihi_h;
   double ***outputlohi_h;
   double ***outputhilo_h;
   double ***outputlolo_h;
   double ***outputhihi_d;
   double ***outputlohi_d;
   double ***outputhilo_d;
   double ***outputlolo_d;

   if((mode == 1) || (mode == 2))
   {
      outputhihi_h = new double**[dim];
      outputlohi_h = new double**[dim];
      outputhilo_h = new double**[dim];
      outputlolo_h = new double**[dim];

      for(int i=0; i<dim; i++)
      {
         outputhihi_h[i] = new double*[dim+1];
         outputlohi_h[i] = new double*[dim+1];
         outputhilo_h[i] = new double*[dim+1];
         outputlolo_h[i] = new double*[dim+1];

         for(int j=0; j<=dim; j++)
         {
            outputhihi_h[i][j] = new double[degp1];
            outputlohi_h[i][j] = new double[degp1];
            outputhilo_h[i][j] = new double[degp1];
            outputlolo_h[i][j] = new double[degp1];
         }
      }
   }
   if((mode == 0) || (mode == 2))
   {
      outputhihi_d = new double**[dim];
      outputlohi_d = new double**[dim];
      outputhilo_d = new double**[dim];
      outputlolo_d = new double**[dim];

      for(int i=0; i<dim; i++)
      {
         outputhihi_d[i] = new double*[dim+1];
         outputlohi_d[i] = new double*[dim+1];
         outputhilo_d[i] = new double*[dim+1];
         outputlolo_d[i] = new double*[dim+1];

         for(int j=0; j<=dim; j++)
         {
            outputhihi_d[i][j] = new double[degp1];
            outputlohi_d[i][j] = new double[degp1];
            outputhilo_d[i][j] = new double[degp1];
            outputlolo_d[i][j] = new double[degp1];
         }
      }
   }
   // The function values are power series truncated at degree deg.
   double **funvalhihi_h;
   double **funvallohi_h;
   double **funvalhilo_h;
   double **funvallolo_h;
   double **funvalhihi_d;
   double **funvallohi_d;
   double **funvalhilo_d;
   double **funvallolo_d;

   if((mode == 1) || (mode == 2))
   {
      funvalhihi_h = new double*[dim];
      funvallohi_h = new double*[dim];
      funvalhilo_h = new double*[dim];
      funvallolo_h = new double*[dim];

      for(int i=0; i<dim; i++)
      {
         funvalhihi_h[i] = new double[degp1];
         funvallohi_h[i] = new double[degp1];
         funvalhilo_h[i] = new double[degp1];
         funvallolo_h[i] = new double[degp1];
      }
   }
   if((mode == 0) || (mode == 2))
   {
      funvalhihi_d = new double*[dim];
      funvallohi_d = new double*[dim];
      funvalhilo_d = new double*[dim];
      funvallolo_d = new double*[dim];

      for(int i=0; i<dim; i++)
      {
         funvalhihi_d[i] = new double[degp1];
         funvallohi_d[i] = new double[degp1];
         funvalhilo_d[i] = new double[degp1];
         funvallolo_d[i] = new double[degp1];
      }
   }
   // The derivatives in the output are a series truncated at degree deg.
   // The coefficients of the series are matrices of dimension dim.
   double ***jacvalhihi_h;
   double ***jacvallohi_h;
   double ***jacvalhilo_h;
   double ***jacvallolo_h;
   double ***jacvalhihi_d;
   double ***jacvallohi_d;
   double ***jacvalhilo_d;
   double ***jacvallolo_d;

   if((mode == 1) || (mode == 2))
   {
      jacvalhihi_h = new double**[degp1];
      jacvallohi_h = new double**[degp1];
      jacvalhilo_h = new double**[degp1];
      jacvallolo_h = new double**[degp1];

      for(int i=0; i<degp1; i++) // jacval[i] is matrix of dimension dim
      {
         jacvalhihi_h[i] = new double*[dim];
         jacvallohi_h[i] = new double*[dim];
         jacvalhilo_h[i] = new double*[dim];
         jacvallolo_h[i] = new double*[dim];

         for(int j=0; j<dim; j++)
         {
            jacvalhihi_h[i][j] = new double[dim];
            jacvallohi_h[i][j] = new double[dim];
            jacvalhilo_h[i][j] = new double[dim];
            jacvallolo_h[i][j] = new double[dim];
         }
      }
   }
   if((mode == 0) || (mode == 2))
   {
      jacvalhihi_d = new double**[degp1];
      jacvallohi_d = new double**[degp1];
      jacvalhilo_d = new double**[degp1];
      jacvallolo_d = new double**[degp1];

      for(int i=0; i<degp1; i++) // jacval[i] is matrix of dimension dim
      {
         jacvalhihi_d[i] = new double*[dim];
         jacvallohi_d[i] = new double*[dim];
         jacvalhilo_d[i] = new double*[dim];
         jacvallolo_d[i] = new double*[dim];

         for(int j=0; j<dim; j++)
         {
            jacvalhihi_d[i][j] = new double[dim];
            jacvallohi_d[i][j] = new double[dim];
            jacvalhilo_d[i][j] = new double[dim];
            jacvallolo_d[i][j] = new double[dim];
         }
      }
   }
/*
 * 2. allocate space to solve the linearized power series system
 */
   // The solution x(t) to jacval(t)*x(t) = -funval(t) in linearized
   // format is a series truncated at degree deg, with as coefficients
   // arrays of dimension dim.
   double **solhihi_h;
   double **sollohi_h;
   double **solhilo_h;
   double **sollolo_h;
   double **solhihi_d;
   double **sollohi_d;
   double **solhilo_d;
   double **sollolo_d;

   if((mode == 1) || (mode == 2))
   {
      solhihi_h = new double*[degp1];
      sollohi_h = new double*[degp1];
      solhilo_h = new double*[degp1];
      sollolo_h = new double*[degp1];

      for(int i=0; i<degp1; i++)
      {
         solhihi_h[i] = new double[dim];
         sollohi_h[i] = new double[dim];
         solhilo_h[i] = new double[dim];
         sollolo_h[i] = new double[dim];
      }
   }
   if((mode == 0) || (mode == 2))
   {
      solhihi_d = new double*[degp1];
      sollohi_d = new double*[degp1];
      solhilo_d = new double*[degp1];
      sollolo_d = new double*[degp1];

      for(int i=0; i<degp1; i++)
      {
         solhihi_d[i] = new double[dim];
         sollohi_d[i] = new double[dim];
         solhilo_d[i] = new double[dim];
         sollolo_d[i] = new double[dim];
      }
   }
   // The right hand side -funval(t) in linearized format is a series
   // truncated at degree deg, with arrays of dimension dim as coefficients.
   double **rhshihi_h;
   double **rhslohi_h;
   double **rhshilo_h;
   double **rhslolo_h;
   double **rhshihi_d;
   double **rhslohi_d;
   double **rhshilo_d;
   double **rhslolo_d;

   if((mode == 1) || (mode == 2))
   {
      rhshihi_h = new double*[degp1];
      rhslohi_h = new double*[degp1];
      rhshilo_h = new double*[degp1];
      rhslolo_h = new double*[degp1];

      for(int i=0; i<degp1; i++)
      {
         rhshihi_h[i] = new double[dim];
         rhslohi_h[i] = new double[dim];
         rhshilo_h[i] = new double[dim];
         rhslolo_h[i] = new double[dim];
      }
   }
   if((mode == 0) || (mode == 2))
   {
      rhshihi_d = new double*[degp1];
      rhslohi_d = new double*[degp1];
      rhshilo_d = new double*[degp1];
      rhslolo_d = new double*[degp1];

      for(int i=0; i<degp1; i++)
      {
         rhshihi_d[i] = new double[dim];
         rhslohi_d[i] = new double[dim];
         rhshilo_d[i] = new double[dim];
         rhslolo_d[i] = new double[dim];
      }
   }
   // Copy the rhs vector into work space for inplace solver.
   double **urhshihi_h;
   double **urhslohi_h;
   double **urhshilo_h;
   double **urhslolo_h;
   double **urhshihi_d;
   double **urhslohi_d;
   double **urhshilo_d;
   double **urhslolo_d;

   if((mode == 1) || (mode == 2))
   {
      urhshihi_h = new double*[degp1];
      urhslohi_h = new double*[degp1];
      urhshilo_h = new double*[degp1];
      urhslolo_h = new double*[degp1];

      for(int i=0; i<degp1; i++)
      {
         urhshihi_h[i] = new double[dim];
         urhslohi_h[i] = new double[dim];
         urhshilo_h[i] = new double[dim];
         urhslolo_h[i] = new double[dim];
      }
   }
   if((mode == 0) || (mode == 2))
   {
      urhshihi_d = new double*[degp1];
      urhslohi_d = new double*[degp1];
      urhshilo_d = new double*[degp1];
      urhslolo_d = new double*[degp1];

      for(int i=0; i<degp1; i++)
      {
         urhshihi_d[i] = new double[dim];
         urhslohi_d[i] = new double[dim];
         urhshilo_d[i] = new double[dim];
         urhslolo_d[i] = new double[dim];
      }
   }
   // Allocate work space for the inplace LU solver.
   double **workmathihi = new double*[dim];
   double **workmatlohi = new double*[dim];
   double **workmathilo = new double*[dim];
   double **workmatlolo = new double*[dim];

   for(int i=0; i<dim; i++)
   {
      workmathihi[i] = new double[dim];
      workmatlohi[i] = new double[dim];
      workmathilo[i] = new double[dim];
      workmatlolo[i] = new double[dim];
   }
   int *ipvt = new int[dim];
   double *workvechihi = new double[dim];
   double *workveclohi = new double[dim];
   double *workvechilo = new double[dim];
   double *workveclolo = new double[dim];
   // Copy the rhs vector into work space for inplace solver.
   double **workrhshihi = new double*[degp1];
   double **workrhslohi = new double*[degp1];
   double **workrhshilo = new double*[degp1];
   double **workrhslolo = new double*[degp1];

   for(int i=0; i<degp1; i++)
   {
      workrhshihi[i] = new double[dim];
      workrhslohi[i] = new double[dim];
      workrhshilo[i] = new double[dim];
      workrhslolo[i] = new double[dim];
   }
   double **resvechihi = new double*[degp1];
   double **resveclohi = new double*[degp1];
   double **resvechilo = new double*[degp1];
   double **resveclolo = new double*[degp1];

   for(int i=0; i<degp1; i++)
   {
      resvechihi[i] = new double[dim];
      resveclohi[i] = new double[dim];
      resvechilo[i] = new double[dim];
      resveclolo[i] = new double[dim];
   }
   double resmaxhihi,resmaxlohi,resmaxhilo,resmaxlolo;

   double **Qhihi_h;
   double **Qlohi_h;
   double **Qhilo_h;
   double **Qlolo_h;
   double **Qhihi_d;
   double **Qlohi_d;
   double **Qhilo_d;
   double **Qlolo_d;

   if((mode == 1) || (mode == 2))
   {
      Qhihi_h = new double*[dim];
      Qlohi_h = new double*[dim];
      Qhilo_h = new double*[dim];
      Qlolo_h = new double*[dim];

      for(int i=0; i<dim; i++)
      {
         Qhihi_h[i] = new double[dim];
         Qlohi_h[i] = new double[dim];
         Qhilo_h[i] = new double[dim];
         Qlolo_h[i] = new double[dim];
      }
   }
   if((mode == 0) || (mode == 2))
   {
      Qhihi_d = new double*[dim];
      Qlohi_d = new double*[dim];
      Qhilo_d = new double*[dim];
      Qlolo_d = new double*[dim];

      for(int i=0; i<dim; i++)
      {
         Qhihi_d[i] = new double[dim];
         Qlohi_d[i] = new double[dim];
         Qhilo_d[i] = new double[dim];
         Qlolo_d[i] = new double[dim];
      }
   }
   double **Rhihi_h;
   double **Rlohi_h;
   double **Rhilo_h;
   double **Rlolo_h;
   double **Rhihi_d;
   double **Rlohi_d;
   double **Rhilo_d;
   double **Rlolo_d;

   if((mode == 1) || (mode == 2))
   {
      Rhihi_h = new double*[dim];
      Rlohi_h = new double*[dim];
      Rhilo_h = new double*[dim];
      Rlolo_h = new double*[dim];

      for(int i=0; i<dim; i++)
      {
         Rhihi_h[i] = new double[dim];
         Rlohi_h[i] = new double[dim];
         Rhilo_h[i] = new double[dim];
         Rlolo_h[i] = new double[dim];
      }
   }
   if((mode == 0) || (mode == 2))
   {
      Rhihi_d = new double*[dim];
      Rlohi_d = new double*[dim];
      Rhilo_d = new double*[dim];
      Rlolo_d = new double*[dim];

      for(int i=0; i<dim; i++)
      {
         Rhihi_d[i] = new double[dim];
         Rlohi_d[i] = new double[dim];
         Rhilo_d[i] = new double[dim];
         Rlolo_d[i] = new double[dim];
      }
   }
/*
 * 3. initialize input, coefficient, evaluate, differentiate, and solve
 */
   // Define the initial input, a vector of ones.

   if(vrblvl > 0) cout << "setting up the test system ..." << endl;

   double **solhihi = new double*[dim];
   double **sollohi = new double*[dim];
   double **solhilo = new double*[dim];
   double **sollolo = new double*[dim];

   for(int i=0; i<dim; i++)
   {
      solhihi[i] = new double[degp1];
      sollohi[i] = new double[degp1];
      solhilo[i] = new double[degp1];
      sollolo[i] = new double[degp1];
   }
   make_real4_exponentials(dim,deg,solhihi,sollohi,solhilo,sollolo);
   if(nbrcol != 1) // generate coefficients for the columns
      make_real4_coefficients(nbrcol,dim,cffhihi,cfflohi,cffhilo,cfflolo);

   // compute the right hand sides via evaluation

   double **mbrhshihi = new double*[dim];
   double **mbrhslohi = new double*[dim];
   double **mbrhshilo = new double*[dim];
   double **mbrhslolo = new double*[dim];

   for(int i=0; i<dim; i++)
   {
      mbrhshihi[i] = new double[degp1];
      mbrhslohi[i] = new double[degp1];
      mbrhshilo[i] = new double[degp1];
      mbrhslolo[i] = new double[degp1];

      mbrhshihi[i][0] = 1.0;     // initialize product to one
      mbrhslohi[i][0] = 0.0;
      mbrhshilo[i][0] = 0.0;
      mbrhslolo[i][0] = 0.0;

      for(int k=1; k<degp1; k++)
      {
         mbrhshihi[i][k] = 0.0;
         mbrhslohi[i][k] = 0.0;
         mbrhshilo[i][k] = 0.0;
         mbrhslolo[i][k] = 0.0;
      }
   }
   if(nbrcol == 1)
      evaluate_real4_monomials
         (dim,deg,rowsA,solhihi,sollohi,solhilo,sollolo,
          mbrhshihi,mbrhslohi,mbrhshilo,mbrhslolo);
   else
      evaluate_real4_columns
         (dim,deg,nbrcol,nvr,idx,rowsA,
          cffhihi,cfflohi,cffhilo,cfflolo,
          solhihi,sollohi,solhilo,sollolo,
          mbrhshihi,mbrhslohi,mbrhshilo,mbrhslolo,vrblvl);

   if(vrblvl > 1)
   {
      cout << "the right hand side series :" << endl;
      cout << scientific << setprecision(16);
      for(int i=0; i<dim; i++)
         for(int j=0; j<degp1; j++)
            cout << "rhs[" << i << "][" << j << "] : "
                 << mbrhshihi[i][j] << "  " << mbrhslohi[i][j] << endl
                 << "  "
                 << mbrhshilo[i][j] << "  " << mbrhslolo[i][j] << endl;
   }
   double *start0hihi = new double[dim];
   double *start0lohi = new double[dim];
   double *start0hilo = new double[dim];
   double *start0lolo = new double[dim];

   for(int i=0; i<dim; i++)  // compute start vector
   {
      start0hihi[i] = solhihi[i][0];
      start0lohi[i] = sollohi[i][0];
      start0hilo[i] = solhilo[i][0];
      start0lolo[i] = sollolo[i][0];
   }
   real4_start_series_vector
      (dim,deg,start0hihi,start0lohi,start0hilo,start0lolo,
       inputhihi_h,inputlohi_h,inputhilo_h,inputlolo_h);

   for(int i=0; i<dim; i++)
      for(int j=0; j<degp1; j++)
      {
         inputhihi_d[i][j] = inputhihi_h[i][j];
         inputlohi_d[i][j] = inputlohi_h[i][j];
         inputhilo_d[i][j] = inputhilo_h[i][j];
         inputlolo_d[i][j] = inputlolo_h[i][j];
      }

   if(vrblvl > 1)
   {
      cout << scientific << setprecision(16);
      cout << "The leading coefficients of the input series :" << endl;
      for(int i=0; i<dim; i++)
      {
         cout << i << " : " << inputhihi_h[i][0] << "  "
                            << inputlohi_h[i][0] << endl;
         cout << "     " << inputhilo_h[i][0] << "  "
                         << inputlolo_h[i][0] << endl;
      }
   }
   if(vrblvl > 0) cout << scientific << setprecision(16);

   int upidx_h = 0;
   int bsidx_h = 0;
   int upidx_d = 0;
   int bsidx_d = 0;
   bool zeroQ_h = true;
   bool zeroQ_d = true;
   bool noqr_h = false;
   bool noqr_d = false;
   int tailidx_h = 1;
   int tailidx_d = 1;
   int wrkdeg = 0; // working degree of precision
   int stepcnt = 0;

   double totcnvlapsedms = 0.0;
   double totqrlapsedms = 0.0;
   double totqtblapsedms = 0.0;
   double totbslapsedms = 0.0;
   double totupdlapsedms = 0.0;
   double totreslapsedms = 0.0;

   struct timeval begintime,endtime; // wall clock time of computations
   gettimeofday(&begintime,0);

   for(int step=0; step<nbsteps; step++)
   {
      if(vrblvl > 0)
         cout << "*** running Newton step " << step
              << " at degree " << wrkdeg << " ***" << endl;

      dbl4_column_newton_qrstep
         (szt,nbt,dim,wrkdeg,nbrcol,
          &tailidx_h,&tailidx_d,nvr,idx,exp,nbrfac,expfac,
          mbrhshihi,mbrhslohi,mbrhshilo,mbrhslolo,dpr,
          cffhihi,cfflohi,cffhilo,cfflolo,acchihi,acclohi,acchilo,acclolo,
          inputhihi_h,inputlohi_h,inputhilo_h,inputlolo_h,
          inputhihi_d,inputlohi_d,inputhilo_d,inputlolo_d,
          outputhihi_h,outputlohi_h,outputhilo_h,outputlolo_h,
          outputhihi_d,outputlohi_d,outputhilo_d,outputlolo_d,
          funvalhihi_h,funvallohi_h,funvalhilo_h,funvallolo_h,
          funvalhihi_d,funvallohi_d,funvalhilo_d,funvallolo_d,
          jacvalhihi_h,jacvallohi_h,jacvalhilo_h,jacvallolo_h,
          jacvalhihi_d,jacvallohi_d,jacvalhilo_d,jacvallolo_d,
          rhshihi_h,rhslohi_h,rhshilo_h,rhslolo_h,
          rhshihi_d,rhslohi_d,rhshilo_d,rhslolo_d,
          urhshihi_h,urhslohi_h,urhshilo_h,urhslolo_h,
          urhshihi_d,urhslohi_d,urhshilo_d,urhslolo_d,
          solhihi_h,sollohi_h,solhilo_h,sollolo_h,
          solhihi_d,sollohi_d,solhilo_d,sollolo_d,
          Qhihi_h,Qlohi_h,Qhilo_h,Qlolo_h,Qhihi_d,Qlohi_d,Qhilo_d,Qlolo_d,
          Rhihi_h,Rlohi_h,Rhilo_h,Rlolo_h,Rhihi_d,Rlohi_d,Rhilo_d,Rlolo_d,
          workmathihi,workmatlohi,workmathilo,workmatlolo,
          workvechihi,workveclohi,workvechilo,workveclolo,
          resvechihi,resveclohi,resvechilo,resveclolo,
          &resmaxhihi,&resmaxlohi,&resmaxhilo,&resmaxlolo,
          &zeroQ_h,&noqr_h,&zeroQ_d,&noqr_d,
          &upidx_h,&bsidx_h,&upidx_d,&bsidx_d,
          &totcnvlapsedms,&totqrlapsedms,&totqtblapsedms,&totbslapsedms,
          &totupdlapsedms,&totreslapsedms,vrblvl,mode);

      stepcnt = stepcnt + 1;

      if(vrblvl > 0)
         cout << "up_h : " << upidx_h << "  bs_h : " << bsidx_h
              << "  tail_h : " << tailidx_h
              << "  up_d : " << upidx_d << "  bs_d : " << bsidx_d
              << "  tail_d : " << tailidx_d
              << "  wdeg : " << wrkdeg << endl;

      if((mode == 1) || (mode == 2)) if(tailidx_h >= deg) break;
      if((mode == 0) || (mode == 2)) if(tailidx_d >= deg) break;

      wrkdeg = wrkdeg + 1 + wrkdeg/2;
      if(wrkdeg > deg) wrkdeg = deg;
   }
   gettimeofday(&endtime,0);
   long seconds = endtime.tv_sec - begintime.tv_sec;
   long microseconds = endtime.tv_usec - begintime.tv_usec;
   double walltimesec = seconds + microseconds*1.0e-6;

   double errsum = 0.0;

   cout << scientific << setprecision(16); // just in case vrblvl == 0
   cout << "The solution series : " << endl;
   for(int j=0; j<degp1; j++)
   {
      cout << "coefficient of degree " << j << " :" << endl;
      for(int i=0; i<dim; i++)
      {
         cout << "sol[" << i << "][" << j << "] : "
                        << solhihi[i][j] << "  "
                        << sollohi[i][j] << endl << "  "
                        << solhilo[i][j] << "  "
                        << sollolo[i][j] << endl;
         if((mode == 0) || (mode == 2))
         {
            cout << "x_d[" << i << "][" << j << "] : "
                           << inputhihi_d[i][j] << "  "
                           << inputlohi_d[i][j] << endl << "  "
                           << inputhilo_d[i][j] << "  "
                           << inputlolo_d[i][j] << endl;
            errsum += abs(solhihi[i][j] - inputhihi_d[i][j])
                    + abs(sollohi[i][j] - inputlohi_d[i][j])
                    + abs(solhilo[i][j] - inputhilo_d[i][j])
                    + abs(sollolo[i][j] - inputlolo_d[i][j]);
         }
         if((mode == 1) || (mode == 2))
         {
            cout << "x_h[" << i << "][" << j << "] : "
                           << inputhihi_h[i][j] << "  "
                           << inputlohi_h[i][j] << endl << "  "
                           << inputhilo_h[i][j] << "  "
                           << inputlolo_h[i][j] << endl;
            errsum += abs(solhihi[i][j] - inputhihi_h[i][j])
                    + abs(sollohi[i][j] - inputlohi_h[i][j])
                    + abs(solhilo[i][j] - inputhilo_h[i][j])
                    + abs(sollolo[i][j] - inputlolo_h[i][j]);
         }
      }
   }
   cout << "error : " << errsum << endl;

   cout << "Wall clock time on all " << stepcnt << " Newton steps : ";
   cout << fixed << setprecision(3) 
        << walltimesec << " seconds." << endl;
   cout << "     Time spent by all convolution kernels : "
        << totcnvlapsedms << " milliseconds." << endl;
   cout << "  Time spent by all Householder QR kernels : "
        << totqrlapsedms << " milliseconds." << endl;
   cout << "     Time spent by all Q times rhs kernels : "
        << totqtblapsedms << " milliseconds." << endl;
   cout << "Time spent by all backsubstitution kernels : "
        << totbslapsedms << " milliseconds." << endl;
   cout << "          Time spent by all update kernels : "
        << totupdlapsedms << " milliseconds." << endl;
   cout << "        Time spent by all residual kernels : "
        << totreslapsedms << " milliseconds." << endl;

   double totkerneltime = totcnvlapsedms + totqrlapsedms + totqtblapsedms
                        + totbslapsedms + totupdlapsedms + totreslapsedms;

   cout << "           Total time spent by all kernels : "
        << totkerneltime << " milliseconds." << endl;

   return 0;
}
