// The file complexadd_jobs.cpp defines the methods of the 
// class ComplexAdditionJobs, specified in "addition_jobs.h".

#include <cstdlib>
#include <iostream>
#include "complexadd_jobs.h"

ComplexAdditionJobs::ComplexAdditionJobs ( int dim, int nbr )
{
   nbrvar = dim;
   nbrmon = nbr;
   jobcount = 0;
   laydepth = 0;
}

void ComplexAdditionJobs::recursive_start ( int nbr, int *level, int *stride )
{
   int lvl = 0;
   int pwr = 1; // pwr = 2**lvl

   while(pwr <= nbr)
   {
      lvl = lvl+1;
      pwr = pwr*2;
   }
   *level = lvl-1;
   *stride = pwr/2;
}

void ComplexAdditionJobs::recursive_make
 ( int level, int stride, int nbr, int *nvr, bool verbose )
{
   const int ix1 = nbr - 1;
   const int ix2 = ix1 - stride;

   if(ix2 >= 0)
   {
      // first real operand
      ComplexAdditionJob job1(1,1,ix1,ix2,nvr[ix1]-1,nvr[ix2]-1);
      if(verbose) cout << "adding " << job1
                       << " to layer " << level << endl;
      jobs[level].push_back(job1);
      jobcount = jobcount + 1;
      freqlaycnt[level] = freqlaycnt[level] + 1;
      // first imaginary operand
      ComplexAdditionJob job2(4,7,ix1,ix2,nvr[ix1]-1,nvr[ix2]-1);
      if(verbose) cout << "adding " << job2
                       << " to layer " << level << endl;
      jobs[level].push_back(job2);
      jobcount = jobcount + 1;
      freqlaycnt[level] = freqlaycnt[level] + 1;
      // second real operand
      ComplexAdditionJob job3(1,4,ix1,ix2,nvr[ix1]-1,nvr[ix2]-1);
      if(verbose) cout << "adding " << job3
                       << " to layer " << level+1 << endl;
      jobs[level+1].push_back(job3);
      jobcount = jobcount + 1;
      freqlaycnt[level+1] = freqlaycnt[level+1] + 1;
      // second imaginary operand
      ComplexAdditionJob job4(4,10,ix1,ix2,nvr[ix1]-1,nvr[ix2]-1);
      if(verbose) cout << "adding " << job4
                       << " to layer " << level+1 << endl;
      jobs[level+1].push_back(job4);
      jobcount = jobcount + 1;
      freqlaycnt[level+1] = freqlaycnt[level+1] + 1;
   }
   else if(ix2 == -1)
   {
      // first real operand
      ComplexAdditionJob job1(1,1,ix1,-1,nvr[ix1]-1,-1);
      if(verbose) cout << "adding " << job1
                       << " to layer " << level << endl;
      jobs[level].push_back(job1);
      jobcount = jobcount + 1;
      freqlaycnt[level] = freqlaycnt[level] + 1;
      // first imaginary operand
      ComplexAdditionJob job2(4,7,ix1,-1,nvr[ix1]-1,-2);
      if(verbose) cout << "adding " << job2
                       << " to layer " << level << endl;
      jobs[level].push_back(job2);
      jobcount = jobcount + 1;
      freqlaycnt[level] = freqlaycnt[level] + 1;
      // there are no second operands with constant coefficients
   }
   if(level > 1)
   {
      recursive_make(level-2,stride/2,nbr,nvr,verbose);
      if(nbr > stride)
         recursive_make(level-2,stride/2,nbr-stride,nvr,verbose);
   }
}

