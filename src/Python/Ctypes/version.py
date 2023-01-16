"""
Tests the retrieval of the version string of the PHCpack library,
using ctypes, in a platform independent manner.
The function getPHCmod() returns the library module for the three
supported platforms.  The functions int4a2str() and str2int4a()
convert integer arrays to strings and string to integer arrays,
using the ctypes string buffer type.
"""
# relative location of the PHCpack library
LOCATION = "../../lib"

import ctypes
from ctypes import c_int, c_double, pointer
from ctypes import create_string_buffer, sizeof

def getPHCmod():
    """
    Returns the proper module according to the platform.
    For the correct 
    """
    import sys
    if 'linux' in sys.platform:
        LIBPHCPACK = LOCATION + "/libPHCpack.so"
        modPHCpack = ctypes.CDLL(LIBPHCPACK)
        return modPHCpack
    elif 'darwin' in sys.platform:
        LIBPHCPACK = LOCATION + "/libPHCpack.dylib"
        modPHCpack = ctypes.CDLL(LIBPHCPACK)
        return modPHCpack
    elif 'win' in sys.platform:
        LIBPHCPACK = LOCATION + "/libPHCpack.dll"
        modPHCpack = ctypes.WinDLL(LIBPHCPACK, winmode=0)
        return modPHCpack
    else:
        print('The platform', sys.platform, 'is not supported.')
        return None

def int4a2str(data, verbose=False):
    """
    Given in data is an integer array stored as a ctypes string buffer,
    returns the string which represent the data.
    The '4a' refers to the 4-byte (or 32-bit) integer array.
    If verbose, then results of intermediate steps are printed,
    otherwise, the function remains silent.
    """
    from ctypes import sizeof
    if verbose:
        print('-> int4a2str, data is', data)
    szd = sizeof(data)
    if verbose:
        print('-> int4a2str, size of the data is', szd)
    dim = szd//4
    if verbose:
        print('-> int4a2str, number of characters :', dim)
    result = ""
    for k in range(dim):
        result = result + data[4*k].decode()
    if verbose:
        print('-> int4a2str returns', result)
    return result

def str2int4a(data, verbose=False):
    """
    Given in data is a string, stored as a Python string,
    returns the 32-bit integer array representation,
    stored as a ctypes string buffer.
    If verbose, then results of intermediate steps are printed,
    otherwise, the function remains silent.
    """
    from ctypes import create_string_buffer
    if verbose:
        print('-> str2int4a, data is', data)
    dim = len(data)
    if verbose:
        print('-> str2int4a, size of the data is', dim)
    szd = 4*dim
    result = create_string_buffer(szd)
    for k in range(dim):
        result[4*k] = data[k].encode()
    if verbose:
        print('-> str2int4a returns', result)
    return result

def version(verbose=True):
    """
    Returns the version string of PHCpack.
    If verbose, then the conversions between strings and integer arrays
    are verified via the ctypes string buffer types.
    """
    modPHCpack = getPHCmod()
    f = modPHCpack._ada_use_c2phc
    a = pointer(c_int(0))
    b = create_string_buffer(30*4)
    c = pointer(c_double(0.0))
    if verbose:
        r = f(999, a, b, c, 2)
    else:
        r = f(999, a, b, c, 0)
    if verbose:
        print('return value :', r)
        print('a :', a[0])
        print('sizeof(b) :', sizeof(b))
    result = int4a2str(b, True)
    if verbose:
         print(result)
    if verbose:
         print('version checks conversions ...')
         bb = str2int4a(result, True)
         sb = int4a2str(bb)
         print(sb)
    return result

if __name__=="__main__":
    print(version(True))
