"""
Exports the definition of polynomial systems.
"""
from ctypes import c_int, c_double, pointer, create_string_buffer
from version import get_phcfun, int4a2nbr, str2int4a, int4a2str
from dimension import set_double_dimension, get_double_dimension
from dimension import set_double_double_dimension, get_double_double_dimension
from dimension import set_quad_double_dimension, get_quad_double_dimension

def set_double_polynomial(idx, nvr, pol, vrblvl=0):
    """
    Sets the polynomial by the string pol, in double precision,
    with a number of variables no more than nvr, at index idx.
    The index starts at one, not at zero.
    This function does not set the dimension,
    which must be set to a value at least idx.
    """
    if vrblvl > 0:
        print("-> set_double_polynomial, pol = ", pol)
    phc = get_phcfun()
    vrb = (vrblvl > 0)
    apars = int4a2nbr([len(pol), nvr, idx], vrb)
    bpol = str2int4a(pol)
    ccc = pointer(c_double(0.0))
    vlvl = c_int(vrblvl)
    retval = phc(76, apars, bpol, ccc, vlvl)
    if vrblvl > 0:
        print('-> set_double_polynomial return value :', retval)
    return retval

def set_double_double_polynomial(idx, nvr, pol, vrblvl=0):
    """
    Sets the polynomial by the string pol, in double double precision,
    with a number of variables no more than nvr, at index idx.
    The index starts at one, not at zero.
    This function does not set the dimension,
    which must be set to a value at least idx.
    """
    if vrblvl > 0:
        print("-> set_double_double_polynomial, pol = ", pol)
    phc = get_phcfun()
    vrb = (vrblvl > 0)
    apars = int4a2nbr([len(pol), nvr, idx], vrb)
    bpol = str2int4a(pol)
    ccc = pointer(c_double(0.0))
    vlvl = c_int(vrblvl)
    retval = phc(338, apars, bpol, ccc, vlvl)
    if vrblvl > 0:
        print('-> set_double_double_polynomial return value :', retval)
    return retval

def set_quad_double_polynomial(idx, nvr, pol, vrblvl=0):
    """
    Sets the polynomial by the string pol, in quad double precision,
    with a number of variables no more than nvr, at index idx.
    The index starts at one, not at zero.
    This function does not set the dimension,
    which must be set to a value at least idx.
    """
    if vrblvl > 0:
        print("-> set_quad_double_polynomial, pol = ", pol)
    phc = get_phcfun()
    vrb = (vrblvl > 0)
    apars = int4a2nbr([len(pol), nvr, idx], vrb)
    bpol = str2int4a(pol)
    ccc = pointer(c_double(0.0))
    vlvl = c_int(vrblvl)
    retval = phc(388, apars, bpol, ccc, vlvl)
    if vrblvl > 0:
        print('-> set_quad_double_polynomial return value :', retval)
    return retval

def set_double_system(nvr, pols, vrblvl=0):
    """
    Sets the system defines by the strings in pols, in double precision,
    with a number of variables no more than nvr.
    The dimension of the system is set to len(pols).
    Returns the sum of the return values of set_double_polynomial.
    """
    if vrblvl > 0:
        print('-> set_double_system, nvr =', nvr)
    dim = len(pols)
    set_double_dimension(dim, vrblvl)
    result = 0
    for k in range(dim):
        if vrblvl > 0:
            print('-> set_double_system, pols[%d] = %s' % (k, pols[k]))
        retval = set_double_polynomial(k+1, nvr, pols[k], vrblvl)
        if vrblvl > 0:
            print('-> set_double_polynomial returns', retval)
        result = result + retval
    return result

def set_double_double_system(nvr, pols, vrblvl=0):
    """
    Sets the system defines by the strings in pols, in double double precision,
    with a number of variables no more than nvr.
    The dimension of the system is set to len(pols).
    Returns the sum of the return values of set_double_double_polynomial.
    """
    if vrblvl > 0:
        print('-> set_double_double_system, nvr =', nvr)
    dim = len(pols)
    set_double_double_dimension(dim, vrblvl)
    result = 0
    for k in range(dim):
        if vrblvl > 0:
            print('-> set_double_double_system, pols[%d] = %s' % (k, pols[k]))
        retval = set_double_double_polynomial(k+1, nvr, pols[k], vrblvl)
        if vrblvl > 0:
            print('-> set_double_double_polynomial returns', retval)
        result = result + retval
    return result

