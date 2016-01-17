//
//  main.swift
//  complex
//
//  Created by Dan Kogai on 6/12/14.
//  Copyright (c) 2014 Dan Kogai. All rights reserved.
//
var tests = 0
func okay(p:Bool, _ message:String = "") {
    tests += 1
    let result = (p ? "" : "not ") + "ok"
    print("\(result) \(tests) # \(message)")
}
func same<T:Equatable>(actual:T, _ expected:T, _ message:String) {
    tests += 1
    if actual == expected {
        print("ok \(tests) # \(message)")
    } else {
        print("not ok \(tests)")
        print("#   message: \(message)")
        print("#       got: \(actual)")
        print("#  expected: \(expected)")
    }
}
func done_testing(){ print("1..\(tests)") }
#if os(Linux)
    import Glibc
#else
    import Foundation
#endif
({
    same(1.0-1.0.i, Complex(1.0,-1.0)           , "1.0-1.0.i, Complex(1.0,-1.0)")
    okay(1.0+0.0.i==1.0                         , "1.0+0.0.i, 1")
    okay(    0.0.i==0.0                         , "    0.0.i, 0")
    same(Complex(), 0+0.i                       , "Complex(), 0+0.i")
    same(Complex(), 0.0+0.0.i                   , "Complex(), 0.0+0.0.i")
    same("\(Complex(0,0))", "(0+0.i)"           , "0+0.i")
    same("\(Complex(0.0,+0.0))", "(0.0+0.0.i)"  , "0.0+0.0.i")
    same("\(Complex(0.0,-0.0))", "(0.0-0.0.i)"  , "0.0-0.0.i")
    same(sizeofValue(Int(1).i) ,   2*sizeof(Int)    , "sizeofValue(Int(1).i) == 2*sizeof(Int)")
    same(sizeofValue(Double(1).i), 2*sizeof(Double) , "sizeofValue(Double(1).i)) == 2*sizeof(Double)")
    same(sizeofValue(Float(1).i),  2*sizeof(Float)  , "sizeofValue(Float(1).i) == 2*sizeof(Float)")
    same(ComplexInt(1,-1).asComplexDouble, Complex(1.0,-1.0), ".asComplexDouble")
    same(ComplexDouble(1.0,-1.0).asComplexInt, Complex(1,-1), ".asComplexInt")
})()
#if os(Linux)
#else
({
    same(ComplexInt(1, 1).asComplexCGFloat, ComplexCGFloat(1, 1), ".asComplexCGFloat")
})()
#endif
({
    var z0 = Complex(abs:10.0, arg:atan2(3.0,4.0))
    same(z0, 8.0+6.0.i      , "Complex(abs:10, arg:atan2(3,4)) == 8.0+6.0.i")
    same(z0 - z0, 0.0+0.0.i , "z - z = 0+0.i")
    same(z0 + z0, z0 * 2    , "z + z = z0*2")
    var z1 = z0; z1 *= z1;
    same(z1, z0*z0  , "var z1=z0; z1*=z1; z1==z0*z0")
    same(z1.abs, z0.abs ** 2  , "z1.abs == z0.abs * z0.abs")
    same(z1.arg, z0.arg *  2  , "z1.arg == z0.abs + z0.arg")
    z1 /= z0;
    same(z1, z0, "z1 /= z0; z1==z0")
})()
({
    let z0 = 0.0 + 0.0.i, zm0 = -z0
    let z1 = 1.0 + 0.0.i, z42_195 = 42.0 + 0.195.i
    okay(z0  ** -1.0 == +1.0/0.0, "\(z0 ) ** -1.0 == \(+1.0/0.0)")
    okay(zm0 ** -1.0 == -1.0/0.0, "\(zm0) ** -1.0 == \(-1.0/0.0)")
    okay(z0  ** -2.0 == +1.0/0.0, "\(z0 ) ** -2.0 == \(+1.0/0.0)")
    okay(zm0 ** -2.0 == +1.0/0.0, "\(zm0) ** -2.0 == \(+1.0/0.0)")
    same(z1 ** z42_195,   z1, "\(z1) ** y  == \(z1) // for any y")
    same(z42_195 ** z0,   z1, "x ** \(z0 ) == \(z1) // for any x")
    same(z42_195 ** zm0,  z1, "x ** \(zm0) == \(z1) // for any x")

})()
({
    let epi = exp(Double.PI.i)
    okay(epi != -1.0          , "exp(π.i) != -1.0 // blame floating point arithmetics")
    okay(epi =~ -1.0          , "exp(π.i) =~ -1.0 // but close enough")
    same(log(epi), Double.PI.i, "log(exp(PI.i)) == PI.i")
    same(log10(100.i).re, 2.0,  "log10(100.i).re == 2.0")
    same(log10(100.i).im, log10(1.i).im,  "log10(100.i).im == log10(1.i).im")
    same(2.0 * 3.0 ** 4.0, 162.0, "2.0*3.0**4.0 == 2.0 * (3.0 ** 4.0)")
    same(Double.E ** Double.PI.i, exp(Double.PI.i), "exp(z) == e ** z")
    same(sqrt(-1+0.i),  1.i     , "sqrt(-1) == i")
    same(sqrt(2.i), 1+1.i       , "sqrt(2i) == 1+i")
    same(2.i **  2.5, -4-4.i    , "z **  2.5  == z*z*sqrt(z)")
    same(2.i **  2, -4+0.i          , "z **  2    == z*z")
    same(2.i **  1.5, -2+2.i        , "z **  1.5  == z*sqrt(z)")
    same(2.i **  1,  2.i            , "z **  1    == z")
    same(2.i **  0.5,  1+1.i        , "z **  0.5  == sqrt(z)")
    same(2.i **  0,  1+0.i          , "z **  0    == 1")
    same(2.i ** -0.5,  0.5-0.5.i    , "z **  -0.5 == 1/sqrt(z)")
    same(2.i ** -1, -0.5.i          , "z ** -1 == 1/z")
    same(2.i ** -1.5, (-1-1.i)/4    , "z ** -1.5 == 1/(z*sqrt(z))")
    same(2.i ** -2, -0.25+0.i       , "z ** -2 == 1/(z*z)")
    same(2.i ** -2.5, (-1+1.i)/8    , "z ** -2.5 == 1/(z*z*sqrt(z))")
})()
({
    let z = 3.0+4.0.i
    same(abs(z), z.abs          , "abs(z) == z.abs")
    same(abs(z), abs(-5.0)      , "abs(z) == abs(-5.0)")
    same(arg(z), z.arg          , "arg(z) == z.arg")
    same(arg(z), atan2(4,3)     , "arg(z) == atan2(3.0,4.0)")
    same(real(z), z.real        , "real(z) == z.real")
    same(imag(z), z.imag        , "imag(z) == z.imag")
    same(norm(z), z.norm        , "norm(z) == z.norm")
    same(norm(z), z.abs ** 2    , "norm(z) == z.abs ** 2")
    same(conj(z), z.conj        , "conj(z) == z.conj")
    same(proj(z), z.proj        , "proj(z) == z.proj")
    same(proj((1/0.0)-1.i),     Complex64(1/0.0, -0.0)  , "(inf,-1).proj == (inf,-0)")
    same(proj(0-(1.0/0.0).i),   Complex64(1/0.0, -0.0)  , "(0,-inf).proj == (inf,-0)")
    same(proj((1/0.0)+1.i),     Complex64(1/0.0, +0.0)  , "(inf,+1).proj == (inf,+0)")
    same(proj(0+(1.0/0.0).i),   Complex64(1/0.0, +0.0)  , "(0,+inf).proj == (inf,+0)")
})()
({
    let r = 0.5, z = sqrt(-1.i)
    okay(sin(r)**2+cos(r)**2 =~ 1 , "sin(r)**2+cos(r)**2 =~ 1")
    okay(sin(z)**2+cos(z)**2 =~ 1 , "sin(z)**2+cos(z)**2 =~ 1")
    okay(asin(sin(r)) =~ r        , "asin(sin(r)) =~ r")
    okay(sin(asin(r)) =~ r        , "sin(asin(r)) =~ r")
    okay(asin(sin(z)) =~ z        , "asin(sin(z)) =~ z")
    okay(sin(asin(z)) =~ z        , "sin(asin(z)) =~ z")
    okay(acos(cos(r)) =~ r        , "acos(cos(r)) =~ r")
    okay(cos(acos(r)) =~ r        , "cos(acos(r)) =~ r")
    okay(acos(cos(z)) =~ z        , "acos(cos(z)) =~ z")
    okay(cos(acos(z)) =~ z        , "cos(acos(z)) =~ z")
    okay(atan(tan(r)) =~ r        , "atan(tan(r)) =~ r")
    okay(tan(atan(r)) =~ r        , "tan(atan(r)) =~ r")
    okay(atan(tan(z)) =~ z        , "atan(tan(z)) =~ z")
    okay(tan(atan(z)) =~ z        , "tan(atan(z)) =~ z")
    okay(sinh(r) =~ -sin(r.i).i   , "sinh(r) =~ -i*sin(r.i)")
    okay(sinh(z) =~ -sin(z.i).i   , "sinh(z) =~ -i*sin(z.i)")
    okay(cosh(r) =~ cos(r.i)      , "cosh(r) =~ cos(r.i)")
    okay(cosh(z) =~ cos(z.i)      , "cosh(z) =~ cos(z.i)")
    okay(tanh(r) =~ -tan(r.i).i   , "tanh(r) =~ -i*tan(r.i)")
    okay(tanh(z) =~ -tan(z.i).i   , "tanh(z) =~ -i*tan(z.i)")
    okay(asinh(sinh(r)) =~ r      , "asinh(sinh(r)) =~ r")
    okay(sinh(asinh(r)) =~ r      , "sinh(asinh(r)) =~ r")
    okay(asinh(sinh(z)) =~ z      , "asinh(sinh(z)) =~ z")
    okay(sinh(asinh(z)) =~ z      , "sinh(asinh(z)) =~ z")
    okay(acosh(cosh(2*r)) =~ 2*r  , "acosh(cosh(r)) =~ r")
    okay(cosh(acosh(2*r)) =~ 2*r  , "cosh(acosh(r)) =~ r")
    okay(acosh(cosh(2*z)) =~ 2*z  , "acosh(cosh(z)) =~ z")
    okay(cosh(acosh(2*z)) =~ 2*z  , "cosh(acosh(z)) =~ z")
    okay(atanh(tanh(r)) =~ r      , "atanh(tanh(r)) =~ r")
    okay(tanh(atanh(r)) =~ r      , "tanh(atanh(r)) =~ r")
    okay(atanh(tanh(z)) =~ z      , "atanh(tanh(z)) =~ z")
    okay(tanh(atanh(z)) =~ z      , "tanh(atanh(z)) =~ z")
})()
({
    var z = 0.0+0.0.i
    z.real += 1; okay(z == 1      , ".real as a setter")
    z.imag += 1; okay(z == 1+1.i  , ".imag as a setter")
    z.abs *= 2;  okay(z == 2+2.i  , ".abs as a setter")
    z.arg *= 2;  okay(z =~ 0.0+2*sqrt(2).i, ".arg as a setter")
})()
({
    var z = 1+1.i
    var (r, i) = z.tuple; okay(r == 1 && i == 1, "(r, i) = z.tuple")
    z.tuple = (2, 2);     okay(z == 2+2.i, "z.tuple = (r, i)")
})()
({
    var dict = [0+0.i:"origin"]
    okay(dict[0+0.i] == "origin", "Complex as a dictionary key")
})()
done_testing()
