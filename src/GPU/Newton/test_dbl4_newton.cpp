/* Tests operations on Newton for series in quad double precision */

#include <iostream>
#include <iomanip>
#include <cstdlib>
#include <cmath>
#include <time.h>
#include "unimodular_matrices.h"
#include "prompt_newton_setup.h"
#include "dbl4_newton_testers.h"
#include "dbl4_newton_method.h"
#include "cmplx4_newton_method.h"

using namespace std;

int main ( void )
{
   cout << "testing Newton in quad double precision..." << endl;

   int seed,dim,deg,size,posvals,vrblvl,nbritr,nbsteps,szt,nbt,mode,cdata;
   double dpr = 1.0;

   prompt_newton_setup
      (&seed,&szt,&nbt,&dim,&deg,&size,&posvals,&vrblvl,&mode,
       &nbritr,&nbsteps,&cdata);

   if(seed == 0)
      srand(time(NULL));
   else
      srand(seed);

   if(nbritr == -1)
      cout << "making the lower triangular unit of dimension " << dim
           << " ..." << endl;
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

   int *expsol = new int[dim];
   int sing = exponents_check(dim,rowsA,expsol,vrblvl);
   cout << "-> give the damper (1.0 is the default) : "; cin >> dpr;
/*
 * 2. calling the test function
 */
   if(cdata == 0)
      test_dbl4_real_newton
         (szt,nbt,dim,deg,nvr,idx,exp,nbrfac,expfac,dpr,nbsteps,mode,vrblvl);
   else
      test_dbl4_complex_newton
         (szt,nbt,dim,deg,nvr,idx,exp,nbrfac,expfac,dpr,nbsteps,mode,vrblvl);

   sing = exponents_check(dim,rowsA,expsol,vrblvl);

   return sing;
}
