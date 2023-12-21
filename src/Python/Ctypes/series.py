"""
Exports functions to compute series of solution curves defined by
polynomial homotopies using Newton's method.
"""

from ctypes import c_int, c_double, pointer
from version import get_phcfun, int4a2nbr, nbr2int4a
from polynomials import string_of_symbols, number_of_symbols
from polynomials import set_double_system, get_double_system
from polynomials import set_double_double_system, get_double_double_system
from polynomials import set_quad_double_system, get_quad_double_system
from polynomials import copy_from_double_syspool, copy_to_double_syspool
from polynomials import initialize_double_syspool, size_double_syspool
from polynomials import clear_double_syspool
from polynomials import initialize_double_double_syspool
from polynomials import copy_from_double_double_syspool
from polynomials import copy_to_double_double_syspool
from polynomials import size_double_double_syspool
from polynomials import clear_double_double_syspool
from polynomials import initialize_quad_double_syspool
from polynomials import copy_from_quad_double_syspool
from polynomials import copy_to_quad_double_syspool
from polynomials import size_quad_double_syspool
from polynomials import clear_quad_double_syspool
from solutions import make_solution
from solutions import set_double_solutions
from solutions import set_double_double_solutions
from solutions import set_quad_double_solutions
from solver import write_double_solutions
from solver import write_double_double_solutions
from solver import write_quad_double_solutions

def replace_symbol(pol, idx):
    """
    In the polynomial pol, 
    replaces the first symbol by the symbol at place idx.
    """
    var = string_of_symbols()
    result = pol.replace(var[0], var[idx-1])
    return result

def substitute_symbol(pols, idx):
    """
    Given in pols is a list of polynomials,
    replaces the first symbol by the symbol at place idx.
    """
    if idx == 1:
        return pols
    result = []
    for pol in pols:
        result.append(replace_symbol(pol, idx))
    return result

def double_newton_at_point(pols, sols, idx=1, maxdeg=4, nbr=4, vrblvl=0):
    r"""
    Computes series in double precision for the polynomials
    in *pols*, where the leading coefficients are the solutions in *sols*.
    On entry are the following five parameters:

    *pols*: a list of string representations of polynomials,

    *sols*: a list of regular solutions of the polynomials in pols,

    *idx*: index of the series parameter, by default equals 1,

    *maxdeg*: maximal degree of the series,

    *nbr*: number of steps with Newton's method,

    *vrblvl*: the verbose level.

    On return is a list of lists of strings.  Each lists of strings
    represents the series solution for the variables in the list *pols*.
    """
    nbsym = number_of_symbols(pols, vrblvl)
    if vrblvl > 0:
        print('-> double_newton_at_point, idx :', idx)
        print('-> double_newton_at_point, the polynomials :')
        for pol in pols:
            print(pol)
        print('number of variables :', nbsym)
    set_double_system(nbsym, pols, vrblvl)
    set_double_solutions(nbsym, sols, vrblvl)
    syspol = get_double_system(vrblvl)
    for pol in syspol:
        print(pol)
    write_double_solutions(vrblvl)
    phc = get_phcfun()
    apars = int4a2nbr([idx, maxdeg, nbr], (vrblvl > 0))
    bbb = pointer(c_int(vrblvl))
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    if vrblvl > 0:
        print('-> double_newton_at_point calls phc ...')
        print('apars =', nbr2int4a(apars))
    retval = phc(691, apars, bbb, ccc, vrb)
    fail = retval > 0
    size = (-1 if fail else size_double_syspool(vrblvl))
    if vrblvl > 0:
        print('the return value of double_newton_at_point :', retval)
        if size == -1:
            print("An error occurred in the execution of Newton's method.")
        else:
            print('Computed %d series solutions.' % size)
    result = []
    for k in range(1, size+1):
        if vrblvl > 0:
            print('')
            print('retrieving series', k, '...')
            print('')
        copy_from_double_syspool(k)
        sersol = get_double_system(vrblvl)
        result.append(substitute_symbol(sersol, idx))
    return result

