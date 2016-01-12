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
    tests += 1
    print("\(result) \(tests) # \(msg)")
}
func done_testing(){ print("1..\(tests)") }
#if os(Linux)
    import Glibc
#else
    import Foundation
#endif
({
    ok(1-1.i == Complex(1,-1), "1-1.i == Complex(1,-1)")
    ok(1+0.i == 1            , "1+0.i == 1")
    ok(1     == 1+0.i        , "1     == 1+0.i")
    ok(Complex() == 0+0.i    , "Complex() == 0+0.i")
})()
({
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
})()
({
    let z0 = 0.0 + 0.0.i, zm0 = -z0
    let z1 = 1.0 + 0.0.i, z42_195 = 42.0 + 0.195.i
    ok(z0  ** -1.0 == +1.0/0.0, "\(z0 ) ** -1.0 == \(+1.0/0.0)")
    ok(zm0 ** -1.0 == -1.0/0.0, "\(zm0) ** -1.0 == \(-1.0/0.0)")
    ok(z0  ** -2.0 == +1.0/0.0, "\(z0 ) ** -2.0 == \(+1.0/0.0)")
    ok(zm0 ** -2.0 == +1.0/0.0, "\(zm0) ** -2.0 == \(+1.0/0.0)")
    ok(z1 ** z42_195 == z1,  "\(z1) ** y  == \(z1) // for any y")
    ok(z42_195 ** z0 == z1,  "x ** \(z0 ) == \(z1) // for any x")
    ok(z42_195 ** zm0 == z1, "x ** \(zm0) == \(z1) // for any x")

})()
({
    let epi = exp(Double.PI.i)
    ok(epi != -1.0            , "exp(π.i) != -1.0 // blame floating point arithmetics")
    ok(epi =~ -1.0            , "exp(π.i) =~ -1.0 // but close enough")
    ok(log(epi) == Double.PI.i, "log(exp(PI.i)) == PI.i")
    ok(log10(100.i).re == 2.0,  "log10(100.i).re == 2.0")
    ok(log10(100.i).im == log10(1.i).im,  "log10(100.i).im == log10(1.i).im")
    ok(2.0 * 3.0 ** 4.0 == 162.0, "2.0 * 3.0 ** 4.0 == 2.0 * (3.0 ** 4.0)")
    ok(Double.E ** Double.PI.i == exp(Double.PI.i), "exp(z) == e ** z")
    ok(sqrt(-1+0.i) == 1.i          , "sqrt(-1) == i")
    ok(sqrt(2.i) == 1+1.i           , "sqrt(2i) == 1+i")
    ok(2.i **  2.5 == -4-4.i        , "z **  2.5  == z*z*sqrt(z)")
    ok(2.i **  2   == -4+0.i        , "z **  2    == z*z")
    ok(2.i **  1.5 == -2+2.i        , "z **  1.5  == z*sqrt(z)")
    ok(2.i **  1   ==  2.i          , "z **  1    == z")
    ok(2.i **  0.5 ==  1+1.i        , "z **  0.5  == sqrt(z)")
    ok(2.i **  0   ==  1+0.i        , "z **  0    == 1")
    ok(2.i ** -0.5 ==  0.5-0.5.i    , "z **  -0.5 == 1/sqrt(z)")
    ok(2.i ** -1   == -0.5.i        , "z ** -1 == 1/z")
    ok(2.i ** -1.5 == (-1-1.i)/4    , "z ** -1.5 == 1/(z*sqrt(z))")
    ok(2.i ** -2   == -0.25         , "z ** -2 == 1/(z*z)")
    ok(2.i ** -2.5 == (-1+1.i)/8    , "z ** -2.5 == 1/(z*z*sqrt(z))")
})()
({
    let r = 0.5, z = sqrt(-1.i)
    ok(sin(r)**2+cos(r)**2 =~ 1 , "sin(r)**2+cos(r)**2 =~ 1")
    ok(sin(z)**2+cos(z)**2 =~ 1 , "sin(z)**2+cos(z)**2 =~ 1")
    ok(asin(sin(r)) =~ r        , "asin(sin(r)) =~ r")
    ok(sin(asin(r)) =~ r        , "sin(asin(r)) =~ r")
    ok(asin(sin(z)) =~ z        , "asin(sin(z)) =~ z")
    ok(sin(asin(z)) =~ z        , "sin(asin(z)) =~ z")
    ok(acos(cos(r)) =~ r        , "acos(cos(r)) =~ r")
    ok(cos(acos(r)) =~ r        , "cos(acos(r)) =~ r")
    ok(acos(cos(z)) =~ z        , "acos(cos(z)) =~ z")
    ok(cos(acos(z)) =~ z        , "cos(acos(z)) =~ z")
    ok(atan(tan(r)) =~ r        , "atan(tan(r)) =~ r")
    ok(tan(atan(r)) =~ r        , "tan(atan(r)) =~ r")
    ok(atan(tan(z)) =~ z        , "atan(tan(z)) =~ z")
    ok(tan(atan(z)) =~ z        , "tan(atan(z)) =~ z")
    ok(sinh(r) =~ -sin(r.i).i   , "sinh(r) =~ -i*sin(r.i)")
    ok(sinh(z) =~ -sin(z.i).i   , "sinh(z) =~ -i*sin(z.i)")
    ok(cosh(r) =~ cos(r.i)      , "cosh(r) =~ cos(r.i)")
    ok(cosh(z) =~ cos(z.i)      , "cosh(z) =~ cos(z.i)")
    ok(tanh(r) =~ -tan(r.i).i   , "tanh(r) =~ -i*tan(r.i)")
    ok(tanh(z) =~ -tan(z.i).i   , "tanh(z) =~ -i*tan(z.i)")
    ok(asinh(sinh(r)) =~ r      , "asinh(sinh(r)) =~ r")
    ok(sinh(asinh(r)) =~ r      , "sinh(asinh(r)) =~ r")
    ok(asinh(sinh(z)) =~ z      , "asinh(sinh(z)) =~ z")
    ok(sinh(asinh(z)) =~ z      , "sinh(asinh(z)) =~ z")
    ok(acosh(cosh(2*r)) =~ 2*r  , "acosh(cosh(r)) =~ r")
    ok(cosh(acosh(2*r)) =~ 2*r  , "cosh(acosh(r)) =~ r")
    ok(acosh(cosh(2*z)) =~ 2*z  , "acosh(cosh(z)) =~ z")
    ok(cosh(acosh(2*z)) =~ 2*z  , "cosh(acosh(z)) =~ z")
    ok(atanh(tanh(r)) =~ r      , "atanh(tanh(r)) =~ r")
    ok(tanh(atanh(r)) =~ r      , "tanh(atanh(r)) =~ r")
    ok(atanh(tanh(z)) =~ z      , "atanh(tanh(z)) =~ z")
    ok(tanh(atanh(z)) =~ z      , "tanh(atanh(z)) =~ z")
})()
({
    let z = -1.i
    ok(abs(z) =~ z.abs          , "abs(z) =~ z.abs")
    ok(abs(z) == abs(-1)        , "abs(-i) == abs(-1)")
    ok(arg(z) =~ z.arg          , "arg(z) =~ z.arg")
    ok(arg(z) == -Double.PI/2   , "arg(-i) == -π/2")
    ok(real(z) == z.real        , "real(z) == z.real")
    ok(imag(z) == z.imag        , "imag(z) == z.imag")
    ok(norm(z) == z.norm        , "norm(z) == z.norm")
    ok(norm(z) == z.abs ** 2    , "norm(z) == z.abs ** 2")
    ok(conj(z) == z.conj        , "conj(z) == z.conj")
    ok(proj(z) == z.proj        , "proj(z) == z.proj")
    ok(proj((1/0.0)-1.i) == Complex64(1/0.0, -0.0)    , "(inf,-1).proj == (inf,-0)")
    ok(proj(0-(1.0/0.0).i) == Complex64(1/0.0, -0.0)  , "(0,-inf).proj == (inf,-0)")
    ok(proj((1/0.0)+1.i) == Complex64(1/0.0, +0.0)    , "(inf,+1).proj == (inf,+0)")
    ok(proj(0+(1.0/0.0).i) == Complex64(1/0.0, +0.0)  , "(0,+inf).proj == (inf,+0)")
})()
({
    var z = 0+0.i
    z.real += 1; ok(z == 1      , ".real as a setter")
    z.imag += 1; ok(z == 1+1.i  , ".imag as a setter")
    z.abs *= 2;  ok(z == 2+2.i  , ".abs as a setter")
    z.arg *= 2;  ok(z =~ 0.0+2*sqrt(2).i, ".arg as a setter")
})()
({
    var z = 1+1.i
    var (r, i) = z.tuple; ok(r == 1 && i == 1, "(r, i) = z.tuple")
    z.tuple = (2, 2);     ok(z == 2+2.i, "z.tuple = (r, i)")
})()
({
    var dict = [0+0.i:"origin"]
    ok(dict[0+0.i] == "origin", "Complex as a dictionary key")
})()
({
    var z32 = Complex32(4,2);
    ok(sizeofValue(z32.re) == sizeof(Float), "z32.re is Float")
})()
done_testing()
