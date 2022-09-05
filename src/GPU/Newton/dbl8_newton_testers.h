// The file dbl8_newton_testers.h specifies test function for Newton's method
// on series in octo double precision.

#ifndef __dbl8_newton_testers_h__
#define __dbl8_newton_testers_h__

void dbl8_unit_series_vector
 ( int dim, int deg,
   double **cffhihihi, double **cfflohihi,
   double **cffhilohi, double **cfflolohi,
   double **cffhihilo, double **cfflohilo,
   double **cffhilolo, double **cfflololo );
/*
 * DESCRIPTION :
 *   Given space in cff* for the doubles
 *   for the vector of dim power series in octo double precision,
 *   of series truncated after degree deg,
 *   initializes the coefficients in cff to one as leading coefficients,
 *   and zero for all other coefficients. */

void dbl8_update_series
 ( int dim, int degp1,
   double **xhihihi, double **xlohihi, double **xhilohi, double **xlolohi,
   double **xhihilo, double **xlohilo, double **xhilolo, double **xlololo,
   double **dxhihihi, double **dxlohihi, double **dxhilohi, double **dxlolohi,
   double **dxhihilo, double **dxlohilo, double **dxhilolo, double **dxlololo,
   int vrblvl );
/*
 * DESCRIPTION :
 *   Adds the series in dx to x.
 *
 * ON ENTRY :
 *   dim       number of series in x and dx;
 *   degp1     degree plus one of the series;
 *   xhihihi   highest doubles of the series to updated, not linearized;
 *   xlohihi   2nd highest doubles of the series to updated, not linearized;
 *   xlohihi   3rd highest doubles of the series to updated, not linearized;
 *   xlolohi   4th highest doubles of the series to updated, not linearized;
 *   xhihilo   4th lowest doubles of the series to updated, not linearized;
 *   xlohilo   3rd lowest doubles of the series to updated, not linearized;
 *   xlohilo   2nd lowest doubles of the series to updated, not linearized;
 *   xlololo   lowest doubles of the series to updated, not linearized;
 *   dxhihihi  linearized highest doubles of the update of the series;
 *   dxlohihi  linearized 2nd highest doubles of the update of the series;
 *   dxhilohi  linearized 3rd highest doubles of the update of the series;
 *   dxlolohi  linearized 4th highest doubles of the update of the series;
 *   dxhihilo  linearized 4th lowest doubles of the update of the series;
 *   dxlohilo  linearized 3rd lowest doubles of the update of the series;
 *   dxhilolo  linearized 2nd lowest doubles of the update of the series;
 *   dxlololo  linearized lowest doubles of the update of the series;
 *   vrblvl    is the verbose level.
 *
 * ON RETURN :
 *   xhihihi   highest doubles of the series x updated with dx;
 *   xlohihi   second highest doubles of the series x updated with dx;
 *   xhilohi   third highest doubles of the series x updated with dx;
 *   xlolohi   fourth highest doubles of the series x updated with dx;
 *   xhihilo   fourth lowest doubles of the series x updated with dx;
 *   xlohilo   third lowest doubles of the series x updated with dx;
 *   xhilolo   second lowest doubles of the series x updated with dx;
 *   xlololo   lowest doubles of the series x updated with dx. */

void dbl8_newton_lustep
 ( int dim, int deg,
   int *nvr, int **idx, int **exp, int *nbrfac, int **expfac,
   double **cffhihihi, double **cfflohihi,
   double **cffhilohi, double **cfflolohi,
   double **cffhihilo, double **cfflohilo,
   double **cffhilolo, double **cfflololo,
   double *acchihihi, double *acclohihi,
   double *acchilohi, double *acclolohi,
   double *acchihilo, double *acclohilo,
   double *acchilolo, double *acclololo,
   double **inputhihihi, double **inputlohihi,
   double **inputhilohi, double **inputlolohi,
   double **inputhihilo, double **inputlohilo,
   double **inputhilolo, double **inputlololo,
   double ***outputhihihi, double ***outputlohihi,
   double ***outputhilohi, double ***outputlolohi,
   double ***outputhihilo, double ***outputlohilo,
   double ***outputhilolo, double ***outputlololo,
   double **funvalhihihi, double **funvallohihi,
   double **funvalhilohi, double **funvallolohi,
   double **funvalhihilo, double **funvallohilo,
   double **funvalhilolo, double **funvallololo,
   double ***jacvalhihihi, double ***jacvallohihi,
   double ***jacvalhilohi, double ***jacvallolohi,
   double ***jacvalhihilo, double ***jacvallohilo,
   double ***jacvalhilolo, double ***jacvallololo,
   double **rhshihihi, double **rhslohihi,
   double **rhshilohi, double **rhslolohi,
   double **rhshihilo, double **rhslohilo,
   double **rhshilolo, double **rhslololo,
   double **solhihihi, double **sollohihi,
   double **solhilohi, double **sollolohi,
   double **solhihilo, double **sollohilo,
   double **solhilolo, double **sollololo,
   double **workmathihihi, double **workmatlohihi,
   double **workmathilohi, double **workmatlolohi,
   double **workmathihilo, double **workmatlohilo,
   double **workmathilolo, double **workmatlololo,
   double *workvechihihi, double *workveclohihi,
   double *workvechilohi, double *workveclolohi,
   double *workvechihilo, double *workveclohilo,
   double *workvechilolo, double *workveclololo,
   double **workrhshihihi, double **workrhslohihi,
   double **workrhshilohi, double **workrhslolohi,
   double **workrhshihilo, double **workrhslohilo,
   double **workrhshilolo, double **workrhslololo,
   double **resvechihihi, double **resveclohihi,
   double **resvechilohi, double **resveclolohi,
   double **resvechihilo, double **resveclohilo,
   double **resvechilolo, double **resveclololo,
   double *resmaxhihihi, double *resmaxlohihi,
   double *resmaxhilohi, double *resmaxlolohi,
   double *resmaxhihilo, double *resmaxlohilo,
   double *resmaxhilolo, double *resmaxlololo, int *ipvt, int vrblvl );
