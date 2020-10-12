/* This file penta_double_functions.h defines the arithmetical operations 
   for penta double numbers.  A penta double is defined by five doubles.

The five doubles of a penta double are named after the five fingers of
the hand, starting with the thumb for the most significant double,
then to the index, middle, ring, and pink, which is the last significant
part of a penta double number.  Abbreviations for thumb, index, middle,
ring, and pink are respectively tb, ix, mi, rg, and pk.

The algorithms are from the CAMPARY and QD software libraries
with the modification that a penta double is not stored as an array
of five doubles, but plainly by five double numbers.
All functions have the prefix pdf_ to avoid name clashes. */

#ifndef __penta_double_functions_h__
#define __penta_double_functions_h__

/************************** renormalizations **************************/

void pdf_renorm5
 ( double f0, double f1, double f2, double f3, double f4, double f5,
   double *pr, double *r0, double *r1, double *r2, double *r3, double *r4 );
/*
 * DESCRIPTION :
 *   Definitions common to fast_renorm2L<6,5> and renorm2L_4Add1<5,5>
 *   from code of the specRenorm.h, generated by the CAMPARY library,
 *   in an unrolled form (Valentina Popescu, Mioara Joldes), with
 *   double double basics of QD-2.3.9 (Y. Hida, X.S. Li, and D.H. Bailey).
 *
 * ON ENTRY :
 *   f0       most significant word;
 *   f1       second most significant word;
 *   f2       third most significant word;
 *   f3       fourth most significant word;
 *   f4       fifth most significant word;
 *   f5       sixth most significant word;
 *   pr       computed by the start of the renormalization.
 *
 * ON RETURN :
 *   pr       updated value by renormalization;
 *   r0       highest part of a penta double number;
 *   r1       second highest part of a penta double number;
 *   r2       middle part of a penta double number.
 *   r3       second lowest part of a penta double number;
 *   r4       lowest part of a penta double number. */

void pdf_fast_renorm
 ( double x0, double x1, double x2, double x3, double x4, double x5,
   double *r0, double *r1, double *r2, double *r3, double *r4 );
/*
 * DESCRIPTION :
 *   The definition is based on the fast_renorm2L<6,5>,
 *   from code of the specRenorm.h, generated by the CAMPARY library,
 *   in an unrolled form (Valentina Popescu, Mioara Joldes), with
 *   double double basics of QD-2.3.9 (Y. Hida, X.S. Li, and D.H. Bailey).
 *
 * ON ENTRY :
 *   x0       most significant word;
 *   x1       second most significant word;
 *   x2       third most significant word;
 *   x3       fourth most significant word;
 *   x4       fifth most significant word;
 *   x5       least significant word.
 *
 * ON RETURN :
 *   r0       highest part of a penta double number;
 *   r1       second highest part of a penta double number;
 *   r2       middle part of a penta double number;
 *   r3       second lowest part of a penta double number;
 *   r4       lowest part of a penta double number. */

void pdf_renorm_add1
 ( double x0, double x1, double x2, double x3, double x4, double y,
   double *r0, double *r1, double *r2, double *r3, double *r4 );
/*
 * DESCRIPTION :
 *   The definition is based on the renorm2L_4Add1<5,5>,
 *   from code of the specRenorm.h, generated by the CAMPARY library,
 *   in an unrolled form (Valentina Popescu, Mioara Joldes), with
 *   double double basics of QD-2.3.9 (Y. Hida, X.S. Li, and D.H. Bailey).
 *
 * ON ENTRY :
 *   x0       most significant word of a penta double x;
 *   x1       second most significant word of a penta double x;
 *   x2       third most significant word of a penta double x;
 *   x3       fourth most significant word of a penta double x;
 *   x4       least significant word of a penta double x;
 *   y        double to be added to x.
 *
 * ON RETURN :
 *   r0       highest part of x + y;
 *   r1       second highest part of x + y;
 *   r2       middle part of x + y;
 *   r3       second lowest part of x + y;
 *   r4       lowest part of x + y. */

/************************ copy and abs *******************************/

void pdf_copy
 ( double a_tb, double a_ix, double a_mi, double a_rg, double a_pk,
   double *b_tb, double *b_ix, double *b_mi, double *b_rg, double *b_pk );
