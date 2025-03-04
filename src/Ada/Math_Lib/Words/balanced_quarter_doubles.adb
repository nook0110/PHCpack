with text_io;                            use text_io;
with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Standard_Natural_Numbers_io;        use Standard_Natural_Numbers_io;
with Standard_Integer_Numbers_io;        use Standard_Integer_Numbers_io;
with Standard_Floating_Numbers_io;       use Standard_Floating_Numbers_io;
with Standard_Random_Numbers;
with Standard_Natural_Vectors;
with Bits_of_Doubles;

package body Balanced_Quarter_Doubles is

  function Thirteen_Random_Bits return integer64 is

    res : integer64 := 1; -- first bit is one
    rnd : integer64;

  begin
    for i in 1..12 loop
      rnd := Standard_Random_Numbers.Random(0,1);
      res := 2*res + rnd;
    end loop;
    return res;
  end Thirteen_Random_Bits;

  function Random_Quarter ( e : in integer32 ) return double_float is

    frc : constant integer64 := Thirteen_Random_Bits;
    mrs : constant double_float := double_float(frc);
    res : constant double_float := double_float'compose(mrs,e);

  begin
    return res;
  end Random_Quarter;

  procedure Random ( x0,x1,x2,x3 : out double_float ) is
  begin
    x0 := Random_Quarter(0);
    x1 := Random_Quarter(-13);
    x2 := Random_Quarter(-26);
    x3 := Random_Quarter(-39);
  end Random;

  function Is_Balanced ( e : integer32; x0,x1,x2,x3 : double_float;
                         verbose : boolean := true ) return boolean is

    res : boolean := true;
    n0,n1,n2,n3 : natural32;
    e0,e1,e2,e3,f0,f1,f2,f3,d0,d1,d2,d3 : integer32;

  begin
   -- number of zero bits at end
    n0 := Bits_of_Doubles.Last_Zero_Count(x0);
    n1 := Bits_of_Doubles.Last_Zero_Count(x1);
    n2 := Bits_of_Doubles.Last_Zero_Count(x2);
    n3 := Bits_of_Doubles.Last_Zero_Count(x3);
    if verbose then
      put("n0 : "); put(n0,1);
      put(", n1 : "); put(n1,1);
      put(", n2 : "); put(n2,1);
      put(", n3 : "); put(n3,1); new_line;
    end if;
   -- exponents of the quarters
    e0 := integer32(double_float'exponent(x0));
    e1 := integer32(double_float'exponent(x1));
    e2 := integer32(double_float'exponent(x2));
    e3 := integer32(double_float'exponent(x3));
    if verbose then
      put("e0 : "); put(e0,1);
      put(", e1 : "); put(e1,1);
      put(", e2 : "); put(e2,1);
      put(", e3 : "); put(e3,1); new_line;
    end if;
   -- freedom number, mind the rounding with x3
    f0 := integer32(n0) + 13 - 52;
    f1 := integer32(n1) + 13 - 52;
    f2 := integer32(n2) + 13 - 52;
    f3 := integer32(n3) + 14 - 52;
    if verbose then
      put("f0 : "); put(f0,1);
      put(", f1 : "); put(f1,1);
      put(", f2 : "); put(f2,1);
      put(", f3 : "); put(f3,1); new_line;
    end if;
   -- deviance of exponent with grid
    d0 := e - e0;
    d1 := e - 13 - e1;
    d2 := e - 26 - e2; 
    d3 := e - 39 - e3;
    if verbose then
      put("d0 : "); put(d0,1);
      put(", d1 : "); put(d1,1);
      put(", d2 : "); put(d2,1);
      put(", d3 : "); put(d3,1); new_line;
    end if;
    res := (d0 <= f0) and (d1 <= f1) and (d2 <= f2) and (d3 <= f3);
    if verbose then
      if res
       then put_line("balanced");
       else put_line("unbalanced");
      end if;
    end if;
    return res;
  end Is_Balanced;

  procedure Split ( x : in double_float;
                    x0,x1,x2,x3,x4 : out double_float;
                    verbose : in boolean := true ) is

    e : constant integer32 := integer32(double_float'exponent(x));
    f : constant double_float := double_float'fraction(x);
    s : constant double_float := double_float'compose(f, 52);
    m : constant integer64 := integer64(double_float'truncation(s));
    xbits : Standard_Natural_Vectors.Vector(0..51);
    wrkbx : Standard_Natural_Vectors.Vector(0..51-e);
    part : constant integer32 := 13;
    valbits : integer64;
    idx,cnt,startidx : integer32;
    tail : boolean := false;

  begin
    if verbose then
      put("The exponent of x : "); put(e,1); new_line;
      put("b : "); put(m,1,b=>2); new_line;
    end if;
    x4 := 0.0;
    if e = 0 then
      if verbose
       then put_line("Quartering the double ...");
      end if;
      Bits_of_Doubles.Split(x,x0,x1,x2,x3); return;
    end if;
    x0 := 0.0; x1 := 0.0; x2 := 0.0; x3 := 0.0;
    if e > 0 then
      if verbose
       then put_line("positive exponent not covered (yet) ...");
      end if;
      return;
    end if;
    if verbose
     then put("xbits'last : "); put(wrkbx'last,1); new_line;
    end if;
    Bits_of_Doubles.expand_52bits(xbits,m);
    if verbose then
      put("x bits : "); Bits_of_Doubles.write_52bits(xbits); new_line;
    end if;
    for i in 0..(-e)-1 loop
      if xbits(xbits'last-i) = 1
       then tail := true;
      end if;
    end loop;
    if tail
     then put_line("x has a tail");
     else put_line("no tail for x");
    end if;
    for i in 0..(-e)-1 loop
      wrkbx(i) := 0;
    end loop;
    for i in (-e)..wrkbx'last loop
      wrkbx(i) := xbits(i+e);
    end loop;
    if verbose then
      put_line("w bits : ");
      for i in 0..(-e)-1 loop
        put(wrkbx(i),1);
      end loop;
      put(" ");
      for i in 0..51 loop
        if i > 0 then
          if i mod 4 = 0
           then put(" ");
          end if;
        end if;
        put(integer32(wrkbx(integer32(i)-e)));
      end loop;
      new_line;
    end if;
    for i in 0..(part-1) loop
      xbits(i) := wrkbx(i);
    end loop;
    for i in part..xbits'last loop
      xbits(i) := 0;
    end loop;
    valbits := Bits_of_Doubles.value_52bits(xbits);
    if verbose then
      put("x0 bits : "); Bits_of_Doubles.write_52bits(xbits); new_line;
      put("b : "); put(valbits,1,b=>2); new_line;
    end if;
    x0 := double_float'compose(double_float(valbits),e);
    if x < 0.0
     then x0 := -x0;
    end if;
    if verbose then
      put(" x : "); put(x); new_line;
      put("x0 : "); put(x0); new_line;
      put("error : "); put(abs(x-x0),2); new_line;
    end if;
    for i in 0..(part-1) loop
      xbits(i) := 0;
    end loop;
    for i in part..(2*part-1) loop
      xbits(i) := wrkbx(i);
    end loop;
    for i in 2*part..xbits'last loop
      xbits(i) := 0;
    end loop;
    valbits := Bits_of_Doubles.value_52bits(xbits);
    if verbose then
      put("x1 bits : "); Bits_of_Doubles.write_52bits(xbits); new_line;
      put("b : "); put(valbits,1,b=>2); new_line;
    end if;
    cnt := 0;
    if valbits /= 0 then
      idx := part;
      while xbits(idx) = 0 loop
        idx := idx + 1;
        cnt := cnt + 1;
      end loop;
    end if;
    if verbose
     then put("leading zero bits : "); put(cnt,1); new_line;
    end if;
    startidx := 2*part;
    if cnt > 0 then
      idx := 2*part-1;
      for i in 1..cnt loop
        if xbits(idx) = 1 then
          xbits(idx) := 0;
          startidx := idx;
          idx := idx - 1;
        end if;
      end loop;
    end if;
    if verbose
     then put("start index for x2 : "); put(startidx,1); new_line;
    end if;
    if startidx /= 2*part then
      valbits := Bits_of_Doubles.value_52bits(xbits);
      if verbose then
        put("x1 bits : "); Bits_of_Doubles.write_52bits(xbits); new_line;
        put("b : "); put(valbits,1,b=>2); new_line;
      end if;
    end if;
    x1 := double_float'compose(double_float(valbits),-part-cnt);
    if x < 0.0
     then x1 := -x1;
    end if;
    if verbose then
      put("x1 : "); put(x1); new_line;
      put("    x : "); put(x); new_line;
      put("x0+x1 : "); put(x0+x1); new_line;
      put("error : "); put(abs(x-(x0+x1)),2); new_line;
    end if;
    for i in 0..(startidx-1) loop
      xbits(i) := 0;
    end loop;
    for i in startidx..startidx+part-1 loop
      xbits(i) := wrkbx(i);
    end loop;
    for i in startidx+part..xbits'last loop
      xbits(i) := 0;
    end loop;
    valbits := Bits_of_Doubles.value_52bits(xbits);
    if verbose then
      put("x2 bits : "); Bits_of_Doubles.write_52bits(xbits); new_line;
      put("b : "); put(valbits,1,b=>2); new_line;
    end if;
    cnt := 0;
    if valbits /= 0 then
      idx := startidx;
      while xbits(idx) = 0 loop
        idx := idx + 1;
        cnt := cnt + 1;
      end loop;
    end if;
    if verbose
     then put("leading zero bits : "); put(cnt,1); new_line;
    end if;
    x2 := double_float'compose(double_float(valbits),-startidx-cnt);
    if x < 0.0
     then x2 := -x2;
    end if;
    if verbose then
      put("x2 : "); put(x2); new_line;
      put("       x : "); put(x); new_line;
      put("x0+x1+x2 : "); put(x0+x1+x2); new_line;
      put("   error : "); put(abs(x-(x0+x1+x2)),2); new_line;
    end if;
    if not tail then
      x3 := x - (x0 + x1 + x2);
    else
      for i in 0..(3*part-1) loop
        xbits(i) := 0;
      end loop;
      for i in 3*part..xbits'last loop
        xbits(i) := wrkbx(i);
      end loop;
      valbits := Bits_of_Doubles.value_52bits(xbits);
      if verbose then
        put("x3 bits : "); Bits_of_Doubles.write_52bits(xbits); new_line;
        put("b : "); put(valbits,1,b=>2); new_line;
      end if;
      cnt := 0;
      if valbits /= 0 then
        idx := 3*part;
        while xbits(idx) = 0 loop
          idx := idx + 1;
          cnt := cnt + 1;
        end loop;
      end if;
      if verbose
       then put("leading zero bits : "); put(cnt,1); new_line;
      end if;
      x3 := double_float'compose(double_float(valbits),-3*part-cnt);
      if x < 0.0
       then x3 := -x3;
      end if;
    end if;
    if verbose then
      put("x3 : "); put(x3); new_line;
      put("          x : "); put(x); new_line;
      put("x0+x1+x2+x3 : "); put(x0+x1+x2+x3); new_line;
      put("      error : "); put(abs(x-(x0+x1+x2+x3)),2); new_line;
    end if;
    if tail then
      x4 := x - (x0 + x1 + x2 + x3);
      put("x4 : "); put(x3); new_line;
      put("             x : "); put(x); new_line;
      put("x0+x1+x2+x3+x4 : "); put(x0+x1+x2+x3+x4); new_line;
      put("         error : "); put(abs(x-(x0+x1+x2+x3+x4)),2); new_line;
    end if;
  end Split;

  procedure Random ( x0,x1,x2,x3,x4,x5,x6,x7 : out double_float ) is
  begin
    Random(x0,x1,x2,x3);
    x4 := Random_Quarter(-52);
    x5 := Random_Quarter(-65);
    x6 := Random_Quarter(-78);
    x7 := Random_Quarter(-91);
  end Random;

  procedure Random ( x0,x1,x2,x3,x4,x5,x6,x7 : out double_float;
                     x8,x9,xA,xB,xC,xD,xE,xF : out double_float ) is
  begin
    Random(x0,x1,x2,x3,x4,x5,x6,x7);
    x8 := Random_Quarter(-104);
    x9 := Random_Quarter(-117);
    xA := Random_Quarter(-130);
    xB := Random_Quarter(-143);
    xC := Random_Quarter(-156);
    xD := Random_Quarter(-169);
    xE := Random_Quarter(-182);
    xF := Random_Quarter(-195);
  end Random;

  procedure Random ( x00,x01,x02,x03,x04,x05,x06,x07 : out double_float;
                     x08,x09,x10,x11,x12,x13,x14,x15 : out double_float;
                     x16,x17,x18,x19,x20,x21,x22,x23 : out double_float;
                     x24,x25,x26,x27,x28,x29,x30,x31 : out double_float ) is
  begin
    Random(x00,x01,x02,x03,x04,x05,x06,x07,x08,x09,x10,x11,x12,x13,x14,x15);
    x16 := Random_Quarter(-208);
    x17 := Random_Quarter(-221);
    x18 := Random_Quarter(-234);
    x19 := Random_Quarter(-247);
    x20 := Random_Quarter(-260);
    x21 := Random_Quarter(-273);
    x22 := Random_Quarter(-286);
    x23 := Random_Quarter(-299);
    x24 := Random_Quarter(-312);
    x25 := Random_Quarter(-325);
    x26 := Random_Quarter(-338);
    x27 := Random_Quarter(-351);
    x28 := Random_Quarter(-364);
    x29 := Random_Quarter(-377);
    x30 := Random_Quarter(-390);
    x31 := Random_Quarter(-403);
  end Random;

  procedure Random ( x00,x01,x02,x03,x04,x05,x06,x07 : out double_float;
                     x08,x09,x10,x11,x12,x13,x14,x15 : out double_float;
                     x16,x17,x18,x19,x20,x21,x22,x23 : out double_float;
                     x24,x25,x26,x27,x28,x29,x30,x31 : out double_float;
                     x32,x33,x34,x35,x36,x37,x38,x39 : out double_float;
                     x40,x41,x42,x43,x44,x45,x46,x47 : out double_float;
                     x48,x49,x50,x51,x52,x53,x54,x55 : out double_float;
                     x56,x57,x58,x59,x60,x61,x62,x63 : out double_float ) is
  begin
    Random(x00,x01,x02,x03,x04,x05,x06,x07,x08,x09,x10,x11,x12,x13,x14,x15,
           x16,x17,x18,x19,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31);
    x32 := Random_Quarter(-416);
    x33 := Random_Quarter(-429);
    x34 := Random_Quarter(-442);
    x35 := Random_Quarter(-455);
    x36 := Random_Quarter(-468);
    x37 := Random_Quarter(-481);
    x38 := Random_Quarter(-494);
    x39 := Random_Quarter(-507);
    x40 := Random_Quarter(-520);
    x41 := Random_Quarter(-533);
    x42 := Random_Quarter(-546);
    x43 := Random_Quarter(-559);
    x44 := Random_Quarter(-572);
    x45 := Random_Quarter(-585);
    x46 := Random_Quarter(-598);
    x47 := Random_Quarter(-611);
    x48 := Random_Quarter(-624);
    x49 := Random_Quarter(-637);
    x50 := Random_Quarter(-650);
    x51 := Random_Quarter(-663);
    x52 := Random_Quarter(-676);
    x53 := Random_Quarter(-689);
    x54 := Random_Quarter(-702);
    x55 := Random_Quarter(-715);
    x56 := Random_Quarter(-728);
    x57 := Random_Quarter(-741);
    x58 := Random_Quarter(-754);
    x59 := Random_Quarter(-767);
    x60 := Random_Quarter(-780);
    x61 := Random_Quarter(-793);
    x62 := Random_Quarter(-806);
    x63 := Random_Quarter(-819);
  end Random;

  procedure Random ( dim : in integer32;
                     x0,x1,x2,x3 : out Standard_Floating_Vectors.Vector ) is
  begin
    for i in 1..dim loop
      Random(x0(i),x1(i),x2(i),x3(i));
    end loop;
  end Random;

  procedure Random ( dim : in integer32;
                     x0,x1,x2,x3 : out Standard_Floating_Vectors.Vector;
                     x4,x5,x6,x7 : out Standard_Floating_Vectors.Vector ) is
  begin
    for i in 1..dim loop
      Random(x0(i),x1(i),x2(i),x3(i),x4(i),x5(i),x6(i),x7(i));
    end loop;
  end Random;

  procedure Random ( dim : in integer32;
                     x0,x1,x2,x3 : out Standard_Floating_Vectors.Vector;
                     x4,x5,x6,x7 : out Standard_Floating_Vectors.Vector;
                     x8,x9,xA,xB : out Standard_Floating_Vectors.Vector;
                     xC,xD,xE,xF : out Standard_Floating_Vectors.Vector ) is
  begin
    for i in 1..dim loop
      Random(x0(i),x1(i),x2(i),x3(i),x4(i),x5(i),x6(i),x7(i),
             x8(i),x9(i),xA(i),xB(i),xC(i),xD(i),xE(i),xF(i));
    end loop;
  end Random;

  procedure Random ( dim : in integer32;
                     x00,x01,x02,x03 : out Standard_Floating_Vectors.Vector;
                     x04,x05,x06,x07 : out Standard_Floating_Vectors.Vector;
                     x08,x09,x10,x11 : out Standard_Floating_Vectors.Vector;
                     x12,x13,x14,x15 : out Standard_Floating_Vectors.Vector;
                     x16,x17,x18,x19 : out Standard_Floating_Vectors.Vector;
                     x20,x21,x22,x23 : out Standard_Floating_Vectors.Vector;
                     x24,x25,x26,x27 : out Standard_Floating_Vectors.Vector;
                     x28,x29,x30,x31 : out Standard_Floating_Vectors.Vector ) is
  begin
    for i in 1..dim loop
      Random(x00(i),x01(i),x02(i),x03(i),x04(i),x05(i),x06(i),x07(i),
             x08(i),x09(i),x10(i),x11(i),x12(i),x13(i),x14(i),x15(i),
             x16(i),x17(i),x18(i),x19(i),x20(i),x21(i),x22(i),x23(i),
             x24(i),x25(i),x26(i),x27(i),x28(i),x29(i),x30(i),x31(i));
    end loop;
  end Random;

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
                     x60,x61,x62,x63 : out Standard_Floating_Vectors.Vector ) is
  begin
    for i in 1..dim loop
      Random(x00(i),x01(i),x02(i),x03(i),x04(i),x05(i),x06(i),x07(i),
             x08(i),x09(i),x10(i),x11(i),x12(i),x13(i),x14(i),x15(i),
             x16(i),x17(i),x18(i),x19(i),x20(i),x21(i),x22(i),x23(i),
             x24(i),x25(i),x26(i),x27(i),x28(i),x29(i),x30(i),x31(i),
             x32(i),x33(i),x34(i),x35(i),x36(i),x37(i),x38(i),x39(i),
             x40(i),x41(i),x42(i),x43(i),x44(i),x45(i),x46(i),x47(i),
             x48(i),x49(i),x50(i),x51(i),x52(i),x53(i),x54(i),x55(i),
             x56(i),x57(i),x58(i),x59(i),x60(i),x61(i),x62(i),x63(i));
    end loop;
  end Random;

  function Make_Double ( r0,r1,r2,r3 : double_float ) return double_float is
  begin
    return ((r3 + r2) + r1) + r0;
  end Make_Double;

  function Make_Double_Double
             ( r0,r1,r2,r3,r4,r5,r6,r7 : double_float )
             return double_double is

    res,reshi,reslo : double_double;

  begin
    reshi := ((Double_Double_Numbers.create(r3) + r2) + r1) + r0;
    reslo := ((Double_Double_Numbers.create(r7) + r6) + r5) + r4;
    res := reshi + reslo;
    return res;
  end Make_Double_Double;

  function Make_Quad_Double
             ( r0,r1,r2,r3,r4,r5,r6,r7 : double_float;
               r8,r9,rA,rB,rC,rD,rE,rF : double_float )
             return quad_double is

    res,reshihi,reslohi,reshilo,reslolo : quad_double;

  begin
    reshihi := ((Quad_Double_Numbers.create(r3) + r2) + r1) + r0;
    reslohi := ((Quad_Double_Numbers.create(r7) + r6) + r5) + r4;
    reshilo := ((Quad_Double_Numbers.create(rB) + rA) + r9) + r8;
    reslolo := ((Quad_Double_Numbers.create(rF) + rE) + rD) + rC;
    res := reshihi + reslohi + reshilo + reslolo;
    return res;
  end Make_Quad_Double;

  function Make_Octo_Double
             ( r00,r01,r02,r03,r04,r05,r06,r07 : double_float;
               r08,r09,r10,r11,r12,r13,r14,r15 : double_float;
               r16,r17,r18,r19,r20,r21,r22,r23 : double_float;
               r24,r25,r26,r27,r28,r29,r30,r31 : double_float )
             return octo_double is

    res : octo_double;
    reshihihi,reslohihi,reshilohi,reslolohi : octo_double;
    reshihilo,reslohilo,reshilolo,reslololo : octo_double;

  begin
    reshihihi := ((Octo_Double_Numbers.create(r03) + r02) + r01) + r00;
    reslohihi := ((Octo_Double_Numbers.create(r07) + r06) + r05) + r04;
    reshilohi := ((Octo_Double_Numbers.create(r11) + r10) + r09) + r08;
    reslolohi := ((Octo_Double_Numbers.create(r15) + r14) + r13) + r12;
    reshihilo := ((Octo_Double_Numbers.create(r19) + r18) + r17) + r16;
    reslohilo := ((Octo_Double_Numbers.create(r23) + r22) + r21) + r20;
    reshilolo := ((Octo_Double_Numbers.create(r27) + r26) + r25) + r24;
    reslololo := ((Octo_Double_Numbers.create(r31) + r30) + r29) + r28;
    res := reshihihi + reslohihi + reshilohi + reslolohi
         + reshihilo + reslohilo + reshilolo + reslololo;
    return res;
  end Make_Octo_Double;

  function Make_Hexa_Double
             ( r00,r01,r02,r03,r04,r05,r06,r07 : double_float;
               r08,r09,r10,r11,r12,r13,r14,r15 : double_float;
               r16,r17,r18,r19,r20,r21,r22,r23 : double_float;
               r24,r25,r26,r27,r28,r29,r30,r31 : double_float;
               r32,r33,r34,r35,r36,r37,r38,r39 : double_float;
               r40,r41,r42,r43,r44,r45,r46,r47 : double_float;
               r48,r49,r50,r51,r52,r53,r54,r55 : double_float;
               r56,r57,r58,r59,r60,r61,r62,r63 : double_float )
             return hexa_double is

    res : hexa_double;
    reshihihihi,reslohihihi,reshilohihi,reslolohihi : hexa_double;
    reshihilohi,reslohilohi,reshilolohi,reslololohi : hexa_double;
    reshihihilo,reslohihilo,reshilohilo,reslolohilo : hexa_double;
    reshihilolo,reslohilolo,reshilololo,reslolololo : hexa_double;

  begin
    reshihihihi := ((Hexa_Double_Numbers.create(r03) + r02) + r01) + r00;
    reslohihihi := ((Hexa_Double_Numbers.create(r07) + r06) + r05) + r04;
    reshilohihi := ((Hexa_Double_Numbers.create(r11) + r10) + r09) + r08;
    reslolohihi := ((Hexa_Double_Numbers.create(r15) + r14) + r13) + r12;
    reshihilohi := ((Hexa_Double_Numbers.create(r19) + r18) + r17) + r16;
    reslohilohi := ((Hexa_Double_Numbers.create(r23) + r22) + r21) + r20;
    reshilolohi := ((Hexa_Double_Numbers.create(r27) + r26) + r25) + r24;
    reslololohi := ((Hexa_Double_Numbers.create(r31) + r30) + r29) + r28;
    reshihihilo := ((Hexa_Double_Numbers.create(r35) + r34) + r33) + r32;
    reslohihilo := ((Hexa_Double_Numbers.create(r39) + r38) + r37) + r36;
    reshilohilo := ((Hexa_Double_Numbers.create(r43) + r42) + r41) + r40;
    reslolohilo := ((Hexa_Double_Numbers.create(r47) + r46) + r45) + r44;
    reshihilolo := ((Hexa_Double_Numbers.create(r51) + r50) + r49) + r48;
    reslohilolo := ((Hexa_Double_Numbers.create(r55) + r54) + r53) + r52;
    reshilololo := ((Hexa_Double_Numbers.create(r59) + r58) + r57) + r56;
    reslolololo := ((Hexa_Double_Numbers.create(r63) + r62) + r61) + r60;
    res := reshihihihi + reslohihihi + reshilohihi + reslolohihi
         + reshihilohi + reslohilohi + reshilolohi + reslololohi
         + reshihihilo + reslohihilo + reshilohilo + reslolohilo
         + reshihilolo + reslohilolo + reshilololo + reslolololo;
    return res;
  end Make_Hexa_Double;

  function Make_Doubles
             ( x0,x1,x2,x3 : Standard_Floating_Vectors.Vector )
             return Standard_Floating_Vectors.Vector is

    res : Standard_Floating_Vectors.Vector(x0'range);

  begin
    for i in x0'range loop
      res(i) := Make_Double(x0(i),x1(i),x2(i),x3(i));
    end loop;
    return res;
  end Make_Doubles;

  function Make_Double_Doubles
             ( x0,x1,x2,x3 : Standard_Floating_Vectors.Vector;
               x4,x5,x6,x7 : Standard_Floating_Vectors.Vector )
             return Double_Double_Vectors.Vector is

    res : Double_Double_Vectors.Vector(x0'range);

  begin
    for i in x0'range loop
      res(i) := Make_Double_Double
                  (x0(i),x1(i),x2(i),x3(i),x4(i),x5(i),x6(i),x7(i));
    end loop;
    return res;
  end Make_Double_Doubles;

  function Make_Quad_Doubles
             ( x0,x1,x2,x3 : Standard_Floating_Vectors.Vector;
               x4,x5,x6,x7 : Standard_Floating_Vectors.Vector;
               x8,x9,xA,xB : Standard_Floating_Vectors.Vector;
               xC,xD,xE,xF : Standard_Floating_Vectors.Vector )
             return Quad_Double_Vectors.Vector is

    res : Quad_Double_Vectors.Vector(x0'range);

  begin
    for i in x0'range loop
      res(i) := Make_Quad_Double
                  (x0(i),x1(i),x2(i),x3(i),x4(i),x5(i),x6(i),x7(i),
                   x8(i),x9(i),xA(i),xB(i),xC(i),xD(i),xE(i),xF(i));
    end loop;
    return res;
  end Make_Quad_Doubles;

  function Make_Octo_Doubles
             ( x00,x01,x02,x03 : Standard_Floating_Vectors.Vector;
               x04,x05,x06,x07 : Standard_Floating_Vectors.Vector;
               x08,x09,x10,x11 : Standard_Floating_Vectors.Vector;
               x12,x13,x14,x15 : Standard_Floating_Vectors.Vector;
               x16,x17,x18,x19 : Standard_Floating_Vectors.Vector;
               x20,x21,x22,x23 : Standard_Floating_Vectors.Vector;
               x24,x25,x26,x27 : Standard_Floating_Vectors.Vector;
               x28,x29,x30,x31 : Standard_Floating_Vectors.Vector )
             return Octo_Double_Vectors.Vector is

    res : Octo_Double_Vectors.Vector(x00'range);

  begin
    for i in x00'range loop
      res(i) := Make_Octo_Double
                  (x00(i),x01(i),x02(i),x03(i),x04(i),x05(i),x06(i),x07(i),
                   x08(i),x09(i),x10(i),x11(i),x12(i),x13(i),x14(i),x15(i),
                   x16(i),x17(i),x18(i),x19(i),x20(i),x21(i),x22(i),x23(i),
                   x24(i),x25(i),x26(i),x27(i),x28(i),x29(i),x30(i),x31(i));
    end loop;
    return res;
  end Make_Octo_Doubles;

  function Make_Hexa_Doubles
             ( x00,x01,x02,x03 : Standard_Floating_Vectors.Vector;
               x04,x05,x06,x07 : Standard_Floating_Vectors.Vector;
               x08,x09,x10,x11 : Standard_Floating_Vectors.Vector;
               x12,x13,x14,x15 : Standard_Floating_Vectors.Vector;
               x16,x17,x18,x19 : Standard_Floating_Vectors.Vector;
               x20,x21,x22,x23 : Standard_Floating_Vectors.Vector;
               x24,x25,x26,x27 : Standard_Floating_Vectors.Vector;
               x28,x29,x30,x31 : Standard_Floating_Vectors.Vector;
               x32,x33,x34,x35 : Standard_Floating_Vectors.Vector;
               x36,x37,x38,x39 : Standard_Floating_Vectors.Vector;
               x40,x41,x42,x43 : Standard_Floating_Vectors.Vector;
               x44,x45,x46,x47 : Standard_Floating_Vectors.Vector;
               x48,x49,x50,x51 : Standard_Floating_Vectors.Vector;
               x52,x53,x54,x55 : Standard_Floating_Vectors.Vector;
               x56,x57,x58,x59 : Standard_Floating_Vectors.Vector;
               x60,x61,x62,x63 : Standard_Floating_Vectors.Vector )
             return Hexa_Double_Vectors.Vector is

    res : Hexa_Double_Vectors.Vector(x00'range);

  begin
    for i in x00'range loop
      res(i) := Make_Hexa_Double
                  (x00(i),x01(i),x02(i),x03(i),x04(i),x05(i),x06(i),x07(i),
                   x08(i),x09(i),x10(i),x11(i),x12(i),x13(i),x14(i),x15(i),
                   x16(i),x17(i),x18(i),x19(i),x20(i),x21(i),x22(i),x23(i),
                   x24(i),x25(i),x26(i),x27(i),x28(i),x29(i),x30(i),x31(i),
                   x32(i),x33(i),x34(i),x35(i),x36(i),x37(i),x38(i),x39(i),
                   x40(i),x41(i),x42(i),x43(i),x44(i),x45(i),x46(i),x47(i),
                   x48(i),x49(i),x50(i),x51(i),x52(i),x53(i),x54(i),x55(i),
                   x56(i),x57(i),x58(i),x59(i),x60(i),x61(i),x62(i),x63(i));
    end loop;
    return res;
  end Make_Hexa_Doubles;

-- WRAPPERS :

  function Random return double_float is

    r0,r1,r2,r3 : double_float;

  begin
    Random(r0,r1,r2,r3);
    return Make_Double(r0,r1,r2,r3);
  end Random;

  function Random return double_double is

    r0,r1,r2,r3,r4,r5,r6,r7 : double_float;

  begin
    Random(r0,r1,r2,r3,r4,r5,r6,r7);
    return Make_Double_Double(r0,r1,r2,r3,r4,r5,r6,r7);
  end Random;

  function Random return quad_double is

    r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,rA,rB,rC,rD,rE,rF : double_float;

  begin
    Random(r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,rA,rB,rC,rD,rE,rF);
    return Make_Quad_Double(r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,rA,rB,rC,rD,rE,rF);
  end Random;

  function Random return octo_double is

    r00,r01,r02,r03,r04,r05,r06,r07 : double_float;
    r08,r09,r10,r11,r12,r13,r14,r15 : double_float;
    r16,r17,r18,r19,r20,r21,r22,r23 : double_float;
    r24,r25,r26,r27,r28,r29,r30,r31 : double_float;

  begin
    Random(r00,r01,r02,r03,r04,r05,r06,r07,r08,r09,r10,r11,r12,r13,r14,r15,
           r16,r17,r18,r19,r20,r21,r22,r23,r24,r25,r26,r27,r28,r29,r30,r31);
    return Make_Octo_Double
             (r00,r01,r02,r03,r04,r05,r06,r07,r08,r09,r10,r11,r12,r13,r14,r15,
              r16,r17,r18,r19,r20,r21,r22,r23,r24,r25,r26,r27,r28,r29,r30,r31);
  end Random;

  function Random return hexa_double is

    r00,r01,r02,r03,r04,r05,r06,r07 : double_float;
    r08,r09,r10,r11,r12,r13,r14,r15 : double_float;
    r16,r17,r18,r19,r20,r21,r22,r23 : double_float;
    r24,r25,r26,r27,r28,r29,r30,r31 : double_float;
    r32,r33,r34,r35,r36,r37,r38,r39 : double_float;
    r40,r41,r42,r43,r44,r45,r46,r47 : double_float;
    r48,r49,r50,r51,r52,r53,r54,r55 : double_float;
    r56,r57,r58,r59,r60,r61,r62,r63 : double_float;

  begin
    Random(r00,r01,r02,r03,r04,r05,r06,r07,r08,r09,r10,r11,r12,r13,r14,r15,
           r16,r17,r18,r19,r20,r21,r22,r23,r24,r25,r26,r27,r28,r29,r30,r31,
           r32,r33,r34,r35,r36,r37,r38,r39,r40,r41,r42,r43,r44,r45,r46,r47,
           r48,r49,r50,r51,r52,r53,r54,r55,r56,r57,r58,r59,r60,r61,r62,r63);
    return Make_Hexa_Double
             (r00,r01,r02,r03,r04,r05,r06,r07,r08,r09,r10,r11,r12,r13,r14,r15,
              r16,r17,r18,r19,r20,r21,r22,r23,r24,r25,r26,r27,r28,r29,r30,r31,
              r32,r33,r34,r35,r36,r37,r38,r39,r40,r41,r42,r43,r44,r45,r46,r47,
              r48,r49,r50,r51,r52,r53,r54,r55,r56,r57,r58,r59,r60,r61,r62,r63);
  end Random;

  function Random 
             ( dim : integer32 ) return Standard_Floating_Vectors.Vector is

    res : Standard_Floating_Vectors.Vector(1..dim);

  begin
    for i in 1..dim loop
      res(i) := Random;
    end loop;
    return res;
  end Random;

  function Random ( dim : integer32 ) return Double_Double_Vectors.Vector is

    res : Double_Double_Vectors.Vector(1..dim);

  begin
    for i in 1..dim loop
      res(i) := Random;
    end loop;
    return res;
  end Random;

  function Random ( dim : integer32 ) return Quad_Double_Vectors.Vector is

    res : Quad_Double_Vectors.Vector(1..dim);

  begin
    for i in 1..dim loop
      res(i) := Random;
    end loop;
    return res;
  end Random;

  function Random ( dim : integer32 ) return Octo_Double_Vectors.Vector is

    res : Octo_Double_Vectors.Vector(1..dim);

  begin
    for i in 1..dim loop
      res(i) := Random;
    end loop;
    return res;
  end Random;

  function Random ( dim : integer32 ) return Hexa_Double_Vectors.Vector is

    res : Hexa_Double_Vectors.Vector(1..dim);

  begin
    for i in 1..dim loop
      res(i) := Random;
    end loop;
    return res;
  end Random;

end Balanced_Quarter_Doubles;
