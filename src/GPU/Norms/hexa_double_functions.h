/* This file hexa_double_functions.h defines the arithmetical operations 
 * for hexa double numbers.  A hexa double is defined by sixteen doubles.
 *
 * The naming of the sixteen doubles of an hexa double extends the naming
 * of the eight doubles in an octo double
 * (hihihi, lohihi, hilohi, lolohi, hihilo, lohilo, hilolo, lololo)
 * into sixteen doubles named as follows:
 * (hihihihi, lohihihi, hilohihi, lolohihi,
 *  hihilohi, lohilohi, hilolohi, lololohi,
 *  hihihilo, lohihilo, hilohilo, lolohilo,
 *  hihilolo, lohilolo, hilololo, lolololo),
 * listed in decreasing order of significance.
 *
 * The algorithms are from the CAMPARY and QD software libraries
 * with the modification that a hexa double is not stored as an array
 * of sixteen doubles, but plainly by sixteen double numbers.
 * All functions have the prefix hdf_ to avoid name clashes. */

#ifndef __hexa_double_functions_h__
#define __hexa_double_functions_h__

/************************* renormalizations ************************/

void hdf_renorm16
 ( double f0, double f1, double f2, double f3, double f4, double f5,
   double f6, double f7, double f8, double f9, double f10, double f11,
   double f12, double f13, double f14, double f15, double f16, double *pr, 
   double *r0, double *r1, double *r2, double *r3, double *r4, double *r5,
   double *r6, double *r7, double *r8, double *r9, double *r10, double *r11,
   double *r12, double *r13, double *r14, double *r15 );
/*
 * DESCRIPTION :
 *   Definitions common to fast_renorm2L<17,16> and renorm2L_4Add1<16,16>
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
 *   f6       seventh most significant word;
 *   f7       eighth most significant word;
 *   f8       nineth most significant word;
 *   f9       tenth most significant word;
 *   f10      eleventh most significant word;
 *   f11      twelveth most significant word;
 *   f12      thirteenth most significant word;
 *   f13      forteenth most significant word;
 *   f14      fifteenth most significant word;
 *   f15      sixteenth most significant word;
 *   f16      least significant word.
 *   pr       computed by the start of the renormalization.
 *
 * ON RETURN :
 *   pr       updated value by renormalization;
 *   r0       highest part of a hexa double number;
 *   r1       second highest part of an hexa double number;
 *   r2       third highest part of an hexa double number.
 *   r3       fourth highest part of an hexa double number;
 *   r4       fifth highest part of an hexa double number;
 *   r5       sixth highest part of an hexa double number;
 *   r6       seventh highest part of an hexa double number;
 *   r7       eighth highest part of an hexa double number;
 *   r8       eighth lowest part of an hexa double number;
 *   r9       seventh lowest part of an hexa double number;
 *   r10      sixth lowest part of an hexa double number;
 *   r11      fifth lowest part of an hexa double number;
 *   r12      fourth lowest part of an hexa double number;
 *   r13      third lowest part of an hexa double number;
 *   r14      second lowest part of an hexa double number;
 *   r15      lowest part of an hexa double number. */

void hdf_fast_renorm
 ( double x0, double x1, double x2, double x3, double x4, double x5,
   double x6, double x7, double x8, double x9, double x10, double x11,
   double x12, double x13, double x14, double x15, double x16,
   double *r0, double *r1, double *r2, double *r3, double *r4, double *r5,
   double *r6, double *r7, double *r8, double *r9, double *r10, double *r11,
   double *r12, double *r13, double *r14, double *r15 );