void ComplexAdditionJobs::recursive_first_make
 ( int level, int stride, int nbr, int *nvr, bool verbose )
{
   const int ix0 = nbr - stride;

   // if(ix0 < 0) return;

   const int ix1 = difidx[0][nbr];
   const int ix2 = difidx[0][ix0];

   if(ix0 > 0)
   {
      // first real operand
      ComplexAdditionJob job1(2,2,ix1,ix2,nvr[ix1]-2,nvr[ix2]-2);
      if(verbose) cout << "adding " << job1
                       << " to layer " << level << endl;
      jobs[level].push_back(job1);
      jobcount = jobcount + 1;
      freqlaycnt[level] = freqlaycnt[level] + 1;
      // first imaginary operand
      ComplexAdditionJob job2(5,8,ix1,ix2,nvr[ix1]-2,nvr[ix2]-2);
      if(verbose) cout << "adding " << job2
                       << " to layer " << level << endl;
      jobs[level].push_back(job2);
      jobcount = jobcount + 1;
      freqlaycnt[level] = freqlaycnt[level] + 1;
      // second real operand
      ComplexAdditionJob job3(2,5,ix1,ix2,nvr[ix1]-2,nvr[ix2]-2);
      if(verbose) cout << "adding " << job3
                       << " to layer " << level+1 << endl;
      jobs[level+1].push_back(job3);
      jobcount = jobcount + 1;
      freqlaycnt[level+1] = freqlaycnt[level+1] + 1;
      // second imaginary operand
      ComplexAdditionJob job4(5,11,ix1,ix2,nvr[ix1]-2,nvr[ix2]-2);
      if(verbose) cout << "adding " << job4
                       << " to layer " << level+1 << endl;
      jobs[level+1].push_back(job4);
      jobcount = jobcount + 1;
      freqlaycnt[level+1] = freqlaycnt[level+1] + 1;
   }
   else if((ix0 == 0) && (ix2 != -1))
   {
      // first real operand
      ComplexAdditionJob job1(2,2,ix1,-1,nvr[ix1]-2,ix2);
      if(verbose) cout << "adding " << job1
                       << " to layer " << level << endl;
      jobs[level].push_back(job1);
      jobcount = jobcount + 1;
      freqlaycnt[level] = freqlaycnt[level] + 1;
      // first imaginary operand
      ComplexAdditionJob job2(5,8,ix1,-2,nvr[ix1]-2,ix2);
      if(verbose) cout << "adding " << job2
                       << " to layer " << level << endl;
      jobs[level].push_back(job2);
      jobcount = jobcount + 1;
      freqlaycnt[level] = freqlaycnt[level] + 1;
      // second real operand
      ComplexAdditionJob job3(2,5,ix1,-1,nvr[ix1]-2,ix2);
      if(verbose) cout << "adding " << job3
                       << " to layer " << level+1 << endl;
      jobs[level+1].push_back(job3);
      jobcount = jobcount + 1;
      freqlaycnt[level+1] = freqlaycnt[level+1] + 1;
      // second imaginary operand
      ComplexAdditionJob job4(5,11,ix1,-2,nvr[ix1]-2,ix2);
      if(verbose) cout << "adding " << job4
                       << " to layer " << level+1 << endl;
      jobs[level+1].push_back(job4);
      jobcount = jobcount + 1;
      freqlaycnt[level+1] = freqlaycnt[level+1] + 1;
   }
   if(level > 1)
   {
      recursive_first_make(level-2,stride/2,nbr,nvr,verbose);
      if(nbr > stride)
         recursive_first_make(level-2,stride/2,nbr-stride,nvr,verbose);
   }
}

int ComplexAdditionJobs::position ( int n, int *idx, int k )
{
   for(int i=0; i<n; i++)
      if(idx[i] == k) return i;

   return -1;
}