def double_double_newton_at_point(pols, sols, idx=1, maxdeg=4, nbr=4, vrblvl=0):
    r"""
    Computes series in double double precision for the polynomials
    in *pols*, where the leading coefficients are the solutions in *sols*.
    On entry are the following five parameters:

    *pols*: a list of string representations of polynomials,

    *sols*: a list of regular solutions of the polynomials in pols,

    *idx*: index of the series parameter, by default equals 1,

    *maxdeg*: maximal degree of the series,

    *nbr*: number of steps with Newton's method,

    *vrblvl*: the verbose level.

    On return is a list of lists of strings.  Each lists of strings
    represents the series solution for the variables in the list *pols*.
    """
    nbsym = number_of_symbols(pols, vrblvl)
    if vrblvl > 0:
        print('-> double_double_newton_at_point, idx :', idx)
        print('-> double_double_newton_at_point, the polynomials :')
        for pol in pols:
            print(pol)
        print('number of variables :', nbsym)
    set_double_double_system(nbsym, pols, vrblvl)
    set_double_double_solutions(nbsym, sols)
    syspol = get_double_double_system(vrblvl)
    for pol in syspol:
        print(pol)
    write_double_double_solutions(vrblvl)
    phc = get_phcfun()
    apars = int4a2nbr([idx, maxdeg, nbr], (vrblvl > 0))
    bbb = pointer(c_int(vrblvl))
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    if vrblvl > 0:
        print('-> double_double_newton_series calls phc ...')
        print('apars =', nbr2int4a(apars))
    retval = phc(692, apars, bbb, ccc, vrb)
    fail = retval > 0
    size = (-1 if fail else size_double_double_syspool(vrblvl))
    if vrblvl > 0:
        print('the return value of double_double_newton_at_point :', retval)
        if size == -1:
            print("An error occurred in the execution of Newton's method.")
        else:
            print('Computed %d series solutions.' % size)
    result = []
    for k in range(1, size+1):
        if vrblvl > 0:
            print('')
            print('retrieving series', k, '...')
            print('')
        copy_from_double_double_syspool(k)
        sersol = get_double_double_system(vrblvl)
        result.append(substitute_symbol(sersol, idx))
    return result

def quad_double_newton_at_point(pols, sols, idx=1, maxdeg=4, nbr=4, vrblvl=0):
    r"""
    Computes series in quad double precision for the polynomials
    in *pols*, where the leading coefficients are the solutions in *sols*.
    On entry are the following five parameters:

    *pols*: a list of string representations of polynomials,

    *sols*: a list of solutions of the polynomials in pols,

    *idx*: index of the series parameter, by default equals 1,

    *maxdeg*: maximal degree of the series,

    *nbr*: number of steps with Newton's method,

    *vrblvl*: the verbose level.

    On return is a list of lists of strings.  Each lists of strings
    represents the series solution for the variables in the list *pols*.
    """
    nbsym = number_of_symbols(pols, vrblvl)
    if vrblvl > 0:
        print('-> quad_double_newton_at_point, idx :', idx)
        print('-> quad_double_newton_at_point, the polynomials :')
        for pol in pols:
            print(pol)
        print('number of variables :', nbsym)
    set_quad_double_system(nbsym, pols, vrblvl)
    set_quad_double_solutions(nbsym, sols)
    syspol = get_quad_double_system(vrblvl)
    for pol in syspol:
        print(pol)
    write_quad_double_solutions(vrblvl)
    phc = get_phcfun()
    apars = int4a2nbr([idx, maxdeg, nbr], (vrblvl > 0))
    bbb = pointer(c_int(vrblvl))
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    if vrblvl > 0:
        print('-> quad_double_newton_at_point calls phc ...')
        print('apars =', nbr2int4a(apars))
    retval = phc(693, apars, bbb, ccc, vrb)
    fail = retval > 0
    size = (-1 if fail else size_quad_double_syspool(vrblvl))
    if vrblvl > 0:
        print('the return value of quad_double_newton_at_point :', retval)
        if size == -1:
            print("An error occurred in the execution of Newton's method.")
        else:
            print('Computed %d series solutions.' % size)
    result = []
    for k in range(1, size+1):
        if vrblvl > 0:
            print('')
            print('retrieving series', k, '...')
            print('')
        copy_from_quad_double_syspool(k)
        sersol = get_quad_double_system(vrblvl)
        result.append(substitute_symbol(sersol, idx))
    return result