/*
 * DESCRIPTION :
 *   The definition is based on the fast_renorm2L<17,16>,
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
 *   x5       sixth most significant word;
 *   x6       seventh most significant word;
 *   x7       eighth most significant word;
 *   x8       nineth most significant word;
 *   x9       tenth most significant word;
 *   x10      eleventh most significant word;
 *   x11      twelveth most significant word;
 *   x12      thirteenth most significant word;
 *   x13      forteenth most significant word;
 *   x14      fifteenth most significant word;
 *   x15      sixteenth most significant word;
 *   x16      least significant word.
 *
 * ON RETURN :
 *   r0       highest part of a hexa double number;
 *   r1       second highest part of an hexa double number;
 *   r2       third highest part of an hexa double number.
 *   r3       fourth highest part of an hexa double number;
 *   r4       fifth highest part of an hexa double number;
 *   r5       sixth highest part of an hexa double number;
 *   r6       seventh highest part of an hexa double number;
 *   r7       eighth highest part of an hexa double number;
 *   r8       eighth lowest part of an hexa double number;
 *   r9       seventh lowest part of an hexa double number;
 *   r10      sixth lowest part of an hexa double number;
 *   r11      fifth lowest part of an hexa double number;
 *   r12      fourth lowest part of an hexa double number;
 *   r13      third lowest part of an hexa double number;
 *   r14      second lowest part of an hexa double number;
 *   r15      lowest part of an hexa double number. */

void hdf_renorm_add1
 ( double x0, double x1, double x2, double x3, double x4, double x5,
   double x6, double x7, double x8, double x9, double x10, double x11,
   double x12, double x13, double x14, double x15, double y,
   double *r0, double *r1, double *r2, double *r3, double *r4, double *r5,
   double *r6, double *r7, double *r8, double *r9, double *r10, double *r11,
   double *r12, double *r13, double *r14, double *r15 );
/*
 * DESCRIPTION :
 *   The definition is based on the renorm2L_4Add1<16,16>,
 *   from code of the specRenorm.h, generated by the CAMPARY library,
 *   in an unrolled form (Valentina Popescu, Mioara Joldes), with
 *   double double basics of QD-2.3.9 (Y. Hida, X.S. Li, and D.H. Bailey).
 *
 * ON ENTRY :
 *   x0       most significant word of an hexa double x;
 *   x1       second most significant word of an hexa double x;
 *   x2       third most significant word of an hexa double x;
 *   x3       fourth most significant word of an hexa double x;
 *   x4       fifth most significant word of an hexa double x;
 *   x5       sixth most significant word of an hexa double x;
 *   x6       seventh most significant word of an hexa double x;
 *   x7       eighth most significant word of an hexa double x;
 *   x8       eighth least significant word of an hexa double number x;
 *   x9       seventh least significant word of an hexa double number x;
 *   x10      sixth least significant word of an hexa double number x;
 *   x11      fifth least significant word of an hexa double number x;
 *   x12      fourth least significant word of an hexa double number x;
 *   x13      third least significant word of an hexa double number x;
 *   x14      second least significant word of an hexa double number x;
 *   x15      least significant word of an hexa double x;
 *   y        double to be added to x.
 *
 * ON RETURN :
 *   r0       highest part of x + y;
 *   r1       second highest part of x + y;
 *   r2       third highest part of x + y;
 *   r3       fourth highest part of x + y;
 *   r4       fifth highest part of x + y;
 *   r5       sixth highest part of x + y;
 *   r6       seventh highest part of x + y;
 *   r7       eighth highest part of x + y;
 *   r8       eighth lowest part of x + y;
 *   r9       seventh lowest part of x + y;
 *   r10      sixth lowest part of x + y;
 *   r11      fifth lowest part of x + y;
 *   r12      fourth lowest part of x + y;
 *   r13      third lowest part of x + y;
 *   r14      second lowest part of x + y;
 *   r15      lowest part of x + y. */

/*********************** copy and abs *****************************/

