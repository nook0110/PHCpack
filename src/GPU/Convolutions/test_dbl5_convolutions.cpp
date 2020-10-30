/* Tests the product of two series in penta double precision. */

#include <iostream>
#include <iomanip>
#include <vector_types.h>
#include "penta_double_functions.h"
#include "random5_vectors.h"
#include "dbl5_convolutions_host.h"
#include "dbl5_convolutions_kernels.h"

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
   double* xtb = new double[deg+1];
   double* xix = new double[deg+1];
   double* xmi = new double[deg+1];
   double* xrg = new double[deg+1];
   double* xpk = new double[deg+1];
   double* ytb = new double[deg+1];
   double* yix = new double[deg+1];
   double* ymi = new double[deg+1];
   double* yrg = new double[deg+1];
   double* ypk = new double[deg+1];
   double* ztb_h = new double[deg+1];
   double* zix_h = new double[deg+1];
   double* zmi_h = new double[deg+1];
   double* zrg_h = new double[deg+1];
   double* zpk_h = new double[deg+1];
   double* ztb_d = new double[deg+1];
   double* zix_d = new double[deg+1];
   double* zmi_d = new double[deg+1];
   double* zrg_d = new double[deg+1];
   double* zpk_d = new double[deg+1];

   for(int k=0; k<=deg; k++)
   {
      xtb[k] = 1.0; xix[k] = 0.0; xmi[k] = 0.0; xrg[k] = 0.0; xpk[k] = 0.0;
      ytb[k] = 0.0; yix[k] = 0.0; ymi[k] = 0.0; yrg[k] = 0.0; ypk[k] = 0.0;
   }
   ytb[0] = 1.0; ytb[1] = -1.0;

   CPU_dbl5_product
      (deg,xtb,xix,xmi,xrg,xpk,ytb,yix,ymi,yrg,ypk,
       ztb_h,zix_h,zmi_h,zrg_h,zpk_h);

   cout << "Series of 1/(1-x) multiplied with 1-x : " << endl;

   for(int k=0; k<=deg; k++)
   {
      cout << "ztb[" << k << "] : " << ztb_h[k];
      cout << "  zix[" << k << "] : " << zix_h[k];
      cout << "  zmi[" << k << "] : " << zmi_h[k];
      cout << "  zrg[" << k << "] : " << zrg_h[k];
      cout << "  zpk[" << k << "] : " << zpk_h[k] << endl;
   }

   GPU_dbl5_product
      (xtb,xix,xmi,xrg,xpk,ytb,yix,ymi,yrg,ypk,
       ztb_d,zix_d,zmi_d,zrg_d,zpk_d,deg,1,deg+1);

   cout << "GPU computed product :" << endl;

   for(int k=0; k<=deg; k++)
   {
      cout << "ztb[" << k << "] : " << ztb_d[k];
      cout << "  zix[" << k << "] : " << zix_d[k];
      cout << "  zmi[" << k << "] : " << zmi_d[k];
      cout << "  zrg[" << k << "] : " << zrg_d[k];
      cout << "  zpk[" << k << "] : " << zpk_d[k] << endl;
   }
   cout << endl;
}

