"""
PHCpy --- a package for Polynomial Homotopy Continuation
========================================================

PHCpy is a collection of Python modules to compute solutions
of polynomial systems using PHCpack.

A homotopy defines the deformation of a start system
(system with known solutions) into the target system
(system that has to be solved).
Continuation or path tracking methods apply numerical
predictor-corrector techniques to track the solution paths
defined by the homotopy, starting at the known solutions of the
start system and ending at the solutions of the target system.

Available modules
-----------------
version
    retrieves the PHCpack version string and defines the basic
    interactions with ctypes.
dimension
    exports the dimension of the system of (Laurent) polynomials.
polynomials
    polynomials are represented as strings with coefficients
    in double, double double, or quad double precision;
    Laurent polynomials can have negative exponents.
solutions
    solutions are lists of PHCpack solution strings
    and this module exports operations to convert the solution
    strings into Python dictionaries, e.g. for evaluation.
solver
    exports the blackbox solver of PHCpack.
series
    allows to compute series developments of solution curves
    defined by polynomial homotopies.
volumes
    exports functions to compute mixed volumes and stable mixed volumes,
    which provides generically sharp root counts.
examples
    contains some interesting examples from the research literature.

The main() of every module provides some basic examples and tests.
"""

def cite():
    """
    Displays the citation information for phcpy.
    """
    print("""
    To cite phcpy in publications use:

    Jan Verschelde: Modernizing PHCpack through phcpy.
    In Proceedings of the 6th European Conference on Python in Science
    (EuroSciPy 2013), edited by Pierre de Buyl and Nelle Varoquaux,
    pages 71-76, 2014, available at http://arxiv.org/abs/1310.0056.

    Jasmine Otto, Angus Forbes, and Jan Verschelde:
    Solving Polynomial Systems with phcpy.  In the Proceedings of the
    18th Python in Science Conference (SciPy 2019), edited by Chris Calloway,
    David Lippa, Dillon Niederhut, and David Shupe, pages 58-64, 2019.
    """)

try:
    from version import version_string
    print(version_string(verbose=False) + ' works!')
except:
    print('Is the libPHCpack not suited for this platform?')

# The version number is defined as a data attribute.
__version__ = '1.1.3'