void hdf_copy 
 ( double a_hihihihi, double a_lohihihi,
   double a_hilohihi, double a_lolohihi,
   double a_hihilohi, double a_lohilohi,
   double a_hilolohi, double a_lololohi,
   double a_hihihilo, double a_lohihilo,
   double a_hilohilo, double a_lolohilo,
   double a_hihilolo, double a_lohilolo,
   double a_hilololo, double a_lolololo,
   double *b_hihihihi, double *b_lohihihi,
   double *b_hilohihi, double *b_lolohihi,
   double *b_hihilohi, double *b_lohilohi,
   double *b_hilolohi, double *b_lololohi,
   double *b_hihihilo, double *b_lohihilo,
   double *b_hilohilo, double *b_lolohilo,
   double *b_hihilolo, double *b_lohilolo,
   double *b_hilololo, double *b_lolololo );
/*
 * DESCRIPTION :
 *   Copies the content of the hexa double a to the hexa double b. */

void hdf_abs 
 ( double a_hihihihi, double a_lohihihi,
   double a_hilohihi, double a_lolohihi,
   double a_hihilohi, double a_lohilohi,
   double a_hilolohi, double a_lololohi,
   double a_hihihilo, double a_lohihilo,
   double a_hilohilo, double a_lolohilo,
   double a_hihilolo, double a_lohilolo,
   double a_hilololo, double a_lolololo,
   double *b_hihihihi, double *b_lohihihi,
   double *b_hilohihi, double *b_lolohihi,
   double *b_hihilohi, double *b_lohilohi,
   double *b_hilolohi, double *b_lololohi,
   double *b_hihihilo, double *b_lohihilo,
   double *b_hilohilo, double *b_lolohilo,
   double *b_hihilolo, double *b_lohilolo,
   double *b_hilololo, double *b_lolololo );
/*
 * DESCRIPTION :
 *   Returns in b the absolute value of a. */

/******************* addition and subtraction *********************/

void hdf_add 
 ( double a_hihihihi, double a_lohihihi,
   double a_hilohihi, double a_lolohihi,
   double a_hihilohi, double a_lohilohi,
   double a_hilolohi, double a_lololohi,
   double a_hihihilo, double a_lohihilo,
   double a_hilohilo, double a_lolohilo,
   double a_hihilolo, double a_lohilolo,
   double a_hilololo, double a_lolololo,
   double b_hihihihi, double b_lohihihi,
   double b_hilohihi, double b_lolohihi,
   double b_hihilohi, double b_lohilohi,
   double b_hilolohi, double b_lololohi,
   double b_hihihilo, double b_lohihilo,
   double b_hilohilo, double b_lolohilo,
   double b_hihilolo, double b_lohilolo,
   double b_hilololo, double b_lolololo,
   double *c_hihihihi, double *c_lohihihi,
   double *c_hilohihi, double *c_lolohihi,
   double *c_hihilohi, double *c_lohilohi,
   double *c_hilolohi, double *c_lololohi,
   double *c_hihihilo, double *c_lohihilo,
   double *c_hilohilo, double *c_lolohilo,
   double *c_hihilolo, double *c_lohilolo,
   double *c_hilololo, double *c_lolololo );
/*
 * DESCRIPTION : c = a + b, or in words:
 *   Adds two hexa doubles in a and b to make the hexa double c. */

void hdf_inc
 ( double *a_hihihihi, double *a_lohihihi,
   double *a_hilohihi, double *a_lolohihi,
   double *a_hihilohi, double *a_lohilohi,
   double *a_hilolohi, double *a_lololohi,
   double *a_hihihilo, double *a_lohihilo,
   double *a_hilohilo, double *a_lolohilo,
   double *a_hihilolo, double *a_lohilolo,
   double *a_hilololo, double *a_lolololo,
   double b_hihihihi, double b_lohihihi,
   double b_hilohihi, double b_lolohihi,
   double b_hihilohi, double b_lohilohi,
   double b_hilolohi, double b_lololohi,
   double b_hihihilo, double b_lohihilo,
   double b_hilohilo, double b_lolohilo,
   double b_hihilolo, double b_lohilolo,
   double b_hilololo, double b_lolololo );