void test_complex ( int deg )
{
   double* xretb = new double[deg+1];
   double* xreix = new double[deg+1];
   double* xremi = new double[deg+1];
   double* xrerg = new double[deg+1];
   double* xrepk = new double[deg+1];
   double* ximtb = new double[deg+1];
   double* ximix = new double[deg+1];
   double* ximmi = new double[deg+1];
   double* ximrg = new double[deg+1];
   double* ximpk = new double[deg+1];
   double* yretb = new double[deg+1];
   double* yreix = new double[deg+1];
   double* yremi = new double[deg+1];
   double* yrerg = new double[deg+1];
   double* yrepk = new double[deg+1];
   double* yimtb = new double[deg+1];
   double* yimix = new double[deg+1];
   double* yimmi = new double[deg+1];
   double* yimrg = new double[deg+1];
   double* yimpk = new double[deg+1];
   double* zretb_h = new double[deg+1];
   double* zreix_h = new double[deg+1];
   double* zremi_h = new double[deg+1];
   double* zrerg_h = new double[deg+1];
   double* zrepk_h = new double[deg+1];
   double* zimtb_h = new double[deg+1];
   double* zimix_h = new double[deg+1];
   double* zimmi_h = new double[deg+1];
   double* zimrg_h = new double[deg+1];
   double* zimpk_h = new double[deg+1];
   double* zretb_d = new double[deg+1];
   double* zreix_d = new double[deg+1];
   double* zremi_d = new double[deg+1];
   double* zrerg_d = new double[deg+1];
   double* zrepk_d = new double[deg+1];
   double* zimtb_d = new double[deg+1];
   double* zimix_d = new double[deg+1];
   double* zimmi_d = new double[deg+1];
   double* zimrg_d = new double[deg+1];
   double* zimpk_d = new double[deg+1];

   for(int k=0; k<=deg; k++)
   {
      xretb[k] = 1.0; xreix[k] = 0.0; xremi[k] = 0.0;
      xrerg[k] = 0.0; xrepk[k] = 0.0;
      ximtb[k] = 0.0; ximix[k] = 0.0; ximmi[k] = 0.0;
      ximrg[k] = 0.0; ximpk[k] = 0.0;
      yretb[k] = 0.0; yreix[k] = 0.0; yremi[k] = 0.0;
      yrerg[k] = 0.0; yrepk[k] = 0.0;
      yimtb[k] = 0.0; yimix[k] = 0.0; yimmi[k] = 0.0;
      yimrg[k] = 0.0; yimpk[k] = 0.0;
   }
   yretb[0] = 1.0; yretb[1] = -1.0;

   CPU_cmplx5_product
      (deg,xretb,xreix,xremi,xrerg,xrepk,ximtb,ximix,ximmi,ximrg,ximpk,
           yretb,yreix,yremi,yrerg,yrepk,yimtb,yimix,yimmi,yimrg,yimpk,
           zretb_h,zreix_h,zremi_h,zrerg_h,zrepk_h,
           zimtb_h,zimix_h,zimmi_h,zimrg_h,zimpk_h);

   cout << "Series of 1/(1-x) multiplied with 1-x :" << endl;

   for(int k=0; k<=deg; k++)
   {
      cout << "zretb[" << k << "] : " << zretb_h[k];
      cout << "  zreix[" << k << "] : " << zreix_h[k];
      cout << "  zremi[" << k << "] : " << zremi_h[k];
      cout << "  zrerg[" << k << "] : " << zrerg_h[k];
      cout << "  zrepk[" << k << "] : " << zrepk_h[k] << endl;
      cout << "zimtb[" << k << "] : " << zimtb_h[k];
      cout << "  zimix[" << k << "] : " << zimix_h[k];
      cout << "  zimmi[" << k << "] : " << zimmi_h[k];
      cout << "  zimrg[" << k << "] : " << zimrg_h[k];
      cout << "  zimpk[" << k << "] : " << zimpk_h[k] << endl;
   }

   GPU_cmplx5_product
      (xretb,xreix,xremi,xrerg,xrepk,ximtb,ximix,ximmi,ximrg,ximpk,
       yretb,yreix,yremi,yrerg,yrepk,yimtb,yimix,yimmi,yimrg,yimpk,
       zretb_d,zreix_d,zremi_d,zrerg_d,zrepk_d,
       zimtb_d,zimix_d,zimmi_d,zimrg_d,zimpk_d,deg,1,deg+1);

   cout << "GPU computed product :" << endl;

   for(int k=0; k<=deg; k++)
   {
      cout << "zretb[" << k << "] : " << zretb_d[k];
      cout << "  zreix[" << k << "] : " << zreix_d[k];
      cout << "  zremi[" << k << "] : " << zremi_d[k];
      cout << "  zrerg[" << k << "] : " << zrerg_d[k];
      cout << "  zrepk[" << k << "] : " << zrepk_d[k] << endl;
      cout << "zimtb[" << k << "] : " << zimtb_d[k];
      cout << "  zimix[" << k << "] : " << zimix_d[k];
      cout << "  zimmi[" << k << "] : " << zimmi_d[k];
      cout << "  zimrg[" << k << "] : " << zimrg_d[k];
      cout << "  zimpk[" << k << "] : " << zimpk_d[k] << endl;
   }
}