def set_quad_double_system(nvr, pols, vrblvl=0):
    """
    Sets the system defines by the strings in pols, in quad double precision,
    with a number of variables no more than nvr.
    The dimension of the system is set to len(pols).
    Returns the sum of the return values of set_quad_double_polynomial.
    """
    if vrblvl > 0:
        print('-> set_quad_double_system, nvr =', nvr)
    dim = len(pols)
    set_quad_double_dimension(dim, vrblvl)
    result = 0
    for k in range(dim):
        if vrblvl > 0:
            print('-> set_quad_double_system, pols[%d] = %s' % (k, pols[k]))
        retval = set_quad_double_polynomial(k+1, nvr, pols[k], vrblvl)
        if vrblvl > 0:
            print('-> set_quad_double_polynomial returns', retval)
        result = result + retval
    return result

def get_double_polynomial(idx, vrblvl=0):
    """
    Returns the string representation of the polynomial
    in double precision, at index idx.
    """
    if vrblvl > 0:
        print("-> get_double_polynomial idx = ", idx)
    phc = get_phcfun()
    adx = pointer(c_int(idx))
    bsz = pointer(c_int(0))
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    retval = phc(600, adx, bsz, ccc, vrb)
    if vrblvl > 0:
        print('-> the return value of getting the size :', retval)
        print('-> size of the polynomial :', bsz[0])
    szd = bsz[0]
    poldata = create_string_buffer(b"", 4*szd)
    retval = phc(67, adx, poldata, ccc, vrb)
    if vrblvl > 0:
        print('-> the return value of get_double_polynomial :', retval)
    strpol = int4a2str(poldata, (vrblvl > 0))
    pols = strpol.split(';')
    result = pols[0] + ';'
    return result

def get_double_double_polynomial(idx, vrblvl=0):
    """
    Returns the string representation of the polynomial
    in double double precision, at index idx.
    """
    if vrblvl > 0:
        print("-> get_double_double_polynomial idx = ", idx)
    phc = get_phcfun()
    adx = pointer(c_int(idx))
    bsz = pointer(c_int(0))
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    retval = phc(601, adx, bsz, ccc, vrb)
    if vrblvl > 0:
        print('-> the return value of getting the size :', retval)
        print('-> size of the polynomial :', bsz[0])
    szd = bsz[0]
    poldata = create_string_buffer(b"", 4*szd)
    retval = phc(106, adx, poldata, ccc, vrb)
    if vrblvl > 0:
        print('-> the return value of get_double_double_polynomial :', retval)
    strpol = int4a2str(poldata, (vrblvl > 0))
    pols = strpol.split(';')
    result = pols[0] + ';'
    return result

def get_quad_double_polynomial(idx, vrblvl=0):
    """
    Returns the string representation of the polynomial
    in quad double precision, at index idx.
    """
    if vrblvl > 0:
        print("-> get_quad_double_polynomial idx = ", idx)
    phc = get_phcfun()
    adx = pointer(c_int(idx))
    bsz = pointer(c_int(0))
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    retval = phc(602, adx, bsz, ccc, vrb)
    if vrblvl > 0:
        print('-> the return value of getting the size :', retval)
        print('-> size of the polynomial :', bsz[0])
    szd = bsz[0]
    poldata = create_string_buffer(b"", 4*szd)
    retval = phc(107, adx, poldata, ccc, vrb)
    if vrblvl > 0:
        print('-> the return value of get_quad_double_polynomial :', retval)
    strpol = int4a2str(poldata, (vrblvl > 0))
    pols = strpol.split(';')
    result = pols[0] + ';'
    return result

def get_double_system(vrblvl=0):
    """
    Returns the string representation of the polynomials
    in double precision.
    """
    dim = get_double_dimension(vrblvl)
    if vrblvl > 0:
        print('-> get_double_system, dim =', dim)
    result = []
    for k in range(1, dim+1):
        pol = get_double_polynomial(k, vrblvl)
        print('-> get_double_system, pol =', pol)
        result.append(pol)
    return result

def get_double_double_system(vrblvl=0):
    """
    Returns the string representation of the polynomials
    in double double precision.
    """
    dim = get_double_double_dimension(vrblvl)
    if vrblvl > 0:
        print('-> get_double_double_system, dim =', dim)
    result = []
    for k in range(1, dim+1):
        pol = get_double_double_polynomial(k, vrblvl)
        print('-> get_double_double_system, pol =', pol)
        result.append(pol)
    return result