/*
 * DESCRIPTION : a = a + b, or in words:
 *   Increments the hexa double a with the hexa double b. */

void hdf_inc_d
 ( double *a_hihihihi, double *a_lohihihi,
   double *a_hilohihi, double *a_lolohihi,
   double *a_hihilohi, double *a_lohilohi,
   double *a_hilolohi, double *a_lololohi,
   double *a_hihihilo, double *a_lohihilo,
   double *a_hilohilo, double *a_lolohilo,
   double *a_hihilolo, double *a_lohilolo,
   double *a_hilololo, double *a_lolololo,
   double b );
/*
 * DESCRIPTION : a = a + b, or in words:
 *   Increments the hexa double a with the double b. */

void hdf_dec
 ( double *a_hihihihi, double *a_lohihihi,
   double *a_hilohihi, double *a_lolohihi,
   double *a_hihilohi, double *a_lohilohi,
   double *a_hilolohi, double *a_lololohi,
   double *a_hihihilo, double *a_lohihilo,
   double *a_hilohilo, double *a_lolohilo,
   double *a_hihilolo, double *a_lohilolo,
   double *a_hilololo, double *a_lolololo,
   double b_hihihihi, double b_lohihihi,
   double b_hilohihi, double b_lolohihi,
   double b_hihilohi, double b_lohilohi,
   double b_hilolohi, double b_lololohi,
   double b_hihihilo, double b_lohihilo,
   double b_hilohilo, double b_lolohilo,
   double b_hihilolo, double b_lohilolo,
   double b_hilololo, double b_lolololo );
/*
 * DESCRIPTION : a = a - b, or in words:
 *   Decrements the hexa double a with the hexa double b. */

void hdf_minus 
 ( double *a_hihihihi, double *a_lohihihi,
   double *a_hilohihi, double *a_lolohihi,
   double *a_hihilohi, double *a_lohilohi,
   double *a_hilolohi, double *a_lololohi,
   double *a_hihihilo, double *a_lohihilo,
   double *a_hilohilo, double *a_lolohilo,
   double *a_hihilolo, double *a_lohilolo,
   double *a_hilololo, double *a_lolololo );
/*
 * DESCRIPTION :
 *   Flips the sign of a. */

void hdf_sub 
 ( double a_hihihihi, double a_lohihihi,
   double a_hilohihi, double a_lolohihi,
   double a_hihilohi, double a_lohilohi,
   double a_hilolohi, double a_lololohi,
   double a_hihihilo, double a_lohihilo,
   double a_hilohilo, double a_lolohilo,
   double a_hihilolo, double a_lohilolo,
   double a_hilololo, double a_lolololo,
   double b_hihihihi, double b_lohihihi,
   double b_hilohihi, double b_lolohihi,
   double b_hihilohi, double b_lohilohi,
   double b_hilolohi, double b_lololohi,
   double b_hihihilo, double b_lohihilo,
   double b_hilohilo, double b_lolohilo,
   double b_hihilolo, double b_lohilolo,
   double b_hilololo, double b_lolololo,
   double *c_hihihihi, double *c_lohihihi,
   double *c_hilohihi, double *c_lolohihi,
   double *c_hihilohi, double *c_lohilohi,
   double *c_hilolohi, double *c_lololohi,
   double *c_hihihilo, double *c_lohihilo,
   double *c_hilohilo, double *c_lolohilo,
   double *c_hihilolo, double *c_lohilolo,
   double *c_hilololo, double *c_lolololo );
/*
 * DESCRIPTION : c = a - b, or in words:
 *   Subtracts from the hexa double in a
 *   the hexa double in b to make the hexa double c. */

/**************  multiplications and division ***********************/