/*
 * DESCRIPTION :
 *   Copies the content of the penta double a (a_tb, a_ix, a_mi, a_rg, a_pk)
 *   to the penta double b (b_tb, b_ix, b_mi, b_rg, b_pk). */

void pdf_abs
 ( double a_tb, double a_ix, double a_mi, double a_rg, double a_pk,
   double *b_tb, double *b_ix, double *b_mi, double *b_rg, double *b_pk );
/*
 * DESCRIPTION :
 *   Returns in b the absolute value of a. */

/****************** additions and substractions ************************/

void pdf_add
 ( double a_tb, double a_ix, double a_mi, double a_rg, double a_pk,
   double b_tb, double b_ix, double b_mi, double b_rg, double b_pk,
   double *c_tb, double *c_ix, double *c_mi, double *c_rg, double *c_pk);
/*
 * DESCRIPTION : c = a + b.
 *   Adds two penta doubles a (a_tb, a_ix, a_mi, a_rg, a_pk)
 *   and b (b_tb, b_ix, b_mi, b_rg, b_pk)
 *   to make the penta double c (c_tb, c_ix, c_mi, c_rg, c_pk).
 *
 * ON ENTRY :
 *   a_tb     highest part of the penta double a;
 *   a_ix     second highest part of the penta double a;
 *   a_mi     middle part of the penta double a;
 *   a_rg     second lowest part of the penta double a;
 *   a_pk     lowest part of the penta double a;
 *   b_tb     highest part of the penta double b;
 *   b_ix     second highest part of the penta double b;
 *   b_mi     middle part of the penta double b;
 *   b_rg     second lowest part of the penta double b;
 *   b_pk     lowest part of the penta double b.
 *
 * ON RETURN :
 *   c_tb     highest part of the penta double c = a + b;
 *   c_ix     second highest part of the penta double c = a + b;
 *   c_mi     middle part of the penta double c = a + b;
 *   c_rg     second lowest part of the penta double c = a + b;
 *   c_pk     lowest part of the penta double c = a + b. */

void pdf_inc
 ( double *a_tb, double *a_ix, double *a_mi, double *a_rg, double *a_pk,
   double b_tb, double b_ix, double b_mi, double b_rg, double b_pk );
/*
 * DESCRIPTION : a = a + b.
 *   Adds to the penta double a (a_tb, a_ix, a_mi, a_rg, a_pk)
 *   the penta double b (b_tb, b_ix, b_mi, b_rg, b_pk).
 *
 * ON ENTRY :
 *   a_tb     highest part of the penta double a;
 *   a_ix     second highest part of the penta double a;
 *   a_mi     middle part of the penta double a;
 *   a_rg     second lowest part of the penta double a;
 *   a_pk     lowest part of the penta double a;
 *   b_tb     highest part of the penta double b;
 *   b_ix     second highest part of the penta double b;
 *   b_mi     middle part of the penta double b;
 *   b_rg     second lowest part of the penta double b;
 *   b_pk     lowest part of the penta double b.
 *
 * ON RETURN :
 *   a_tb     highest part of the penta double a + b;
 *   a_ix     second highest part of the penta double a + b;
 *   a_mi     middle part of the penta double a + b;
 *   a_rg     second lowest part of the penta double a + b;
 *   a_pk     lowest part of the penta double a + b. */

void pdf_minus
 ( double *a_tb, double *a_ix, double *a_mi, double *a_rg, double *a_pk );
/*
 * DESCRIPTION :
 *   Flips the sign of a (a_tb, a_ix, a_mi, a_rg, a_pk). */

void pdf_sub
 ( double a_tb, double a_ix, double a_mi, double a_rg, double a_pk,
   double b_tb, double b_ix, double b_mi, double b_rg, double b_pk,
   double *c_tb, double *c_ix, double *c_mi, double *c_rg, double *c_pk );