def get_quad_double_system(vrblvl=0):
    """
    Returns the string representation of the polynomials
    in quad double precision.
    """
    dim = get_quad_double_dimension(vrblvl)
    if vrblvl > 0:
        print('-> get_quad_double_system, dim =', dim)
    result = []
    for k in range(1, dim+1):
        pol = get_quad_double_polynomial(k, vrblvl)
        print('-> get_quad_double_system, pol =', pol)
        result.append(pol)
    return result

def string_of_symbols(maxlen=100, vrblvl=0):
    """
    Returns the list of all symbols (as strings),
    defined when storing polynomials.
    The maxlen on entry equals the maximum number of characters
    in the symbol string, that is: the sequence of all string
    representations of the symbols, separated by one space.
    """
    if vrblvl > 0:
        print('-> string_of_symbols, maxlen :', maxlen)
    phc = get_phcfun()
    slen = pointer(c_int(0))
    ssym = create_string_buffer(b"", maxlen*4)
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    retval = phc(295, slen, ssym, ccc, vrb)
    if vrblvl > 0:
        print('-> string_of_symbols, return value :', retval)
        print('number of characters :', slen[0])
    vars = int4a2str(ssym, (vrblvl > 0))
    result = vars[0:slen[0]].split(' ')
    return result

def number_of_symbols(pols, vrblvl=0):
    """
    Returns the number of symbols that appear as variables
    in the polynomials, givein in the list of strings pols.
    Useful to determine whether a system is square or not.
    """
    if vrblvl > 0:
        print('-> string_of_symbols, pols :')
        for pol in pols:
            print(pol)
    inpols = ''.join(pols)
    phc = get_phcfun()
    slen = pointer(c_int(len(inpols)))
    bpol = str2int4a(inpols)
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    retval = phc(439, slen, bpol, ccc, vrb)
    if vrblvl > 0:
        print('-> number_of_symbols, return value :', retval)
        print('-> number_of_symbols, result :', slen[0])
    return slen[0]

def clear_double_system(vrblvl=0):
    """
    Clears the system set in double precision.
    """
    if vrblvl > 0:
        print('-> clear_double_system', end='')
    phc = get_phcfun()
    adim = pointer(c_int(0))
    bbb = pointer(c_int(0))
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    retval = phc(27, adim, bbb, ccc, vrb)
    if vrblvl > 0:
        print(', return value :', retval)
    return retval

def clear_double_double_system(vrblvl=0):
    """
    Clears the system set in double double precision.
    """
    if vrblvl > 0:
        print('-> clear_double_double_system', end='')
    phc = get_phcfun()
    adim = pointer(c_int(0))
    bbb = pointer(c_int(0))
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    retval = phc(337, adim, bbb, ccc, vrb)
    if vrblvl > 0:
        print(', return value :', retval)
    return retval

def clear_quad_double_system(vrblvl=0):
    """
    Clears the system set in quad double precision.
    """
    if vrblvl > 0:
        print('-> clear_quad_double_system', end='')
    phc = get_phcfun()
    adim = pointer(c_int(0))
    bbb = pointer(c_int(0))
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    retval = phc(387, adim, bbb, ccc, vrb)
    if vrblvl > 0:
        print(', return value :', retval)
    return retval

def initialize_double_syspool(dim, vrblvl=0):
    """
    Initialize the systems pool in double precision with dim.
    """
    if vrblvl > 0:
        print("-> initialize_double_syspool, dim = ", dim)
    phc = get_phcfun()
    adim = pointer(c_int(dim))
    bbb = pointer(c_int(0))
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    retval = phc(300, adim, bbb, ccc, vrb)
    if vrblvl > 0:
        print('-> initialize_double_syspool, return value :', retval)
    return retval

def initialize_double_double_syspool(dim, vrblvl=0):
    """
    Initialize the systems pool in double double precision with dim.
    """
    if vrblvl > 0:
        print("-> initialize_double_double_syspool, dim = ", dim)
    phc = get_phcfun()
    adim = pointer(c_int(dim))
    bbb = pointer(c_int(0))
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    retval = phc(318, adim, bbb, ccc, vrb)
    if vrblvl > 0:
        print('-> initialize_double_double_syspool, return value :', retval)
    return retval

