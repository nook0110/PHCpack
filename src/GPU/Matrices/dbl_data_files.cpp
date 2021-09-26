/* The file dbl_data_files.cpp defines the functions specified in
 * the file dbl_data_files.h. */

#include <iostream>
#include <iomanip>
#include <fstream>
#include "dbl_data_files.h"

void dbl_write_matrix ( string name, int dim, double **A )
{
   ofstream outs(name.c_str());

   outs << scientific << setprecision(16);

   for(int i=0; i<dim; i++)
   {
      for(int j=0; j<dim; j++) outs << " " << A[i][j];
      outs << endl;
   }
   outs.close();
}

void dbl_reads_matrix ( string name, int dim, double **A )
{
   ifstream infs(name.c_str());

   for(int i=0; i<dim; i++)
   {
      for(int j=0; j<dim; j++) infs >> A[i][j];
   }
   infs.close();
}
