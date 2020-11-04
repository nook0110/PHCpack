/* Tests the product of two series in quad double precision. */

#include <iostream>
#include <iomanip>
#include <vector_types.h>
#include "quad_double_functions.h"
#include "random4_vectors.h"
#include "random4_series.h"
#include "dbl4_convolutions_host.h"
#include "dbl4_convolutions_kernels.h"

using namespace std;

void test_real ( int deg );
/*
 * DESCRIPTION :
 *   Multiplies the power series of 1/(1-x) with 1+x,
 *   truncated to degree deg, for real coefficients. */

void test_complex ( int deg );
/*
 * DESCRIPTION :
 *   Multiplies the power series of 1/(1-x) with 1+x,
 *   truncated to degree deg, for complex coefficients. */

void test_real_exponential ( int deg );
/*
 * DESCRIPTION :
 *   Multiplies the power series for exp(x) with exp(-x)
 *   for some random x in [-1,+1], for real coefficients
 *   of a series of degree truncated to deg. */


void test_complex_exponential ( int deg );
/*
 * DESCRIPTION :
 *   Multiplies the power series for exp(x) with exp(-x)
 *   for some random complex number on the unit circle,
 *   for series of degree truncated to deg. */

int main ( void )
{
   int deg;

   cout << "Give a degree larger than one : "; cin >> deg;

   if(deg > 0) test_real(deg);
   if(deg > 0) test_complex(deg);
   if(deg > 0) test_real_exponential(deg);
   if(deg > 0) test_complex_exponential(deg);

   return 0;
}

void test_real ( int deg )
{
   double* xhihi = new double[deg+1];
   double* xlohi = new double[deg+1];
   double* xhilo = new double[deg+1];
   double* xlolo = new double[deg+1];
   double* yhihi = new double[deg+1];
   double* ylohi = new double[deg+1];
   double* yhilo = new double[deg+1];
   double* ylolo = new double[deg+1];
   double* zhihi_h = new double[deg+1];
   double* zlohi_h = new double[deg+1];
   double* zhilo_h = new double[deg+1];
   double* zlolo_h = new double[deg+1];
   double* zhihi_d = new double[deg+1];
   double* zlohi_d = new double[deg+1];
   double* zhilo_d = new double[deg+1];
   double* zlolo_d = new double[deg+1];

   for(int k=0; k<=deg; k++)
   {
      xhihi[k] = 1.0; xlohi[k] = 0.0;
      xhilo[k] = 0.0; xlolo[k] = 0.0;
      yhihi[k] = 0.0; ylohi[k] = 0.0;
      yhilo[k] = 0.0; ylolo[k] = 0.0;
   }
   yhihi[0] = 1.0; yhihi[1] = -1.0;

   CPU_dbl4_product(deg,xhihi,xlohi,xhilo,xlolo,yhihi,ylohi,yhilo,ylolo,
                        zhihi_h,zlohi_h,zhilo_h,zlolo_h);

   cout << "Series of 1/(1-x) multiplied with 1-x : " << endl;

   for(int k=0; k<=deg; k++)
   {
      cout << "zhihi[" << k << "] : " << zhihi_h[k];
      cout << "  zlohi[" << k << "] : " << zlohi_h[k];
      cout << "  zhilo[" << k << "] : " << zhilo_h[k];
      cout << "  zlolo[" << k << "] : " << zlolo_h[k] << endl;
   }

   GPU_dbl4_product(xhihi,xlohi,xhilo,xlolo,
                    yhihi,ylohi,yhilo,ylolo,
                    zhihi_d,zlohi_d,zhilo_d,zlolo_d,deg,1,deg+1);

   cout << "GPU computed product :" << endl;

   for(int k=0; k<=deg; k++)
   {
      cout << "zhihi[" << k << "] : " << zhihi_d[k];
      cout << "  zlohi[" << k << "] : " << zlohi_d[k];
      cout << "  zhilo[" << k << "] : " << zhilo_d[k];
      cout << "  zlolo[" << k << "] : " << zlolo_d[k] << endl;
   }
}