void hdf_mul_pwr2
 ( double a_hihihihi, double a_lohihihi,
   double a_hilohihi, double a_lolohihi,
   double a_hihilohi, double a_lohilohi,
   double a_hilolohi, double a_lololohi,
   double a_hihihilo, double a_lohihilo,
   double a_hilohilo, double a_lolohilo,
   double a_hihilolo, double a_lohilolo,
   double a_hilololo, double a_lolololo,
   double b,
   double *c_hihihihi, double *c_lohihihi,
   double *c_hilohihi, double *c_lolohihi,
   double *c_hihilohi, double *c_lohilohi,
   double *c_hilolohi, double *c_lololohi,
   double *c_hihihilo, double *c_lohihilo,
   double *c_hilohilo, double *c_lolohilo,
   double *c_hihilolo, double *c_lohilolo,
   double *c_hilololo, double *c_lolololo );

/*
 * DESCRIPTION : c = a * b, where b is a power of two.
 *   As b is a power of two, all components of the hexa double
 *   are plainly multiplied by b. */

void hdf_mul
 ( double a_hihihihi, double a_lohihihi,
   double a_hilohihi, double a_lolohihi,
   double a_hihilohi, double a_lohilohi,
   double a_hilolohi, double a_lololohi,
   double a_hihihilo, double a_lohihilo,
   double a_hilohilo, double a_lolohilo,
   double a_hihilolo, double a_lohilolo,
   double a_hilololo, double a_lolololo,
   double b_hihihihi, double b_lohihihi,
   double b_hilohihi, double b_lolohihi,
   double b_hihilohi, double b_lohilohi,
   double b_hilolohi, double b_lololohi,
   double b_hihihilo, double b_lohihilo,
   double b_hilohilo, double b_lolohilo,
   double b_hihilolo, double b_lohilolo,
   double b_hilololo, double b_lolololo,
   double *c_hihihihi, double *c_lohihihi,
   double *c_hilohihi, double *c_lolohihi,
   double *c_hihilohi, double *c_lohilohi,
   double *c_hilolohi, double *c_lololohi,
   double *c_hihihilo, double *c_lohihilo,
   double *c_hilohilo, double *c_lolohilo,
   double *c_hihilolo, double *c_lohilolo,
   double *c_hilololo, double *c_lolololo );
/*
 * DESCRIPTION : c = a * b, or in words:
 *   Multiplies the hexa doubles a and b to make the hexa double c. */

void hdf_sqr
 ( double a_hihihihi, double a_lohihihi,
   double a_hilohihi, double a_lolohihi,
   double a_hihilohi, double a_lohilohi,
   double a_hilolohi, double a_lololohi,
   double a_hihihilo, double a_lohihilo,
   double a_hilohilo, double a_lolohilo,
   double a_hihilolo, double a_lohilolo,
   double a_hilololo, double a_lolololo,
   double *c_hihihihi, double *c_lohihihi,
   double *c_hilohihi, double *c_lolohihi,
   double *c_hihilohi, double *c_lohilohi,
   double *c_hilolohi, double *c_lololohi,
   double *c_hihihilo, double *c_lohihilo,
   double *c_hilohilo, double *c_lolohilo,
   double *c_hihilolo, double *c_lohilolo,
   double *c_hilololo, double *c_lolololo );

/*
 * DESCRIPTION : c = a * a.
 *   Multiplies the hexa double a with a
 *   to make the hexa double c. */

void hdf_mul_hd_d
 ( double a_hihihihi, double a_lohihihi,
   double a_hilohihi, double a_lolohihi,
   double a_hihilohi, double a_lohilohi,
   double a_hilolohi, double a_lololohi,
   double a_hihihilo, double a_lohihilo,
   double a_hilohilo, double a_lolohilo,
   double a_hihilolo, double a_lohilolo,
   double a_hilololo, double a_lolololo,
   double b,
   double *c_hihihihi, double *c_lohihihi,
   double *c_hilohihi, double *c_lolohihi,
   double *c_hihilohi, double *c_lohilohi,
   double *c_hilolohi, double *c_lololohi,
   double *c_hihihilo, double *c_lohihilo,
   double *c_hilohilo, double *c_lolohilo,
   double *c_hihilolo, double *c_lohilolo,
   double *c_hilololo, double *c_lolololo );
