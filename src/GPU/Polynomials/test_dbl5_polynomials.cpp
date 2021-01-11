/* Tests polynomial evaluation and differentiation
 * in penta double precision. */

#include <iostream>
#include "prompt_for_setup.h"
#include "dbl5_polynomials_testers.h"

using namespace std;

int main ( void )
{
   int seed,dim,nva,nbr,pwr,deg,vrb,mode;

   prompt_for_setup(&seed,&dim,&nbr,&nva,&pwr,&deg,&vrb,&mode);

   int fail = main_dbl5_test_polynomial
                 (seed,dim,nbr,nva,pwr,deg,vrb,1.0e-72,true,mode);

   if(mode == 2)
   {
      if(fail == 0)
         cout << "All tests passed." << endl;
      else
         cout << "Number of failed tests : " << fail << endl;
   }
   return 0;
}