/*
 * DESCRIPTION :
 *   Does one step with Newton's method to update a power series.
 *
 * ON ENTRY :
 *   dim       number of monomials;
 *   deg       degree of the power series;
 *   nvr       nvr[i] is the number of variables in the i-th monomial;
 *   idx       idx[i] are the indices of the variables in monomial i;
 *   exp       exp[i] are the exponents of the variables in monomial i;
 *   nbrfac    nbrfac[i] are the number of exponents > 1 in monomial i;
 *   expfac    expfac[i] are the exponents in the i-th polynomial
 *             that are larger than one, minus one in the factor,
 *             if exp[i][k] > 1, then expfac[i][k] = exp[i][k] - 1;
 *   cffhihihi has the highest doubles of the monomial coefficients;
 *   cfflohihi has the 2nd highest doubles of the monomial coefficients;
 *   cffhilohi has the 3rd highest doubles of the monomial coefficients;
 *   cfflolohi has the 4th highest doubles of the monomial coefficients;
 *   cffhihilo has the 4th lowest doubles of the monomial coefficients;
 *   cfflohilo has the 3rd lowest doubles of the monomial coefficients;
 *   cffhilolo has the 2nd lowest doubles of the monomial coefficients;
 *   cfflololo has the lowest doubles of the monomial coefficients;
 *   acchihihi has space to accumulate one power series of degree deg;
 *   acclohihi has space to accumulate one power series of degree deg;
 *   acchilohi has space to accumulate one power series of degree deg;
 *   acclolohi has space to accumulate one power series of degree deg;
 *   acchihilo has space to accumulate one power series of degree deg;
 *   acclohilo has space to accumulate one power series of degree deg;
 *   acchilolo has space to accumulate one power series of degree deg;
 *   acclololo has space to accumulate one power series of degree deg;
 *   inputhihihi are the highest doubles of the coefficients of the power
 *             series of degree deg, for dim variables;
 *   inputlohihi are the second highest doubles of the coefficients of the
 *             power series of degree deg, for dim variables;
 *   inputhilohi are the third highest doubles of the coefficients of the
 *             power series of degree deg, for dim variables;
 *   inputlolohi are the fourth highest doubles of the coefficients of the
 *             power series of degree deg, for dim variables;
 *   inputhihilo are the fourth lowest doubles of the coefficients of the
 *             power series of degree deg, for dim variables;
 *   inputlohilo are the third lowest doubles of the coefficients of the
 *             power series of degree deg, for dim variables;
 *   inputhilolo are the second lowest doubles of the coefficients of the
 *             power series of degree deg, for dim variables;
 *   inputlololo are the lowest doubles of the coefficients of the power
 *             series of degree deg, for dim variables;
 *   outputhihihi has space for the evaluated and differentiated monomials;
 *   outputlohihi has space for the evaluated and differentiated monomials;
 *   outputhilohi has space for the evaluated and differentiated monomials;
 *   outputlolohi has space for the evaluated and differentiated monomials;
 *   outputhihilo has space for the evaluated and differentiated monomials;
 *   outputlohilo has space for the evaluated and differentiated monomials;
 *   outputhilolo has space for the evaluated and differentiated monomials;
 *   outputlololo has space for the evaluated and differentiated monomials;
 *   funvalhihihi has space for the evaluated power series;
 *   funvallohihi has space for the evaluated power series;
 *   funvalhilohi has space for the evaluated power series;
 *   funvallolohi has space for the evaluated power series;
 *   funvalhihilo has space for the evaluated power series;
 *   funvallohilo has space for the evaluated power series;
 *   funvalhilolo has space for the evaluated power series;
 *   funvallololo has space for the evaluated power series;
 *   jacvalhihihi has space for deg+1 matrices of dimension dim;
 *   jacvallohihi has space for deg+1 matrices of dimension dim;
 *   jacvalhilohi has space for deg+1 matrices of dimension dim;
 *   jacvallolohi has space for deg+1 matrices of dimension dim;
 *   jacvalhihilo has space for deg+1 matrices of dimension dim;
 *   jacvallohilo has space for deg+1 matrices of dimension dim;
 *   jacvalhilolo has space for deg+1 matrices of dimension dim;
 *   jacvallololo has space for deg+1 matrices of dimension dim;
 *   rhshihihi has space for deg+1 vectors of dimension dim;
 *   rhslohihi has space for deg+1 vectors of dimension dim;
 *   rhshilohi has space for deg+1 vectors of dimension dim;
 *   rhslolohi has space for deg+1 vectors of dimension dim;
 *   rhshihilo has space for deg+1 vectors of dimension dim;
 *   rhslohilo has space for deg+1 vectors of dimension dim;
 *   rhshilolo has pace for deg+1 vectors of dimension dim;
 *   rhslololo has space for deg+1 vectors of dimension dim;
 *   solhihihi has space for deg+1 vectors of dimension dim;
 *   sollohihi has space for deg+1 vectors of dimension dim;
 *   solhilohi has space for deg+1 vectors of dimension dim;
 *   sollolohi has space for deg+1 vectors of dimension dim;
 *   solhihilo has space for deg+1 vectors of dimension dim;
 *   sollohilo has space for deg+1 vectors of dimension dim;
 *   solhilolo has space for deg+1 vectors of dimension dim;
 *   sollololo has space for deg+1 vectors of dimension dim;
 *   wrkmathihihi has work space allocated for a matrix of dimension dim;
 *   wrkmatlohihi has work space allocated for a matrix of dimension dim;
 *   wrkmathilohi has work space allocated for a matrix of dimension dim;
 *   wrkmatlolohi has work space allocated for a matrix of dimension dim;
 *   wrkmathihilo has work space allocated for a matrix of dimension dim;
 *   wrkmatlohilo has work space allocated for a matrix of dimension dim;
 *   wrkmathilolo has work space allocated for a matrix of dimension dim;
 *   wrkmatlololo has work space allocated for a matrix of dimension dim;
 *   wrkvechihihi has work space allocated for a vector of dimension dim;
 *   wrkveclohihi has work space allocated for a vector of dimension dim;
 *   wrkvechilohi has work space allocated for a vector of dimension dim;
 *   wrkveclolohi has work space allocated for a vector of dimension dim;
 *   wrkvechihilo has work space allocated for a vector of dimension dim;
 *   wrkveclohilo has work space allocated for a vector of dimension dim;
 *   wrkvechilolo has work space allocated for a vector of dimension dim;
 *   wrkveclololo has work space allocated for a vector of dimension dim;
 *   resvechihihi has space for deg+1 vectors of dimension dim;
 *   resveclohihi has space for deg+1 vectors of dimension dim;
 *   resvechilohi has space for deg+1 vectors of dimension dim;
 *   resveclolohi has space for deg+1 vectors of dimension dim;
 *   resvechihilo has space for deg+1 vectors of dimension dim;
 *   resveclohilo has space for deg+1 vectors of dimension dim;
 *   resvechilolo has space for deg+1 vectors of dimension dim;
 *   resveclololo has space for deg+1 vectors of dimension dim;
 *   ipvt      space allocated for dim pivots;
 *   vrblvl    is the verbose level.
 *
 * ON RETURN :
 *   funvalhihihi are the highest doubles of the output[i][dim];
 *   funvallohihi are the second highest doubles of the output[i][dim];
 *   funvalhilohi are the third highest doubles of the output[i][dim];
 *   funvallolohi are the fourth highest doubles of the output[i][dim];
 *   funvalhihilo are the fourth lowest doubles of the output[i][dim];
 *   funvallohilo are the third lowest doubles of the output[i][dim];
 *   funvalhilolo are the second lowest doubles of the output[i][dim];
 *   funvallololo are the lowest doubles of the output[i][dim];
 *   jacvalhihihi are the highest doubles of a matrix series,
 *             the leading coefficient is the Jacobian matrix.
 *   jacvallohihi are the second highest doubles of a matrix series,
 *             the leading coefficient is the Jacobian matrix.
 *   jacvalhilohi are the third highest doubles of a matrix series,
 *             the leading coefficient is the Jacobian matrix.
 *   jacvallolohi are the fourth highest doubles of a matrix series,
 *             the leading coefficient is the Jacobian matrix.
 *   jacvalhihilo are the fourth lowest doubles of a matrix series,
 *             the leading coefficient is the Jacobian matrix.
 *   jacvallohilo are the third lowest doubles of a matrix series,
 *             the leading coefficient is the Jacobian matrix.
 *   jacvalhilolo are the second lowest doubles of a matrix series,
 *             the leading coefficient is the Jacobian matrix.
 *   jacvallololo are the lowest doubles of a matrix series,
 *             the leading coefficient is the Jacobian matrix.
 *   rhshihihi are the highest doubles of the linearized right hand side,
 *             the function values subtracted by 1 and added by t;
 *   rhslohihi are the second highest doubles of the linearized right hand
 *             side, the function values subtracted by 1 and added by t;
 *   rhshilohi are the third highest doubles of the linearized right hand
 *             side, are the function values subtracted by 1 and added by t;
 *   rhslolohi are the fourth highest doubles ofthe linearized right hand
 *             side, are the function values subtracted by 1 and added by t;
 *   rhshihilo are the fourth lowest doubles of the linearized right hand
 *             side, the function values subtracted by 1 and added by t;
 *   rhslohilo are the third lowest doubles of the linearized right hand
 *             side, the function values subtracted by 1 and added by t;
 *   rhshilolo are the second lowest doubles of the linearized right hand
 *             side, the function values subtracted by 1 and added by t;
 *   rhslololo are the lowest doubles ofthe linearized right hand
 *             side, the function values subtracted by 1 and added by t;
 *   wrkmathihihi are the highest doubles of the LU factorization
 *             of the Jacobian matrix;
 *   wrkmatlohihi are the second highest doubles of the LU factorization
 *             of the Jacobian matrix;
 *   wrkmathilohi are the third highest doubles of the LU factorization
 *             of the Jacobian matrix;
 *   wrkmatlolohi are the fourth highest doubles of the LU factorization
 *             of the Jacobian matrix;
 *   wrkmathihilo are the fourth lowest doubles of the LU factorization
 *             of the Jacobian matrix;
 *   wrkmatlohilo are the third lowest doubles of the LU factorization
 *             of the Jacobian matrix;
 *   wrkmathilolo are the second lowest doubles of the LU factorization
 *             of the Jacobian matrix;
 *   wrkmatlololo are the lowest doubles of the LU factorization
 *             of the Jacobian matrix;
 *   resvechihihi are the highest doubles of the residual vectors;
 *   resveclohihi are the second highest doubles of the residual vectors;
 *   resvechilohi are the third highest doubles of the residual vectors;
 *   resveclolohi are the fourth highest doubles of the residual vectors;
 *   resvechihilo are the fourth lowest doubles of the residual vectors;
 *   resveclohilo are the third lowest doubles of the residual vectors;
 *   resvechilolo are the second lowest doubles of the residual vectors;
 *   resveclololo are the lowest doubles of the residual vectors;
 *   resmaxhihihi is the highest double of the maximum element
 *             of the residual vectors;
 *   resmaxlohihi is the second highest double of the maximum element
 *             of the residual vectors;
 *   resmaxhilohi is the third highest double of the maximum element
 *             of the residual vectors;
 *   resmaxlolohi is the fourth highest double of the maximum element
 *             of the residual vectors;
 *   resmaxhihilo is the fourth lowest double of the maximum element
 *             of the residual vectors;
 *   resmaxlohilo is the third lowest double of the maximum element
 *             of the residual vectors;
 *   resmaxhilolo is the second lowest double of the maximum element
 *             of the residual vectors;
 *   resmaxlololo is the lowest double of the maximum element
 *             of the residual vectors;
 *   ipvt      pivots used on the LU factorization of the lead matrix. */

