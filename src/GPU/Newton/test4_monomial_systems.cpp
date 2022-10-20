/* Tests the making of a monomial systems in quad double precision. */

#include <iostream>
#include <iomanip>
#include <cstdlib>
#include <cmath>
#include <time.h>
#include "random4_series.h"
#include "unimodular_matrices.h"
#include "dbl4_monomial_systems.h"

using namespace std;

int make_real_system ( int dim, int deg, int **rowsA );
/*
 * DESCRIPTION :
 *   Sets up a monomial system of dim equations,
 *   of series with real coefficients truncated to degree deg,
 *   using the exponents in the rows of rowsA. */

int make_complex_system ( int dim, int deg, int **rowsA );
/*
 * DESCRIPTION :
 *   Sets up a monomial system of dim equations,
 *   of series with complex coefficients truncated to degree deg,
 *   using the exponents in the rows of rowsA. */

int main ( void )
{
   cout << "testing the making of a monomial system ..." << endl;

   const int vrblvl = 2;
   int seed,dim,deg,size,nbritr,cdata;

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
   cout << "-> on complex data (1 is yes, 0 is no) : "; cin >> cdata;

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

   if(cdata == 1)
      return make_complex_system(dim,deg,rowsA);
   else
      return make_real_system(dim,deg,rowsA);
}

int make_real_system ( int dim, int deg, int **rowsA )
{
   double **solhihi = new double*[dim];
   double **sollohi = new double*[dim];
   double **solhilo = new double*[dim];
   double **sollolo = new double*[dim];

   const int degp1 = deg+1;

   for(int i=0; i<dim; i++)
   {
      solhihi[i] = new double[degp1];
      sollohi[i] = new double[degp1];
      solhilo[i] = new double[degp1];
      sollolo[i] = new double[degp1];
   }
   make_real4_exponentials
      (dim,deg,solhihi,sollohi,solhilo,sollolo);

   cout << scientific << setprecision(16);

   for(int j=0; j<degp1; j++)
   {
      cout << "coefficients of degree " << j << " :" << endl;

      for(int i=0; i<dim; i++)
      {
         cout << "c[" << i << "][" << j << "] : ";     
         cout << solhihi[i][j] << "  " << sollohi[i][j] << endl << "  "
              << solhilo[i][j] << "  " << sollolo[i][j] << endl;
      }
   }

// compute the right hand sides via evaluation

   double **rhshihi = new double*[dim];
   double **rhslohi = new double*[dim];
   double **rhshilo = new double*[dim];
   double **rhslolo = new double*[dim];

   for(int i=0; i<dim; i++)
   {
      rhshihi[i] = new double[degp1];
      rhslohi[i] = new double[degp1];
      rhshilo[i] = new double[degp1];
      rhslolo[i] = new double[degp1];

      rhshihi[i][0] = 1.0;     // initialize product to one
      rhslohi[i][0] = 0.0;
      rhshilo[i][0] = 0.0; 
      rhslolo[i][0] = 0.0;

      for(int k=1; k<degp1; k++)
      {
         rhshihi[i][k] = 0.0; rhslohi[i][k] = 0.0;
         rhshilo[i][k] = 0.0; rhslolo[i][k] = 0.0;
      }
   }
   evaluate_real4_monomials
      (dim,deg,rowsA,solhihi,sollohi,solhilo,sollolo,
       rhshihi,rhslohi,rhshilo,rhslolo);

   cout << "the evaluated right hand sides :" << endl;

   for(int j=0; j<degp1; j++)
   {
      cout << "coefficients of degree " << j << " :" << endl;

      for(int i=0; i<dim; i++)
      {
         cout << "r[" << i << "][" << j << "] : ";     
         cout << rhshihi[i][j] << "  " << rhslohi[i][j] << endl << "  "
              << rhshilo[i][j] << "  " << rhslolo[i][j] << endl;
      }
   }
   return 0;
}

