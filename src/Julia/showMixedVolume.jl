# standalone test on computing the mixed volume
include("JuPHC.jl")
verbose = 10
polynomials = ["x^3 + 2*x*y - 1;", "x + y - 1;"]
JuPHC.setDoubleSystem(2, polynomials, verbose)
pols = JuPHC.getDoubleSystem(verbose)
println("the polynomials :")
for pol in pols
    println(pol)
end
mv = JuPHC.mixedVolume(true, verbose)
println("the mixed volume : ", mv)
mv = JuPHC.mixedVolume(false, verbose)
println("the mixed volume : ", mv)