void test_real_exponential ( int deg )
{
   double *xtb = new double[deg+1];
   double *xix = new double[deg+1];
   double *xmi = new double[deg+1];
   double *xrg = new double[deg+1];
   double *xpk = new double[deg+1];
   double *ytb = new double[deg+1];
   double *yix = new double[deg+1];
   double *ymi = new double[deg+1];
   double *yrg = new double[deg+1];
   double *ypk = new double[deg+1];
   double *ztb_h = new double[deg+1];
   double *zix_h = new double[deg+1];
   double *zmi_h = new double[deg+1];
   double *zrg_h = new double[deg+1];
   double *zpk_h = new double[deg+1];
   double *ztb_d = new double[deg+1];
   double *zix_d = new double[deg+1];
   double *zmi_d = new double[deg+1];
   double *zrg_d = new double[deg+1];
   double *zpk_d = new double[deg+1];
   double rtb,rix,rmi,rrg,rpk;
   double ftb,fix,fmi,frg,fpk;

   random_penta_double(&rtb,&rix,&rmi,&rrg,&rpk);

   xtb[0] = 1.0;  xix[0] = 0.0;  xmi[0] = 0.0;  xrg[0] = 0.0;  xpk[0] = 0.0;
   ytb[0] = 1.0;  yix[0] = 0.0;  ymi[0] = 0.0;  yrg[0] = 0.0;  ypk[0] = 0.0;
   xtb[1] = rtb;  xix[1] = rix;  xmi[1] = rmi;  xrg[1] = rrg;  xpk[1] = rpk;
   ytb[1] = -rtb; yix[1] = -rix; ymi[1] = -rmi; yrg[1] = -rrg; ypk[1] = -rpk;

   for(int k=2; k<=deg; k++)
   {
      pdf_mul(xtb[k-1],xix[k-1],xmi[k-1],xrg[k-1],xpk[k-1],
              rtb,rix,rmi,rrg,rpk,
              &xtb[k],&xix[k],&xmi[k],&xrg[k],&xpk[k]);    // x[k] = x[k-1]*r
      pdf_mul(ytb[k-1],yix[k-1],ymi[k-1],yrg[k-1],ypk[k-1],
              -rtb,-rix,-rmi,-rrg,-rpk,
              &ytb[k],&yix[k],&ymi[k],&yrg[k],&ypk[k]); 
      // y[k] = y[k-1]*(-r);
      ftb = (double) k; fix = 0.0; fmi = 0.0; frg = 0.0; fpk = 0.0;
      pdf_div(xtb[k],xix[k],xmi[k],xrg[k],xpk[k],ftb,fix,fmi,frg,fpk,
              &xtb[k],&xix[k],&xmi[k],&xrg[k],&xpk[k]);
      pdf_div(ytb[k],yix[k],ymi[k],yrg[k],ypk[k],ftb,fix,fmi,frg,fpk,
              &ytb[k],&yix[k],&ymi[k],&yrg[k],&ypk[k]);
   }

   CPU_dbl5_product
      (deg,xtb,xix,xmi,xrg,xpk,ytb,yix,ymi,yrg,ypk,
       ztb_h,zix_h,zmi_h,zrg_h,zpk_h);

   cout << scientific << setprecision(16);

   cout << "Product of series of exp(x) with series of exp(-x)," << endl;
   cout << "  for xtb = " << rtb << endl;
   cout << "      xix = " << rix << endl;
   cout << "      xmi = " << rmi << endl;
   cout << "      xrg = " << rrg << endl;
   cout << "  and xpk = " << rpk << endl;

   double sumtb = 0.0;
   double sumix = 0.0;
   double summi = 0.0;
   double sumrg = 0.0;
   double sumpk = 0.0;

   for(int k=0; k<=deg; k++)
      pdf_inc(&sumtb,&sumix,&summi,&sumrg,&sumpk,
              ztb_h[k],zix_h[k],zmi_h[k],zrg_h[k],zpk_h[k]);

   cout << "Summation of all coefficients in the product ..." << endl;
   cout << "       highest part of the sum : " << sumtb << endl;
   cout << "second highest part of the sum : " << sumix << endl;
   cout << "        middle part of the sum : " << summi << endl;
   cout << " second lowest part of the sum : " << sumrg << endl;
   cout << "        lowest part of the sum : " << sumpk << endl;

   GPU_dbl5_product
      (xtb,xix,xmi,xrg,xpk,ytb,yix,ymi,yrg,ypk,
       ztb_d,zix_d,zmi_d,zrg_d,zpk_d,deg,1,deg+1);

   sumtb = 0.0; sumix = 0.0; summi = 0.0; sumrg = 0.0; sumpk = 0.0;

   for(int k=0; k<=deg; k++)
      pdf_inc(&sumtb,&sumix,&summi,&sumrg,&sumpk,
              ztb_d[k],zix_d[k],zmi_d[k],zrg_d[k],zpk_d[k]);

   cout << "Summation of all coefficients in the GPU computed product ..."
        << endl;
   cout << "       highest part of the sum : " << sumtb << endl;
   cout << "second highest part of the sum : " << sumix << endl;
   cout << "        middle part of the sum : " << summi << endl;
   cout << " second lowest part of the sum : " << sumrg << endl;
   cout << "        lowest part of the sum : " << sumpk << endl;
}

