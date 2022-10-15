/* Tests the making of a monomial systems. */

#include <iostream>
#include <iomanip>
#include <cstdlib>
#include <cmath>
#include <time.h>
#include "random_series.h"
#include "dbl_convolutions_host.h"
#include "unimodular_matrices.h"
#include "dbl_monomial_systems.h"

using namespace std;

int main ( void )
{
   cout << "testing the making of a monomial system ..." << endl;

   const int vrblvl = 2;
   int seed,dim,deg,size,nbritr;

   cout << "-> give the seed (0 for time) : "; cin >> seed;
   cout << "-> give the number of series : "; cin >> dim;
   while(true)
   {
      cout << "-> give the truncation degree : "; cin >> deg;
      if(deg > 0) break;
      cout << "The degree must be one or larger.  Retry" << endl;
   }
   cout << "-> give the size of the numbers : "; cin >> size;
   cout << "-> give the number of iterations : "; cin >> nbritr;

   if(seed == 0)
      srand(time(NULL));
   else
      srand(seed);

// make the unimodular matrix of the system

   int **rowsA = new int*[dim];  // exponents in the rows
   int *nvr = new int[dim];      // number of variables in each monomial
   int **idx = new int*[dim];    // indexes of variables in each monomial
   int **exp = new int*[dim];    // exponents of the variables
   int *nbrfac = new int[dim];   // number of exponents > 1 in each monomial
   int **expfac = new int*[dim]; // exponents of the common factors

   make_monomial_system
      (dim,size,1,nbritr,nvr,idx,exp,nbrfac,expfac,rowsA,vrblvl);

   int *expsol = new int[dim];
   int sing = exponents_check(dim,rowsA,expsol,vrblvl);

// generate the solution series

   double *angles = new double[dim];
   double **solre = new double*[dim];
   double **solim = new double*[dim];

   const int degp1 = deg+1;

   for(int i=0; i<dim; i++)
   {
      solre[i] = new double[degp1];
      solim[i] = new double[degp1];
   }
   make_complex_exponentials(dim,deg,angles,solre,solim);

   cout << scientific << setprecision(16);

   for(int j=0; j<degp1; j++)
   {
      cout << "coefficients of degree " << j << " :" << endl;

      for(int i=0; i<dim; i++)
      {
         cout << "c[" << i << "][" << j << "] : ";     
         cout << solre[i][j] << "  " << solim[i][j] << endl;
         if(j == 1)
         {
            cout << "angle[" << i << "] : " << angles[i] << endl;
            cout << "c[" << i << "][" << j << "] : ";     
            cout << cos(angles[i]) << "  " << sin(angles[i]) << endl;
         }
      }
   }

// compute the right hand sides via evaluation

   double **rhsre = new double*[dim];
   double **rhsim = new double*[dim];

   for(int i=0; i<dim; i++)
   {
      rhsre[i] = new double[degp1];
      rhsim[i] = new double[degp1];

      rhsre[i][0] = 1.0;     // initialize product to one
      rhsim[i][0] = 0.0;

      for(int k=1; k<degp1; k++)
      {
         rhsre[i][k] = 0.0;
         rhsim[i][k] = 0.0;
      }
   }
   double *accre = new double[degp1]; // accumulates product
   double *accim = new double[degp1];

   for(int i=0; i<dim; i++)    // run over all monomials
   {
      for(int j=0; j<dim; j++) // run over all variables
      {
         if(rowsA[i][j] > 0)   // only multiply if positive exponent
         {
            for(int k=0; k<rowsA[i][j]; k++)
            {
               CPU_cmplx_product
                  (deg,solre[j],solim[j],rhsre[i],rhsim[i],accre,accim);

               for(int L=0; L<degp1; L++)
               {
                  rhsre[i][L] = accre[L];
                  rhsim[i][L] = accim[L];
               }
            }
         }
      }
   }

   cout << "the evaluated right hand sides :" << endl;

   for(int j=0; j<degp1; j++)
   {
      cout << "coefficients of degree " << j << " :" << endl;

      for(int i=0; i<dim; i++)
      {
         cout << "r[" << i << "][" << j << "] : ";     
         cout << rhsre[i][j] << "  " << rhsim[i][j] << endl;
      }
   }

   return 0;
}
