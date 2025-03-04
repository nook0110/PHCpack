with Quad_Double_Numbers;                use Quad_Double_Numbers;
with Quad_Double_Numbers_io;             use Quad_Double_Numbers_io;

package body QuadDobl_Complex_Numbers_io is

  procedure get ( c : in out Complex_Number ) is
  begin
    get(standard_input,c);
  end get;

  procedure get ( file : in file_type; c : in out Complex_Number ) is

    x,y : quad_double := Create(0.0);

  begin
    get(file,x,y);
    c := Create(x,y);
  end get;

  procedure get ( s : in string; c : in out Complex_Number;
                  last : out integer ) is

    x,y : quad_double := Create(0.0);
    fail : boolean;

  begin
    last := s'first;
    read(s,last,x,fail);
    while s(last) /= ' ' loop  -- make sure to start at dividing spaces
      last := last + 1;
      exit when last >= s'last;
    end loop;
    read(s,last,y,fail);
    c := Create(x,y);
  end get;

  procedure put ( c : in Complex_Number ) is
  begin
    put(standard_output,c);
  end put;

  procedure put ( file : in file_type; c : in Complex_Number ) is
  begin
    put(file,REAL_PART(c));
    put(file,"  ");
    put(file,IMAG_PART(c));
  end put;

  procedure put ( s : out string; c : in Complex_Number ) is

    re,im : string(1..75);
    re_ends,im_ends : integer;
    x : constant quad_double := REAL_PARt(c);
    y : constant quad_double := IMAG_PARt(c);

  begin
    s := (s'range => ' ');
    to_string(x,64,0,false,false,true,' ',re,re_ends);
    to_string(y,64,0,false,false,true,' ',im,im_ends);
    declare
      t : constant string
        := re(1..re_ends) & "  " & im(1..im_ends);
    begin
      s(t'range) := t;
    end;
  end put;

  procedure put ( c : in Complex_Number; dp : in natural32 ) is
  begin
    put(standard_output,c,dp);
  end put;

  procedure put ( file : in file_type;
                  c : in Complex_Number; dp : in natural32 ) is
  begin
    put(file,REAL_PART(c),dp);
    put(file,"  ");
    put(file,IMAG_PART(c),dp);
  end put;

  procedure put ( s : out string;
                  c : in Complex_Number; dp : in natural32 ) is

    re,im : string(1..integer(dp)+10);
    re_ends,im_ends : integer;
    x : constant quad_double := REAL_PARt(c);
    y : constant quad_double := IMAG_PARt(c);

  begin
    to_string(x,dp,0,false,false,true,' ',re,re_ends);
    to_string(y,dp,0,false,false,true,' ',im,im_ends);
    s := re(1..re_ends) & "  " & im(1..im_ends);
  end put;

end QuadDobl_Complex_Numbers_io;