void test_complex ( int deg )
{
   double* xrehihi = new double[deg+1];
   double* xrelohi = new double[deg+1];
   double* xrehilo = new double[deg+1];
   double* xrelolo = new double[deg+1];
   double* ximhihi = new double[deg+1];
   double* ximlohi = new double[deg+1];
   double* ximhilo = new double[deg+1];
   double* ximlolo = new double[deg+1];
   double* yrehihi = new double[deg+1];
   double* yrelohi = new double[deg+1];
   double* yrehilo = new double[deg+1];
   double* yrelolo = new double[deg+1];
   double* yimhihi = new double[deg+1];
   double* yimlohi = new double[deg+1];
   double* yimhilo = new double[deg+1];
   double* yimlolo = new double[deg+1];
   double* zrehihi_h = new double[deg+1];
   double* zrelohi_h = new double[deg+1];
   double* zrehilo_h = new double[deg+1];
   double* zrelolo_h = new double[deg+1];
   double* zimhihi_h = new double[deg+1];
   double* zimlohi_h = new double[deg+1];
   double* zimhilo_h = new double[deg+1];
   double* zimlolo_h = new double[deg+1];
   double* zrehihi_d = new double[deg+1];
   double* zrelohi_d = new double[deg+1];
   double* zrehilo_d = new double[deg+1];
   double* zrelolo_d = new double[deg+1];
   double* zimhihi_d = new double[deg+1];
   double* zimlohi_d = new double[deg+1];
   double* zimhilo_d = new double[deg+1];
   double* zimlolo_d = new double[deg+1];

   for(int k=0; k<=deg; k++)
   {
      xrehihi[k] = 1.0; xrelohi[k] = 0.0;
      xrehilo[k] = 0.0; xrelolo[k] = 0.0;
      ximhihi[k] = 0.0; ximlohi[k] = 0.0;
      ximhilo[k] = 0.0; ximlolo[k] = 0.0;
      yrehihi[k] = 0.0; yrelohi[k] = 0.0;
      yrehilo[k] = 0.0; yrelolo[k] = 0.0;
      yimhihi[k] = 0.0; yimlohi[k] = 0.0;
      yimhilo[k] = 0.0; yimlolo[k] = 0.0;
   }
   yrehihi[0] = 1.0; yrehihi[1] = -1.0;

   CPU_cmplx4_product
      (deg,xrehihi,xrelohi,xrehilo,xrelolo,ximhihi,ximlohi,ximhilo,ximlolo,
           yrehihi,yrelohi,yrehilo,yimlolo,yimhihi,yimlohi,yimhilo,yimlolo,
           zrehihi_h,zrelohi_h,zrehilo_h,zrelolo_h,
           zimhihi_h,zimlohi_h,zimhilo_h,zimlolo_h);

   cout << "Series of 1/(1-x) multiplied with 1-x : " << endl;

   for(int k=0; k<=deg; k++)
   {
      cout << "zrehihi[" << k << "] : " << zrehihi_h[k];
      cout << "  zrelohi[" << k << "] : " << zrelohi_h[k];
      cout << "  zrehilo[" << k << "] : " << zrehilo_h[k];
      cout << "  zrelolo[" << k << "] : " << zrelolo_h[k] << endl;
      cout << "zimhihi[" << k << "] : " << zimhihi_h[k];
      cout << "  zimlohi[" << k << "] : " << zimlohi_h[k];
      cout << "  zimhilo[" << k << "] : " << zimhilo_h[k];
      cout << "  zimlolo[" << k << "] : " << zimlolo_h[k] << endl;
   }

   GPU_cmplx4_product
      (xrehihi,xrelohi,xrehilo,xrelolo,ximhihi,ximlohi,ximhilo,ximlolo,
       yrehihi,yrelohi,yrehilo,yrelolo,yimhihi,yimlohi,yimhilo,yimlolo,
       zrehihi_d,zrelohi_d,zrehilo_d,zrelolo_d,
       zimhihi_d,zimlohi_d,zimhilo_d,zimlolo_d,deg,1,deg+1);

   cout << "GPU computed product :" << endl;

   for(int k=0; k<=deg; k++)
   {
      cout << "zrehihi[" << k << "] : " << zrehihi_d[k];
      cout << "  zrelohi[" << k << "] : " << zrelohi_d[k];
      cout << "  zrehilo[" << k << "] : " << zrehilo_d[k];
      cout << "  zrelolo[" << k << "] : " << zrelolo_d[k] << endl;
      cout << "zimhihi[" << k << "] : " << zimhihi_d[k];
      cout << "  zimlohi[" << k << "] : " << zimlohi_d[k];
      cout << "  zimhilo[" << k << "] : " << zimhilo_d[k];
      cout << "  zimlolo[" << k << "] : " << zimlolo_d[k] << endl;
   }

}

