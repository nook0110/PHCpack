/* Tests operations on Newton for series in double precision */

#include <iostream>
#include <iomanip>
#include <cstdlib>
#include <cmath>
#include <time.h>
#include "unimodular_matrices.h"
#include "prompt_newton_setup.h"
#include "dbl_newton_testers.h"

using namespace std;

void exponents_check ( int dim, int **rowsA );
/*
 * DESCRIPTION :
 *   Writes the exponents of the solution for checking ... */

int main ( void )
{
   cout << "testing Newton in double precision ..." << endl;

   int seed,dim,deg,size,posvals,vrblvl,nbritr,nbsteps,szt,nbt,mode,cdata;

   prompt_newton_setup
      (&seed,&szt,&nbt,&dim,&deg,&size,&posvals,&vrblvl,&mode,
       &nbritr,&nbsteps,&cdata);

   if(seed == 0)
      srand(time(NULL));
   else
      srand(seed);

   if(nbritr > 0)
      cout << "generating an integer matrix of dimension " << dim
           << " ..." << endl;
/*
 * 1. defining the unimodular matrix of monomials
 */
   int **rowsA = new int*[dim];  // exponents in the rows
   int *nvr = new int[dim];      // number of variables in each monomial
   int **idx = new int*[dim];    // indexes of variables in each monomial
   int **exp = new int*[dim];    // exponents of the variables
   int *nbrfac = new int[dim];   // number of exponents > 1 in each monomial
   int **expfac = new int*[dim]; // exponents of the common factors

   make_monomial_system
      (dim,size,posvals,nbritr,nvr,idx,exp,nbrfac,expfac,rowsA,vrblvl);
/*
 * 2. calling the test function
 */
  if(cdata == 0)
     test_dbl_real_newton
        (szt,nbt,dim,deg,nvr,idx,exp,nbrfac,expfac,nbsteps,mode,vrblvl);
  else
     test_dbl_complex_newton
        (szt,nbt,dim,deg,nvr,idx,exp,nbrfac,expfac,nbsteps,mode,vrblvl);

   exponents_check(dim, rowsA);

   return 0;
}

void exponents_check ( int dim, int **rowsA )
{
   cout << "The matrix :" << endl;
   write_exponent_matrix(dim, rowsA);

   int *expsol = new int[dim];
   int **copyA = new int*[dim];  // copy of A
   int **unimd = new int*[dim];  // unimodular transformation

   for(int i=0; i<dim; i++)      // initialize the data
   {
      unimd[i] = new int[dim];
      copyA[i] = new int[dim];
   }
   copy_integer_matrix(dim, rowsA, copyA);
   int sing = lower_triangulate(dim, copyA, unimd, 0);
   exponent_forward_substitution(dim, copyA, expsol);
   cout << "exponents after forward substitution :" << endl;
   for(int i=0; i<dim; i++) cout << " " << expsol[i];
   cout << endl;
   exponent_unimodular_transformation(dim, unimd, expsol);
   cout << "exponents after unimodular transformation :" << endl;
   for(int i=0; i<dim; i++) cout << " " << expsol[i];
   cout << endl;

   for(int i=0; i<dim; i++)
   {
      free(unimd[i]);
      free(copyA[i]);
   }
   free(unimd); free(copyA); free(expsol);
}
