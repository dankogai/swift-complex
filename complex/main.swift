//
//  main.swift
//  complex
//
//  Created by Dan Kogai on 6/12/14.
//  Copyright (c) 2014 Dan Kogai. All rights reserved.
//
var tests = 0
func ok(p:Bool, _ msg:String = "") {
    let result = (p ? "" : "not ") + "ok"
    print("\(result) \(++tests) # \(msg)")
}
func done_testing(){ print("1..\(tests)") }
#if os(Linux)
    import Glibc
#else
    import Foundation
#endif
ok(1-1.i == Complex(1,-1), "1-1.i == Complex(1,-1)")
ok(1+0.i == 1            , "1+0.i == 1")
ok(1     == 1+0.i        , "1     == 1+0.i")
var z0 = Complex(abs:10.0, arg:atan2(3.0,4.0))
ok(z0.re == 8 && z0.im == 6, "Complex(abs:10, arg:atan2(3,4)) == 8+6.i")
ok(sizeofValue(z0.re) == sizeof(Double), "z0.re is Double")
ok(z0 - z0 == 0+0.i   , "z - z = 0+0.i")
ok(z0 + z0 =~ z0 * 2  , "z + z = z0 * 2")
var z1 = z0
z1 *= z0;   ok(z1 =~ z0*z0  , "*=")
ok(z1.abs =~ z0.abs ** 2  , "(z0 * z1).abs = z0.abs * z1.abs")
ok(z1.arg =~ z0.arg *  2  , "(z0 * z1).arg = z0.abs + z1.arg")
z1 /= z0;   ok(z1 == z0     , "/=")
let epi = exp(Double.PI.i)
ok(epi != -1.0            , "exp(π.i) != -1.0 // blame floating point arithmetics")
ok(epi =~ -1.0            , "exp(π.i) =~ -1.0 // but close enough")
ok(log(epi) == Double.PI.i, "log(exp(PI.i)) == PI.i")
ok(2.0 * 3.0 ** 4.0 == 162.0, "2.0 * 3.0 ** 4.0 == 2.0 * (3.0 ** 4.0)")
let zero = 0 + 0.i, one = 1.0 + 0.0.i
ok(zero ** (42.0 + 0.195.i) == one, "pow(0, y) == 1.0+0.0i // issue 8")
ok(Double.E ** Double.PI.i == exp(Double.PI.i), "exp(z) == e ** z")
ok(sqrt(-1+0.i) == 1.i            , "sqrt(-1) == i")
ok(sqrt(2.i) == 1+1.i             , "sqrt(2i) == 1+i")
ok(tan(z0) == sin(z0)/cos(z0)     , "tan(z) == sin(z)/cos(z)")
// z0 = 0.5.i
// print(sin(z0)**2+cos(z0)**2 =~ 1)
ok(asin(sin(0.5)) =~ 0.5          , "asin(sin(r)) =~ r")
ok(sin(asin(0.5)) =~ 0.5          , "sin(asin(r)) =~ r")
ok(asin(sin(0.5.i)) =~ 0.5.i      , "asin(sin(z)) =~ z")
ok(sin(asin(0.5.i)) =~ 0.5.i      , "sin(asin(z)) =~ z")
ok(acos(cos(0.5)) =~ 0.5          , "acos(cos(r)) =~ r")
ok(cos(acos(0.5)) =~ 0.5          , "cos(acos(r)) =~ r")
ok(acos(cos(0.5.i)) =~ 0.5.i      , "acos(cos(z)) =~ z")
ok(cos(acos(0.5.i)) =~ 0.5.i      , "cos(acos(z)) =~ z")
ok(atan(tan(0.5)) =~ 0.5          , "atan(tan(r)) =~ r")
ok(tan(atan(0.5)) =~ 0.5          , "tan(atan(r)) =~ r")
ok(atan(tan(0.5.i)) =~ 0.5.i      , "atan(tan(z)) =~ z")
ok(tan(atan(0.5.i)) =~ 0.5.i      , "tan(atan(z)) =~ z")
ok(sinh(0.5) == -sin(0.5.i).i     , "sinh(r) = -i*sin(r.i)")
ok(sinh(0.5.i) == -sin(0.5.i.i).i , "sinh(z) = -i*sin(z.i)")
ok(cosh(0.5) == cos(0.5.i)        , "cosh(r) == cos(r.i)")
ok(cosh(0.5.i) == cos(0.5.i.i)    , "cosh(z) == cos(z.i)")
ok(tanh(0.5) =~ -tan(0.5.i).i     , "tanh(r) =~ -i*tan(r.i)")
ok(tanh(0.5.i) =~ -tan(0.5.i.i).i , "tanh(z) =~ -i*tan(z.i)")
ok(asinh(sinh(0.5)) =~ 0.5        , "asinh(sinh(r)) =~ r")
ok(sinh(asinh(0.5)) =~ 0.5        , "sinh(asinh(r)) =~ r")
ok(asinh(sinh(0.5.i)) =~ 0.5.i    , "asinh(sinh(z)) =~ z")
ok(sinh(asinh(0.5.i)) =~ 0.5.i    , "sinh(asinh(z)) =~ z")
ok(acosh(cosh(1.5)) =~ 1.5        , "acosh(cosh(r)) =~ r")
ok(cosh(acosh(1.5)) =~ 1.5        , "cosh(acosh(r)) =~ r")
ok(acosh(cosh(1.5.i)) =~ 1.5.i    , "acosh(cosh(z)) =~ z")
ok(cosh(acosh(1.5.i)) =~ 1.5.i    , "cosh(acosh(z)) =~ z")
ok(atanh(tanh(0.5)) =~ 0.5        , "atanh(tanh(r)) =~ r")
ok(tanh(atanh(0.5)) =~ 0.5        , "tanh(atanh(r)) =~ r")
ok(atanh(tanh(0.5.i)) =~ 0.5.i    , "atanh(tanh(z)) =~ z")
ok(tanh(atanh(0.5.i)) =~ 0.5.i    , "tanh(atanh(z)) =~ z")
z0 = -1.i
ok(abs(z0) =~ z0.abs      , "abs(z0) =~ z0.abs")
ok(abs(z0) == abs(-1)     , "abs(-i) == abs(-1)")
ok(arg(z0) =~ z0.arg      , "arg(z0) =~ z0.arg")
ok(arg(z0) == -Double.PI/2, "arg(-i) == -π/2")
ok(real(z0) == z0.real    , "real(z0) == z0.real")
ok(imag(z0) == z0.imag    , "imag(z0) == z0.imag")
ok(norm(z0) == z0.norm    , "norm(z0) == z0.norm")
ok(norm(z0) == z0.abs ** 2, "norm(z0) == z0.abs ** 2")
ok(conj(z0) == z0.conj    , "conj(z0) == z0.conj")
ok(proj(z0) == z0.proj    , "proj(z0) == z0.proj")
ok(proj((1/0.0)-1.i) == Complex64(1/0.0, -0.0)    , "(inf,-1).proj == (inf,-0)")
ok(proj(0-(1.0/0.0).i) == Complex64(1/0.0, -0.0)  , "(0,-inf).proj == (inf,-0)")
ok(proj((1/0.0)+1.i) == Complex64(1/0.0, +0.0)    , "(inf,+1).proj == (inf,+0)")
ok(proj(0+(1.0/0.0).i) == Complex64(1/0.0, +0.0)  , "(0,+inf).proj == (inf,+0)")
z0 = 0+0.i
z0.real += 1; ok(z0 == 1      , ".real as a setter")
z0.imag += 1; ok(z0 == 1+1.i  , ".imag as a setter")
z0.abs *= 2;  ok(z0 == 2+2.i  , ".abs as a setter")
z0.arg *= 2;  ok(z0 =~ 0.0+2*sqrt(2).i, ".arg as a setter")
z0 = 1+1.i
var (r, i) = z0.tuple; ok(r == 1 && i == 1, "(r, i) = z.tuple")
z0.tuple = (2, 2);     ok(z0 == 2+2.i, "z.tuple = (r, i)")
var dict = [0+0.i:"origin"]
ok(dict[0+0.i] == "origin", "Complex as a dictionary key")
var z32 = Complex32(4,2);
ok(sizeofValue(z32.re) == sizeof(Float), "z32.re is Float")
done_testing()