void test_real_exponential ( int deg )
{
   double *xhihi = new double[deg+1];
   double *xlohi = new double[deg+1];
   double *xhilo = new double[deg+1];
   double *xlolo = new double[deg+1];
   double *yhihi = new double[deg+1];
   double *ylohi = new double[deg+1];
   double *yhilo = new double[deg+1];
   double *ylolo = new double[deg+1];
   double *zhihi_h = new double[deg+1];
   double *zlohi_h = new double[deg+1];
   double *zhilo_h = new double[deg+1];
   double *zlolo_h = new double[deg+1];
   double *zhihi_d = new double[deg+1];
   double *zlohi_d = new double[deg+1];
   double *zhilo_d = new double[deg+1];
   double *zlolo_d = new double[deg+1];
   double rhihi,rlohi,rhilo,rlolo;

   random_dbl4_exponentials
      (deg,&rhihi,&rlohi,&rhilo,&rlolo,
           xhihi,xlohi,xhilo,xlolo,yhihi,ylohi,yhilo,ylolo);

   CPU_dbl4_product(deg,xhihi,xlohi,xhilo,xlolo,yhihi,ylohi,yhilo,ylolo,
                        zhihi_h,zlohi_h,zhilo_h,zlolo_h);

   cout << scientific << setprecision(16);

   cout << "Product of series of exp(x) with series of exp(-x)," << endl;
   cout << "  for xhihi = " << rhihi;
   cout << "      xlohi = " << rlohi << endl;
   cout << "      xhilo = " << rhilo;
   cout << "  and xlolo = " << rlolo << endl;

   double sumhihi = 0.0;
   double sumlohi = 0.0;
   double sumhilo = 0.0;
   double sumlolo = 0.0;

   for(int k=0; k<=deg; k++)
      qdf_inc(&sumhihi,&sumlohi,&sumhilo,&sumlolo,
              zhihi_h[k],zlohi_h[k],zhilo_h[k],zlolo_h[k]);

   cout << "Summation of all coefficients in the product ..." << endl;
   cout << "    highest part of sum : " << sumhihi << endl;
   cout << "2nd highest part of sum : " << sumlohi << endl;
   cout << " 2nd lowest part of sum : " << sumhilo << endl;
   cout << "     lowest part of sum : " << sumlolo << endl;

   GPU_dbl4_product(xhihi,xlohi,xhilo,xlolo,
                    yhihi,ylohi,yhilo,ylolo,
                    zhihi_d,zlohi_d,zhilo_d,zlolo_d,deg,1,deg+1);

   sumhihi = 0.0; sumlohi = 0.0; sumhilo = 0.0; sumlolo = 0.0;

   for(int k=0; k<=deg; k++)
      qdf_inc(&sumhihi,&sumlohi,&sumhilo,&sumlolo,
              zhihi_d[k],zlohi_d[k],zhilo_d[k],zlolo_d[k]);

   cout << "Summation of all coefficients in the GPU computed product ..."
        << endl;
   cout << "    highest part of sum : " << sumhihi << endl;
   cout << "2nd highest part of sum : " << sumlohi << endl;
   cout << " 2nd lowest part of sum : " << sumhilo << endl;
   cout << "     lowest part of sum : " << sumlolo << endl;
}