void ComplexAdditionJobs::recursive_other_make
 ( int level, int stride, int nbr, int *nvr, int **idx, int varidx,
   bool verbose )
{
   const int ix0 = nbr - stride;
   const int ix1 = difidx[varidx][nbr];
   // index of the monomial at position nbr that contains varidx
   const int ix3 = nvr[ix1]-1; // last index of variable in monomial nbr

   if(verbose)
   {
      cout << "nbr : " << nbr << ", stride : " << stride;
      cout << ", ix0 : " << ix0;
      cout << ", ix1 : " << ix1;
   }
   if(ix0 > 0)
   {
      const int ix2 = difidx[varidx][ix0];
      // index of the monomial at position ix0 that contains varidx
      const int ix4 = nvr[ix2]-1;
      // last index of variable in other monomial

      if(verbose) cout << ", ix2 = " << ix2 << ", ix4 = " << ix4 << endl;

      if(idx[ix1][0] == varidx) // update the backward product
      {
         if(idx[ix2][0] == varidx)       // use backward product as increment
         {
            // first real operand
            ComplexAdditionJob job1(2,2,ix1,ix2,nvr[ix1]-2,nvr[ix2]-2);
            if(verbose) cout << "adding " << job1
                             << " to layer " << level << endl;
            jobs[level].push_back(job1);
            jobcount = jobcount + 1;
            freqlaycnt[level] = freqlaycnt[level] + 1;
            // first imaginary operand
            ComplexAdditionJob job2(5,8,ix1,ix2,nvr[ix1]-2,nvr[ix2]-2);
            if(verbose) cout << "adding " << job2
                             << " to layer " << level << endl;
            jobs[level].push_back(job2);
            jobcount = jobcount + 1;
            freqlaycnt[level] = freqlaycnt[level] + 1;
            // second real operand
            ComplexAdditionJob job3(2,5,ix1,ix2,nvr[ix1]-2,nvr[ix2]-2);
            if(verbose) cout << "adding " << job3
                             << " to layer " << level+1 << endl;
            jobs[level+1].push_back(job3);
            jobcount = jobcount + 1;
            freqlaycnt[level+1] = freqlaycnt[level+1] + 1;
            // second imaginary operand
            ComplexAdditionJob job4(5,11,ix1,ix2,nvr[ix1]-2,nvr[ix2]-2);
            if(verbose) cout << "adding " << job4
                             << " to layer " << level+1 << endl;
            jobs[level+1].push_back(job4);
            jobcount = jobcount + 1;
            freqlaycnt[level+1] = freqlaycnt[level+1] + 1;
         }
         else if(idx[ix2][ix4] == varidx) // use forward product as increment
         {
            // first real operand
            ComplexAdditionJob job1(2,1,ix1,ix2,nvr[ix1]-2,nvr[ix2]-2);
            if(verbose) cout << "adding " << job1
                             << " to layer " << level << endl;
            jobs[level].push_back(job1);
            jobcount = jobcount + 1;
            freqlaycnt[level] = freqlaycnt[level] + 1;
            // first imaginary operand
            ComplexAdditionJob job2(5,7,ix1,ix2,nvr[ix1]-2,nvr[ix2]-2);
            if(verbose) cout << "adding " << job2
                             << " to layer " << level << endl;
            jobs[level].push_back(job2);
            jobcount = jobcount + 1;
            freqlaycnt[level] = freqlaycnt[level] + 1;
            // second real operand
            ComplexAdditionJob job3(2,4,ix1,ix2,nvr[ix1]-2,nvr[ix2]-2);
            if(verbose) cout << "adding " << job3
                             << " to layer " << level+1 << endl;
            jobs[level+1].push_back(job3);
            jobcount = jobcount + 1;
            freqlaycnt[level+1] = freqlaycnt[level+1] + 1;
            // second imaginary operand
            ComplexAdditionJob job4(5,10,ix1,ix2,nvr[ix1]-2,nvr[ix2]-2);
            if(verbose) cout << "adding " << job4
                             << " to layer " << level+1 << endl;
            jobs[level+1].push_back(job4);
            jobcount = jobcount + 1;
            freqlaycnt[level+1] = freqlaycnt[level+1] + 1;
         }
         else                               // use cross product as increment
         {
            const int crossidx = position(nvr[ix2],idx[ix2],varidx)-1;
            // first real operand
            ComplexAdditionJob job1(2,3,ix1,ix2,nvr[ix1]-2,crossidx);
            if(verbose) cout << "adding " << job1
                             << " to layer " << level << endl;
            jobs[level].push_back(job1);
            jobcount = jobcount + 1;
            freqlaycnt[level] = freqlaycnt[level] + 1;
            // first imaginary operand
            ComplexAdditionJob job2(5,9,ix1,ix2,nvr[ix1]-2,crossidx);
            if(verbose) cout << "adding " << job2
                             << " to layer " << level << endl;
            jobs[level].push_back(job2);
            jobcount = jobcount + 1;
            freqlaycnt[level] = freqlaycnt[level] + 1;
            // second real operand
            ComplexAdditionJob job3(2,6,ix1,ix2,nvr[ix1]-2,crossidx);
            if(verbose) cout << "adding " << job3
                             << " to layer " << level+1 << endl;
            jobs[level+1].push_back(job3);
            jobcount = jobcount + 1;
            freqlaycnt[level+1] = freqlaycnt[level+1] + 1;
            // second imaginary operand
            ComplexAdditionJob job4(5,12,ix1,ix2,nvr[ix1]-2,crossidx);
            if(verbose) cout << "adding " << job4
                             << " to layer " << level+1 << endl;
            jobs[level+1].push_back(job4);
            jobcount = jobcount + 1;
            freqlaycnt[level+1] = freqlaycnt[level+1] + 1;
         }
      }
      else if(idx[ix1][ix3] == varidx) // update forward product
      {
         if(idx[ix2][0] == varidx)       // use backward product as increment
         {
            // first real operand
            ComplexAdditionJob job1(1,2,ix1,ix2,nvr[ix1]-2,nvr[ix2]-2);
            if(verbose) cout << "adding " << job1
                             << " to layer " << level << endl;
            jobs[level].push_back(job1);
            jobcount = jobcount + 1;
            freqlaycnt[level] = freqlaycnt[level] + 1;
            // first imaginary operand
            ComplexAdditionJob job2(4,8,ix1,ix2,nvr[ix1]-2,nvr[ix2]-2);
            if(verbose) cout << "adding " << job2
                             << " to layer " << level << endl;
            jobs[level].push_back(job2);
            jobcount = jobcount + 1;
            freqlaycnt[level] = freqlaycnt[level] + 1;
            // second real operand
            ComplexAdditionJob job3(1,5,ix1,ix2,nvr[ix1]-2,nvr[ix2]-2);
            if(verbose) cout << "adding " << job3
                             << " to layer " << level+1 << endl;
            jobs[level+1].push_back(job3);
            jobcount = jobcount + 1;
            freqlaycnt[level+1] = freqlaycnt[level+1] + 1;
            // second imaginary operand
            ComplexAdditionJob job4(4,11,ix1,ix2,nvr[ix1]-2,nvr[ix2]-2);
            if(verbose) cout << "adding " << job4
                             << " to layer " << level+1 << endl;
            jobs[level+1].push_back(job4);
            jobcount = jobcount + 1;
            freqlaycnt[level+1] = freqlaycnt[level+1] + 1;
         }
         else if(idx[ix2][ix4] == varidx) // use forward product as increment
         {
            // first real operand
            ComplexAdditionJob job1(1,1,ix1,ix2,nvr[ix1]-2,nvr[ix2]-2);
            if(verbose) cout << "adding " << job1
                             << " to layer " << level << endl;
            jobs[level].push_back(job1);
            jobcount = jobcount + 1;
            freqlaycnt[level] = freqlaycnt[level] + 1;
            // first imaginary operand
            ComplexAdditionJob job2(4,7,ix1,ix2,nvr[ix1]-2,nvr[ix2]-2);
            if(verbose) cout << "adding " << job2
                             << " to layer " << level << endl;
            jobs[level].push_back(job2);
            jobcount = jobcount + 1;
            freqlaycnt[level] = freqlaycnt[level] + 1;
            // second real operand
            ComplexAdditionJob job3(1,4,ix1,ix2,nvr[ix1]-2,nvr[ix2]-2);
            if(verbose) cout << "adding " << job3
                             << " to layer " << level+1 << endl;
            jobs[level+1].push_back(job3);
            jobcount = jobcount + 1;
            freqlaycnt[level+1] = freqlaycnt[level+1] + 1;
            // second imaginary operand
            ComplexAdditionJob job4(4,10,ix1,ix2,nvr[ix1]-2,nvr[ix2]-2);
            if(verbose) cout << "adding " << job4
                             << " to layer " << level+1 << endl;
            jobs[level+1].push_back(job4);
            jobcount = jobcount + 1;
            freqlaycnt[level+1] = freqlaycnt[level+1] + 1;
         }
         else                               // use cross product as increment
         {
            const int crossidx = position(nvr[ix2],idx[ix2],varidx)-1;
            // first real operand
            ComplexAdditionJob job1(1,3,ix1,ix2,nvr[ix1]-2,crossidx);
            if(verbose) cout << "adding " << job1
                             << " to layer " << level << endl;
            jobs[level].push_back(job1);
            jobcount = jobcount + 1;
            freqlaycnt[level] = freqlaycnt[level] + 1;
            // first imaginary operand
            ComplexAdditionJob job2(4,9,ix1,ix2,nvr[ix1]-2,crossidx);
            if(verbose) cout << "adding " << job2
                             << " to layer " << level << endl;
            jobs[level].push_back(job2);
            jobcount = jobcount + 1;
            freqlaycnt[level] = freqlaycnt[level] + 1;
            // second real operand
            ComplexAdditionJob job3(1,6,ix1,ix2,nvr[ix1]-2,crossidx);
            if(verbose) cout << "adding " << job3
                             << " to layer " << level+1 << endl;
            jobs[level+1].push_back(job3);
            jobcount = jobcount + 1;
            freqlaycnt[level+1] = freqlaycnt[level+1] + 1;
            // second imaginary operand
            ComplexAdditionJob job4(4,12,ix1,ix2,nvr[ix1]-2,crossidx);
            if(verbose) cout << "adding " << job4
                             << " to layer " << level+1 << endl;
            jobs[level+1].push_back(job4);
            jobcount = jobcount + 1;
            freqlaycnt[level+1] = freqlaycnt[level+1] + 1;
         }
      }
      else                                 // update cross product
      {
         const int crossidx = position(nvr[ix1],idx[ix1],varidx)-1;

         if(idx[ix2][0] == varidx)       // use backward product as increment
         {
            // first real operand
            ComplexAdditionJob job1(3,2,ix1,ix2,crossidx,nvr[ix2]-2);
            if(verbose) cout << "adding " << job1
                             << " to layer " << level << endl;
            jobs[level].push_back(job1);
            jobcount = jobcount + 1;
            freqlaycnt[level] = freqlaycnt[level] + 1;
            // first imaginary operand
            ComplexAdditionJob job2(6,8,ix1,ix2,crossidx,nvr[ix2]-2);
            if(verbose) cout << "adding " << job2
                             << " to layer " << level << endl;
            jobs[level].push_back(job2);
            jobcount = jobcount + 1;
            freqlaycnt[level] = freqlaycnt[level] + 1;
            // second real operand
            ComplexAdditionJob job3(3,5,ix1,ix2,crossidx,nvr[ix2]-2);
            if(verbose) cout << "adding " << job3
                             << " to layer " << level+1 << endl;
            jobs[level+1].push_back(job3);
            jobcount = jobcount + 1;
            freqlaycnt[level+1] = freqlaycnt[level+1] + 1;
            // second imaginary operand
            ComplexAdditionJob job4(6,11,ix1,ix2,crossidx,nvr[ix2]-2);
            if(verbose) cout << "adding " << job4
                             << " to layer " << level+1 << endl;
            jobs[level+1].push_back(job4);
            jobcount = jobcount + 1;
            freqlaycnt[level+1] = freqlaycnt[level+1] + 1;
         }
         else if(idx[ix2][ix4] == varidx) // use forward product as increment
         {
            // first real operand
            ComplexAdditionJob job1(3,1,ix1,ix2,crossidx,nvr[ix2]-2);
            if(verbose) cout << "adding " << job1
                             << " to layer " << level << endl;
            jobs[level].push_back(job1);
            jobcount = jobcount + 1;
            freqlaycnt[level] = freqlaycnt[level] + 1;
            // first imaginary operand
            ComplexAdditionJob job2(6,7,ix1,ix2,crossidx,nvr[ix2]-2);
            if(verbose) cout << "adding " << job2
                             << " to layer " << level << endl;
            jobs[level].push_back(job2);
            jobcount = jobcount + 1;
            freqlaycnt[level] = freqlaycnt[level] + 1;
            // second real operand
            ComplexAdditionJob job3(3,4,ix1,ix2,crossidx,nvr[ix2]-2);
            if(verbose) cout << "adding " << job3
                             << " to layer " << level+1 << endl;
            jobs[level+1].push_back(job3);
            jobcount = jobcount + 1;
            freqlaycnt[level+1] = freqlaycnt[level+1] + 1;
            // second imaginary operand
            ComplexAdditionJob job4(6,11,ix1,ix2,crossidx,nvr[ix2]-2);
            if(verbose) cout << "adding " << job4
                             << " to layer " << level+1 << endl;
            jobs[level+1].push_back(job4);
            jobcount = jobcount + 1;
            freqlaycnt[level+1] = freqlaycnt[level+1] + 1;
         }
         else                               // use cross product as increment
         {
            const int crossidx2 = position(nvr[ix2],idx[ix2],varidx)-1;
            // first real operand
            ComplexAdditionJob job1(3,3,ix1,ix2,crossidx,crossidx2);
            if(verbose) cout << "adding " << job1
                             << " to layer " << level << endl;
            jobs[level].push_back(job1);
            jobcount = jobcount + 1;
            freqlaycnt[level] = freqlaycnt[level] + 1;
            // first imaginary operand
            ComplexAdditionJob job2(6,9,ix1,ix2,crossidx,crossidx2);
            if(verbose) cout << "adding " << job2
                             << " to layer " << level << endl;
            jobs[level].push_back(job2);
            jobcount = jobcount + 1;
            freqlaycnt[level] = freqlaycnt[level] + 1;
            // second real operand
            ComplexAdditionJob job3(3,6,ix1,ix2,crossidx,crossidx2);
            if(verbose) cout << "adding " << job3
                             << " to layer " << level+1 << endl;
            jobs[level+1].push_back(job3);
            jobcount = jobcount + 1;
            freqlaycnt[level+1] = freqlaycnt[level+1] + 1;
            // second imaginary operand
            ComplexAdditionJob job4(6,12,ix1,ix2,crossidx,crossidx2);
            if(verbose) cout << "adding " << job4
                             << " to layer " << level+1 << endl;
            jobs[level+1].push_back(job4);
            jobcount = jobcount + 1;
            freqlaycnt[level+1] = freqlaycnt[level+1] + 1;
         }
      }
   }
   else if(ix0 == 0) // check if cff contributes to a derivative
   {
      const int ix2 = difidx[varidx][ix0];

      if(verbose) cout << ", ix2 = " << ix2 << endl;
     
      if(ix2 != -1)  // cff contributes to a derivative
      {
         if(verbose)
            cout << "idx[" << ix1 << "][" << ix3 << "] = " << idx[ix1][ix3]
                 << ", varidx = " << varidx << endl;

         if(idx[ix1][0] == varidx)       // update backward product with cff
         {
            // first real operand
            ComplexAdditionJob job1(2,0,ix1,-1,nvr[ix1]-2,ix2);
            if(verbose) cout << "adding " << job1
                             << " to layer " << level << endl;
            jobs[level].push_back(job1);
            jobcount = jobcount + 1;
            freqlaycnt[level] = freqlaycnt[level] + 1;
            // first imaginary operand
            ComplexAdditionJob job2(5,0,ix1,-1,nvr[ix1]-2,ix2);
            if(verbose) cout << "adding " << job2
                             << " to layer " << level << endl;
            jobs[level].push_back(job2);
            jobcount = jobcount + 1;
            freqlaycnt[level] = freqlaycnt[level] + 1;
            // no second operand for cff
         }
         else if(idx[ix1][ix3] == varidx) // update forward product with cff
         {
            // first real operand
            ComplexAdditionJob job1(1,0,ix1,-1,nvr[ix1]-2,ix2);
            if(verbose) cout << "adding " << job1
                             << " to layer " << level << endl;
            jobs[level].push_back(job1);
            jobcount = jobcount + 1;
            freqlaycnt[level] = freqlaycnt[level] + 1;
            // first imaginary operand
            ComplexAdditionJob job2(4,0,ix1,-1,nvr[ix1]-2,ix2);
            if(verbose) cout << "adding " << job2
                             << " to layer " << level << endl;
            jobs[level].push_back(job2);
            jobcount = jobcount + 1;
            freqlaycnt[level] = freqlaycnt[level] + 1;
            // no second operand for cff
         }
         else                               // update cross product with cff
         {
            const int crossidx = position(nvr[ix1],idx[ix1],varidx)-1;
            // first real operand
            ComplexAdditionJob job1(3,0,ix1,-1,crossidx,ix2);
            if(verbose) cout << "adding " << job1
                             << " to layer " << level << endl;
            jobs[level].push_back(job1);
            jobcount = jobcount + 1;
            freqlaycnt[level] = freqlaycnt[level] + 1;
            // first imaginary operand
            ComplexAdditionJob job2(6,0,ix1,-1,crossidx,ix2);
            if(verbose) cout << "adding " << job2
                             << " to layer " << level << endl;
            jobs[level].push_back(job2);
            jobcount = jobcount + 1;
            freqlaycnt[level] = freqlaycnt[level] + 1;
            // there is no second operand for cff
         }
      }
   }
   if(level > 1)
   {
      recursive_other_make(level-2,stride/2,nbr,nvr,idx,varidx,verbose);
      if(nbr > stride)
         recursive_other_make
            (level-2,stride/2,nbr-stride,nvr,idx,varidx,verbose);
   }
}