/*
 * DESCRIPTION : c = a * b.
 *   Multiplies the hexa double a with the double b
 *   to make the hexa double c. */

void hdf_mlt_d
 ( double *a_hihihihi, double *a_lohihihi,
   double *a_hilohihi, double *a_lolohihi,
   double *a_hihilohi, double *a_lohilohi,
   double *a_hilolohi, double *a_lololohi,
   double *a_hihihilo, double *a_lohihilo,
   double *a_hilohilo, double *a_lolohilo,
   double *a_hihilolo, double *a_lohilolo,
   double *a_hilololo, double *a_lolololo,
   double b );
/*
 * DESCRIPTION : a = a * b.
 *   Inplace multiplication of the hexa double a
 *   with the double b. */

void hdf_div 
 ( double a_hihihihi, double a_lohihihi,
   double a_hilohihi, double a_lolohihi,
   double a_hihilohi, double a_lohilohi,
   double a_hilolohi, double a_lololohi,
   double a_hihihilo, double a_lohihilo,
   double a_hilohilo, double a_lolohilo,
   double a_hihilolo, double a_lohilolo,
   double a_hilololo, double a_lolololo,
   double b_hihihihi, double b_lohihihi,
   double b_hilohihi, double b_lolohihi,
   double b_hihilohi, double b_lohilohi,
   double b_hilolohi, double b_lololohi,
   double b_hihihilo, double b_lohihilo,
   double b_hilohilo, double b_lolohilo,
   double b_hihilolo, double b_lohilolo,
   double b_hilololo, double b_lolololo,
   double *c_hihihihi, double *c_lohihihi,
   double *c_hilohihi, double *c_lolohihi,
   double *c_hihilohi, double *c_lohilohi,
   double *c_hilolohi, double *c_lololohi,
   double *c_hihihilo, double *c_lohihilo,
   double *c_hilohilo, double *c_lolohilo,
   double *c_hihilolo, double *c_lohilolo,
   double *c_hilololo, double *c_lolololo );
/*
 * DESCRIPTION : c = a / b, or in words:
 *   Divides the hexa double a by the hexa double b
 *   to make the hexa double c. */

/************************* square root *********************************/

void hdf_sqrt 
 ( double a_hihihihi, double a_lohihihi,
   double a_hilohihi, double a_lolohihi,
   double a_hihilohi, double a_lohilohi,
   double a_hilolohi, double a_lololohi,
   double a_hihihilo, double a_lohihilo,
   double a_hilohilo, double a_lolohilo,
   double a_hihilolo, double a_lohilolo,
   double a_hilololo, double a_lolololo,
   double *b_hihihihi, double *b_lohihihi,
   double *b_hilohihi, double *b_lolohihi,
   double *b_hihilohi, double *b_lohilohi,
   double *b_hilolohi, double *b_lololohi,
   double *b_hihihilo, double *b_lohihilo,
   double *b_hilohilo, double *b_lolohilo,
   double *b_hihilolo, double *b_lohilolo,
   double *b_hilololo, double *b_lolololo );
/*
 * DESCRIPTION :
 *   Returns in b the square root of a. */

/************************ basic output *********************************/

void hdf_write_doubles 
 ( double a_hihihihi, double a_lohihihi,
   double a_hilohihi, double a_lolohihi,
   double a_hihilohi, double a_lohilohi,
   double a_hilolohi, double a_lololohi,
   double a_hihihilo, double a_lohihilo,
   double a_hilohilo, double a_lolohilo,
   double a_hihilolo, double a_lohilolo,
   double a_hilololo, double a_lolololo );
/*
 * DESCRIPTION :
 *   Writes the doubles in the hexa double number a
 *   in scientific formation with 16 decimal places of precision. */

#endif /* __hexa_double_functions_h__ */