void test_complex_exponential ( int deg )
{
   double* xretb = new double[deg+1];
   double* xreix = new double[deg+1];
   double* xremi = new double[deg+1];
   double* xrerg = new double[deg+1];
   double* xrepk = new double[deg+1];
   double* ximtb = new double[deg+1];
   double* ximix = new double[deg+1];
   double* ximmi = new double[deg+1];
   double* ximrg = new double[deg+1];
   double* ximpk = new double[deg+1];
   double* yretb = new double[deg+1];
   double* yreix = new double[deg+1];
   double* yremi = new double[deg+1];
   double* yrerg = new double[deg+1];
   double* yrepk = new double[deg+1];
   double* yimtb = new double[deg+1];
   double* yimix = new double[deg+1];
   double* yimmi = new double[deg+1];
   double* yimrg = new double[deg+1];
   double* yimpk = new double[deg+1];
   double* zretb_h = new double[deg+1];
   double* zreix_h = new double[deg+1];
   double* zremi_h = new double[deg+1];
   double* zrerg_h = new double[deg+1];
   double* zrepk_h = new double[deg+1];
   double* zimtb_h = new double[deg+1];
   double* zimix_h = new double[deg+1];
   double* zimmi_h = new double[deg+1];
   double* zimrg_h = new double[deg+1];
   double* zimpk_h = new double[deg+1];
   double* zretb_d = new double[deg+1];
   double* zreix_d = new double[deg+1];
   double* zremi_d = new double[deg+1];
   double* zrerg_d = new double[deg+1];
   double* zrepk_d = new double[deg+1];
   double* zimtb_d = new double[deg+1];
   double* zimix_d = new double[deg+1];
   double* zimmi_d = new double[deg+1];
   double* zimrg_d = new double[deg+1];
   double* zimpk_d = new double[deg+1];
   double rndretb,rndreix,rndremi,rndrerg,rndrepk;
   double rndimtb,rndimix,rndimmi,rndimrg,rndimpk;
   double tmptb,tmpix,tmpmi,tmprg,tmppk;

   random_penta_double
      (&rndretb,&rndreix,&rndremi,&rndrerg,&rndrepk);       // cos(a)

   pdf_sqr(rndretb,rndreix,rndremi,rndrerg,rndrepk,
           &tmptb,&tmpix,&tmpmi,&tmprg,&tmppk);             // cos^2(a)
   pdf_minus(&tmptb,&tmpix,&tmpmi,&tmprg,&tmppk);           // -cos^2(a)
   pdf_inc_d(&tmptb,&tmpix,&tmpmi,&tmprg,&tmppk,1.0);       // 1-cos^2(a)
   pdf_sqrt(tmptb,tmpix,tmpmi,tmprg,tmppk,
            &rndimtb,&rndimix,&rndimmi,&rndimrg,&rndimpk);  // sin is sqrt

   xretb[0] = 1.0; xreix[0] = 0.0; xremi[0] = 0.0;
   xrerg[0] = 0.0; xrepk[0] = 0.0;
   yretb[0] = 1.0; yreix[0] = 0.0; yremi[0] = 0.0;
   yrerg[0] = 0.0; yrepk[0] = 0.0;
   ximtb[0] = 0.0; ximix[0] = 0.0; ximmi[0] = 0.0;
   ximrg[0] = 0.0; ximpk[0] = 0.0;
   yimtb[0] = 0.0; yimix[0] = 0.0; yimmi[0] = 0.0;
   ximrg[0] = 0.0; yimpk[0] = 0.0;
   xretb[1] = rndretb; xreix[1] = rndreix; xremi[1] = rndremi;
   xrerg[1] = rndrerg; xrepk[1] = rndrepk;
   ximtb[1] = rndimtb; ximix[1] = rndimix; ximmi[1] = rndimmi;
   ximrg[1] = rndimrg; ximpk[1] = rndimpk;
   yretb[1] = -rndretb; yreix[1] = -rndreix; yremi[1] = -rndremi;
   yrerg[1] = -rndrerg; yrepk[1] = -rndrepk;
   yimtb[1] = -rndimtb; yimix[1] = -rndimix; yimmi[1] = -rndimmi;
   yimrg[1] = -rndimrg; yimpk[1] = -rndimpk;

   for(int k=2; k<=deg; k++)
   {
      // xre[k] = (xre[k-1]*cr - xim[k-1]*sr)/k;
      pdf_mul(xretb[k-1],xreix[k-1],xremi[k-1],xrerg[k-1],xrepk[k-1],
              rndretb,rndreix,rndremi,rndrerg,rndrepk,
              &xretb[k],&xreix[k],&xremi[k],&xrerg[k],&xrepk[k]);
      pdf_mul(ximtb[k-1],ximix[k-1],ximmi[k-1],ximrg[k-1],ximpk[k-1],
              rndimtb,rndimix,rndimmi,rndimrg,rndimpk,
              &tmptb,&tmpix,&tmpmi,&tmprg,&tmppk);
      pdf_minus(&tmptb,&tmpix,&tmpmi,&tmprg,&tmppk);
      pdf_inc(&xretb[k],&xreix[k],&xremi[k],&xrerg[k],&xrepk[k],
              tmptb,tmpix,tmpmi,tmprg,tmppk);
      tmptb = (double) k; tmpix = 0.0; tmpmi = 0.0; tmprg = 0.0; tmppk = 0.0;
      pdf_div(xretb[k],xreix[k],xremi[k],xrerg[k],xrepk[k],
              tmptb,tmpix,tmpmi,tmprg,tmppk,
              &xretb[k],&xreix[k],&xremi[k],&xrerg[k],&xrepk[k]);
      // xim[k] = (xre[k-1]*sr + xim[k-1]*cr)/k;
      pdf_mul(xretb[k-1],xreix[k-1],xremi[k-1],xrerg[k-1],xrepk[k-1],
              rndimtb,rndimix,rndimmi,rndimrg,rndimpk,
              &ximtb[k],&ximix[k],&ximmi[k],&ximrg[k],&ximpk[k]);
      pdf_mul(ximtb[k-1],ximix[k-1],ximmi[k-1],ximrg[k-1],ximpk[k-1],
              rndretb,rndreix,rndremi,rndrerg,rndrepk,
              &tmptb,&tmpix,&tmpmi,&tmprg,&tmppk);
      pdf_inc(&ximtb[k],&ximix[k],&ximmi[k],&ximrg[k],&ximpk[k],
              tmptb,tmpix,tmpmi,tmprg,tmppk);
      tmptb = (double) k; tmpix = 0.0; tmpmi = 0.0; tmprg = 0.0; tmppk = 0.0;
      pdf_div(ximtb[k],ximix[k],ximmi[k],ximrg[k],ximpk[k],
              tmptb,tmpix,tmpmi,tmprg,tmppk,
              &ximtb[k],&ximix[k],&ximmi[k],&ximrg[k],&ximpk[k]);
      // yre[k] = (yre[k-1]*(-cr) - yim[k-1]*(-sr))/k;
      pdf_mul(yretb[k-1],yreix[k-1],yremi[k-1],yrerg[k-1],yrepk[k-1],
              -rndretb,-rndreix,-rndremi,-rndrerg,-rndrepk,
              &yretb[k],&yreix[k],&yremi[k],&yrerg[k],&yrepk[k]);
      pdf_mul(yimtb[k-1],yimix[k-1],yimmi[k-1],yimrg[k-1],yimpk[k-1],
              -rndimtb,-rndimix,-rndimmi,-rndimrg,-rndimpk,
              &tmptb,&tmpix,&tmpmi,&tmprg,&tmppk);
      pdf_minus(&tmptb,&tmpix,&tmpmi,&tmprg,&tmppk);
      pdf_inc(&yretb[k],&yreix[k],&yremi[k],&yrerg[k],&yrepk[k],
              tmptb,tmpix,tmpmi,tmprg,tmppk);
      tmptb = (double) k; tmpix = 0.0; tmpmi = 0.0; tmprg = 0.0; tmppk = 0.0;
      pdf_div(yretb[k],yreix[k],yremi[k],yrerg[k],yrepk[k],
              tmptb,tmpix,tmpmi,tmprg,tmppk,
              &yretb[k],&yreix[k],&yremi[k],&yrerg[k],&yrepk[k]);
      // yim[k] = (yre[k-1]*(-sr) + yim[k-1]*(-cr))/k;
      pdf_mul(yretb[k-1],yreix[k-1],yremi[k-1],yrerg[k-1],yrepk[k-1],
              -rndimtb,-rndimix,-rndimmi,-rndimrg,-rndimpk,
              &yimtb[k],&yimix[k],&yimmi[k],&yimrg[k],&yimpk[k]);
      pdf_mul(yimtb[k-1],yimix[k-1],yimmi[k-1],yimrg[k-1],yimpk[k-1],
              -rndretb,-rndreix,-rndremi,-rndrerg,-rndrepk,
              &tmptb,&tmpix,&tmpmi,&tmprg,&tmppk);
      pdf_inc(&yimtb[k],&yimix[k],&yimmi[k],&yimrg[k],&yimpk[k],
              tmptb,tmpix,tmpmi,tmprg,tmppk);
      tmptb = (double) k; tmpix = 0.0; tmpmi = 0.0; tmprg = 0.0; tmppk = 0.0;
      pdf_div(yimtb[k],yimix[k],yimmi[k],yimrg[k],yimpk[k],
              tmptb,tmpix,tmpmi,tmprg,tmppk,
              &yimtb[k],&yimix[k],&yimmi[k],&yimrg[k],&yimpk[k]);
   }

   CPU_cmplx5_product
      (deg,xretb,xreix,xremi,xrerg,xrepk,ximtb,ximix,ximmi,ximrg,ximpk,
           yretb,yreix,yremi,yrerg,yrepk,yimtb,yimix,yimmi,yimrg,yimpk,
           zretb_h,zreix_h,zremi_h,zrerg_h,zrepk_h,
           zimtb_h,zimix_h,zimmi_h,zimrg_h,zimpk_h);

   cout << scientific << setprecision(16);

   cout << "Product of series of exp(x) with series of exp(-x)," << endl;
   cout << "  for xretb = " << rndretb;
   cout << "      xreix = " << rndreix << endl;
   cout << "      xremi = " << rndremi;
   cout << "      xrerg = " << rndrerg << endl;
   cout << "  and xrepk = " << rndrepk << endl;
   cout << "  for ximtb = " << rndimtb;
   cout << "      ximix = " << rndimix << endl;
   cout << "      ximmi = " << rndimmi;
   cout << "      ximrg = " << rndimrg << endl;
   cout << "  and ximpk = " << rndimpk << endl;

   double sumretb = 0.0;
   double sumreix = 0.0;
   double sumremi = 0.0;
   double sumrerg = 0.0;
   double sumrepk = 0.0;
   double sumimtb = 0.0;
   double sumimix = 0.0;
   double sumimmi = 0.0;
   double sumimrg = 0.0;
   double sumimpk = 0.0;

   for(int k=0; k<=deg; k++) 
   {
      pdf_inc(&sumretb,&sumreix,&sumremi,&sumrerg,&sumrepk,
              zretb_h[k],zreix_h[k],zremi_h[k],zrerg_h[k],zrepk_h[k]);
      pdf_inc(&sumimtb,&sumimix,&sumimmi,&sumimrg,&sumimpk,
              zimtb_h[k],zimix_h[k],zimmi_h[k],zimrg_h[k],zimpk_h[k]);
   }
   cout << "Summation of all coefficients of the product ..." << endl;
   cout << "  sumretb : " << sumretb;
   cout << "  sumreix : " << sumreix << endl;
   cout << "  sumremi : " << sumremi;
   cout << "  sumrerg : " << sumrerg << endl;
   cout << "  sumrepk : " << sumrepk << endl;
   cout << "  sumimtb : " << sumimtb;
   cout << "  sumimix : " << sumimix << endl;
   cout << "  sumimmi : " << sumimmi;
   cout << "  sumimrg : " << sumimrg << endl;
   cout << "  sumimpk : " << sumimpk << endl;

   GPU_cmplx5_product
      (xretb,xreix,xremi,xrerg,xrepk,ximtb,ximix,ximmi,ximrg,ximpk,
       yretb,yreix,yremi,yrerg,yrepk,yimtb,yimix,yimmi,yimrg,yimpk,
       zretb_d,zreix_d,zremi_d,zrerg_d,zrepk_d,
       zimtb_d,zimix_d,zimmi_d,zimrg_d,zimpk_d,deg,1,deg+1);

   sumretb = 0.0; sumreix = 0.0; sumremi = 0.0; sumrerg = 0.0; sumrepk = 0.0;
   sumimtb = 0.0; sumimix = 0.0; sumimmi = 0.0; sumimrg = 0.0; sumimpk = 0.0;

   for(int k=0; k<=deg; k++) 
   {
      pdf_inc(&sumretb,&sumreix,&sumremi,&sumrerg,&sumrepk,
              zretb_d[k],zreix_d[k],zremi_d[k],zrerg_d[k],zrepk_d[k]);
      pdf_inc(&sumimtb,&sumimix,&sumimmi,&sumimrg,&sumimpk,
              zimtb_d[k],zimix_d[k],zimmi_d[k],zimrg_d[k],zimpk_d[k]);
   }
   cout << "Summation of all coefficients of the GPU computed product ..."
        << endl;
   cout << "  sumretb : " << sumretb;
   cout << "  sumreix : " << sumreix << endl;
   cout << "  sumremi : " << sumremi;
   cout << "  sumrerg : " << sumrerg << endl;
   cout << "  sumrepk : " << sumrepk << endl;
   cout << "  sumimtb : " << sumimtb;
   cout << "  sumimix : " << sumimix << endl;
   cout << "  sumimmi : " << sumimmi;
   cout << "  sumimrg : " << sumimrg << endl;
   cout << "  sumimpk : " << sumimpk << endl;
}