def checkin_newton_at_series(nbsym, lser, idx):
    """
    Given in nbsym the number of symbols in the polynomial system,
    in lser the list of leading terms in the series and 
    in idx the index of the parameter, returns True
    if nbsym = len(lser) if idx == 0, or otherwise
    if nbsym = len(lser) + 1 if idx != 0.
    An error message is written and False is returned
    if the above conditions are not satisfied.
    """
    if idx == 0:
        okay = nbsym == len(lser)
    else:
        okay = nbsym == len(lser) + 1
    if not okay:
        if idx == 0:
            dim = nbsym
        else:
            dim = nbsym - 1
        print('Wrong length of list of leading terms, should be', \
            str(dim) + '.')
    return okay

def double_newton_at_series(pols, lser, idx=1, maxdeg=4, nbr=4, \
    checkin=True, vrblvl=0):
    r"""
    Computes series in double precision for the polynomials
    in *pols*, where the leading terms are given in the list *lser*.
    On entry are the following five parameters:

    *pols*: a list of string representations of polynomials,

    *lser*: a list of polynomials in the series parameter (e.g.: t),
    for use as start terms in Newton's method,

    *idx*: index of the series parameter, by default equals 1,

    *maxdeg*: maximal degree of the series,

    *nbr*: number of steps with Newton's method,

    *checkin*: checks whether the number of symbols in pols matches
    the length of the list lser if idx == 0, or is one less than 
    the length of the list lser if idx != 0.  If the conditions are
    not satisfied, then an error message is printed and lser is returned.

    *vrblvl*: is the verbose level.

    On return is a list of lists of strings.  Each lists of strings
    represents the series solution for the variables in the list *pols*.
    """
    nbsym = number_of_symbols(pols)
    if vrblvl > 0:
        print("the polynomials :")
        for pol in pols:
            print(pol)
        print("Number of variables :", nbsym)
    if checkin:
        if not checkin_newton_at_series(nbsym, lser, idx):
            return lser
    set_double_system(1, lser)
    initialize_double_syspool(1, vrblvl)
    copy_to_double_syspool(1, vrblvl)
    set_double_system(nbsym, pols)
    phc = get_phcfun()
    apars = int4a2nbr([idx, maxdeg, nbr], (vrblvl > 0))
    bbb = pointer(c_int(vrblvl))
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    if vrblvl > 0:
        print('-> double_newton_at_series calls phc ...')
        print('apars =', nbr2int4a(apars))
    retval = phc(694, apars, bbb, ccc, vrb)
    fail = retval > 0
    size = (-1 if fail else size_double_syspool(vrblvl))
    if vrblvl > 0:
        if size == -1:
            print("An error occurred in the execution of Newton's method.")
        else:
            print("Computed one series solution.")
    copy_from_double_syspool(1, vrblvl)
    result = get_double_system()
    result = substitute_symbol(result, idx)
    clear_double_syspool(vrblvl)
    return result

def double_double_newton_at_series(pols, lser, idx=1, maxdeg=4, nbr=4, \
    checkin=True, vrblvl=0):
    r"""
    Computes series in double double precision for the polynomials
    in *pols*, where the leading terms are given in the list *lser*.
    On entry are the following five parameters:

    *pols*: a list of string representations of polynomials,

    *lser*: a list of polynomials in the series parameter (e.g.: t),
    for use as start terms in Newton's method,

    *idx*: index of the series parameter, by default equals 1,

    *maxdeg*: maximal degree of the series,

    *nbr*: number of steps with Newton's method,

    *checkin*: checks whether the number of symbols in pols matches
    the length of the list lser if idx == 0, or is one less than 
    the length of the list lser if idx != 0.  If the conditions are
    not satisfied, then an error message is printed and lser is returned.

    *vrblvl*: is the verbose level.

    On return is a list of lists of strings.  Each lists of strings
    represents the series solution for the variables in the list *pols*.
    """
    nbsym = number_of_symbols(pols)
    if vrblvl > 0:
        print("the polynomials :")
        for pol in pols:
            print(pol)
        print("Number of variables :", nbsym)
    if checkin:
        if not checkin_newton_at_series(nbsym, lser, idx):
            return lser
    set_double_double_system(1, lser)
    initialize_double_double_syspool(1, vrblvl)
    copy_to_double_double_syspool(1, vrblvl)
    set_double_double_system(nbsym, pols)
    phc = get_phcfun()
    apars = int4a2nbr([idx, maxdeg, nbr], (vrblvl > 0))
    bbb = pointer(c_int(vrblvl))
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    if vrblvl > 0:
        print('-> double_double_newton_at_series calls phc ...')
        print('apars =', nbr2int4a(apars))
    retval = phc(695, apars, bbb, ccc, vrb)
    fail = retval > 0
    size = (-1 if fail else size_double_double_syspool(vrblvl))
    if vrblvl > 0:
        if size == -1:
            print("An error occurred in the execution of Newton's method.")
        else:
            print("Computed one series solution.")
    copy_from_double_double_syspool(1, vrblvl)
    result = get_double_double_system()
    result = substitute_symbol(result, idx)
    clear_double_double_syspool(vrblvl)
    return result