void dbl8_newton_qrstep
 ( int szt, int nbt, int dim, int deg,
   int *nvr, int **idx, int **exp, int *nbrfac, int **expfac,
   double **cffhihihi, double **cfflohihi,
   double **cffhilohi, double **cfflolohi,
   double **cffhihilo, double **cfflohilo,
   double **cffhilolo, double **cfflololo,
   double *acchihihi, double *acclohihi, double *acchilohi, double *acclolohi,
   double *acchihilo, double *acclohilo, double *acchilolo, double *acclololo,
   double **inputhihihi_h, double **inputlohihi_h,
   double **inputhilohi_h, double **inputlolohi_h,
   double **inputhihilo_h, double **inputlohilo_h,
   double **inputhilolo_h, double **inputlololo_h,
   double **inputhihihi_d, double **inputlohihi_d,
   double **inputhilohi_d, double **inputlolohi_d,
   double **inputhihilo_d, double **inputlohilo_d,
   double **inputhilolo_d, double **inputlololo_d,
   double ***outputhihihi_h, double ***outputlohihi_h,
   double ***outputhilohi_h, double ***outputlolohi_h,
   double ***outputhihilo_h, double ***outputlohilo_h,
   double ***outputhilolo_h, double ***outputlololo_h,
   double ***outputhihihi_d, double ***outputlohihi_d,
   double ***outputhilohi_d, double ***outputlolohi_d,
   double ***outputhihilo_d, double ***outputlohilo_d,
   double ***outputhilolo_d, double ***outputlololo_d,
   double **funvalhihihi_h, double **funvallohihi_h,
   double **funvalhilohi_h, double **funvallolohi_h,
   double **funvalhihilo_h, double **funvallohilo_h,
   double **funvalhilolo_h, double **funvallololo_h,
   double **funvalhihihi_d, double **funvallohihi_d,
   double **funvalhilohi_d, double **funvallolohi_d,
   double **funvalhihilo_d, double **funvallohilo_d,
   double **funvalhilolo_d, double **funvallololo_d,
   double ***jacvalhihihi_h, double ***jacvallohihi_h,
   double ***jacvalhilohi_h, double ***jacvallolohi_h,
   double ***jacvalhihilo_h, double ***jacvallohilo_h,
   double ***jacvalhilolo_h, double ***jacvallololo_h,
   double ***jacvalhihihi_d, double ***jacvallohihi_d,
   double ***jacvalhilohi_d, double ***jacvallolohi_d,
   double ***jacvalhihilo_d, double ***jacvallohilo_d,
   double ***jacvalhilolo_d, double ***jacvallololo_d,
   double **rhshihihi_h, double **rhslohihi_h,
   double **rhshilohi_h, double **rhslolohi_h,
   double **rhshihilo_h, double **rhslohilo_h,
   double **rhshilolo_h, double **rhslololo_h,
   double **rhshihihi_d, double **rhslohihi_d,
   double **rhshilohi_d, double **rhslolohi_d,
   double **rhshihilo_d, double **rhslohilo_d,
   double **rhshilolo_d, double **rhslololo_d,
   double **urhshihihi_h, double **urhslohihi_h,
   double **urhshilohi_h, double **urhslolohi_h,
   double **urhshihilo_h, double **urhslohilo_h,
   double **urhshilolo_h, double **urhslololo_h,
   double **urhshihihi_d, double **urhslohihi_d,
   double **urhshilohi_d, double **urhslolohi_d,
   double **urhshihilo_d, double **urhslohilo_d,
   double **urhshilolo_d, double **urhslololo_d,
   double **solhihihi_h, double **sollohihi_h,
   double **solhilohi_h, double **sollolohi_h,
   double **solhihilo_h, double **sollohilo_h,
   double **solhilolo_h, double **sollololo_h,
   double **solhihihi_d, double **sollohihi_d,
   double **solhilohi_d, double **sollolohi_d,
   double **solhihilo_d, double **sollohilo_d,
   double **solhilolo_d, double **sollololo_d,
   double **Qhihihi_h, double **Qlohihi_h,
   double **Qhilohi_h, double **Qlolohi_h,
   double **Qhihilo_h, double **Qlohilo_h,
   double **Qhilolo_h, double **Qlololo_h,
   double **Qhihihi_d, double **Qlohihi_d,
   double **Qhilohi_d, double **Qlolohi_d,
   double **Qhihilo_d, double **Qlohilo_d,
   double **Qhilolo_d, double **Qlololo_d,
   double **Rhihihi_h, double **Rlohihi_h,
   double **Rhilohi_h, double **Rlolohi_h,
   double **Rhihilo_h, double **Rlohilo_h,
   double **Rhilolo_h, double **Rlololo_h,
   double **Rhihihi_d, double **Rlohihi_d,
   double **Rhilohi_d, double **Rlolohi_d,
   double **Rhihilo_d, double **Rlohilo_d,
   double **Rhilolo_d, double **Rlololo_d,
   double **workmathihihi, double **workmatlohihi,
   double **workmathilohi, double **workmatlolohi,
   double **workmathihilo, double **workmatlohilo,
   double **workmathilolo, double **workmatlololo,
   double *workvechihihi, double *workveclohihi,
   double *workvechilohi, double *workveclolohi,
   double *workvechihilo, double *workveclohilo,
   double *workvechilolo, double *workveclololo,
   double **resvechihihi, double **resveclohihi, 
   double **resvechilohi, double **resveclolohi, 
   double **resvechihilo, double **resveclohilo, 
   double **resvechilolo, double **resveclololo, 
   double *resmaxhihihi, double *resmaxlohihi,
   double *resmaxhilohi, double *resmaxlolohi,
   double *resmaxhihilo, double *resmaxlohilo,
   double *resmaxhilolo, double *resmaxlololo, int vrblvl, int mode );