void test_complex_exponential ( int deg )
{
   double* xrehihi = new double[deg+1];
   double* xrelohi = new double[deg+1];
   double* xrehilo = new double[deg+1];
   double* xrelolo = new double[deg+1];
   double* ximhihi = new double[deg+1];
   double* ximlohi = new double[deg+1];
   double* ximhilo = new double[deg+1];
   double* ximlolo = new double[deg+1];
   double* yrehihi = new double[deg+1];
   double* yrelohi = new double[deg+1];
   double* yrehilo = new double[deg+1];
   double* yrelolo = new double[deg+1];
   double* yimhihi = new double[deg+1];
   double* yimlohi = new double[deg+1];
   double* yimhilo = new double[deg+1];
   double* yimlolo = new double[deg+1];
   double* zrehihi_h = new double[deg+1];
   double* zrelohi_h = new double[deg+1];
   double* zrehilo_h = new double[deg+1];
   double* zrelolo_h = new double[deg+1];
   double* zimhihi_h = new double[deg+1];
   double* zimlohi_h = new double[deg+1];
   double* zimhilo_h = new double[deg+1];
   double* zimlolo_h = new double[deg+1];
   double* zrehihi_d = new double[deg+1];
   double* zrelohi_d = new double[deg+1];
   double* zrehilo_d = new double[deg+1];
   double* zrelolo_d = new double[deg+1];
   double* zimhihi_d = new double[deg+1];
   double* zimlohi_d = new double[deg+1];
   double* zimhilo_d = new double[deg+1];
   double* zimlolo_d = new double[deg+1];
   double rndrehihi,rndrelohi,rndrehilo,rndrelolo;
   double rndimhihi,rndimlohi,rndimhilo,rndimlolo;

   random_cmplx4_exponentials
      (deg,&rndrehihi,&rndrelohi,&rndrehilo,&rndrelolo,
           &rndimhihi,&rndimlohi,&rndimhilo,&rndimlolo,
           xrehihi,xrelohi,xrehilo,xrelolo,ximhihi,ximlohi,ximhilo,ximlolo,
           yrehihi,yrelohi,yrehilo,yrelolo,yimhihi,yimlohi,yimhilo,yimlolo);

   CPU_cmplx4_product
      (deg,xrehihi,xrelohi,xrehilo,xrelolo,ximhihi,ximlohi,ximhilo,ximlolo,
           yrehihi,yrelohi,yrehilo,yrelolo,yimhihi,yimlohi,yimhilo,yimlolo,
           zrehihi_h,zrelohi_h,zrehilo_h,zrelolo_h,
           zimhihi_h,zimlohi_h,zimhilo_h,zimlolo_h);

   cout << scientific << setprecision(16);

   cout << "Product of series of exp(x) with series of exp(-x)," << endl;
   cout << "  for xrehihi = " << rndrehihi;
   cout << "      xrelohi = " << rndrelohi << endl;
   cout << "      xrehilo = " << rndrehilo;
   cout << "  and xrelolo = " << rndrelolo << endl;
   cout << "  for ximhihi = " << rndimhihi;
   cout << "      ximlohi = " << rndimlohi << endl;
   cout << "      ximhilo = " << rndimhilo;
   cout << "  and ximlolo = " << rndimlolo << endl;

   double sumrehihi = 0.0;
   double sumrelohi = 0.0;
   double sumrehilo = 0.0;
   double sumrelolo = 0.0;
   double sumimhihi = 0.0;
   double sumimlohi = 0.0;
   double sumimhilo = 0.0;
   double sumimlolo = 0.0;

   for(int k=0; k<=deg; k++) 
   {
      qdf_inc(&sumrehihi,&sumrelohi,&sumrehilo,&sumrelolo,
              zrehihi_h[k],zrelohi_h[k],zrehilo_h[k],zrelolo_h[k]);
      qdf_inc(&sumimhihi,&sumimlohi,&sumimhilo,&sumimlolo,
              zimhihi_h[k],zimlohi_h[k],zimhilo_h[k],zimlolo_h[k]);
   }
   cout << "Summation of all coefficients of the product ..." << endl;
   cout << "  sumrehihi : " << sumrehihi;
   cout << "  sumrelohi : " << sumrelohi << endl;
   cout << "  sumrehilo : " << sumrehilo;
   cout << "  sumrelolo : " << sumrelolo << endl;
   cout << "  sumimhihi : " << sumimhihi;
   cout << "  sumimlohi : " << sumimlohi << endl;
   cout << "  sumimhilo : " << sumimhilo;
   cout << "  sumimlolo : " << sumimlolo << endl;

   GPU_cmplx4_product
      (xrehihi,xrelohi,xrehilo,xrelolo,ximhihi,ximlohi,ximhilo,ximlolo,
       yrehihi,yrelohi,yrehilo,yrelolo,yimhihi,yimlohi,yimhilo,yimlolo,
       zrehihi_d,zrelohi_d,zrehilo_d,zrelolo_d,
       zimhihi_d,zimlohi_d,zimhilo_d,zimlolo_d,deg,1,deg+1);

   sumrehihi = 0.0; sumrelohi = 0.0; sumimhihi = 0.0; sumimlohi = 0.0;
   sumrehilo = 0.0; sumrelolo = 0.0; sumimhilo = 0.0; sumimlolo = 0.0;

   for(int k=0; k<=deg; k++) 
   {
      qdf_inc(&sumrehihi,&sumrelohi,&sumrehilo,&sumrelolo,
              zrehihi_d[k],zrelohi_d[k],zrehilo_d[k],zrelolo_d[k]);
      qdf_inc(&sumimhihi,&sumimlohi,&sumimhilo,&sumimlolo,
              zimhihi_d[k],zimlohi_d[k],zimhilo_d[k],zimlolo_d[k]);
   }
   cout << "Summation of all coefficients of the GPU computed product ..."
        << endl;
   cout << "  sumrehihi : " << sumrehihi;
   cout << "  sumrelohi : " << sumrelohi << endl;
   cout << "  sumrehilo : " << sumrehilo;
   cout << "  sumrelolo : " << sumrelolo << endl;
   cout << "  sumimhihi : " << sumimhihi;
   cout << "  sumimlohi : " << sumimlohi << endl;
   cout << "  sumimhilo : " << sumimhilo;
   cout << "  sumimlolo : " << sumimlolo << endl;
}