def quad_double_newton_at_series(pols, lser, idx=1, maxdeg=4, nbr=4, \
    checkin=True, vrblvl=0):
    r"""
    Computes series in quad double precision for the polynomials
    in *pols*, where the leading terms are given in the list *lser*.
    On entry are the following five parameters:

    *pols*: a list of string representations of polynomials,

    *lser*: a list of polynomials in the series parameter (e.g.: t),
    for use as start terms in Newton's method,

    *idx*: index of the series parameter, by default equals 1,

    *maxdeg*: maximal degree of the series,

    *nbr*: number of steps with Newton's method,

    *checkin*: checks whether the number of symbols in pols matches
    the length of the list lser if idx == 0, or is one less than 
    the length of the list lser if idx != 0.  If the conditions are
    not satisfied, then an error message is printed and lser is returned.

    *vrblvl*: is the verbose level.

    On return is a list of lists of strings.  Each lists of strings
    represents the series solution for the variables in the list *pols*.
    """
    nbsym = number_of_symbols(pols)
    if vrblvl > 0:
        print("the polynomials :")
        for pol in pols:
            print(pol)
        print("Number of variables :", nbsym)
    if checkin:
        if not checkin_newton_at_series(nbsym, lser, idx):
            return lser
    set_quad_double_system(1, lser)
    initialize_quad_double_syspool(1, vrblvl)
    copy_to_quad_double_syspool(1, vrblvl)
    set_quad_double_system(nbsym, pols)
    phc = get_phcfun()
    apars = int4a2nbr([idx, maxdeg, nbr], (vrblvl > 0))
    bbb = pointer(c_int(vrblvl))
    ccc = pointer(c_double(0.0))
    vrb = c_int(vrblvl)
    if vrblvl > 0:
        print('-> quad_double_newton_at_series calls phc ...')
        print('apars =', nbr2int4a(apars))
    retval = phc(696, apars, bbb, ccc, vrb)
    fail = retval > 0
    size = (-1 if fail else size_quad_double_syspool(vrblvl))
    if vrblvl > 0:
        if size == -1:
            print("An error occurred in the execution of Newton's method.")
        else:
            print("Computed one series solution.")
    copy_from_quad_double_syspool(1, vrblvl)
    result = get_quad_double_system()
    result = substitute_symbol(result, idx)
    clear_quad_double_syspool(vrblvl)
    return result

def test_double_viviani_at_point(vrblvl=0):
    """
    Returns the system which stores the Viviani curve,
    with some solutions intersected with a plane,
    in double precision.
    """
    pols = ['(1-s)*y + s*(y-1);', \
            'x^2 + y^2 + z^2 - 4;' , \
            '(x-1)^2 + y^2 - 1;', \
            's;']
    variables = ['s', 'x', 'y', 'z']
    values = [0, 0, 0, 2]
    sols = [make_solution(variables, values)]
    print("The solutions on the Viviani curve :")
    for sol in sols:
        print(sol)
    sersols = double_newton_at_point(pols[:3], sols, vrblvl=vrblvl)
    print('the solution series :')
    newvars = ['y', 'x', 'z']
    for srs in sersols:
        for (var, pol) in zip(newvars, srs):
            print(var, '=', pol)
    fail = len(sersols) != 1
    return fail

