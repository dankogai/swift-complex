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
epi == -1   // sorry, floating point is inexact
epi =~ -1   // but you can use this!
log(-1+0.i) // πi
let z2 = sqrt(-1.i)
tan(z2) == sin(z2)/cos(z2)
(sin(z2)**2 + cos(z2)**2) =~ 1
asin(sin(z2)) =~ z2
acos(cos(z2)) =~ z2
atan(tan(z2)) =~ z2
sinh(z2) == -sin(z2).i
cosh(z2) == cos(z2.i)
tanh(z2) =~ -tan(z2.i).i
asinh(sinh(z2)) =~ z2
acosh(cosh(z2)) =~ z2
atanh(tanh(z2)) =~ z2
