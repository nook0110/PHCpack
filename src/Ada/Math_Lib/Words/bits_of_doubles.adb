with text_io;                            use text_io;
with Standard_Integer_Numbers_io;        use Standard_Integer_Numbers_io;
with Standard_Floating_Numbers_io;       use Standard_Floating_Numbers_io;
with Mask_Bits_of_Doubles;

package body Bits_of_Doubles is

  procedure expand_52bits
              ( bits : out Standard_Natural_Vectors.Vector;
                nbr : in integer64 ) is

    temp : integer64 := nbr;
    idx : integer32;

  begin
    for i in 0..51 loop
      idx := integer32(51 - i);
      bits(idx) := natural32(temp mod 2);
      temp := temp/2;
    end loop;
  end expand_52bits;

  procedure write_52bits
              ( bits : in Standard_Natural_Vectors.Vector ) is

  begin
    for i in 0..51 loop
      if i > 0 then
        if i mod 4 = 0
         then put(" ");
        end if;
      end if;
      put(integer32(bits(integer32(i))));
    end loop;
  end write_52bits;

  procedure Fraction_Exponent
              ( x : in double_float;
                f : out integer64; e : out integer32 ) is

    r : constant double_float := double_float'fraction(x);
    s : constant double_float := double_float'compose(r, 52);

  begin
    e := integer32(double_float'exponent(x));
    f := integer64(double_float'truncation(s));
  end Fraction_Exponent;

  procedure write_52bits_expo ( x : in double_float ) is

    e : integer32;
    m : integer64;
    b : Standard_Natural_Vectors.Vector(0..51);

  begin
    Fraction_Exponent(x,m,e);
    expand_52bits(b,m);
    if x < 0.0
     then put("-");
     else put("+");
    end if;
    write_52bits(b);
    put(", "); put(e,1);
  end write_52bits_expo;

  function Bit_Equal ( x,y : double_float ) return boolean is

    ex,ey : integer32;
    mx,my : integer64;

  begin
    if x < 0.0 and y > 0.0 then
      return false;
    elsif x > 0.0 and y < 0.0 then
      return false;
    else
      Fraction_Exponent(x,mx,ex);
      Fraction_Exponent(y,my,ey);
      if ex /= ey then
        return false;
      else
        return mx = my;
      end if;
    end if;
  end Bit_Equal;

  procedure write_fraction_bits ( nbr : in double_float ) is

    e : integer32;
    mfr : integer64;

  begin
    Fraction_Exponent(nbr,mfr,e);
    put(mfr,1,b=>2); new_line;
  end write_fraction_bits;

  function value_52bits
             ( bits : Standard_Natural_Vectors.Vector ) return integer64 is

    result : integer64 := 0;
 
  begin
    for i in 0..51 loop
      result := 2*result + integer64(bits(integer32(i)));
    end loop;
    return result;
  end value_52bits;

  function chop_last_bits
             ( nbr : double_float; lastbits : natural32 )
             return double_float is

    frc : constant double_float := double_float'fraction(nbr);
    exn : constant integer32 := integer32(double_float'exponent(nbr));
    sfr : constant double_float := double_float'compose(frc, 52);
    mfr : constant integer64 := integer64(double_float'truncation(sfr));
    bits : Standard_Natural_Vectors.Vector(0..51);
    value : integer64;

  begin
    expand_52bits(bits,mfr);
    for i in 0..(lastbits-1) loop
      bits(integer32(51-i)) := 0;
    end loop;
    value := value_52bits(bits);
    return double_float'compose(double_float(value), exn);
  end chop_last_bits;

  procedure chop_last_bits
             ( nbr : in out double_float; lastbits : in natural32;
               headbits : out Standard_Natural_Vectors.Vector;
               tailbits : out Standard_Natural_Vectors.Vector ) is

    frc : constant double_float := double_float'fraction(nbr);
    exn : constant integer32 := integer32(double_float'exponent(nbr));
    sfr : constant double_float := double_float'compose(frc, 52);
    mfr : constant integer64 := integer64(double_float'truncation(sfr));
    value : integer64;

  begin
    expand_52bits(headbits,mfr);
    for i in 0..51-lastbits loop
      tailbits(integer32(i)) := 0;
    end loop;
    for i in 0..(lastbits-1) loop
      tailbits(integer32(51-i)) := headbits(integer32(51-i));
      headbits(integer32(51-i)) := 0;
    end loop;
    value := value_52bits(headbits);
    nbr := double_float'compose(double_float(value), exn);
  end chop_last_bits;

  procedure insert_first_bits
              ( bits : in out Standard_Natural_Vectors.Vector;
                firstbits : in natural32;
                headbits : in Standard_Natural_Vectors.Vector ) is
  begin
    for i in 0..firstbits-1 loop
      bits(integer32(51-i)) := bits(integer32(51-i-firstbits));
      bits(integer32(51-i-firstbits)) := 0;
    end loop;
    for i in 0..firstbits-1 loop
      bits(integer32(i)) := headbits(integer32(i));
    end loop;
  end insert_first_bits;

  procedure insert_first_bits
              ( nbr : in out double_float;
                firstbits : in natural32;
                headbits : in Standard_Natural_Vectors.Vector ) is

    fnbr : constant double_float := double_float'fraction(nbr);
    enbr : constant integer32 := integer32(double_float'exponent(nbr));
    snbr : constant double_float := double_float'compose(fnbr, 52);
    mnbr : constant integer64 := integer64(double_float'truncation(snbr));
    bits : Standard_Natural_Vectors.Vector(0..51);
    value : integer64;
    ifirst : constant integer32 := integer32(firstbits);

  begin
    expand_52bits(bits, mnbr);
    insert_first_bits(bits, firstbits, headbits);
    value := value_52bits(bits);
    nbr := double_float'compose(double_float(value), enbr + ifirst);
  end insert_first_bits;

  function insert_first_bits
             ( nbr : double_float;
               firstbits : natural32;
               headbits : Standard_Natural_Vectors.Vector )
             return double_float is

    res : double_float := nbr;
  
  begin
    insert_first_bits(res,firstbits,headbits);
    return res;
  end insert_first_bits;

  procedure Mod_Split ( x : in double_float;
                        xhi,xlo : out double_float ) is

    e : constant integer32 := integer32(double_float'exponent(x));
    f : constant double_float := double_float'fraction(x);
    s : constant double_float := double_float'compose(f, 52);
    m : constant integer64 := integer64(double_float'truncation(s));
    mlast,mchop : integer64;
    cnt : integer32 := 0;

  begin
    mlast := Mask_Bits_of_Doubles.last_bits(m,26);
    mchop := m - mlast;
    put("m     : "); put(m,1,b=>2); new_line;
    put("mchop : "); put(mchop,1,b=>2); new_line;
    xhi := double_float'compose(double_float(mchop),e);
    if mlast /= 0 then
      while mlast < 2**natural(25-cnt) loop
        cnt := cnt + 1;
      end loop;
      put("mlast : "); put(mlast,1,b=>2); new_line;
      put("cnt : "); put(cnt,1); new_line;
    end if;
    xlo := double_float'compose(double_float(mlast),e-26-cnt);
  end Mod_Split;

  procedure Vec_Split ( x : in double_float;
                        xhi,xlo : out double_float ) is

    head,tail : Standard_Natural_Vectors.Vector(0..51);
    val : integer64;
    expo : constant integer32 := integer32(double_float'exponent(x));
    cnt : integer32 := 0;

  begin
    xhi := x;
    chop_last_bits(xhi,26,head,tail);
    val := value_52bits(tail);
    if val /= 0 then
      while tail(cnt+26) = 0 loop
        cnt := cnt + 1;
      end loop;
    end if;
    xlo := double_float'compose(double_float(val),expo-26-cnt);
  end Vec_Split;

  procedure Split ( x : in double_float;
                    x0,x1,x2,x3 : out double_float ) is

    f : constant double_float := double_float'fraction(x);
    e : constant integer32 := integer32(double_float'exponent(x));
    s : constant double_float := double_float'compose(f, 52);
    m : constant integer64 := integer64(double_float'truncation(s));
    thebits,xp0,xp1,xp2,xp3 : Standard_Natural_Vectors.Vector(0..51);
    part : constant integer32 := 52/4;
    valbits : integer64;
    idx,cnt : integer32;
  
  begin
    expand_52bits(thebits,m);
   -- put("the bits : "); write_52bits(thebits); new_line;
    for i in 0..(part-1) loop
      xp0(i) := thebits(i);
      xp1(i) := 0; xp2(i) := 0; xp3(i) := 0;
    end loop;
    for i in part..(2*part-1) loop
      xp1(i) := thebits(i);
      xp0(i) := 0; xp2(i) := 0; xp3(i) := 0;
    end loop;
    for i in 2*part..(3*part-1) loop
      xp2(i) := thebits(i);
      xp0(i) := 0; xp1(i) := 0; xp3(i) := 0;
    end loop;
    for i in 3*part..51 loop
      xp3(i) := thebits(i);
      xp0(i) := 0; xp1(i) := 0; xp2(i) := 0;
    end loop;
   -- put("1st part : "); write_52bits(xp0); new_line;
   -- put("2nd part : "); write_52bits(xp1); new_line;
   -- put("3rd part : "); write_52bits(xp2); new_line;
   -- put("4th part : "); write_52bits(xp3); new_line;
    valbits := value_52bits(xp0);
    x0 := double_float'compose(double_float(valbits),e);
    if x < 0.0
     then x0 := -x0;
    end if;
    valbits := value_52bits(xp1);
    cnt := 0;
    if valbits /= 0 then
      idx := part;
      while xp1(idx) = 0 loop
        idx := idx + 1;
        cnt := cnt + 1;
      end loop;
    end if;
    x1 := double_float'compose(double_float(valbits),e - part - cnt);
    if x < 0.0
     then x1 := -x1;
    end if;
    valbits := value_52bits(xp2);
    cnt := 0;
    if valbits /= 0 then
      idx := 2*part;
      while xp2(idx) = 0 loop
        idx := idx + 1;
        cnt := cnt + 1;
      end loop;
    end if;
    x2 := double_float'compose(double_float(valbits),e - 2*part - cnt);
    if x < 0.0
     then x2 := -x2;
    end if;
    valbits := value_52bits(xp3);
    cnt := 0;
    if valbits /= 0 then
      idx := 3*part;
      while xp3(idx) = 0 loop
        idx := idx + 1;
        cnt := cnt + 1;
      end loop;
    end if;
   -- x3 := double_float'compose(double_float(valbits),e - 3*part - cnt);
   -- if x < 0.0
   --  then x3 := -x3;
   -- end if;
    x3 := x - (x0 + x1 + x2);
  end Split;

  procedure Sign_Balance ( hi,lo : in out double_float;
                           verbose : in boolean := true ) is

    mhi,mlo : double_float;

  begin
    if hi < 0.0 then
      mhi := -hi;
      mlo := -lo;
      Sign_Balance(mhi,mlo,verbose);
      hi := -mhi;
      lo := -mlo;
    else
      for k in 1..52 loop
        mhi := hi - chop_last_bits(hi,natural32(k));
        if verbose then
          put("b hi : "); write_fraction_bits(hi);
          put("  hi : "); put(hi); new_line;
          put("  lo : "); put(lo); new_line;
          put("last bit : "); put(mhi); new_line;
        end if;
        exit when (mhi > 0.0);
      end loop;
      hi := hi - mhi;
      lo := lo + mhi;
      if verbose then
        put("  hi : "); put(hi); new_line;
        put("  lo : "); put(lo); new_line;
      end if;
    end if;
  end Sign_Balance;

  function Different_Sign ( x,y : double_float ) return boolean is
  begin
    if x > 0.0 then
      if y < 0.0
       then return true;
       else return false;
      end if;
    else -- x < 0.0
      if y > 0.0
       then return true;
       else return false;
      end if;
    end if;
  end Different_Sign;

  procedure Sign_Balance ( hihi,lohi,hilo,lolo : in out double_float;
                           verbose : in boolean := true ) is

    mhihi,mlohi,mhilo,mlolo : double_float;
    qdinc,qdnewlo : quad_double;
    ddinc,ddnewlo : double_double;

  begin
    if hihi < 0.0 then
      mhihi := -hihi;
      mlohi := -lohi;
      mhilo := -hilo;
      mlolo := -lolo;
      Sign_Balance(mhihi,mlohi,mhilo,mlolo,verbose);
      hihi := -mhihi;
      lohi := -mlohi;
      hilo := -mhilo;
      lolo := -mlolo;
    else
      if Different_Sign(hihi,lohi) then
        for k in 1..52 loop
          mhihi := hihi - chop_last_bits(hihi,natural32(k));
          if verbose then
            put("b hihi : "); write_fraction_bits(hihi);
            put("  hihi : "); put(hihi); new_line;
            put("last bit : "); put(mhihi); new_line;
          end if;
          exit when (mhihi > 0.0);
        end loop;
        hihi := hihi - mhihi;
       -- lo := lo + mhi;
        qdinc := create(mhihi,0.0,0.0,0.0);
        qdnewlo := create(lohi,hilo,lolo,0.0) + qdinc;
        lohi := hihi_part(qdnewlo);
        hilo := lohi_part(qdnewlo);
        lolo := hilo_part(qdnewlo);
        if verbose then
          put("  hihi : "); put(hihi); new_line;
          put("  lohi : "); put(lohi); new_line;
          put("  hilo : "); put(hilo); new_line;
          put("  lolo : "); put(lolo); new_line;
        end if;
      end if;
      if Different_Sign(lohi,hilo) then
        for k in 1..52 loop
          mlohi := lohi - chop_last_bits(lohi,natural32(k));
          if verbose then
            put("b lohi : "); write_fraction_bits(lohi);
            put("  lohi : "); put(lohi); new_line;
            put("last bit : "); put(mlohi); new_line;
          end if;
          exit when (mlohi > 0.0);
        end loop;
        lohi := lohi - mlohi;
       -- lo := lo + mhi;
        ddinc := create(mlohi,0.0);
        ddnewlo := create(hilo,lolo) + ddinc;
        hilo := hi_part(ddnewlo);
        lolo := lo_part(ddnewlo);
        if verbose then
          put("  hihi : "); put(hihi); new_line;
          put("  lohi : "); put(lohi); new_line;
          put("  hilo : "); put(hilo); new_line;
          put("  lolo : "); put(lolo); new_line;
        end if;
      end if;
      if Different_Sign(hilo,lolo) then
        for k in 1..52 loop
          mhilo := hilo - chop_last_bits(hilo,natural32(k));
          if verbose then
            put("b hilo : "); write_fraction_bits(hilo);
            put("  hilo : "); put(hilo); new_line;
            put("last bit : "); put(mhilo); new_line;
          end if;
          exit when (mhilo > 0.0);
        end loop;
        hilo := hilo - mhilo;
        lolo := lolo + mhilo;
        if verbose then
          put("  hihi : "); put(hihi); new_line;
          put("  lohi : "); put(lohi); new_line;
          put("  hilo : "); put(hilo); new_line;
          put("  lolo : "); put(lolo); new_line;
        end if;
      end if;
    end if;
  end Sign_Balance;

  procedure Sign_Balance
              ( hihihi,lohihi,hilohi,lolohi : in out double_float;
                hihilo,lohilo,hilolo,lololo : in out double_float;
                verbose : in boolean := true ) is

    mhihihi,mlohihi,mhilohi,mlolohi : double_float;
    mhihilo,mlohilo,mhilolo,mlololo : double_float;
    odinc,odnewlo : octo_double;
    qdinc,qdnewlo : quad_double;

  begin
    if hihihi < 0.0 then
      mhihihi := -hihihi;
      mlohihi := -lohihi;
      mhilohi := -hilohi;
      mlolohi := -lolohi;
      mhihilo := -hihilo;
      mlohilo := -lohilo;
      mhilolo := -hilolo;
      mlololo := -lololo;
      Sign_Balance(mhihihi,mlohihi,mhilohi,mlolohi,
                   mhihilo,mlohilo,mhilolo,mlololo,verbose);
      hihihi := -mhihihi;
      lohihi := -mlohihi;
      hilohi := -mhilohi;
      lolohi := -mlolohi;
      hihilo := -mhihilo;
      lohilo := -mlohilo;
      hilolo := -mhilolo;
      lololo := -mlololo;
    else
      if Different_Sign(hihihi,lohihi) then
        for k in 1..52 loop
          mhihihi := hihihi - chop_last_bits(hihihi,natural32(k));
          if verbose then
            put("b hihihi : "); write_fraction_bits(hihihi);
            put("  hihihi : "); put(hihihi); new_line;
            put("last bit : "); put(mhihihi); new_line;
          end if;
          exit when (mhihihi > 0.0);
        end loop;
        hihihi := hihihi - mhihihi;
       -- lo := lo + mhi;
        odinc := create(mhihihi,0.0,0.0,0.0,0.0,0.0,0.0,0.0);
        odnewlo := create(lohihi,hilohi,lolohi,
                          hihilo,lohilo,hilolo,lololo,0.0) + odinc;
        lohihi := hihihi_part(odnewlo);
        hilohi := lohihi_part(odnewlo);
        lolohi := hilohi_part(odnewlo);
        hihilo := lolohi_part(odnewlo);
        lohilo := hihilo_part(odnewlo);
        hilolo := lohilo_part(odnewlo);
        lololo := hilolo_part(odnewlo);
        if verbose then
          put("  hihihi : "); put(hihihi); new_line;
          put("  lohihi : "); put(lohihi); new_line;
          put("  hilohi : "); put(hilohi); new_line;
          put("  lolohi : "); put(lolohi); new_line;
          put("  hihilo : "); put(hihilo); new_line;
          put("  lohilo : "); put(lohilo); new_line;
          put("  hilolo : "); put(hilolo); new_line;
          put("  lololo : "); put(lololo); new_line;
        end if;
      end if;
      if Different_Sign(lohihi,hilohi) then
        for k in 1..52 loop
          mlohihi := lohihi - chop_last_bits(lohihi,natural32(k));
          if verbose then
            put("b lohihi : "); write_fraction_bits(lohihi);
            put("  lohihi : "); put(lohihi); new_line;
            put("last bit : "); put(mlohihi); new_line;
          end if;
          exit when (mlohihi > 0.0);
        end loop;
        lohihi := lohihi - mlohihi;
       -- lo := lo + mhi;
        odinc := create(mlohihi,0.0,0.0,0.0,0.0,0.0,0.0,0.0);
        odnewlo := create(hilohi,lolohi,
                          hihilo,lohilo,hilolo,lololo,0.0,0.0) + odinc;
        hilohi := hihihi_part(odnewlo);
        lolohi := lohihi_part(odnewlo);
        hihilo := hilohi_part(odnewlo);
        lohilo := lolohi_part(odnewlo);
        hilolo := hihilo_part(odnewlo);
        lololo := lohilo_part(odnewlo);
        if verbose then
          put("  hihihi : "); put(hihihi); new_line;
          put("  lohihi : "); put(lohihi); new_line;
          put("  hilohi : "); put(hilohi); new_line;
          put("  lolohi : "); put(lolohi); new_line;
          put("  hihilo : "); put(hihilo); new_line;
          put("  lohilo : "); put(lohilo); new_line;
          put("  hilolo : "); put(hilolo); new_line;
          put("  lololo : "); put(lololo); new_line;
        end if;
      end if;
      if Different_Sign(hilohi,lolohi) then
        for k in 1..52 loop
          mhilohi := hilohi - chop_last_bits(hilohi,natural32(k));
          if verbose then
            put("b hilohi : "); write_fraction_bits(hilohi);
            put("  hilohi : "); put(hilohi); new_line;
            put("last bit : "); put(mhilohi); new_line;
          end if;
          exit when (mhilohi > 0.0);
        end loop;
        hilohi := hilohi - mhilohi;
       -- lo := lo + mhi;
        odinc := create(mhilohi,0.0,0.0,0.0,0.0,0.0,0.0,0.0);
        odnewlo := create(lolohi,
                          hihilo,lohilo,hilolo,lololo,0.0,0.0,0.0) + odinc;
        lolohi := hihihi_part(odnewlo);
        hihilo := lohihi_part(odnewlo);
        lohilo := hilohi_part(odnewlo);
        hilolo := lolohi_part(odnewlo);
        lololo := hihilo_part(odnewlo);
        if verbose then
          put("  hihihi : "); put(hihihi); new_line;
          put("  lohihi : "); put(lohihi); new_line;
          put("  hilohi : "); put(hilohi); new_line;
          put("  lolohi : "); put(lolohi); new_line;
          put("  hihilo : "); put(hihilo); new_line;
          put("  lohilo : "); put(lohilo); new_line;
          put("  hilolo : "); put(hilolo); new_line;
          put("  lololo : "); put(lololo); new_line;
        end if;
      end if;
      if Different_Sign(lolohi,hihilo) then
        for k in 1..52 loop
          mlolohi := lolohi - chop_last_bits(lolohi,natural32(k));
          if verbose then
            put("b lolohi : "); write_fraction_bits(lolohi);
            put("  lolohi : "); put(lolohi); new_line;
            put("last bit : "); put(mlolohi); new_line;
          end if;
          exit when (mlolohi > 0.0);
        end loop;
        lolohi := lolohi - mlolohi;
       -- lo := lo + mhi;
        qdinc := create(mlolohi,0.0,0.0,0.0);
        qdnewlo := create(hihilo,lohilo,hilolo,lololo) + qdinc;
        hihilo := hihi_part(qdnewlo);
        lohilo := lohi_part(qdnewlo);
        hilolo := hilo_part(qdnewlo);
        lololo := lolo_part(qdnewlo);
        if verbose then
          put("  hihihi : "); put(hihihi); new_line;
          put("  lohihi : "); put(lohihi); new_line;
          put("  hilohi : "); put(hilohi); new_line;
          put("  lolohi : "); put(lolohi); new_line;
          put("  hihilo : "); put(hihilo); new_line;
          put("  lohilo : "); put(lohilo); new_line;
          put("  hilolo : "); put(hilolo); new_line;
          put("  lololo : "); put(lololo); new_line;
        end if;
      end if;
      Sign_Balance(hihilo,lohilo,hilolo,lololo,verbose);
    end if;
  end Sign_Balance;

  procedure Sign_Balance
              ( hihihihi,lohihihi,hilohihi,lolohihi : in out double_float;
                hihilohi,lohilohi,hilolohi,lololohi : in out double_float;
                hihihilo,lohihilo,hilohilo,lolohilo : in out double_float;
                hihilolo,lohilolo,hilololo,lolololo : in out double_float;
                verbose : in boolean := true ) is

    mhihihihi,mlohihihi,mhilohihi,mlolohihi : double_float;
    mhihilohi,mlohilohi,mhilolohi,mlololohi : double_float;
    mhihihilo,mlohihilo,mhilohilo,mlolohilo : double_float;
    mhihilolo,mlohilolo,mhilololo,mlolololo : double_float;
    hdinc,hdnewlo : hexa_double;
    odinc,odnewlo : octo_double;

  begin
    if hihihihi < 0.0 then
      mhihihihi := -hihihihi;
      mlohihihi := -lohihihi;
      mhilohihi := -hilohihi;
      mlolohihi := -lolohihi;
      mhihilohi := -hihilohi;
      mlohilohi := -lohilohi;
      mhilolohi := -hilolohi;
      mlololohi := -lololohi;
      mhihihilo := -hihihilo;
      mlohihilo := -lohihilo;
      mhilohilo := -hilohilo;
      mlolohilo := -lolohilo;
      mhihilolo := -hihilolo;
      mlohilolo := -lohilolo;
      mhilololo := -hilololo;
      mlolololo := -lolololo;
      Sign_Balance(mhihihihi,mlohihihi,mhilohihi,mlolohihi,
                   mhihilohi,mlohilohi,mhilolohi,mlololohi,
                   mhihihilo,mlohihilo,mhilohilo,mlolohilo,
                   mhihilolo,mlohilolo,mhilololo,mlolololo,verbose);
      hihihihi := -mhihihihi;
      lohihihi := -mlohihihi;
      hilohihi := -mhilohihi;
      lolohihi := -mlolohihi;
      hihilohi := -mhihilohi;
      lohilohi := -mlohilohi;
      hilolohi := -mhilolohi;
      lololohi := -mlololohi;
      hihihilo := -mhihihilo;
      lohihilo := -mlohihilo;
      hilohilo := -mhilohilo;
      lolohilo := -mlolohilo;
      hihilolo := -mhihilolo;
      lohilolo := -mlohilolo;
      hilololo := -mhilololo;
      lolololo := -mlolololo;
    else
      if Different_Sign(hihihihi,lohihihi) then
        for k in 1..52 loop
          mhihihihi := hihihihi - chop_last_bits(hihihihi,natural32(k));
          if verbose then
            put("b hihihihi : "); write_fraction_bits(hihihihi);
            put("  hihihihi : "); put(hihihihi); new_line;
            put("  last bit : "); put(mhihihihi); new_line;
          end if;
          exit when (mhihihihi > 0.0);
        end loop;
        hihihihi := hihihihi - mhihihihi;
       -- lo := lo + mhi;
        hdinc := create(mhihihihi,0.0,0.0,0.0,0.0,0.0,0.0,0.0,
                        0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0);
        hdnewlo := create(lohihihi,hilohihi,lolohihi,
                          hihilohi,lohilohi,hilolohi,lololohi,
                          hihihilo,lohihilo,hilohilo,lolohilo,
                          hihilolo,lohilolo,hilololo,lolololo,0.0) + hdinc;
        lohihihi := hihihihi_part(hdnewlo);
        hilohihi := lohihihi_part(hdnewlo);
        lolohihi := hilohihi_part(hdnewlo);
        hihilohi := lolohihi_part(hdnewlo);
        lohilohi := hihilohi_part(hdnewlo);
        hilolohi := lohilohi_part(hdnewlo);
        lololohi := hilolohi_part(hdnewlo);
        hihihilo := lololohi_part(hdnewlo);
        lohihilo := hihihilo_part(hdnewlo);
        hilohilo := lohihilo_part(hdnewlo);
        lolohilo := hilohilo_part(hdnewlo);
        hihilolo := lolohilo_part(hdnewlo);
        lohilolo := hihilolo_part(hdnewlo);
        hilololo := lohilolo_part(hdnewlo);
        lolololo := hilololo_part(hdnewlo);
        if verbose then
          put("  hihihihi : "); put(hihihihi); new_line;
          put("  lohihihi : "); put(lohihihi); new_line;
          put("  hilohihi : "); put(hilohihi); new_line;
          put("  lolohihi : "); put(lolohihi); new_line;
          put("  hihilohi : "); put(hihilohi); new_line;
          put("  lohilohi : "); put(lohilohi); new_line;
          put("  hilolohi : "); put(hilolohi); new_line;
          put("  lololohi : "); put(lololohi); new_line;
          put("  hihihilo : "); put(hihihilo); new_line;
          put("  lohihilo : "); put(lohihilo); new_line;
          put("  hilohilo : "); put(hilohilo); new_line;
          put("  lolohilo : "); put(lolohilo); new_line;
          put("  hihilolo : "); put(hihilolo); new_line;
          put("  lohilolo : "); put(lohilolo); new_line;
          put("  hilololo : "); put(hilololo); new_line;
          put("  lolololo : "); put(lolololo); new_line;
        end if;
      end if;
      if Different_Sign(lohihihi,hilohihi) then
        for k in 1..52 loop
          mlohihihi := lohihihi - chop_last_bits(lohihihi,natural32(k));
          if verbose then
            put("b lohihihi : "); write_fraction_bits(lohihihi);
            put("  lohihihi : "); put(lohihihi); new_line;
            put("  last bit : "); put(mlohihihi); new_line;
          end if;
          exit when (mlohihihi > 0.0);
        end loop;
        lohihihi := lohihihi - mlohihihi;
       -- lo := lo + mhi;
        hdinc := create(mlohihihi,0.0,0.0,0.0,0.0,0.0,0.0,0.0,
                        0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0);
        hdnewlo := create(hilohihi,lolohihi,
                          hihilohi,lohilohi,hilolohi,lololohi,
                          hihihilo,lohihilo,hilohilo,lolohilo,
                          hihilolo,lohilolo,hilololo,lolololo,
                          0.0,0.0) + hdinc;
        hilohihi := hihihihi_part(hdnewlo);
        lolohihi := lohihihi_part(hdnewlo);
        hihilohi := hilohihi_part(hdnewlo);
        lohilohi := lolohihi_part(hdnewlo);
        hilolohi := hihilohi_part(hdnewlo);
        lololohi := lohilohi_part(hdnewlo);
        hihihilo := hilolohi_part(hdnewlo);
        lohihilo := lololohi_part(hdnewlo);
        hilohilo := hihihilo_part(hdnewlo);
        lolohilo := lohihilo_part(hdnewlo);
        hihilolo := hilohilo_part(hdnewlo);
        lohilolo := lolohilo_part(hdnewlo);
        hilololo := hihilolo_part(hdnewlo);
        lolololo := lohilolo_part(hdnewlo);
        if verbose then
          put("  hihihihi : "); put(hihihihi); new_line;
          put("  lohihihi : "); put(lohihihi); new_line;
          put("  hilohihi : "); put(hilohihi); new_line;
          put("  lolohihi : "); put(lolohihi); new_line;
          put("  hihilohi : "); put(hihilohi); new_line;
          put("  lohilohi : "); put(lohilohi); new_line;
          put("  hilolohi : "); put(hilolohi); new_line;
          put("  lololohi : "); put(lololohi); new_line;
          put("  hihihilo : "); put(hihihilo); new_line;
          put("  lohihilo : "); put(lohihilo); new_line;
          put("  hilohilo : "); put(hilohilo); new_line;
          put("  lolohilo : "); put(lolohilo); new_line;
          put("  hihilolo : "); put(hihilolo); new_line;
          put("  lohilolo : "); put(lohilolo); new_line;
          put("  hilololo : "); put(hilololo); new_line;
          put("  lolololo : "); put(lolololo); new_line;
        end if;
      end if;
      if Different_Sign(hilohihi,lolohihi) then
        for k in 1..52 loop
          mhilohihi := hilohihi - chop_last_bits(hilohihi,natural32(k));
          if verbose then
            put("b hilohihi : "); write_fraction_bits(hilohihi);
            put("  hilohihi : "); put(lohihihi); new_line;
            put("  last bit : "); put(mlohihihi); new_line;
          end if;
          exit when (mhilohihi > 0.0);
        end loop;
        hilohihi := hilohihi - mhilohihi;
       -- lo := lo + mhi;
        hdinc := create(mhilohihi,0.0,0.0,0.0,0.0,0.0,0.0,0.0,
                        0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0);
        hdnewlo := create(lolohihi,
                          hihilohi,lohilohi,hilolohi,lololohi,
                          hihihilo,lohihilo,hilohilo,lolohilo,
                          hihilolo,lohilolo,hilololo,lolololo,
                          0.0,0.0,0.0) + hdinc;
        lolohihi := hihihihi_part(hdnewlo);
        hihilohi := lohihihi_part(hdnewlo);
        lohilohi := hilohihi_part(hdnewlo);
        hilolohi := lolohihi_part(hdnewlo);
        lololohi := hihilohi_part(hdnewlo);
        hihihilo := lohilohi_part(hdnewlo);
        lohihilo := hilolohi_part(hdnewlo);
        hilohilo := lololohi_part(hdnewlo);
        lolohilo := hihihilo_part(hdnewlo);
        hihilolo := lohihilo_part(hdnewlo);
        lohilolo := hilohilo_part(hdnewlo);
        hilololo := lolohilo_part(hdnewlo);
        lolololo := hihilolo_part(hdnewlo);
        if verbose then
          put("  hihihihi : "); put(hihihihi); new_line;
          put("  lohihihi : "); put(lohihihi); new_line;
          put("  hilohihi : "); put(hilohihi); new_line;
          put("  lolohihi : "); put(lolohihi); new_line;
          put("  hihilohi : "); put(hihilohi); new_line;
          put("  lohilohi : "); put(lohilohi); new_line;
          put("  hilolohi : "); put(hilolohi); new_line;
          put("  lololohi : "); put(lololohi); new_line;
          put("  hihihilo : "); put(hihihilo); new_line;
          put("  lohihilo : "); put(lohihilo); new_line;
          put("  hilohilo : "); put(hilohilo); new_line;
          put("  lolohilo : "); put(lolohilo); new_line;
          put("  hihilolo : "); put(hihilolo); new_line;
          put("  lohilolo : "); put(lohilolo); new_line;
          put("  hilololo : "); put(hilololo); new_line;
          put("  lolololo : "); put(lolololo); new_line;
        end if;
      end if;
      if Different_Sign(lolohihi,hihilohi) then
        for k in 1..52 loop
          mlolohihi := lolohihi - chop_last_bits(lolohihi,natural32(k));
          if verbose then
            put("b lolohihi : "); write_fraction_bits(lolohihi);
            put("  lolohihi : "); put(lolohihi); new_line;
            put("  last bit : "); put(mlolohihi); new_line;
          end if;
          exit when (mlolohihi > 0.0);
        end loop;
        lolohihi := lolohihi - mlolohihi;
       -- lo := lo + mhi;
        hdinc := create(mlolohihi,0.0,0.0,0.0,0.0,0.0,0.0,0.0,
                        0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0);
        hdnewlo := create(hihilohi,lohilohi,hilolohi,lololohi,
                          hihihilo,lohihilo,hilohilo,lolohilo,
                          hihilolo,lohilolo,hilololo,lolololo,
                          0.0,0.0,0.0,0.0) + hdinc;
        hihilohi := hihihihi_part(hdnewlo);
        lohilohi := lohihihi_part(hdnewlo);
        hilolohi := hilohihi_part(hdnewlo);
        lololohi := lolohihi_part(hdnewlo);
        hihihilo := hihilohi_part(hdnewlo);
        lohihilo := lohilohi_part(hdnewlo);
        hilohilo := hilolohi_part(hdnewlo);
        lolohilo := lololohi_part(hdnewlo);
        hihilolo := hihihilo_part(hdnewlo);
        lohilolo := lohihilo_part(hdnewlo);
        hilololo := hilohilo_part(hdnewlo);
        lolololo := lolohilo_part(hdnewlo);
        if verbose then
          put("  hihihihi : "); put(hihihihi); new_line;
          put("  lohihihi : "); put(lohihihi); new_line;
          put("  hilohihi : "); put(hilohihi); new_line;
          put("  lolohihi : "); put(lolohihi); new_line;
          put("  hihilohi : "); put(hihilohi); new_line;
          put("  lohilohi : "); put(lohilohi); new_line;
          put("  hilolohi : "); put(hilolohi); new_line;
          put("  lololohi : "); put(lololohi); new_line;
          put("  hihihilo : "); put(hihihilo); new_line;
          put("  lohihilo : "); put(lohihilo); new_line;
          put("  hilohilo : "); put(hilohilo); new_line;
          put("  lolohilo : "); put(lolohilo); new_line;
          put("  hihilolo : "); put(hihilolo); new_line;
          put("  lohilolo : "); put(lohilolo); new_line;
          put("  hilololo : "); put(hilololo); new_line;
          put("  lolololo : "); put(lolololo); new_line;
        end if;
      end if;
      if Different_Sign(hihilohi,lohilohi) then
        for k in 1..52 loop
          mhihilohi := hihilohi - chop_last_bits(hihilohi,natural32(k));
          if verbose then
            put("b hihilohi : "); write_fraction_bits(hihilohi);
            put("  hihilohi : "); put(hihilohi); new_line;
            put("  last bit : "); put(mhihilohi); new_line;
          end if;
          exit when (mhihilohi > 0.0);
        end loop;
        hihilohi := hihilohi - mhihilohi;
       -- lo := lo + mhi;
        hdinc := create(mhihilohi,0.0,0.0,0.0,0.0,0.0,0.0,0.0,
                        0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0);
        hdnewlo := create(lohilohi,hilolohi,lololohi,
                          hihihilo,lohihilo,hilohilo,lolohilo,
                          hihilolo,lohilolo,hilololo,lolololo,
                          0.0,0.0,0.0,0.0,0.0) + hdinc;
        lohilohi := hihihihi_part(hdnewlo);
        hilolohi := lohihihi_part(hdnewlo);
        lololohi := hilohihi_part(hdnewlo);
        hihihilo := lolohihi_part(hdnewlo);
        lohihilo := hihilohi_part(hdnewlo);
        hilohilo := lohilohi_part(hdnewlo);
        lolohilo := hilolohi_part(hdnewlo);
        hihilolo := lololohi_part(hdnewlo);
        lohilolo := hihihilo_part(hdnewlo);
        hilololo := lohihilo_part(hdnewlo);
        lolololo := hilohilo_part(hdnewlo);
        if verbose then
          put("  hihihihi : "); put(hihihihi); new_line;
          put("  lohihihi : "); put(lohihihi); new_line;
          put("  hilohihi : "); put(hilohihi); new_line;
          put("  lolohihi : "); put(lolohihi); new_line;
          put("  hihilohi : "); put(hihilohi); new_line;
          put("  lohilohi : "); put(lohilohi); new_line;
          put("  hilolohi : "); put(hilolohi); new_line;
          put("  lololohi : "); put(lololohi); new_line;
          put("  hihihilo : "); put(hihihilo); new_line;
          put("  lohihilo : "); put(lohihilo); new_line;
          put("  hilohilo : "); put(hilohilo); new_line;
          put("  lolohilo : "); put(lolohilo); new_line;
          put("  hihilolo : "); put(hihilolo); new_line;
          put("  lohilolo : "); put(lohilolo); new_line;
          put("  hilololo : "); put(hilololo); new_line;
          put("  lolololo : "); put(lolololo); new_line;
        end if;
      end if;
      if Different_Sign(lohilohi,hilolohi) then
        for k in 1..52 loop
          mlohilohi := lohilohi - chop_last_bits(lohilohi,natural32(k));
          if verbose then
            put("b lohilohi : "); write_fraction_bits(lohilohi);
            put("  lohilohi : "); put(lohilohi); new_line;
            put("  last bit : "); put(mlohilohi); new_line;
          end if;
          exit when (mlohilohi > 0.0);
        end loop;
        lohilohi := lohilohi - mlohilohi;
       -- lo := lo + mhi;
        hdinc := create(mlohilohi,0.0,0.0,0.0,0.0,0.0,0.0,0.0,
                        0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0);
        hdnewlo := create(hilolohi,lololohi,
                          hihihilo,lohihilo,hilohilo,lolohilo,
                          hihilolo,lohilolo,hilololo,lolololo,
                          0.0,0.0,0.0,0.0,0.0,0.0) + hdinc;
        hilolohi := hihihihi_part(hdnewlo);
        lololohi := lohihihi_part(hdnewlo);
        hihihilo := hilohihi_part(hdnewlo);
        lohihilo := lolohihi_part(hdnewlo);
        hilohilo := hihilohi_part(hdnewlo);
        lolohilo := lohilohi_part(hdnewlo);
        hihilolo := hilolohi_part(hdnewlo);
        lohilolo := lololohi_part(hdnewlo);
        hilololo := hihihilo_part(hdnewlo);
        lolololo := lohihilo_part(hdnewlo);
        if verbose then
          put("  hihihihi : "); put(hihihihi); new_line;
          put("  lohihihi : "); put(lohihihi); new_line;
          put("  hilohihi : "); put(hilohihi); new_line;
          put("  lolohihi : "); put(lolohihi); new_line;
          put("  hihilohi : "); put(hihilohi); new_line;
          put("  lohilohi : "); put(lohilohi); new_line;
          put("  hilolohi : "); put(hilolohi); new_line;
          put("  lololohi : "); put(lololohi); new_line;
          put("  hihihilo : "); put(hihihilo); new_line;
          put("  lohihilo : "); put(lohihilo); new_line;
          put("  hilohilo : "); put(hilohilo); new_line;
          put("  lolohilo : "); put(lolohilo); new_line;
          put("  hihilolo : "); put(hihilolo); new_line;
          put("  lohilolo : "); put(lohilolo); new_line;
          put("  hilololo : "); put(hilololo); new_line;
          put("  lolololo : "); put(lolololo); new_line;
        end if;
      end if;
      if Different_Sign(hilolohi,lololohi) then
        for k in 1..52 loop
          mhilolohi := hilolohi - chop_last_bits(hilolohi,natural32(k));
          if verbose then
            put("b hilolohi : "); write_fraction_bits(hilolohi);
            put("  hilolohi : "); put(hilolohi); new_line;
            put("  last bit : "); put(mhilolohi); new_line;
          end if;
          exit when (mhilolohi > 0.0);
        end loop;
        hilolohi := hilolohi - mhilolohi;
       -- lo := lo + mhi;
        hdinc := create(mhilolohi,0.0,0.0,0.0,0.0,0.0,0.0,0.0,
                        0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0);
        hdnewlo := create(lololohi,
                          hihihilo,lohihilo,hilohilo,lolohilo,
                          hihilolo,lohilolo,hilololo,lolololo,
                          0.0,0.0,0.0,0.0,0.0,0.0,0.0) + hdinc;
        lololohi := hihihihi_part(hdnewlo);
        hihihilo := lohihihi_part(hdnewlo);
        lohihilo := hilohihi_part(hdnewlo);
        hilohilo := lolohihi_part(hdnewlo);
        lolohilo := hihilohi_part(hdnewlo);
        hihilolo := lohilohi_part(hdnewlo);
        lohilolo := hilolohi_part(hdnewlo);
        hilololo := lololohi_part(hdnewlo);
        lolololo := hihihilo_part(hdnewlo);
        if verbose then
          put("  hihihihi : "); put(hihihihi); new_line;
          put("  lohihihi : "); put(lohihihi); new_line;
          put("  hilohihi : "); put(hilohihi); new_line;
          put("  lolohihi : "); put(lolohihi); new_line;
          put("  hihilohi : "); put(hihilohi); new_line;
          put("  lohilohi : "); put(lohilohi); new_line;
          put("  hilolohi : "); put(hilolohi); new_line;
          put("  lololohi : "); put(lololohi); new_line;
          put("  hihihilo : "); put(hihihilo); new_line;
          put("  lohihilo : "); put(lohihilo); new_line;
          put("  hilohilo : "); put(hilohilo); new_line;
          put("  lolohilo : "); put(lolohilo); new_line;
          put("  hihilolo : "); put(hihilolo); new_line;
          put("  lohilolo : "); put(lohilolo); new_line;
          put("  hilololo : "); put(hilololo); new_line;
          put("  lolololo : "); put(lolololo); new_line;
        end if;
      end if;
      if Different_Sign(lololohi,hihihilo) then
        for k in 1..52 loop
          mlololohi := lololohi - chop_last_bits(lololohi,natural32(k));
          if verbose then
            put("b lololohi : "); write_fraction_bits(lololohi);
            put("  lololohi : "); put(lololohi); new_line;
            put("  last bit : "); put(mlololohi); new_line;
          end if;
          exit when (mlololohi > 0.0);
        end loop;
        lololohi := lololohi - mlololohi;
       -- lo := lo + mhi;
        odinc := create(mlololohi,0.0,0.0,0.0,0.0,0.0,0.0,0.0);
        odnewlo := create(hihihilo,lohihilo,hilohilo,lolohilo,
                          hihilolo,lohilolo,hilololo,lolololo) + odinc;
        hihihilo := hihihi_part(odnewlo);
        lohihilo := lohihi_part(odnewlo);
        hilohilo := hilohi_part(odnewlo);
        lolohilo := lolohi_part(odnewlo);
        hihilolo := hihilo_part(odnewlo);
        lohilolo := lohilo_part(odnewlo);
        hilololo := hilolo_part(odnewlo);
        lolololo := lololo_part(odnewlo);
        if verbose then
          put("  hihihihi : "); put(hihihihi); new_line;
          put("  lohihihi : "); put(lohihihi); new_line;
          put("  hilohihi : "); put(hilohihi); new_line;
          put("  lolohihi : "); put(lolohihi); new_line;
          put("  hihilohi : "); put(hihilohi); new_line;
          put("  lohilohi : "); put(lohilohi); new_line;
          put("  hilolohi : "); put(hilolohi); new_line;
          put("  lololohi : "); put(lololohi); new_line;
          put("  hihihilo : "); put(hihihilo); new_line;
          put("  lohihilo : "); put(lohihilo); new_line;
          put("  hilohilo : "); put(hilohilo); new_line;
          put("  lolohilo : "); put(lolohilo); new_line;
          put("  hihilolo : "); put(hihilolo); new_line;
          put("  lohilolo : "); put(lohilolo); new_line;
          put("  hilololo : "); put(hilololo); new_line;
          put("  lolololo : "); put(lolololo); new_line;
        end if;
      end if;
      Sign_Balance(hihihilo,lohihilo,hilohilo,lolohilo,
                   hihilolo,lohilolo,hilololo,lolololo,verbose);
    end if;
  end Sign_Balance;

  procedure Sign_Balance ( x : in out double_double;
                           verbose : in boolean := true ) is

    hi : double_float := hi_part(x);
    lo : double_float := lo_part(x);

  begin
    if Different_Sign(hi,lo) then
      Sign_Balance(hi,lo,verbose);
      x := create(hi,lo);
    end if;
  end Sign_Balance;

  procedure Sign_Balance ( x : in out quad_double;
                           verbose : in boolean := true ) is

    hihi : double_float := hihi_part(x);
    lohi : double_float := lohi_part(x);
    hilo : double_float := hilo_part(x);
    lolo : double_float := lolo_part(x);
    p1 : constant boolean := Different_Sign(hihi,lohi);
    p2 : constant boolean := Different_Sign(lohi,hilo);
    p3 : constant boolean := Different_Sign(hilo,lolo);

  begin
    if p1 or p2 or p3 then
      Sign_Balance(hihi,lohi,hilo,lolo,verbose);
      x := create(hihi,lohi,hilo,lolo);
    end if;
  end Sign_Balance;

  procedure Sign_Balance ( x : in out octo_double;
                           verbose : in boolean := true ) is

    hihihi : double_float := hihihi_part(x);
    lohihi : double_float := lohihi_part(x);
    hilohi : double_float := hilohi_part(x);
    lolohi : double_float := lolohi_part(x);
    hihilo : double_float := hihilo_part(x);
    lohilo : double_float := lohilo_part(x);
    hilolo : double_float := hilolo_part(x);
    lololo : double_float := lololo_part(x);
    p1 : constant boolean := Different_Sign(hihihi,lohihi);
    p2 : constant boolean := Different_Sign(lohihi,hilohi);
    p3 : constant boolean := Different_Sign(hilohi,lohihi);
    p4 : constant boolean := Different_Sign(lohihi,lolohi);
    p5 : constant boolean := Different_Sign(lolohi,hihilo);
    p6 : constant boolean := Different_Sign(hihilo,lohilo);
    p7 : constant boolean := Different_Sign(lohilo,lololo);

  begin
    if p1 or p2 or p3 or p4 or p5 or p6 or p7 then
      Sign_Balance(hihihi,lohihi,hilohi,lolohi,
                   hihilo,lohilo,hilolo,lololo,verbose);
      x := create(hihihi,lohihi,hilohi,lolohi,hihilo,lohilo,hilolo,lololo);
    end if;
  end Sign_Balance;

  procedure Sign_Balance ( x : in out hexa_double;
                           verbose : in boolean := true ) is

    hihihihi : double_float := hihihihi_part(x);
    lohihihi : double_float := lohihihi_part(x);
    hilohihi : double_float := hilohihi_part(x);
    lolohihi : double_float := lolohihi_part(x);
    hihilohi : double_float := hihilohi_part(x);
    lohilohi : double_float := lohilohi_part(x);
    hilolohi : double_float := hilolohi_part(x);
    lololohi : double_float := lololohi_part(x);
    hihihilo : double_float := hihihilo_part(x);
    lohihilo : double_float := lohihilo_part(x);
    hilohilo : double_float := hilohilo_part(x);
    lolohilo : double_float := lolohilo_part(x);
    hihilolo : double_float := hihilolo_part(x);
    lohilolo : double_float := lohilolo_part(x);
    hilololo : double_float := hilololo_part(x);
    lolololo : double_float := lolololo_part(x);
    p1 : constant boolean := Different_Sign(hihihihi,lohihihi);
    p2 : constant boolean := Different_Sign(lohihihi,hilohihi);
    p3 : constant boolean := Different_Sign(hilohihi,lohihihi);
    p4 : constant boolean := Different_Sign(lohihihi,lolohihi);
    p5 : constant boolean := Different_Sign(lolohihi,hihilohi);
    p6 : constant boolean := Different_Sign(hihilohi,lohilohi);
    p7 : constant boolean := Different_Sign(lohilohi,lololohi);
    p8 : constant boolean := Different_Sign(lololohi,hihihilo);
    p9 : constant boolean := Different_Sign(hihihilo,lohihilo);
    pA : constant boolean := Different_Sign(lohihilo,hilohilo);
    pB : constant boolean := Different_Sign(hilohilo,lohihilo);
    pC : constant boolean := Different_Sign(lohihilo,lolohilo);
    pD : constant boolean := Different_Sign(lolohilo,hihilolo);
    pE : constant boolean := Different_Sign(hihilolo,lohilolo);
    pF : constant boolean := Different_Sign(lohilolo,lolololo);

  begin
    if p1 or p2 or p3 or p4 or p5 or p6 or p7 
          or p8 or p9 or pA or pB or pC or pD or pE or pF then
      Sign_Balance(hihihihi,lohihihi,hilohihi,lolohihi,
                   hihilohi,lohilohi,hilolohi,lololohi,
                   hihihilo,lohihilo,hilohilo,lolohilo,
                   hihilolo,lohilolo,hilololo,lolololo,verbose);
      x := create(hihihihi,lohihihi,hilohihi,lolohihi,
                  hihilohi,lohilohi,hilolohi,lololohi,
                  hihihilo,lohihilo,hilohilo,lolohilo,
                  hihilolo,lohilolo,hilololo,lolololo);
    end if;
  end Sign_Balance;

  function Is_Sign_Balanced ( x : double_double ) return boolean is

    hi : constant double_float := hi_part(x);
    lo : constant double_float := lo_part(x);

  begin
    return not Different_Sign(hi,lo);
  end Is_Sign_Balanced;

  function Is_Sign_Balanced ( x : quad_double ) return boolean is

    hihi : constant double_float := hihi_part(x);
    lohi : constant double_float := lohi_part(x);
    hilo : constant double_float := hilo_part(x);
    lolo : constant double_float := lolo_part(x);

  begin
    if Different_Sign(hihi,lolo) then
      return false;
    else
      if Different_Sign(lohi,hilo) then
        return false;
      else
        return not Different_Sign(hilo,lolo);
      end if;
    end if;
  end Is_Sign_Balanced;

  function Is_Sign_Balanced ( x : octo_double ) return boolean is

    hihihi : constant double_float := hihihi_part(x);
    lohihi : constant double_float := lohihi_part(x);
    hilohi : constant double_float := hilohi_part(x);
    lolohi : constant double_float := lolohi_part(x);
    hihilo : constant double_float := hihilo_part(x);
    lohilo : constant double_float := lohilo_part(x);
    hilolo : constant double_float := hilolo_part(x);
    lololo : constant double_float := lololo_part(x);

  begin
    if Different_Sign(hihihi,lohihi) then
      return false;
    else
      if Different_Sign(lohihi,hilohi) then
        return false;
      else
        if Different_Sign(hilohi,lolohi) then
          return false;
        else
          if Different_Sign(lolohi,hihilo) then
            return false;
          else
            if Different_Sign(hihilo,lohilo) then
              return false;
            else
              if Different_Sign(lohilo,hilolo) then
                return false;
              else
                return not Different_Sign(hilolo,lololo);
              end if;
            end if;
          end if;
        end if;
      end if;
    end if;
  end Is_Sign_Balanced;

  function Is_Sign_Balanced ( x : hexa_double ) return boolean is

    hihihihi : constant double_float := hihihihi_part(x);
    lohihihi : constant double_float := lohihihi_part(x);
    hilohihi : constant double_float := hilohihi_part(x);
    lolohihi : constant double_float := lolohihi_part(x);
    hihilohi : constant double_float := hihilohi_part(x);
    lohilohi : constant double_float := lohilohi_part(x);
    hilolohi : constant double_float := hilolohi_part(x);
    lololohi : constant double_float := lololohi_part(x);
    hihihilo : constant double_float := hihihilo_part(x);
    lohihilo : constant double_float := lohihilo_part(x);
    hilohilo : constant double_float := hilohilo_part(x);
    lolohilo : constant double_float := lolohilo_part(x);
    hihilolo : constant double_float := hihilolo_part(x);
    lohilolo : constant double_float := lohilolo_part(x);
    hilololo : constant double_float := hilololo_part(x);
    lolololo : constant double_float := lolololo_part(x);

  begin
    if Different_Sign(hihihihi,lohihihi) then
      return false;
    else
      if Different_Sign(lohihihi,hilohihi) then
        return false;
      else
        if Different_Sign(hilohihi,lolohihi) then
          return false;
        else
          if Different_Sign(lolohihi,hihilohi) then
            return false;
          else
            if Different_Sign(hihilohi,lohilohi) then
              return false;
            else
              if Different_Sign(lohilohi,hilolohi) then
                return false;
              else
                if Different_Sign(hilolohi,lololohi) then
                  return false;
                else
                  if Different_Sign(lololohi,hihihilo) then
                    return false;
                  else
                    if Different_Sign(hihihilo,lohihilo) then
                      return false;
                    else
                      if Different_Sign(lohihilo,hilohilo) then
                        return false;
                      else
                        if Different_Sign(hilohilo,lolohilo) then
                          return false;
                        else
                          if Different_Sign(lolohilo,hihilolo) then
                            return false;
                          else
                            if Different_Sign(hihilolo,lohilolo) then
                              return false;
                            else
                              if Different_Sign(lohilolo,hilololo) then
                                return false;
                              else
                                return not Different_Sign(hilololo,lolololo);
                              end if;
                            end if;
                          end if;
                        end if;
                      end if;
                    end if;
                  end if;
                end if;
              end if;
            end if;
          end if;
        end if;
      end if;
    end if;
  end Is_Sign_Balanced;

end Bits_of_Doubles;