void ComplexAdditionJobs::differential_index_count
 ( int dim, int nbr, int *nvr, int **idx,
   vector<int> &cnt, bool verbose )
{
   for(int i=0; i<dim; i++)
   {
      if(verbose) cout << "Variable " <<  i << " occurs in monomials"; 

      cnt[i] = 0;
      for(int j=0; j<nbr; j++)
      {
         for(int k=0; k<nvr[j]; k++)
            if(idx[j][k] == i)
            {
               if(verbose)
               {
                  cout << " " << j;
                  if(nvr[j] == 1) cout << "(cff!)";
               }
               cnt[i] = cnt[i] + 1; break;
            }
      }
      if(verbose) cout << endl;
   }
}

void ComplexAdditionJobs::make_differential_indices
 ( int dim, int nbr, int *nvr, int **idx,
   vector<int> &cnt, vector< vector<int> > &difidx, bool verbose )
{
   int pos;

   for(int i=0; i<dim; i++)
   {
      if(verbose) cout << "Variable " <<  i << " occurs in monomials"; 
      
      difidx[i][0] = -1;
      pos = 1;
      for(int j=0; j<nbr; j++)
      {
         for(int k=0; k<nvr[j]; k++)
            if(idx[j][k] == i)
            {
               if(verbose)
               {
                  cout << " " << j;
                  if(nvr[j] == 1) cout << "(cff!)";
               }
               if(nvr[j] == 1)
               {
                  difidx[i][0] = j;
                  cnt[i] = cnt[i] - 1;
               }
               else
               {
                  difidx[i][pos++] = j;
               }
               break;
            }
      }
      if(verbose) cout << endl;
   }
}