def initialize_quad_double_syspool(dim, vrblvl=0):
    """
    Initialize the systems pool in quad double precision with dim.
    """
    if vrblvl > 0:
        print("-> initialize_quad_double_syspool, dim = ", dim)
    phc = get_phcfun()
    adim = pointer(c_int(dim))
    bbb = pointer(c_int(0))
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    retval = phc(319, adim, bbb, ccc, vrb)
    if vrblvl > 0:
        print('-> initialize_quad_double_syspool, return value :', retval)
    return retval

def size_double_syspool(vrblvl=0):
    """
    Returns the size of the systems pool in double precision.
    """
    if vrblvl > 0:
        print('-> size_double_syspool', end='')
    phc = get_phcfun()
    adim = pointer(c_int(0))
    bbb = pointer(c_int(0))
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    retval = phc(301, adim, bbb, ccc, vrb)
    if vrblvl > 0:
        print(', return value :', retval)
        print('number of systems in the pool :', adim[0])
    return adim[0]

def size_double_double_syspool(vrblvl=0):
    """
    Returns the size of the systems pool in double double precision.
    """
    if vrblvl > 0:
        print('-> size_double_double_syspool', end='')
    phc = get_phcfun()
    adim = pointer(c_int(0))
    bbb = pointer(c_int(0))
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    retval = phc(316, adim, bbb, ccc, vrb)
    if vrblvl > 0:
        print(', return value :', retval)
        print('number of systems in the pool :', adim[0])
    return adim[0]

def size_quad_double_syspool(vrblvl=0):
    """
    Returns the size of the systems pool in quad double precision.
    """
    if vrblvl > 0:
        print('-> size_quad_double_syspool,', end='')
    phc = get_phcfun()
    adim = pointer(c_int(0))
    bbb = pointer(c_int(0))
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    retval = phc(317, adim, bbb, ccc, vrb)
    if vrblvl > 0:
        print(', return value :', retval)
        print('number of systems in the pool :', adim[0])
    return adim[0]

def copy_to_double_syspool(idx, vrblvl=0):
    """
    Copies the system set in double precision to position idx
    in the systems pool.
    """
    if vrblvl > 0:
        print('-> copy_to_double_syspool, idx =', idx)
    phc = get_phcfun()
    adim = pointer(c_int(idx))
    bbb = pointer(c_int(0))
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    retval = phc(304, adim, bbb, ccc, vrb)
    if vrblvl > 0:
        print('-> copy_to_double_syspool, return value :', retval)
    return retval

def copy_to_double_double_syspool(idx, vrblvl=0):
    """
    Copies the system set in double double precision to position idx
    in the systems pool.
    """
    if vrblvl > 0:
        print('-> copy_to_double_double_syspool, idx =', idx)
    phc = get_phcfun()
    adim = pointer(c_int(idx))
    bbb = pointer(c_int(0))
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    retval = phc(608, adim, bbb, ccc, vrb)
    if vrblvl > 0:
        print('-> copy_to_double_double_syspool, return value :', retval)
    return retval

def copy_to_quad_double_syspool(idx, vrblvl=0):
    """
    Copies the system set in quad double precision to position idx
    in the systems pool.
    """
    if vrblvl > 0:
        print('-> copy_to_quad_double_syspool, idx =', idx)
    phc = get_phcfun()
    adim = pointer(c_int(idx))
    bbb = pointer(c_int(0))
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    retval = phc(609, adim, bbb, ccc, vrb)
    if vrblvl > 0:
        print('-> copy_to_quad_double_syspool, return value :', retval)
    return retval

def copy_from_double_syspool(idx, vrblvl=0):
    """
    Copies the system in double precision at position idx
    in the systems pool to the defined system in double precision.
    """
    if vrblvl > 0:
        print('-> copy_from_double_syspool, idx =', idx)
    phc = get_phcfun()
    adim = pointer(c_int(idx))
    bbb = pointer(c_int(0))
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    retval = phc(313, adim, bbb, ccc, vrb)
    if vrblvl > 0:
        print('-> copy_from_double_syspool, return value :', retval)
    return retval