/*
 * DESCRIPTION : c = a - b.
 *   Subtracts the penta double in b (b_tb, b_ix, b_mi, b_rg, b_pk)
 *   from the penta double in a (a_tb, a_ix, a_mi, a_rg, a_pk) and
 *   places the result in the penta double c (c_tb, c_ix, c_mi, c_rg, c_pk).
 *
 * ON ENTRY :
 *   a_tb     highest part of the penta double a;
 *   a_ix     second highest part of the penta double a;
 *   a_mi     middle part of the penta double a;
 *   a_rg     second lowest part of the penta double a;
 *   a_pk     lowest part of the penta double a;
 *   b_tb     highest part of the penta double b;
 *   b_ix     second highest part of the penta double b;
 *   b_mi     middle part of the penta double b;
 *   b_rg     second lowest part of the penta double b;
 *   b_pk     lowest part of the penta double b.
 *
 * ON RETURN :
 *   c_tb     highest part of the penta double c = a - b;
 *   c_ix     second highest part of the penta double c = a - b;
 *   c_mi     middle part of the penta double c = a - b;
 *   c_rg     second lowest part of the penta double c = a - b;
 *   c_pk     lowest part of the penta double c = a - b. */

/***************** multiplications and division ********************/

void pdf_mul_pwr2
 ( double a_tb, double a_ix, double a_mi, double a_rg, double a_pk,
   double b,
   double *c_tb, double *c_ix, double *c_mi, double *c_rg, double *c_pk );
/*
 * DESCRIPTION : c = a * b, where b is a power of two.
 *   As b is a power of two, all components of the penta double
 *   are plainly multiplied by b.
 *
 * ON ENTRY :
 *   a_tb     highest part of the penta double a;
 *   a_ix     second highest part of the penta double a;
 *   a_mi     middle part of the penta double a;
 *   a_rg     second lowest part of the penta double a;
 *   a_pk     lowest part of the penta double a;
 *   b        a power of two.
 *
 * ON RETURN :
 *   c_tb     highest part of the penta double c = a * b;
 *   c_ix     second highest part of the penta double c = a * b;
 *   c_mi     middle part of the penta double c = a * b;
 *   c_rg     second lowest part of the penta double c = a * b;
 *   c_pk     lowest part of the penta double c = a * b. */

void pdf_mul
 ( double a_tb, double a_ix, double a_mi, double a_rg, double a_pk,
   double b_tb, double b_ix, double b_mi, double b_rg, double b_pk,
   double *c_tb, double *c_ix, double *c_mi, double *c_rg, double *c_pk );
/*
 * DESCRIPTION : c = a * b.
 *   Multiplies two penta doubles a (a_tb, a_ix, a_mi, a_pk, a_lo)
 *   and b (b_tb, b_ix, b_mi, b_rg, b_pk) 
 *   to make the penta double c (c_tb, c_ix, c_mi, c_rg, c_pk).
 *
 * ON ENTRY :
 *   a_tb     highest part of the penta double a;
 *   a_ix     second highest part of the penta double a;
 *   a_mi     middle part of the penta double a;
 *   a_rg     second lowest part of the penta double a;
 *   a_pk     lowest part of the penta double a;
 *   b_tb     highest part of the penta double b;
 *   b_ix     second highest part of the penta double b;
 *   b_mi     middle part of the penta double b;
 *   b_rg     second lowest part of the penta double b;
 *   b_pk     lowest part of the penta double b.
 *
 * ON RETURN :
 *   c_tb     highest part of the penta double c = a * b;
 *   c_ix     second highest part of the penta double c = a * b;
 *   c_mi     middle part of the penta double c = a * b;
 *   c_pk     second lowest part of the penta double c = a * b;
 *   c_pk     lowest part of the penta double c = a * b. */

void pdf_sqr
 ( double a_tb, double a_ix, double a_mi, double a_rg, double a_pk,
   double *c_tb, double *c_ix, double *c_mi, double *c_rg, double *c_pk );
/*
 * DESCRIPTION : c = a * a.
 *   Multiplies the penta double a (a_tb, a_ix, a_mi, a_rg, a_pk) with a
 *   to make the penta double c (c_tb, c_ix, c_mi, c_rg, c_pk).
 *
 * ON ENTRY :
 *   a_tb     highest part of the penta double a;
 *   a_ix     second highest part of the penta double a;
 *   a_mi     middle part of the penta double a;
 *   a_rg     second lowest part of the penta double a;
 *   a_pk     lowest part of the penta double a.
 *
 * ON RETURN :
 *   c_tb     highest part of the penta double c = a * a;
 *   c_ix     second highest part of the penta double c = a * a;
 *   c_mi     middle part of the penta double c = a * a;
 *   c_rg     second lowest part of the penta double c = a * a;
 *   c_pk     lowest part of the penta double c = a * a. */

