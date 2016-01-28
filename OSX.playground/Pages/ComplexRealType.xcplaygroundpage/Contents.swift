//: [Previous](@previous)
/*:
## Complex<T:RealType>

In addition to `Complex<T:ArithmeticType>`, `Complex<RealType>` is capable of "cmath" operations.  This is Swift's equivalent of [C++ std::complex].

[C++ std::complex]: http://www.cplusplus.com/reference/complex/

*/
// Foundation or Glibc needed for atan2()
#if os(Linux)
import Glibc
#else
import Foundation
#endif
let z0 = Complex(abs:10.0, arg:atan2(3.0,4.0))
z0.re == 8 && z0.im == 6
z0 - z0 == 0
let z1 = z0 * z0
z1 - z0 == z0
z1 / z0 == z0
(-z0).abs == z0.abs
z0.proj
sqrt(z1) == z0
let π = Double.PI
let epi = exp(π.i)
epi == -1.0             // sorry, floating point is inexact
epi =~ -1.0             // but you can use this!
log(-1.0+0.0.i) == π.i  // this one is true
log(exp(π.i))        =~ π.i
exp(log(-1.0+0.0.i)) =~ -1.0
let z2 = sqrt(-1.i)
tan(z2) =~ sin(z2)/cos(z2)
sin(z2)**2 + cos(z2)**2 =~ 1.0
asin(sin(z2)) =~ z2
sin(asin(z2)) =~ z2
acos(cos(z2)) =~ z2
cos(acos(z2)) =~ z2
atan(tan(z2)) =~ z2
tan(atan(z2)) =~ z2
sinh(z2) =~ -sin(z2).i
cosh(z2) =~ cos(z2.i)
tanh(z2) =~ -tan(z2.i).i
asinh(sinh(z2)) =~ z2
sinh(asinh(z2)) =~ z2
acosh(cosh(z2)) =~ z2
cosh(acosh(z2)) =~ z2
atanh(tanh(z2)) =~ z2
tanh(atanh(z2)) =~ z2
// .hashValue
(1+1.i).hashValue
(1.0+1.0.i).hashValue
//: [Next](@next)
