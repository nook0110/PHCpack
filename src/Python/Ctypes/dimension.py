"""
Exports the dimension of the system of polynomials.
Needs the version module.
"""
from ctypes import c_int, c_double, pointer
from version import getPHCmod

def set_double_dimension(dim, vrblvl=0):
    """
    Sets the number of polynomials in double precision
    to the value of the first parameter dim.
    """
    if vrblvl > 0:
        print("in set_double_dimension, dim = ", dim)
    phcpack = getPHCmod()
    phc = phcpack._ada_use_c2phc
    adim = pointer(c_int(dim))
    bbb = pointer(c_int(0))
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    retval = phc(23, adim, bbb, ccc, vrb)
    if vrblvl > 0:
        print('the return value of set_double_dimension :', retval)
    return retval

def get_double_dimension(vrblvl=0):
    """
    Returns the number of polynomials in double precision.
    """
    if vrblvl > 0:
        print("in getDoubleDimension ...")
    phcpack = getPHCmod()
    phc = phcpack._ada_use_c2phc
    adim = pointer(c_int(0))
    bbb = pointer(c_int(0))
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    retval = phc(22, adim, bbb, ccc, vrb)
    if vrblvl > 0:
        print('the return value of setDoubleDimension :', retval)
        print('the retrieved dimension :', adim[0])
    return adim[0]

def show_dimension():
    """
    Test on setting and getting the dimension.
    """
    set_double_dimension(12345, 10)
    dim = get_double_dimension(10)
    print('the dimension :', dim)

if __name__=="__main__":
    show_dimension()