def copy_from_double_double_syspool(idx, vrblvl=0):
    """
    Copies the system in double double precision at position idx
    in the systems pool to the defined system in double double precision.
    """
    if vrblvl > 0:
        print('-> copy_from_double_double_syspool, idx =', idx)
    phc = get_phcfun()
    adim = pointer(c_int(idx))
    bbb = pointer(c_int(0))
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    retval = phc(314, adim, bbb, ccc, vrb)
    if vrblvl > 0:
        print('-> copy_from_double_double_syspool, return value :', retval)
    return retval

def copy_from_quad_double_syspool(idx, vrblvl=0):
    """
    Copies the system in quad double precision at position idx
    in the systems pool to the defined system in quad double precision.
    """
    if vrblvl > 0:
        print('-> copy_from_quad_double_syspool, idx =', idx)
    phc = get_phcfun()
    adim = pointer(c_int(idx))
    bbb = pointer(c_int(0))
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    retval = phc(315, adim, bbb, ccc, vrb)
    if vrblvl > 0:
        print('-> copy_from_quad_double_syspool, return value :', retval)
    return retval

def clear_double_syspool(vrblvl=0):
    """
    Clears the systems pool in double precision.
    """
    if vrblvl > 0:
        print('-> clear_double_syspool', end='')
    phc = get_phcfun()
    adim = pointer(c_int(0))
    bbb = pointer(c_int(0))
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    retval = phc(697, adim, bbb, ccc, vrb)
    if vrblvl > 0:
        print(', return value :', retval)
    return retval

def clear_double_double_syspool(vrblvl=0):
    """
    Clears the systems pool in double double precision.
    """
    if vrblvl > 0:
        print('-> clear_double_double_syspool', end='')
    phc = get_phcfun()
    adim = pointer(c_int(0))
    bbb = pointer(c_int(0))
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    retval = phc(698, adim, bbb, ccc, vrb)
    if vrblvl > 0:
        print(', return value :', retval)
    return retval

def clear_quad_double_syspool(vrblvl=0):
    """
    Clears the systems pool in quad double precision.
    """
    if vrblvl > 0:
        print('-> clear_quad_double_syspool', end='')
    phc = get_phcfun()
    adim = pointer(c_int(0))
    bbb = pointer(c_int(0))
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    retval = phc(699, adim, bbb, ccc, vrb)
    if vrblvl > 0:
        print(', return value :', retval)
    return retval

def test_double_polynomial():
    """
    Tests the setting and getting of a polynomial,
    in double precision.
    """
    lvl = 10
    set_double_dimension(2, lvl)
    dim = get_double_dimension(lvl)
    print('the dimension :', dim)
    # org = "x*y - 1;"
    org = ";"
    idx = 1
    set_double_polynomial(idx, dim, org, lvl)
    pol = get_double_polynomial(idx, lvl)
    print('the retrieved polynomial :', pol)
    smb = string_of_symbols(100,lvl)
    print('the list of symbols :', smb)

def test_double_double_polynomial():
    """
    Tests the setting and getting of a polynomial,
    in double double precision.
    """
    lvl = 10
    set_double_double_dimension(2, lvl)
    dim = get_double_double_dimension(lvl)
    print('the dimension :', dim)
    org = "x*y - 1;"
    idx = 1
    set_double_double_polynomial(idx, dim, org, lvl)
    pol = get_double_double_polynomial(idx, lvl)
    print('the retrieved polynomial :', pol)

def test_quad_double_polynomial():
    """
    Tests the setting and getting of a polynomial,
    in quad double precision.
    """
    lvl = 10
    set_quad_double_dimension(2, lvl)
    dim = get_quad_double_dimension(lvl)
    print('the dimension :', dim)
    org = "x*y - 1;"
    idx = 1
    set_quad_double_polynomial(idx, dim, org, lvl)
    pol = get_quad_double_polynomial(idx, lvl)
    print('the retrieved polynomial :', pol)

def test_double_system():
    """
    Tests the setting and getting of a system,
    in double precision.
    """
    lvl = 10
    polynomials = ["x^3 + 2*x*y - 1;", "x + y - 1;", "x - 1;"]
    dim = number_of_symbols(polynomials, lvl)
    print('number of symbols :', dim)
    if dim == len(polynomials):
        print('The system is square.')
    else:
        print('number of polynomials :', len(polynomials))
        print('  number of variables :', dim)
        print('The system is not square.')
    set_double_system(dim, polynomials, lvl)
    pols = get_double_system(lvl)
    print('the retrieved polynomials :')
    for pol in pols:
        print(pol)