def test_double_double_viviani_at_point(vrblvl=0):
    """
    Returns the system which stores the Viviani curve,
    with some solutions intersected with a plane,
    in double double precision.
    """
    pols = ['(1-s)*y + s*(y-1);', \
            'x^2 + y^2 + z^2 - 4;' , \
            '(x-1)^2 + y^2 - 1;', \
            's;']
    variables = ['s', 'x', 'y', 'z']
    values = [0, 0, 0, 2]
    sols = [make_solution(variables, values)]
    print("The solutions on the Viviani curve :")
    for sol in sols:
        print(sol)
    sersols = double_double_newton_at_point(pols[:3], sols, vrblvl=vrblvl)
    print('the solution series :')
    newvars = ['y', 'x', 'z']
    for srs in sersols:
        for (var, pol) in zip(newvars, srs):
            print(var, '=', pol)
    fail = len(sersols) != 1
    return fail

def test_quad_double_viviani_at_point(vrblvl=0):
    """
    Returns the system which stores the Viviani curve,
    with some solutions intersected with a plane,
    in quad double precision.
    """
    pols = ['(1-s)*y + s*(y-1);', \
            'x^2 + y^2 + z^2 - 4;' , \
            '(x-1)^2 + y^2 - 1;', \
            's;']
    variables = ['s', 'x', 'y', 'z']
    values = [0, 0, 0, 2]
    sols = [make_solution(variables, values)]
    print("The solutions on the Viviani curve :")
    for sol in sols:
        print(sol)
    sersols = quad_double_newton_at_point(pols[:3], sols, vrblvl=vrblvl)
    print('the solution series :')
    newvars = ['y', 'x', 'z']
    for srs in sersols:
        for (var, pol) in zip(newvars, srs):
            print(var, '=', pol)
    fail = len(sersols) != 1
    return fail

def test_double_viviani_at_series(vrblvl=0):
    """
    Computes the power series expansion for the Viviani curve,
    from a natural parameter perspective, in double precision.
    """
    pols = [ '2*t^2 - x;', \
             'x^2 + y^2 + z^2 - 4;' , \
             '(x-1)^2 + y^2 - 1;']
    lser = [ '2*t^2;', '2*t;', '2;']
    nser = double_newton_at_series(pols, lser, maxdeg=12, nbr=8, vrblvl=vrblvl)
    variables = ['x', 'y', 'z']
    for (var, pol) in zip(variables, nser):
        print(var, '=', pol)
    fail = not len(nser) == 3
    return fail

def test_double_double_viviani_at_series(vrblvl=0):
    """
    Computes the power series expansion for the Viviani curve,
    from a natural parameter perspective, in double double precision.
    """
    pols = [ '2*t^2 - x;', \
             'x^2 + y^2 + z^2 - 4;' , \
             '(x-1)^2 + y^2 - 1;']
    lser = [ '2*t^2;', '2*t;', '2;']
    nser = double_double_newton_at_series(pols, lser, \
        maxdeg=12, nbr=8, vrblvl=vrblvl)
    variables = ['x', 'y', 'z']
    for (var, pol) in zip(variables, nser):
        print(var, '=', pol)
    fail = not len(nser) == 3
    return fail

def test_quad_double_viviani_at_series(vrblvl=0):
    """
    Computes the power series expansion for the Viviani curve,
    from a natural parameter perspective, in quad double precision.
    """
    pols = [ '2*t^2 - x;', \
             'x^2 + y^2 + z^2 - 4;' , \
             '(x-1)^2 + y^2 - 1;']
    lser = [ '2*t^2;', '2*t;', '2;']
    nser = quad_double_newton_at_series(pols, lser, \
        maxdeg=12, nbr=8, vrblvl=vrblvl)
    variables = ['x', 'y', 'z']
    for (var, pol) in zip(variables, nser):
        print(var, '=', pol)
    fail = not len(nser) == 3
    return fail

def test_double_apollonius_at_series(vrblvl=0):
    """
    Tests Newton's method starting at a series
    for the problem of Apollonius, in double precision.
    The parameter t is the fourth variable, whence we call
    Newton's method with idx equal to four.
    """
    pols = [ 'x1^2 + 3*x2^2 - r^2 - 2*r - 1;', \
             'x1^2 + 3*x2^2 - r^2 - 4*x1 - 2*r + 3;', \
       '3*t^2 + x1^2 - 6*t*x2 + 3*x2^2 - r^2 + 6*t - 2*x1 - 6*x2 + 2*r + 3;']
    lser1 = ['1;', '1 + 0.536*t;', '1 + 0.904*t;']
    lser2 = ['1;', '1 + 7.464*t;', '1 + 11.196*t;']
    nser1 = double_newton_at_series(pols, lser1, idx=4, nbr=7, vrblvl=vrblvl)
    nser2 = double_newton_at_series(pols, lser2, idx=4, nbr=7, vrblvl=vrblvl)
    variables = ['x', 'y', 'z']
    print('the first solution series :')
    for (var, pol) in zip(variables, nser1):
        print(var, '=', pol)
    print('the second solution series :')
    for (var, pol) in zip(variables, nser2):
        print(var, '=', pol)
    fail1 = not len(nser1) == 3
    fail2 = not len(nser1) == 3
    return fail1 + fail2