/*
 * DESCRIPTION :
 *   Does one step with Newton's method to update a power series,
 *   using QR factorization to solve linear systems.
 *
 * REQUIRED : szt*nbt = dim for GPU computing.
 *
 * ON ENTRY :
 *   szt       size of each tile and block;
 *   nbt       number of tiles and number of blocks;
 *   dim       number of monomials;
 *   deg       degree of the power series;
 *   nvr       nvr[i] is the number of variables in the i-th monomial;
 *   idx       idx[i] are the indices of the variables in monomial i;
 *   exp       exp[i] are the exponents of the variables in monomial i;
 *   nbrfac    nbrfac[i] are the number of exponents > 1 in monomial i;
 *   expfac    expfac[i] are the exponents in the i-th polynomial
 *             that are larger than one, minus one in the factor,
 *             if exp[i][k] > 1, then expfac[i][k] = exp[i][k] - 1;
 *   cffhihihi are the highest doubles of the coefficients of the monomials;
 *   cfflohihi are the second highest doubles of the coefficients;
 *   cffhilohi are the thirnd highest doubles of the coefficients;
 *   cfflolohi are the fourth highest doubles of the coefficients;
 *   cffhihilo are the fourth lowest doubles of the coefficients;
 *   cfflohilo are the third lowest doubles of the coefficients;
 *   cffhilolo are the second lowest doubles of the coefficients;
 *   cfflololo are the lowest doubles of the coefficients of the monomials;
 *   acchihihi has has space for highest doubles of one series of degree deg;
 *   acclohihi has space for second highest doubles of one series;
 *   acchilohi has space for third highest doubles of one series;
 *   acclolohi has space for fourth highest doubles of one series;
 *   acchihilo has space for fourth lowest doubles of one series;
 *   acclohilo has space for third lowest doubles of one series;
 *   acchilolo has space for second lowest doubles of one series;
 *   acclololo has space for lowest doubles of one series of degree deg;
 *   inputhihihi_h has the highest doubles of the input series,
 *             of degree deg, for dim variables, computed on host;
 *   inputlohihi_h has the second highest doubles of the input series,
 *             of degree deg, for dim variables, computed on host;
 *   inputhilohi_h has the third highest doubles of the input series,
 *             of degree deg, for dim variables, computed on host;
 *   inputlolohi_h has the fourth highest doubles of the input series,
 *             of degree deg, for dim variables, computed on host;
 *   inputhihilo_h has the fourth lowest doubles of the input series,
 *             of degree deg, for dim variables, computed on host;
 *   inputlohilo_h has the third lowest doubles of the input series,
 *             of degree deg, for dim variables, computed on host;
 *   inputhilolo_h has the second lowest doubles of the input series,
 *             of degree deg, for dim variables, computed on host;
 *   inputlololo_h has the lowest doubles of the input series,
 *             of degree deg, for dim variables, computed on host;
 *   inputhihihi_d has space for series computed on device;
 *   inputlohihi_d has space for series computed on device;
 *   inputhilohi_d has space for series computed on device;
 *   inputlolohi_d has space for series computed on device;
 *   inputhihilo_d has space for series computed on device;
 *   inputlohilo_d has space for series computed on device;
 *   inputhilolo_d has space for series computed on device;
 *   inputlololo_d has space for series computed on device;
 *   outputhihihi_h has space for the highest doubles of the evaluated
 *             and differentiated monomials, computed on the host;
 *   outputlohihi_h has space for the second highest doubles of the evaluated 
 *             and differentiated monomials, computed on the host;
 *   outputhilohi_h has space for the third highest doubles of the evaluated
 *             and differentiated monomials, computed on the host;
 *   outputlolohi_h has space for the fourth highest doubles of the evaluated 
 *             and differentiated monomials, computed on the host;
 *   outputhihilo_h has space for the fourth lowest doubles of the evaluated
 *             and differentiated monomials, computed on the host;
 *   outputlohilo_h has space for the third lowest doubles of the evaluated 
 *             and differentiated monomials, computed on the host;
 *   outputhilolo_h has space for the second lowest doubles of the evaluated
 *             and differentiated monomials, computed on the host;
 *   outputlololo_h has space for the lowest doubles of the evaluated 
 *             and differentiated monomials, computed on the host;
 *   outputhihihi_d has space for the output, computed on the device;
 *   outputlohihi_d has space for the output, computed on the device;
 *   outputhilohi_d has space for the output, computed on the device;
 *   outputlolohi_d has space for the output, computed on the device;
 *   outputhihilo_d has space for the output, computed on the device;
 *   outputlohilo_d has space for the output, computed on the device;
 *   outputhilolo_d has space for the output, computed on the device;
 *   outputlololo_d has space for the output, computed on the device;
 *   funvalhihihi_h has space for the evaluated series on the host;
 *   funvallohihi_h has space for the evaluated series on the host;
 *   funvalhilohi_h has space for the evaluated series on the host;
 *   funvallolohi_h has space for the evaluated series on the host;
 *   funvalhihilo_h has space for the evaluated series on the host;
 *   funvallohilo_h has space for the evaluated series on the host;
 *   funvalhilolo_h has space for the evaluated series on the host;
 *   funvallololo_h has space for the evaluated series on the host;
 *   funvalhihihi_d has space for the evaluated series on the device;
 *   funvallohihi_d has space for the evaluated series on the device;
 *   funvalhilohi_d has space for the evaluated series on the device;
 *   funvallolohi_d has space for the evaluated series on the device;
 *   funvalhihilo_d has space for the evaluated series on the device;
 *   funvallohilo_d has space for the evaluated series on the device;
 *   funvalhilolo_d has space for the evaluated series on the device;
 *   funvallololo_d has space for the evaluated series on the device;
 *   jacvalhihihi_h has space for deg+1 matrices of dimension dim on host;
 *   jacvallohihi_h has space for deg+1 matrices of dimension dim on host;
 *   jacvalhilohi_h has space for deg+1 matrices of dimension dim on host;
 *   jacvallolohi_h has space for deg+1 matrices of dimension dim on host;
 *   jacvalhihilo_h has space for deg+1 matrices of dimension dim on host;
 *   jacvallohilo_h has space for deg+1 matrices of dimension dim on host;
 *   jacvalhilolo_h has space for deg+1 matrices of dimension dim on host;
 *   jacvallololo_h has space for deg+1 matrices of dimension dim on host;
 *   jacvalhihihi_d has space for deg+1 matrices of dimension dim on device;
 *   jacvallohihi_d has space for deg+1 matrices of dimension dim on device;
 *   jacvalhilohi_d has space for deg+1 matrices of dimension dim on device;
 *   jacvallolohi_d has space for deg+1 matrices of dimension dim on device;
 *   jacvalhihilo_d has space for deg+1 matrices of dimension dim on device;
 *   jacvallohilo_d has space for deg+1 matrices of dimension dim on device;
 *   jacvalhilolo_d has space for deg+1 matrices of dimension dim on device;
 *   jacvallololo_d has space for deg+1 matrices of dimension dim on device;
 *   rhshihihi_h has space for deg+1 vectors of dimension dim on host;
 *   rhslohihi_h has space for deg+1 vectors of dimension dim on host;
 *   rhshilohi_h has space for deg+1 vectors of dimension dim on host;
 *   rhslolohi_h has space for deg+1 vectors of dimension dim on host;
 *   rhshihilo_h has space for deg+1 vectors of dimension dim on host;
 *   rhslohilo_h has space for deg+1 vectors of dimension dim on host;
 *   rhshilolo_h has space for deg+1 vectors of dimension dim on host;
 *   rhslololo_h has space for deg+1 vectors of dimension dim on host;
 *   rhshihihi_d has space for deg+1 vectors of dimension dim on device;
 *   rhslohihi_d has space for deg+1 vectors of dimension dim on device;
 *   rhshilohi_d has space for deg+1 vectors of dimension dim on device;
 *   rhslolohi_d has space for deg+1 vectors of dimension dim on device;
 *   rhshihilo_d has space for deg+1 vectors of dimension dim on device;
 *   rhslohilo_d has space for deg+1 vectors of dimension dim on device;
 *   rhshilolo_d has space for deg+1 vectors of dimension dim on device;
 *   rhslololo_d has space for deg+1 vectors of dimension dim on device;
 *   urhshihihi_h has space for updated right hand side vectors on host;
 *   urhslohihi_h has space for updated right hand side vectors on host;
 *   urhshilohi_h has space for updated right hand side vectors on host;
 *   urhslolohi_h has space for updated right hand side vectors on host;
 *   urhshihilo_h has space for updated right hand side vectors on host;
 *   urhslohilo_h has space for updated right hand side vectors on host;
 *   urhshilolo_h has space for updated right hand side vectors on host;
 *   urhslololo_h has space for updated right hand side vectors on host;
 *   urhshihihi_d has space for updated right hand side vectors on device; 
 *   urhslohihi_d has space for updated right hand side vectors on device; 
 *   urhshilohi_d has space for updated right hand side vectors on device; 
 *   urhslolohi_d has space for updated right hand side vectors on device; 
 *   urhshihilo_d has space for updated right hand side vectors on device; 
 *   urhslohilo_d has space for updated right hand side vectors on device; 
 *   urhshilolo_d has space for updated right hand side vectors on device; 
 *   urhslololo_d has space for updated right hand side vectors on device; 
 *   solhihihi_h has space for deg+1 vectors of dimension dim;
 *   sollohihi_h has space for deg+1 vectors of dimension dim;
 *   solhilohi_h has space for deg+1 vectors of dimension dim;
 *   sollolohi_h has space for deg+1 vectors of dimension dim;
 *   solhihilo_h has space for deg+1 vectors of dimension dim;
 *   sollohilo_h has space for deg+1 vectors of dimension dim;
 *   solhilolo_h has space for deg+1 vectors of dimension dim;
 *   sollololo_h has space for deg+1 vectors of dimension dim;
 *   solhihihi_d has space for deg+1 vectors of dimension dim;
 *   sollohihi_d has space for deg+1 vectors of dimension dim;
 *   solhilohi_d has space for deg+1 vectors of dimension dim;
 *   sollolohi_d has space for deg+1 vectors of dimension dim;
 *   solhihilo_d has space for deg+1 vectors of dimension dim;
 *   sollohilo_d has space for deg+1 vectors of dimension dim;
 *   solhilolo_d has space for deg+1 vectors of dimension dim;
 *   sollololo_d has space for deg+1 vectors of dimension dim;
 *   Qhihihi_h has space allocated for the Q computed by the host;
 *   Qlohihi_h has space allocated for the Q computed by the host;
 *   Qhilohi_h has space allocated for the Q computed by the host;
 *   Qlolohi_h has space allocated for the Q computed by the host;
 *   Qhihilo_h has space allocated for the Q computed by the host;
 *   Qlohilo_h has space allocated for the Q computed by the host;
 *   Qhilolo_h has space allocated for the Q computed by the host;
 *   Qlololo_h has space allocated for the Q computed by the host;
 *   Qhihihi_d has space allocated for the Q computed by the device;
 *   Qlohihi_d has space allocated for the Q computed by the device;
 *   Qhilohi_d has space allocated for the Q computed by the device;
 *   Qlolohi_d has space allocated for the Q computed by the device;
 *   Qhihilo_d has space allocated for the Q computed by the device;
 *   Qlohilo_d has space allocated for the Q computed by the device;
 *   Qhilolo_d has space allocated for the Q computed by the device;
 *   Qlololo_d has space allocated for the Q computed by the device;
 *   Rhihihi_h has space allocated for the R computed by the host;
 *   Rlohihi_h has space allocated for the R computed by the host;
 *   Rhilohi_h has space allocated for the R computed by the host;
 *   Rlolohi_h has space allocated for the R computed by the host;
 *   Rhihilo_h has space allocated for the R computed by the host;
 *   Rlohilo_h has space allocated for the R computed by the host;
 *   Rhilolo_h has space allocated for the R computed by the host;
 *   Rlololo_h has space allocated for the R computed by the host;
 *   Rhihihi_d has space allocated for the R computed by the device;
 *   Rlohihi_d has space allocated for the R computed by the device;
 *   Rhilohi_d has space allocated for the R computed by the device;
 *   Rlolohi_d has space allocated for the R computed by the device;
 *   Rhihilo_d has space allocated for the R computed by the device;
 *   Rlohilo_d has space allocated for the R computed by the device;
 *   Rhilolo_d has space allocated for the R computed by the device;
 *   Rlololo_d has space allocated for the R computed by the device;
 *   wrkmathihihi has work space allocated for a matrix of dimension dim;
 *   wrkmatlohihi has work space allocated for a matrix of dimension dim;
 *   wrkmathilohi has work space allocated for a matrix of dimension dim;
 *   wrkmatlolohi has work space allocated for a matrix of dimension dim;
 *   wrkmathihilo has work space allocated for a matrix of dimension dim;
 *   wrkmatlohilo has work space allocated for a matrix of dimension dim;
 *   wrkmathilolo has work space allocated for a matrix of dimension dim;
 *   wrkmatlololo has work space allocated for a matrix of dimension dim;
 *   wrkvechihihi has work space allocated for a vector of dimension dim;
 *   wrkveclohihi has work space allocated for a vector of dimension dim;
 *   wrkvechilohi has work space allocated for a vector of dimension dim;
 *   wrkveclolohi has work space allocated for a vector of dimension dim;
 *   wrkvechihilo has work space allocated for a vector of dimension dim;
 *   wrkveclohilo has work space allocated for a vector of dimension dim;
 *   wrkvechilolo has work space allocated for a vector of dimension dim;
 *   wrkveclololo has work space allocated for a vector of dimension dim;
 *   resvechihihi has space for deg+1 vectors of dimension dim;
 *   resveclohihi has space for deg+1 vectors of dimension dim;
 *   resvechilohi has space for deg+1 vectors of dimension dim;
 *   resveclolohi has space for deg+1 vectors of dimension dim;
 *   resvechihilo has space for deg+1 vectors of dimension dim;
 *   resveclohilo has space for deg+1 vectors of dimension dim;
 *   resvechilolo has space for deg+1 vectors of dimension dim;
 *   resveclololo has space for deg+1 vectors of dimension dim;
 *   vrblvl    is the verbose level;
 *   mode      execution mode, 0 (GPU only), 1 (CPU only) or 2 (GPU+CPU).
 *
 * ON RETURN :
 *   inputhihihi_h has the highest doubles of series, on host (mode 1, 2);
 *   inputlohihi_h has the second highest doubles of series computed on host;
 *   inputhilohi_h has the third highest doubles of series computed on host;
 *   inputlolohi_h has the fourth highest doubles of series computed on host;
 *   inputhihilo_h has the fourth lowest doubles of series, on host;
 *   inputlohilo_h has the third lowest doubles of series computed on host;
 *   inputhilolo_h has the second lowest doubles of series computed on host;
 *   inputlololo_h has the lowest doubles of series computed on host;
 *   inputhihihi_d has the highest doubles of series, on device (mode 0, 2);
 *   inputlohihi_d has the second highest doubles of series, on device;
 *   inputhilohi_d has the third highest doubles of series, on device;
 *   inputlolohi_d has the fourth highest doubles of series, on device;
 *   inputhihihi_d has the fourth lowest doubles of series, on device;
 *   inputlohihi_d has the third lowest doubles of series, on device;
 *   inputhilohi_d has the second lowest doubles of series, on device;
 *   inputlolohi_d has the lowest doubles of series, on device;
 *   outputhihi_h has the highest doubles of evaluated series, on host;
 *   outputlohi_h has the second highest doubles of series, on host;
 *   outputhilo_h has the third highest doubles of series, on host;
 *   outputlolo_h has the fourth highest doubles of series, on host;
 *   outputhihi_h has the fourth lowest doubles of series, on host;
 *   outputlohi_h has the third lowest doubles of series, on host;
 *   outputhilo_h has the second lowest doubles of series, on host;
 *   outputlolo_h has the lowest doubles of series, on host;
 *   outputhihi_d has the highest doubles of series, on device;
 *   outputlohi_d has the second highest doubles of series, on device;
 *   outputhilo_d has the third highest doubles of series, on device;
 *   outputlolo_d has the fourth highest doubles of series, on device;
 *   outputhihi_d has the fourth lowest doubles of series, on device;
 *   outputlohi_d has the third lowest doubles of series, on device;
 *   outputhilo_d has the second lowest doubles of series, on device;
 *   outputlolo_d has the lowest doubles of series, on device;
 *   funvalhihihi_h has the highest doubles of output[i][dim], on host;
 *   funvallohihi_h has the second highest doubles of output[i][dim], on host;
 *   funvalhilohi_h has the third highest doubles of output[i][dim], on host;
 *   funvallolohi_h has the fourth highest doubles of output[i][dim], on host;
 *   funvalhihilo_h has the fourth lowest doubles of output[i][dim], on host;
 *   funvallohilo_h has the third lowest doubles of output[i][dim], on host;
 *   funvalhilolo_h has the second lowest doubles of output[i][dim], on host;
 *   funvallololo_h has the lowest doubles of output[i][dim], on host;
 *   funvalhihihi_d has the highest doubles of output[i][dim], on device;
 *   funvallohihi_d has the 2nd highest doubles of output[i][dim], on device;
 *   funvalhilohi_d has the 3rd highest doubles of output[i][dim], on device;
 *   funvallolohi_d has the 4th highest doubles of output[i][dim], on device;
 *   funvalhihilo_d has the 4th lowest doubles of output[i][dim], on device;
 *   funvallohilo_d has the 3rd lowest doubles of output[i][dim], on device;
 *   funvalhilolo_d has the 2nd lowest doubles of output[i][dim], on device;
 *   funvallololo_d has the lowest doubles of output[i][dim], on device;
 *   jacvalhihihi_h has the highest doubles of matrices, on host,
 *             the leading coefficient is the Jacobian matrix;
 *   jacvallohihi_h has the second highest doubles of matrices, on host;
 *   jacvalhilohi_h has the third highest doubles of matrices, on host;
 *   jacvallolohi_h has the fourth highest doubles of matrices, on host;
 *   jacvalhihilo_h has the fourth lowest doubles of matrices, on host;
 *   jacvallohilo_h has the third lowest doubles of matrices, on host;
 *   jacvalhilolo_h has the second lowest doubles of matrices, on host;
 *   jacvallololo_h has the lowest doubles of matrices, on host;
 *   jacvalhihihi_d has the highest doubles of matrices, on device,
 *             the leading coefficient is the Jacobian matrix;
 *   jacvallohihi_d has the second highest doubles of matrices, on device;
 *   jacvalhilohi_d has the third highest doubles of matrices, on device;
 *   jacvallolohi_d has the fourth highest doubles of matrices, on device;
 *   jacvalhihilo_d has the fourth lowest doubles of matrices, on device;
 *   jacvallohilo_d has the third lowest doubles of matrices, on device;
 *   jacvalhilolo_d has the second lowest doubles of matrices, on device:
 *   jacvallololo_d has the lowest doubles of matrices, on device;
 *   rhshihihi_h has the highest doubles of the right hand side, linearized,
 *             subtracted by 1 and added by t, computed by host;
 *   rhslohihi_h has the 2nd highest doubles of the right hand side, on host;
 *   rhshilohi_h has the 3rd highest doubles of the right hand side, on host;
 *   rhslolohi_h has the 4th highest doubles of the right hand side, on host;
 *   rhshihilo_h has the 4th lowest doubles of the right hand side, on host;
 *   rhslohilo_h has the 3rd lowest doubles of the right hand side, on host;
 *   rhshilolo_h has the 2nd lowest doubles of the right hand side, on host;
 *   rhslololo_h has the lowest doubles of the right hand side, on host;
 *   rhshihi_d has the highest doubles of the right hand side, linearized,
 *             subtracted by 1 and added by t, computed by device;
 *   rhslohi_d has the 2nd highest doubles of the right hand side, on device;
 *   rhshilo_d has the 3rd highest doubles of the right hand side, on device;
 *   rhslolo_d has the 4th highest doubles of the right hand side, on device;
 *   rhshihi_d has the 4th lowest doubles of the right hand side, on device;
 *   rhslohi_d has the 3rd lowest doubles of the right hand side, on device;
 *   rhshilo_d has the 2nd lowest doubles of the right hand side, on device;
 *   rhslolo_d has the lowest doubles of the right hand side, on device;
 *   urhshihihi_h has the highest doubles of updated right hand side, on host;
 *   urhslohihi_h has the second highest doubles of right hand side, on host;
 *   urhshilohi_h has the third highest doubles of right hand side, on host;
 *   urhslolohi_h has the fourth highest doubles of right hand side, on host;
 *   urhshihilo_h has the fourth lowest doubles of right hand side, on host;
 *   urhslohilo_h has the third lowest doubles of right hand side, on host;
 *   urhshilolo_h has the second lowest doubles of right hand side, on host;
 *   urhslololo_h has the lowest doubles of updated right hand side, on host;
 *   urhshihihi_d has the highest doubles of right hand side, on device;
 *   urhslohihi_d has the second highest doubles of right hand side, on device;
 *   urhshilohi_d has the third highest doubles of right hand side, on device;
 *   urhslolohi_d has the fourth highest doubles of right hand side, on device;
 *   urhshihilo_d has the fourth lowest doubles of right hand side, on device;
 *   urhslohilo_d has the third lowest doubles of right hand side, on device;
 *   urhshilolo_d has the second lowest doubles of right hand side, on device;
 *   urhslololo_d has the lowest doubles of right hand side, on device;
 *   solhihihi_h has the highest doubles of solution, on the host;
 *   sollohihi_h has the second highest doubles of solution, on the host;
 *   solhilohi_h has the third highest doubles of solution, on the host;
 *   sollolohi_h has the fourth highest doubles of solution, on the host;
 *   solhihilo_h has the fourth lowest doubles of solution, on the host;
 *   sollohilo_h has the third lowest doubles of solution, on the host;
 *   solhilolo_h has the second lowest doubles of solution, on the host;
 *   sollololo_h has the lowest doubles of solution, on the host;
 *   solhihihi_d has the highest doubles of solution, on the device;
 *   sollohihi_d has the second highest doubles of solution, on the device;
 *   solhilohi_d has the third highest doubles of solution, on the device;
 *   sollolohi_d has the fourth highest doubles of solution, on the device;
 *   solhihilo_d has the fourth lowest doubles of solution, on the device;
 *   sollohilo_d has the third lowest doubles of solution, on the device;
 *   solhilolo_d has the second lowest doubles of solution, on the device;
 *   sollololo_d has the lowest doubles of solution, on the device;
 *   Qhihihi_h are the highest doubles of Q of the QR, on the host;
 *   Qlohihi_h are the second highest doubles of Q of the QR, on the host;
 *   Qhilohi_h are the third highest doubles of Q of the QR, on the host;
 *   Qlolohi_h are the fourth highest doubles of Q of the QR, on the host;
 *   Qhihilo_h are the fourth lowest doubles of Q of the QR, on the host;
 *   Qlohilo_h are the third lowest doubles of Q of the QR, on the host;
 *   Qhilolo_h are the second lowest doubles of Q of the QR, on the host;
 *   Qlololo_h are the lowest doubles of Q of the QR, on the host;
 *   Qhihihi_d are the highest doubles of Q of the QR, on the device;
 *   Qlohihi_d are the second highest doubles of Q of the QR, on the device;
 *   Qhilohi_d are the third highest doubles of Q of the QR, on the device;
 *   Qlolohi_d are the fourth highest doubles of Q of the QR, on the device;
 *   Qhihilo_d are the fourth lowest doubles of Q of the QR, on the device;
 *   Qlohilo_d are the third lowest doubles of Q of the QR, on the device;
 *   Qhilolo_d are the second lowest doubles of Q of the QR, on the device;
 *   Qlololo_d are the lowest doubles of Q of the QR, on the device;
 *   Rhihihi_h are the highest doubles of R of the QR, on the host;
 *   Rlohihi_h are the second highest doubles of R of the QR, on the host;
 *   Rhilohi_h are the third highest doubles of R of the QR, on the host;
 *   Rlolohi_h are the fourth highest doubles of R of the QR, on the host;
 *   Rhihilo_h are the fourth lowest doubles of R of the QR, on the host;
 *   Rlohilo_h are the third lowest doubles of R of the QR, on the host;
 *   Rhilolo_h are the second lowest doubles of R of the QR, on the host;
 *   Rlololo_h are the lowest doubles of R of the QR, on the host;
 *   Rhihihi_d are the highest doubles of R of the QR, on the device;
 *   Rlohihi_d are the second highest doubles of R of the QR, on the device;
 *   Rhilohi_d are the third highest doubles of R of the QR, on the device;
 *   Rlolohi_d are the fourth highest doubles of R of the QR, on the device;
 *   Rhihilo_d are the fourth lowest doubles of R of the QR, on the device;
 *   Rlohilo_d are the third lowhest doubles of R of the QR, on the device;
 *   Rhilolo_d are the second lowest doubles of R of the QR, on the device;
 *   Rlololo_d are the lowest doubles of R of the QR, on the device;
 *   wrkmathihihi has a copy of the highest doubles of the Jacobian;
 *   wrkmatlohihi has a copy of the second highest doubles of the Jacobian;
 *   wrkmathilohi has a copy of the third highest doubles of the Jacobian;
 *   wrkmatlolohi has a copy of the fourth highest doubles of the Jacobian;
 *   wrkmathihilo has a copy of the fourth lowest doubles of the Jacobian;
 *   wrkmatlohilo has a copy of the third lowest doubles of the Jacobian;
 *   wrkmathilolo has a copy of the second lowest doubles of the Jacobian;
 *   wrkmatlololo has a copy of the lowest doubles of the Jacobian matrix;
 *   resvechihihi has the highest doubles of the residual vectors;
 *   resveclohihi has the second highest doubles of the residual vectors;
 *   resvechilohi has the third highest doubles of the residual vectors;
 *   resveclolohi has the fourth highest doubles of the residual vectors;
 *   resvechihilo has the fourth lowest doubles of the residual vectors;
 *   resveclohilo has the third lowest doubles of the residual vectors;
 *   resvechilolo has the second lowest doubles of the residual vectors;
 *   resveclololo has the lowest doubles of the residual vectors;
 *   resmaxhihihi is the highest double of the maximum of residual vectors;
 *   resmaxlohihi is the second highest double of the maximum of residual;
 *   resmaxhilohi is the third highest double of the maximum of residual;
 *   resmaxlolohi is the fourth highest double of the maximum of residual;
 *   resmaxhihilo is the fourth lowest double of the maximum of residual;
 *   resmaxlohilo is the third lowest double of the maximum of residual;
 *   resmaxhilolo is the second lowest double of the maximum of residual;
 *   resmaxlololo is the lowest double of the maximum of residual. */

#endif