def test_double_double_system():
    """
    Tests the setting and getting of a system,
    in double double precision.
    """
    lvl = 10
    polynomials = ["x^3 + 2*x*y - 1;", "x + y - 1/3;", "x - 1;"]
    dim = number_of_symbols(polynomials, lvl)
    print('number of symbols :', dim)
    if dim == len(polynomials):
        print('The system is square.')
    else:
        print('number of polynomials :', len(polynomials))
        print('  number of variables :', dim)
        print('The system is not square.')
    set_double_double_system(dim, polynomials, lvl)
    pols = get_double_double_system(lvl)
    print('the retrieved polynomials :')
    for pol in pols:
        print(pol)

def test_quad_double_system():
    """
    Tests the setting and getting of a system,
    in quad double precision.
    """
    lvl = 10
    polynomials = ["x^3 + 2*x*y - 1;", "x + y - 1/3;", "y - 1;"]
    dim = number_of_symbols(polynomials, lvl)
    print('number of symbols :', dim)
    if dim == len(polynomials):
        print('The system is square.')
    else:
        print('number of polynomials :', len(polynomials))
        print('  number of variables :', dim)
        print('The system is not square.')
    set_quad_double_system(dim, polynomials, lvl)
    pols = get_quad_double_system(lvl)
    print('the retrieved polynomials :')
    for pol in pols:
        print(pol)

def test_double_syspool():
    """
    Tests the systems pool in double precision.
    """
    lvl = 10
    initialize_double_syspool(3, lvl)
    dim = size_double_syspool(lvl)
    print('The size of the systems pool :', dim)
    pol1 = ['t - 1;']
    set_double_system(1, pol1, lvl)
    copy_to_double_syspool(1)
    pol2 = ['t - 2;']
    set_double_system(1, pol2, lvl)
    copy_to_double_syspool(2)
    pol3 = ['t - 3;']
    set_double_system(1, pol3, lvl)
    copy_to_double_syspool(3)
    for i in range(1, dim+1):
        clear_double_system(lvl)
        copy_from_double_syspool(i)
        pols = get_double_system(lvl)
        print('system at', i, 'in the pool :', pols)
    clear_double_syspool(lvl)

def test_double_double_syspool():
    """
    Tests the systems pool in double double precision.
    """
    lvl = 10
    initialize_double_double_syspool(3, lvl)
    dim = size_double_double_syspool(lvl)
    print('The size of the systems pool :', dim)
    pol1 = ['t - 1/3;']
    set_double_double_system(1, pol1, lvl)
    copy_to_double_double_syspool(1)
    pol2 = ['t - 2/3;']
    set_double_double_system(1, pol2, lvl)
    copy_to_double_double_syspool(2)
    pol3 = ['t - 1;']
    set_double_double_system(1, pol3, lvl)
    copy_to_double_double_syspool(3)
    for i in range(1, dim+1):
        clear_double_double_system(lvl)
        copy_from_double_double_syspool(i)
        pols = get_double_double_system(lvl)
        print('system at', i, 'in the pool :', pols)
    clear_double_double_syspool(lvl)

def test_quad_double_syspool():
    """
    Tests the systems pool in quad double precision.
    """
    lvl = 10
    initialize_quad_double_syspool(3, lvl)
    dim = size_quad_double_syspool(lvl)
    print('The size of the systems pool :', dim)
    pol1 = ['t - 1/3;']
    set_quad_double_system(1, pol1, lvl)
    copy_to_quad_double_syspool(1)
    pol2 = ['t - 2/3;']
    set_quad_double_system(1, pol2, lvl)
    copy_to_quad_double_syspool(2)
    pol3 = ['t - 1;']
    set_quad_double_system(1, pol3, lvl)
    copy_to_quad_double_syspool(3)
    for i in range(1, dim+1):
        clear_quad_double_system(lvl)
        copy_from_quad_double_syspool(i)
        pols = get_quad_double_system(lvl)
        print('system at', i, 'in the pool :', pols)
    clear_quad_double_syspool(lvl)

if __name__=="__main__":
    test_double_polynomial()
    # test_double_system()
    # test_double_double_system()
    # test_quad_double_system()
    # test_double_syspool()
    # test_double_double_syspool()
    # test_quad_double_syspool()