def test_double_double_apollonius_at_series(vrblvl=0):
    """
    Tests Newton's method starting at a series
    for the problem of Apollonius, in double double precision.
    The parameter t is the fourth variable, whence we call
    Newton's method with idx equal to four.
    """
    pols = [ 'x1^2 + 3*x2^2 - r^2 - 2*r - 1;', \
             'x1^2 + 3*x2^2 - r^2 - 4*x1 - 2*r + 3;', \
       '3*t^2 + x1^2 - 6*t*x2 + 3*x2^2 - r^2 + 6*t - 2*x1 - 6*x2 + 2*r + 3;']
    lser1 = ['1;', '1 + 0.536*t;', '1 + 0.904*t;']
    lser2 = ['1;', '1 + 7.464*t;', '1 + 11.196*t;']
    nser1 = double_double_newton_at_series(pols, lser1,\
        idx=4, nbr=7, vrblvl=vrblvl)
    nser2 = double_newton_at_series(pols, lser2, idx=4,\
        nbr=7, vrblvl=vrblvl)
    variables = ['x', 'y', 'z']
    print('the first solution series :')
    for (var, pol) in zip(variables, nser1):
        print(var, '=', pol)
    print('the second solution series :')
    for (var, pol) in zip(variables, nser2):
        print(var, '=', pol)
    fail1 = not len(nser1) == 3
    fail2 = not len(nser1) == 3
    return fail1 + fail2

def test_quad_double_apollonius_at_series(vrblvl=0):
    """
    Tests Newton's method starting at a series
    for the problem of Apollonius, in quad double precision.
    The parameter t is the fourth variable, whence we call
    Newton's method with idx equal to four.
    """
    pols = [ 'x1^2 + 3*x2^2 - r^2 - 2*r - 1;', \
             'x1^2 + 3*x2^2 - r^2 - 4*x1 - 2*r + 3;', \
       '3*t^2 + x1^2 - 6*t*x2 + 3*x2^2 - r^2 + 6*t - 2*x1 - 6*x2 + 2*r + 3;']
    lser1 = ['1;', '1 + 0.536*t;', '1 + 0.904*t;']
    lser2 = ['1;', '1 + 7.464*t;', '1 + 11.196*t;']
    nser1 = quad_double_newton_at_series(pols, lser1,\
        idx=4, nbr=7, vrblvl=vrblvl)
    nser2 = quad_double_newton_at_series(pols, lser2,\
        idx=4, nbr=7, vrblvl=vrblvl)
    variables = ['x', 'y', 'z']
    print('the first solution series :')
    for (var, pol) in zip(variables, nser1):
        print(var, '=', pol)
    print('the second solution series :')
    for (var, pol) in zip(variables, nser2):
        print(var, '=', pol)
    fail1 = not len(nser1) == 3
    fail2 = not len(nser1) == 3
    return fail1 + fail2

def main():
    """
    Runs some tests on series developments.
    """
    level = 3
    fail = test_double_viviani_at_point(level)
    fail = fail + test_double_double_viviani_at_point(level)
    fail = fail + test_quad_double_viviani_at_point(level)
    fail = fail + test_double_viviani_at_series(level)
    fail = fail + test_double_double_viviani_at_series(level)
    fail = fail + test_quad_double_viviani_at_series(level)
    fail = fail + test_quad_double_viviani_at_series(level)
    fail = fail + test_double_apollonius_at_series(level)
    fail = fail + test_double_double_apollonius_at_series(level)
    fail = fail + test_quad_double_apollonius_at_series(level)
    if fail == 0:
        print('=> All tests passed.')
    else:
        print('Number of failed tests :', fail)

if __name__=="__main__":
    main()
