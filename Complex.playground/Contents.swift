//: Playground - noun: a place where people can play
#if os(Linux)
    import Glibc
#else
    import Foundation
#endif
1-1.i
0.i == Complex(0, 0)
1 == 1+0.i
let z0 = Complex(abs:10.0, arg:atan2(3.0,4.0))
z0.re == 8 && z0.im == 6
z0 - z0 == 0
let z1 = z0 * z0
z1 - z0 == z0
z1 / z0 == z0
sqrt(z1) == z0
let epi = exp(Double.PI.i)
epi == -1
epi =~ -1
log(-1+0.i).i
tan(z0) == sin(z0)/cos(z0)
(sin(1.i)**2 + cos(1.i)**2) =~ 1
asin(sin(0.5.i))
acos(cos(0.5.i))
atan(tan(0.5.i))
sinh(0.5) == -sin(0.5.i).i
cosh(0.5) == cos(0.5.i)
tanh(0.5+0.i) =~ -tan(0.5.i).i
asinh(sinh(0.5.i))
acosh(cosh(0.5.i))
atanh(tanh(0.5.i))
