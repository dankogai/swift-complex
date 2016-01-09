//
//  main.swift
//  complex
//
//  Created by Dan Kogai on 6/12/14.
//  Copyright (c) 2014 Dan Kogai. All rights reserved.
//
var tests = 0
infix operator !! { associativity left precedence 95 }
func !! (p:Bool, msg:String = "") {
    let result = (p ? "" : "not ") + "ok"
    print("\(result) \(++tests) # \(msg)")
}
func done_testing(){ print("1..\(tests)") }
#if os(Linux)
    import Glibc
#else
    import Foundation
#endif
1-1.i == Complex(1,-1) !! "1-1.i == Complex(1,-1)"
0.i   == Complex()     !! "0.i   == Complex()"
1+0.i == 1             !! "1+0.i == 1"
1     == 1+0.i         !! "1     == 1+0.i"
var z0 = Complex(abs:10.0, arg:atan2(3.0,4.0))
z0.re == 8 && z0.im == 6 !! "Complex(abs:10, arg:atan2(3,4)) == 8+6.i"
sizeofValue(z0.re) == sizeof(Double) !! "z0.re is Double"
z0 - z0 == 0+0.i    !! "z - z = 0+0.i"
z0 + z0 =~ z0 * 2   !! "z + z = z0 * 2"
var z1 = z0
z1 *= z0
z1 =~ z0*z0 !! "*="
z1.abs =~ z0.abs ** 2 !! "(z0 * z1).abs = z0.abs * z1.abs"
z1.arg =~ z0.arg *  2 !! "(z0 * z1).arg = z0.abs + z1.arg"
z1 /= z0
z1 == z0 !! "/="
z0 = exp(Double.PI.i)
z0 != -1.0 !! "exp(π.i) != -1.0 // blame floating point arithmetics"
z0 =~ -1.0 !! "exp(π.i) =~ -1.0 // but close enough"
log(z0) == Double.PI.i !! "log(exp(PI.i)) == PI.i"
2.0 * 3.0 ** 4.0 == 162.0 !! "2.0 * 3.0 ** 4.0 == 2.0 * (3.0 ** 4.0)"
let zero = 0 + 0.i, one = 1.0 + 0.0.i
zero ** (42.0 + 0.195.i) == one !! "pow(0, y) == 1.0+0.0i // issue 8"
Double.E ** Double.PI.i == exp(Double.PI.i) !! "exp(z) == e ** z"
sqrt(-1+0.i) == 1.i             !! "sqrt(-1) == i"
sqrt(2.i) == 1+1.i              !! "sqrt(2i) == 1+i"
tan(z0) == sin(z0)/cos(z0)      !! "tan(z) == sin(z)/cos(z)"
sin(z0)**2 + cos(z0)**2 =~ 1    !! "sin**2 + cos**2"
asin(sin(0.5)) =~ 0.5           !! "asin(sin(r)) =~ r"
sin(asin(0.5)) =~ 0.5           !! "sin(asin(r)) =~ r"
asin(sin(0.5.i)) =~ 0.5.i       !! "asin(sin(z)) =~ z"
sin(asin(0.5.i)) =~ 0.5.i       !! "sin(asin(z)) =~ z"
acos(cos(0.5)) =~ 0.5           !! "acos(cos(r)) =~ r"
cos(acos(0.5)) =~ 0.5           !! "cos(acos(r)) =~ r"
acos(cos(0.5.i)) =~ 0.5.i       !! "acos(cos(z)) =~ z"
cos(acos(0.5.i)) =~ 0.5.i       !! "cos(acos(z)) =~ z"
atan(tan(0.5)) =~ 0.5           !! "atan(tan(r)) =~ r"
tan(atan(0.5)) =~ 0.5           !! "tan(atan(r)) =~ r"
atan(tan(0.5.i)) =~ 0.5.i       !! "atan(tan(z)) =~ z"
tan(atan(0.5.i)) =~ 0.5.i       !! "tan(atan(z)) =~ z"
sinh(0.5) == -sin(0.5.i).i      !! "sinh(r) = -i*sin(r.i)"
sinh(0.5.i) == -sin(0.5.i.i).i  !! "sinh(z) = -i*sin(z.i)"
cosh(0.5) == cos(0.5.i)         !! "cosh(r) == cos(r.i)"
cosh(0.5.i) == cos(0.5.i.i)     !! "cosh(z) == cos(z.i)"
tanh(0.5) =~ -tan(0.5.i).i      !! "tanh(r) =~ -i*tan(r.i)"
tanh(0.5.i) =~ -tan(0.5.i.i).i  !! "tanh(z) =~ -i*tan(z.i)"
asinh(sinh(0.5)) =~ 0.5         !! "asinh(sinh(r)) =~ r"
sinh(asinh(0.5)) =~ 0.5         !! "sinh(asinh(r)) =~ r"
asinh(sinh(0.5.i)) =~ 0.5.i     !! "asinh(sinh(z)) =~ z"
sinh(asinh(0.5.i)) =~ 0.5.i     !! "sinh(asinh(z)) =~ z"
acosh(cosh(1.5)) =~ 1.5         !! "acosh(cosh(r)) =~ r"
cosh(acosh(1.5)) =~ 1.5         !! "cosh(acosh(r)) =~ r"
acosh(cosh(1.5.i)) =~ 1.5.i     !! "acosh(cosh(z)) =~ z"
cosh(acosh(1.5.i)) =~ 1.5.i     !! "cosh(acosh(z)) =~ z"
atanh(tanh(0.5)) =~ 0.5         !! "atanh(tanh(r)) =~ r"
tanh(atanh(0.5)) =~ 0.5         !! "tanh(atanh(r)) =~ r"
atanh(tanh(0.5.i)) =~ 0.5.i     !! "atanh(tanh(z)) =~ z"
tanh(atanh(0.5.i)) =~ 0.5.i     !! "tanh(atanh(z)) =~ z"
z0 = -1.i
abs(z0) =~ z0.abs       !! "abs(z0) =~ z0.abs"
abs(z0) == abs(-1)      !! "abs(-i) == abs(-1)"
arg(z0) =~ z0.arg       !! "arg(z0) =~ z0.arg"
arg(z0) == -Double.PI/2 !! "arg(-i) == -π/2"
real(z0) == z0.real     !! "real(z0) == z0.real"
imag(z0) == z0.imag     !! "imag(z0) == z0.imag"
norm(z0) == z0.norm     !! "norm(z0) == z0.norm"
norm(z0) == z0.abs ** 2 !! "norm(z0) == z0.abs ** 2"
conj(z0) == z0.conj     !! "conj(z0) == z0.conj"
proj(z0) == z0.proj     !! "proj(z0) == z0.proj"
proj((1/0.0)-1.i) == Complex64(1/0.0, -0.0)     !! "(inf,-1).proj == (inf,-0)"
proj(0-(1.0/0.0).i) == Complex64(1/0.0, -0.0)   !! "(0,-inf).proj == (inf,-0)"
proj((1/0.0)+1.i) == Complex64(1/0.0, +0.0)     !! "(inf,+1).proj == (inf,+0)"
proj(0+(1.0/0.0).i) == Complex64(1/0.0, +0.0)   !! "(0,+inf).proj == (inf,+0)"
z0 = 0+0.i
z0.real += 1
z0 == 1     !! ".real as a setter"
z0.imag += 1
z0 == 1+1.i !! ".imag as a setter"
z0.abs *= 2
z0 == 2+2.i !! ".abs as a setter"
z0.arg *= 2
z0 =~ 0.0+2*sqrt(2).i !! ".arg as a setter"
z0 = 1+1.i
var (r, i) = z0.tuple
r == 1 && i == 1 !! "(r, i) = z.tuple"
//(r, i) = z0
r == 1 && i == 1 !! "(r, i) = z"
z0.tuple = (2, 2)
z0 == 2+2.i !! "z.tuple = (r, i)"
var dict = [0+0.i:"origin"]
dict[0+0.i] == "origin" !! "Complex as a dictionary key"
var z32 = Complex32(4,2);
sizeofValue(z32.re) == sizeof(Float) !! "z32.re is Float"
done_testing()