int make_complex_system ( int dim, int deg, int **rowsA )
{
   double **solrehihi = new double*[dim];
   double **solrelohi = new double*[dim];
   double **solrehilo = new double*[dim];
   double **solrelolo = new double*[dim];
   double **solimhihi = new double*[dim];
   double **solimlohi = new double*[dim];
   double **solimhilo = new double*[dim];
   double **solimlolo = new double*[dim];

   const int degp1 = deg+1;

   for(int i=0; i<dim; i++)
   {
      solrehihi[i] = new double[degp1];
      solrelohi[i] = new double[degp1];
      solrehilo[i] = new double[degp1];
      solrelolo[i] = new double[degp1];
      solimhihi[i] = new double[degp1];
      solimlohi[i] = new double[degp1];
      solimhilo[i] = new double[degp1];
      solimlolo[i] = new double[degp1];
   }
   make_complex4_exponentials
      (dim,deg,solrehihi,solrelohi,solrehilo,solrelolo,
               solimhihi,solimlohi,solimhilo,solimlolo);

   cout << scientific << setprecision(16);

   for(int j=0; j<degp1; j++)
   {
      cout << "coefficients of degree " << j << " :" << endl;

      for(int i=0; i<dim; i++)
      {
         cout << "c[" << i << "][" << j << "] : ";     
         cout << solrehihi[i][j] << "  " << solrelohi[i][j] << endl << "  "
              << solrehilo[i][j] << "  " << solrelolo[i][j] << endl << "  "
              << solimhihi[i][j] << "  " << solimlohi[i][j] << endl << "  "
              << solimhilo[i][j] << "  " << solimlolo[i][j] << endl;
      }
   }

// compute the right hand sides via evaluation

   double **rhsrehihi = new double*[dim];
   double **rhsrelohi = new double*[dim];
   double **rhsrehilo = new double*[dim];
   double **rhsrelolo = new double*[dim];
   double **rhsimhihi = new double*[dim];
   double **rhsimlohi = new double*[dim];
   double **rhsimhilo = new double*[dim];
   double **rhsimlolo = new double*[dim];

   for(int i=0; i<dim; i++)
   {
      rhsrehihi[i] = new double[degp1];
      rhsrelohi[i] = new double[degp1];
      rhsrehilo[i] = new double[degp1];
      rhsrelolo[i] = new double[degp1];
      rhsimhihi[i] = new double[degp1];
      rhsimlohi[i] = new double[degp1];
      rhsimhilo[i] = new double[degp1];
      rhsimlolo[i] = new double[degp1];

      rhsrehihi[i][0] = 1.0;     // initialize product to one
      rhsrelohi[i][0] = 0.0;
      rhsrehilo[i][0] = 0.0; 
      rhsrelolo[i][0] = 0.0;
      rhsimhihi[i][0] = 0.0;
      rhsimlohi[i][0] = 0.0;
      rhsimhilo[i][0] = 0.0;
      rhsimlolo[i][0] = 0.0;

      for(int k=1; k<degp1; k++)
      {
         rhsrehihi[i][k] = 0.0; rhsrelohi[i][k] = 0.0;
         rhsrehilo[i][k] = 0.0; rhsrelolo[i][k] = 0.0;
         rhsimhihi[i][k] = 0.0; rhsimlohi[i][k] = 0.0;
         rhsimhilo[i][k] = 0.0; rhsimlolo[i][k] = 0.0;
      }
   }
   evaluate_complex4_monomials
      (dim,deg,rowsA,
       solrehihi,solrelohi,solrehilo,solrelolo,
       solimhihi,solimlohi,solimhilo,solimlolo,
       rhsrehihi,rhsrelohi,rhsrehilo,rhsrelolo,
       rhsimhihi,rhsimlohi,rhsimhilo,rhsimlolo);

   cout << "the evaluated right hand sides :" << endl;

   for(int j=0; j<degp1; j++)
   {
      cout << "coefficients of degree " << j << " :" << endl;

      for(int i=0; i<dim; i++)
      {
         cout << "r[" << i << "][" << j << "] : ";     
         cout << rhsrehihi[i][j] << "  " << rhsrelohi[i][j] << endl << "  "
              << rhsrehilo[i][j] << "  " << rhsrelolo[i][j] << endl << "  "
              << rhsimhihi[i][j] << "  " << rhsimlohi[i][j] << endl << "  "
              << rhsimhilo[i][j] << "  " << rhsimlolo[i][j] << endl;
      }
   }
   return 0;
}
