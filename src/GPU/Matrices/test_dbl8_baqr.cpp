/* Tests operations on blocked accelerated QR decomposition
 * in octo double precision */

#include <iostream>
#include <cstdlib>
#include <time.h>
#include "prompt_baqr_setup.h"
#include "dbl8_baqr_testers.h"

using namespace std;

int main ( void )
{
   int seed,szt,nbt,nrows,vrb,mode;

   prompt_baqr_setup(&seed,&szt,&nbt,&nrows,&vrb,&mode);

   if(seed == 0)
      srand(time(NULL));
   else
      srand(seed);

   cout << "Testing the real blocked QR ..." << endl;
   test_real8_blocked_qr(seed,szt,nbt,nrows,vrb,mode);

   cout << endl;

   prompt_baqr_setup(&seed,&szt,&nbt,&nrows,&vrb,&mode);

   if(seed == 0)
      srand(time(NULL));
   else
      srand(seed);

   cout << "Testing the complex blocked QR ..." << endl;
   test_cmplx8_blocked_qr(seed,szt,nbt,nrows,vrb,mode);

   return 0;
}