void pdf_mul_pd_d
 ( double a_tb, double a_ix, double a_mi, double a_rg, double a_pk,
   double b,
   double *c_tb, double *c_ix, double *c_mi, double *c_rg, double *c_pk );
/*
 * DESCRIPTION : c = a * b.
 *   Multiplies the penta double a (a_tb, a_ix, a_mi, a_rg, a_pk) with b
 *   to make the penta double c (c_tb, c_ix, c_mi, c_rg, c_pk).
 *
 * ON ENTRY :
 *   a_tb     highest part of the penta double a;
 *   a_ix     second highest part of the penta double a;
 *   a_mi     middle part of the penta double a;
 *   a_rg     second lowest part of the penta double a;
 *   a_pk     lowest part of the penta double a;
 *   b        some double.
 *
 * ON RETURN :
 *   c_tb     highest part of the penta double c = a * b;
 *   c_ix     second highest part of the penta double c = a * b;
 *   c_mi     middle part of the penta double c = a * b;
 *   c_rg     second lowest part of the penta double c = a * b;
 *   c_pk     lowest part of the penta double c = a * b. */

void pdf_div
 ( double a_tb, double a_ix, double a_mi, double a_rg, double a_pk,
   double b_tb, double b_ix, double b_mi, double b_rg, double b_pk,
   double *c_tb, double *c_ix, double *c_mi, double *c_rg, double *c_pk );
/*
 * DESCRIPTION : c = a / b.
 *   Divides the penta double a (a_tb, a_ix, a_mi, a_rg, a_pk) 
 *   by b (b_tb, b_ix, b_mi, b_rg, b_pk) 
 *   to make the penta double c (c_tb, c_ix, c_mi, c_rg, c_pk).
 *
 * ON ENTRY :
 *   a_tb     highest part of the penta double a;
 *   a_ix     second highest part of the penta double a;
 *   a_mi     middle part of the penta double a;
 *   a_rg     second lowest part of the penta double a;
 *   a_pk     lowest part of the penta double a;
 *   b_tb     highest part of the penta double b;
 *   b_ix     second highest part of the penta double b;
 *   b_mi     middle part of the penta double b;
 *   b_rg     second lowest part of the penta double b;
 *   b_pk     lowest part of the penta double b.
 *
 * ON RETURN :
 *   c_tb     highest part of the penta double c = a / b;
 *   c_ix     second highest part of the penta double c = a / b;
 *   c_mi     middle part of the penta double c = a / b;
 *   c_rg     second lowest part of the penta double c = a / b;
 *   c_pk     lowest part of the penta double c = a / b. */

/***************************** square root *****************************/

void pdf_sqrt
 ( double a_tb, double a_ix, double a_mi, double a_rg, double a_pk,
   double *b_tb, double *b_ix, double *b_mi, double *b_rg, double *b_pk );
/*
 * DESCRIPTION :
 *   Returns in the penta double b (b_tb, b_ix, b_mi, b_rg, b_pk) 
 *   the square root of the penta double a (a_tb, a_ix, a_mi, a_rg, a_pk).
 *
 * ON ENTRY :
 *   a_tb     highest part of the penta double a;
 *   a_ix     second highest part of the penta double a;
 *   a_mi     middle part of the penta double a;
 *   a_rg     second lowest part of the penta double a;
 *   a_pk     lowest part of the penta double a.
 *
 * ON RETURN :
 *   b_tb     highest part of the penta double b;
 *   b_ix     second highest part of the penta double b;
 *   b_mi     middle part of the penta double b;
 *   b_rg     second lowest part of the penta double b;
 *   b_pk     lowest part of the penta double b. */

/*************************** basic output ***************************/

void pdf_write_doubles
 ( double a_tb, double a_ix, double a_mi, double a_rg, double a_pk );
/*
 * DESCRIPTION :
 *   Writes the five doubles (a_tb, a_ix, a_mi, a_rg, a_lo) of the penta
 *   double a in scientific format with 16 decimal places of precision. */

#endif