void ComplexAdditionJobs::make ( int nbr, int *nvr, int **idx, bool verbose )
{
   for(int i=0; i<2*nbrmon; i++) freqlaycnt.push_back(0);
   // for dubbling of the number of layers
   for(int i=0; i<nbrvar; i++) difcnt.push_back(0);

   differential_index_count(nbrvar,nbr,nvr,idx,difcnt,verbose);

   if(verbose)
   {
      cout << "The differential counts :";
      for(int i=0; i<nbrvar; i++) cout << " " << difcnt[i];
      cout << endl;
   }
   for(int i=0; i<nbrvar; i++)
   {
      vector<int> cnt;

      for(int j=0; j<difcnt[i]+1; j++) cnt.push_back(0);

      difidx.push_back(cnt);
   }
   make_differential_indices(nbrvar,nbr,nvr,idx,difcnt,difidx,verbose);

   if(verbose)
   {
      cout << "The differential counts :";
      for(int i=0; i<nbrvar; i++) cout << " " << difcnt[i];
      cout << endl;
   }
   for(int i=0; i<2*nbrmon; i++) // for the dubbling of the layers
   {
      vector<ComplexAdditionJob> jobvec;
      jobs.push_back(jobvec);
   }
   int level,stride;

   if(verbose) cout << "-> adding jobs for the value ..." << endl;
   recursive_start(nbr,&level,&stride);
   recursive_make(2*level,stride,nbr,nvr,verbose);

   laydepth = 2*level+1; // the value involves all monomials => highest level

   if(difcnt[0] > 0)
   {
      if(verbose) cout << "-> adding jobs for derivative 0 ..."
                       << endl;
      recursive_start(difcnt[0],&level,&stride);
      recursive_first_make(2*level,stride,difcnt[0],nvr,verbose);
   }
   for(int k=1; k<nbrvar; k++)
   {
      if(difcnt[k] > 0)
      {
         if(verbose) cout << "-> adding jobs for derivative " << k
                          << " ..." << endl;
         recursive_start(difcnt[k],&level,&stride);
         recursive_other_make(2*level,stride,difcnt[k],nvr,idx,k,verbose);
      }
   }
}

int ComplexAdditionJobs::get_number_of_variables ( void ) const
{
   return nbrvar;
}

int ComplexAdditionJobs::get_number_of_monomials ( void ) const
{
   return nbrmon;
}

int ComplexAdditionJobs::get_count ( void ) const
{
   return jobcount;
}

int ComplexAdditionJobs::get_layer_count ( int k ) const
{
   if(k >= nbrmon)
      return 0;
   else
      return freqlaycnt[k];
}

int ComplexAdditionJobs::get_depth ( void ) const
{
   return laydepth;
}

int ComplexAdditionJobs::get_differential_count ( int k ) const
{
   if(k >= nbrvar)
      return 0;
   else
      return difcnt[k];
}

int ComplexAdditionJobs::get_differential_index ( int k, int i ) const
{
   if(k >= nbrvar)
      return -1;
   else if(i > difcnt[k])
      return -1;
   else
      return difidx[k][i];
}

ComplexAdditionJob ComplexAdditionJobs::get_job ( int k, int i ) const
{
   return jobs[k][i];
}

ComplexAdditionJobs::~ComplexAdditionJobs ( void )
{
   nbrvar = 0;
   nbrmon = 0;
}
