with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Floating_Numbers;          use Standard_Floating_Numbers;
with Standard_Floating_Vectors;
with Double_Double_Numbers;              use Double_Double_Numbers;
with Quad_Double_Numbers;                use Quad_Double_Numbers;
with Octo_Double_Numbers;                use Octo_Double_Numbers;
with Hexa_Double_Numbers;                use Hexa_Double_Numbers;
with Double_Double_Vectors;
with Quad_Double_Vectors;
with Octo_Double_Vectors;
with Hexa_Double_Vectors;

package Balanced_Quarter_Doubles is

-- DESCRIPTION :
--   A double is quarter balanced is its quarters are sign balanced
--   (that is: all doubles have the same sign as the leading quarter)
--   and the exponents of the quarters are 0, -4, -8, -12.

  function Thirteen_Random_Bits return integer64;

  -- DESCRIPTION :
  --   Returns a thirteen bit number, of the format 1 bbbb bbbb bbbb,
  --   starting at 1 and 0 or 1 for every 'b' in the format.

  function Random_Quarter ( e : in integer32 ) return double_float;

  -- DESCRIPTION :
  --   Returns a random double where the fraction is generated by
  --   Thirteen_Random_Bits and with exponent e.

  procedure Random ( x0,x1,x2,x3 : out double_float );

  -- DESCRIPTION :
  --   Makes a random balanced quarter double.

  procedure Random ( x0,x1,x2,x3,x4,x5,x6,x7 : out double_float );

  -- DESCRIPTION :
  --   Makes a random balanced quarter double double.

  procedure Random ( x0,x1,x2,x3,x4,x5,x6,x7 : out double_float;
                     x8,x9,xA,xB,xC,xD,xE,xF : out double_float );

  -- DESCRIPTION :
  --   Makes a random balanced quarter quad double.

  procedure Random ( x00,x01,x02,x03,x04,x05,x06,x07 : out double_float;
                     x08,x09,x10,x11,x12,x13,x14,x15 : out double_float;
                     x16,x17,x18,x19,x20,x21,x22,x23 : out double_float;
                     x24,x25,x26,x27,x28,x29,x30,x31 : out double_float );

  -- DESCRIPTION :
  --   Makes a random balanced quarter octo double.

  procedure Random ( x00,x01,x02,x03,x04,x05,x06,x07 : out double_float;
                     x08,x09,x10,x11,x12,x13,x14,x15 : out double_float;
                     x16,x17,x18,x19,x20,x21,x22,x23 : out double_float;
                     x24,x25,x26,x27,x28,x29,x30,x31 : out double_float;
                     x32,x33,x34,x35,x36,x37,x38,x39 : out double_float;
                     x40,x41,x42,x43,x44,x45,x46,x47 : out double_float;
                     x48,x49,x50,x51,x52,x53,x54,x55 : out double_float;
                     x56,x57,x58,x59,x60,x61,x62,x63 : out double_float ); 

  -- DESCRIPTION :
  --   Makes a random balanced quarter hexa double.

  procedure Random ( dim : in integer32;
                     x0,x1,x2,x3 : out Standard_Floating_Vectors.Vector );
  procedure Random ( dim : in integer32;
                     x0,x1,x2,x3 : out Standard_Floating_Vectors.Vector;
                     x4,x5,x6,x7 : out Standard_Floating_Vectors.Vector );
  procedure Random ( dim : in integer32;
                     x0,x1,x2,x3 : out Standard_Floating_Vectors.Vector;
                     x4,x5,x6,x7 : out Standard_Floating_Vectors.Vector;
                     x8,x9,xA,xB : out Standard_Floating_Vectors.Vector;
                     xC,xD,xE,xF : out Standard_Floating_Vectors.Vector );
  procedure Random ( dim : in integer32;
                     x00,x01,x02,x03 : out Standard_Floating_Vectors.Vector;
                     x04,x05,x06,x07 : out Standard_Floating_Vectors.Vector;
                     x08,x09,x10,x11 : out Standard_Floating_Vectors.Vector;
                     x12,x13,x14,x15 : out Standard_Floating_Vectors.Vector;
                     x16,x17,x18,x19 : out Standard_Floating_Vectors.Vector;
                     x20,x21,x22,x23 : out Standard_Floating_Vectors.Vector;
                     x24,x25,x26,x27 : out Standard_Floating_Vectors.Vector;
                     x28,x29,x30,x31 : out Standard_Floating_Vectors.Vector );
  procedure Random ( dim : in integer32;
                     x00,x01,x02,x03 : out Standard_Floating_Vectors.Vector;
                     x04,x05,x06,x07 : out Standard_Floating_Vectors.Vector;
                     x08,x09,x10,x11 : out Standard_Floating_Vectors.Vector;
                     x12,x13,x14,x15 : out Standard_Floating_Vectors.Vector;
                     x16,x17,x18,x19 : out Standard_Floating_Vectors.Vector;
                     x20,x21,x22,x23 : out Standard_Floating_Vectors.Vector;
                     x24,x25,x26,x27 : out Standard_Floating_Vectors.Vector;
                     x28,x29,x30,x31 : out Standard_Floating_Vectors.Vector;
                     x32,x33,x34,x35 : out Standard_Floating_Vectors.Vector;
                     x36,x37,x38,x39 : out Standard_Floating_Vectors.Vector;
                     x40,x41,x42,x43 : out Standard_Floating_Vectors.Vector;
                     x44,x45,x46,x47 : out Standard_Floating_Vectors.Vector;
                     x48,x49,x50,x51 : out Standard_Floating_Vectors.Vector;
                     x52,x53,x54,x55 : out Standard_Floating_Vectors.Vector;
                     x56,x57,x58,x59 : out Standard_Floating_Vectors.Vector;
                     x60,x61,x62,x63 : out Standard_Floating_Vectors.Vector );

  -- DESCRIPTION :
  --   Makes vectors of random balanced quarter doubles.

  -- REQUIRED :
  --   The range of all vectors includes 1..dim.

-- WRAPPERS :

  function Random return double_float;
  function Random return double_double;
  function Random return quad_double;
  function Random return octo_double;
  function Random return hexa_double;

  -- DESCRIPTION :
  --   Returns a random double, double double, quad double,
  --   octo double, and hexa double summing the doubles of
  --   a random balanced quarter double.

  function Random ( dim : integer32 ) return Standard_Floating_Vectors.Vector;
  function Random ( dim : integer32 ) return Double_Double_Vectors.Vector;
  function Random ( dim : integer32 ) return Quad_Double_Vectors.Vector;
  function Random ( dim : integer32 ) return Octo_Double_Vectors.Vector;
  function Random ( dim : integer32 ) return Hexa_Double_Vectors.Vector;

  -- DESCRIPTION :
  --   Returns a vector of range 1..dim of random balanced quarters.

end Balanced_Quarter_Doubles;
