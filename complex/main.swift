//
//  main.swift
//  complex
//
//  Created by Dan Kogai on 6/12/14.
//  Copyright (c) 2014 Dan Kogai. All rights reserved.
//
#if os(Linux)
    import Glibc
#else
    import Foundation
#endif
let test = TAP()
({
    test.eq(1.0-1.0.i, Complex(1.0,-1.0)           , "1.0-1.0.i, Complex(1.0,-1.0)")
    test.ok(1.0+0.0.i==1.0                         , "1.0+0.0.i, 1")
    test.ok(    0.0.i==0.0                         , "    0.0.i, 0")
    test.eq(Complex(), 0+0.i                       , "Complex(), 0+0.i")
    test.eq(Complex(), 0.0+0.0.i                   , "Complex(), 0.0+0.0.i")
    test.eq("\(Complex(0,0))", "(0+0.i)"           , "0+0.i")
    test.eq("\(Complex(0.0,+0.0))", "(0.0+0.0.i)"  , "0.0+0.0.i")
    test.eq("\(Complex(0.0,-0.0))", "(0.0-0.0.i)"  , "0.0-0.0.i")
    test.eq(sizeofValue(Int(1).i) ,   2*sizeof(Int)    , "sizeofValue(Int(1).i) == 2*sizeof(Int)")
    test.eq(sizeofValue(Double(1).i), 2*sizeof(Double) , "sizeofValue(Double(1).i)) == 2*sizeof(Double)")
    test.eq(sizeofValue(Float(1).i),  2*sizeof(Float)  , "sizeofValue(Float(1).i) == 2*sizeof(Float)")
    test.eq(ComplexInt(1,-1).asComplexDouble, Complex(1.0,-1.0), ".asComplexDouble")
    test.eq(ComplexDouble(1.0,-1.0).asComplexInt, Complex(1,-1), ".asComplexInt")
})()
#if !os(Linux)
({
    test.eq(ComplexInt(1, 1).asComplexCGFloat, ComplexCGFloat(1, 1),   ".asComplexCGFloat")
    test.eq(ComplexInt(1, 1).asCGPoint, CGPoint(x:1,y:1),              ".asCGPoint")
    test.eq(Complex(CGPoint(x:1, y:1)), ComplexCGFloat(1,1),           "init(CGPoint(x:y:))")
})()
#endif
({
    var z0 = Complex(abs:10.0, arg:atan2(3.0,4.0))
    test.eq(z0, 8.0+6.0.i      , "Complex(abs:10, arg:atan2(3,4)) == 8.0+6.0.i")
    test.eq(z0 - z0, 0.0+0.0.i , "z - z = 0+0.i")
    test.eq(z0 + z0, z0 * 2    , "z + z = z0*2")
    var z1 = z0; z1 *= z1;
    test.eq(z1, z0*z0  , "var z1=z0; z1*=z1; z1==z0*z0")
    test.eq(z1.abs, z0.abs ** 2  , "z1.abs == z0.abs * z0.abs")
    test.eq(z1.arg, z0.arg *  2  , "z1.arg == z0.abs + z0.arg")
    z1 /= z0;
    test.eq(z1, z0, "z1 /= z0; z1==z0")
})()
({
    let z0 = 0.0 + 0.0.i, zm0 = -z0
    let z1 = 1.0 + 0.0.i, z42_195 = 42.0 + 0.195.i
    test.ok(z0  ** -1.0 == +1.0/0.0, "\(z0 ) ** -1.0 == \(+1.0/0.0)")
    test.ok(zm0 ** -1.0 == -1.0/0.0, "\(zm0) ** -1.0 == \(-1.0/0.0)")
    test.ok(z0  ** -2.0 == +1.0/0.0, "\(z0 ) ** -2.0 == \(+1.0/0.0)")
    test.ok(zm0 ** -2.0 == +1.0/0.0, "\(zm0) ** -2.0 == \(+1.0/0.0)")
    test.eq(z1 ** z42_195,   z1, "\(z1) ** y  == \(z1) // for any y")
    test.eq(z42_195 ** z0,   z1, "x ** \(z0 ) == \(z1) // for any x")
    test.eq(z42_195 ** zm0,  z1, "x ** \(zm0) == \(z1) // for any x")
    
})()
({
    let epi = exp(Double.PI.i)
    test.ok(epi != -1.0          , "exp(π.i) != -1.0 // blame floating point arithmetics")
    test.ok(epi =~ -1.0          , "exp(π.i) =~ -1.0 // but close enough")
    test.eq(log(epi), Double.PI.i, "log(exp(PI.i)) == PI.i")
    test.eq(log10(100.i).re, 2.0,  "log10(100.i).re == 2.0")
    test.eq(log10(100.i).im, log10(1.i).im,  "log10(100.i).im == log10(1.i).im")
    test.eq(2.0 * 3.0 ** 4.0, 162.0, "2.0*3.0**4.0 == 2.0 * (3.0 ** 4.0)")
    test.eq(Double.E ** Double.PI.i, exp(Double.PI.i), "exp(z) == e ** z")
    test.eq(sqrt(-1+0.i),  1.i     , "sqrt(-1) == i")
    test.eq(sqrt(2.i), 1+1.i       , "sqrt(2i) == 1+i")
    test.eq(2.i **  2.5, -4-4.i    , "z **  2.5  == z*z*sqrt(z)")
    test.eq(2.i **  2, -4+0.i          , "z **  2    == z*z")
    test.eq(2.i **  1.5, -2+2.i        , "z **  1.5  == z*sqrt(z)")
    test.eq(2.i **  1,  2.i            , "z **  1    == z")
    test.eq(2.i **  0.5,  1+1.i        , "z **  0.5  == sqrt(z)")
    test.eq(2.i **  0,  1+0.i          , "z **  0    == 1")
    test.eq(2.i ** -0.5,  0.5-0.5.i    , "z **  -0.5 == 1/sqrt(z)")
    test.eq(2.i ** -1, -0.5.i          , "z ** -1 == 1/z")
    test.eq(2.i ** -1.5, (-1-1.i)/4    , "z ** -1.5 == 1/(z*sqrt(z))")
    test.eq(2.i ** -2, -0.25+0.i       , "z ** -2 == 1/(z*z)")
    test.eq(2.i ** -2.5, (-1+1.i)/8    , "z ** -2.5 == 1/(z*z*sqrt(z))")
})()
({
    let z = 3.0+4.0.i
    test.eq(abs(z), z.abs          , "abs(z) == z.abs")
    test.eq(abs(z), abs(-5.0)      , "abs(z) == abs(-5.0)")
    test.eq(arg(z), z.arg          , "arg(z) == z.arg")
    test.eq(arg(z), atan2(4,3)     , "arg(z) == atan2(3.0,4.0)")
    test.eq(real(z), z.real        , "real(z) == z.real")
    test.eq(imag(z), z.imag        , "imag(z) == z.imag")
    test.eq(norm(z), z.norm        , "norm(z) == z.norm")
    test.eq(norm(z), z.abs ** 2    , "norm(z) == z.abs ** 2")
    test.eq(conj(z), z.conj        , "conj(z) == z.conj")
    test.eq(proj(z), z.proj        , "proj(z) == z.proj")
    test.eq(proj((1/0.0)-1.i),     Complex64(1/0.0, -0.0)  , "(inf,-1).proj == (inf,-0)")
    test.eq(proj(0-(1.0/0.0).i),   Complex64(1/0.0, -0.0)  , "(0,-inf).proj == (inf,-0)")
    test.eq(proj((1/0.0)+1.i),     Complex64(1/0.0, +0.0)  , "(inf,+1).proj == (inf,+0)")
    test.eq(proj(0+(1.0/0.0).i),   Complex64(1/0.0, +0.0)  , "(0,+inf).proj == (inf,+0)")
})()
({
    let r = 0.5, z = sqrt(-1.i)
    test.ok(sin(r)**2+cos(r)**2 =~ 1 , "sin(r)**2+cos(r)**2 =~ 1")
    test.ok(sin(z)**2+cos(z)**2 =~ 1 , "sin(z)**2+cos(z)**2 =~ 1")
    test.ok(asin(sin(r)) =~ r        , "asin(sin(r)) =~ r")
    test.ok(sin(asin(r)) =~ r        , "sin(asin(r)) =~ r")
    test.ok(asin(sin(z)) =~ z        , "asin(sin(z)) =~ z")
    test.ok(sin(asin(z)) =~ z        , "sin(asin(z)) =~ z")
    test.ok(acos(cos(r)) =~ r        , "acos(cos(r)) =~ r")
    test.ok(cos(acos(r)) =~ r        , "cos(acos(r)) =~ r")
    test.ok(acos(cos(z)) =~ z        , "acos(cos(z)) =~ z")
    test.ok(cos(acos(z)) =~ z        , "cos(acos(z)) =~ z")
    test.ok(atan(tan(r)) =~ r        , "atan(tan(r)) =~ r")
    test.ok(tan(atan(r)) =~ r        , "tan(atan(r)) =~ r")
    test.ok(atan(tan(z)) =~ z        , "atan(tan(z)) =~ z")
    test.ok(tan(atan(z)) =~ z        , "tan(atan(z)) =~ z")
    test.ok(sinh(r) =~ -sin(r.i).i   , "sinh(r) =~ -i*sin(r.i)")
    test.ok(sinh(z) =~ -sin(z.i).i   , "sinh(z) =~ -i*sin(z.i)")
    test.ok(cosh(r) =~ cos(r.i)      , "cosh(r) =~ cos(r.i)")
    test.ok(cosh(z) =~ cos(z.i)      , "cosh(z) =~ cos(z.i)")
    test.ok(tanh(r) =~ -tan(r.i).i   , "tanh(r) =~ -i*tan(r.i)")
    test.ok(tanh(z) =~ -tan(z.i).i   , "tanh(z) =~ -i*tan(z.i)")
    test.ok(asinh(sinh(r)) =~ r      , "asinh(sinh(r)) =~ r")
    test.ok(sinh(asinh(r)) =~ r      , "sinh(asinh(r)) =~ r")
    test.ok(asinh(sinh(z)) =~ z      , "asinh(sinh(z)) =~ z")
    test.ok(sinh(asinh(z)) =~ z      , "sinh(asinh(z)) =~ z")
    test.ok(acosh(cosh(2*r)) =~ 2*r  , "acosh(cosh(r)) =~ r")
    test.ok(cosh(acosh(2*r)) =~ 2*r  , "cosh(acosh(r)) =~ r")
    test.ok(acosh(cosh(2*z)) =~ 2*z  , "acosh(cosh(z)) =~ z")
    test.ok(cosh(acosh(2*z)) =~ 2*z  , "cosh(acosh(z)) =~ z")
    test.ok(atanh(tanh(r)) =~ r      , "atanh(tanh(r)) =~ r")
    test.ok(tanh(atanh(r)) =~ r      , "tanh(atanh(r)) =~ r")
    test.ok(atanh(tanh(z)) =~ z      , "atanh(tanh(z)) =~ z")
    test.ok(tanh(atanh(z)) =~ z      , "tanh(atanh(z)) =~ z")
})()
({
    var z = 0.0+0.0.i
    z.real += 1; test.ok(z == 1      , ".real as a setter")
    z.imag += 1; test.ok(z == 1+1.i  , ".imag as a setter")
    z.abs *= 2;  test.ok(z == 2+2.i  , ".abs as a setter")
    z.arg *= 2;  test.ok(z =~ 0.0+2*sqrt(2).i, ".arg as a setter")
})()
({
    var z = 1+1.i
    var (r, i) = z.tuple; test.ok(r == 1 && i == 1, "(r, i) = z.tuple")
    z.tuple = (2, 2);     test.ok(z == 2+2.i, "z.tuple = (r, i)")
})()
({
    var dict = [0+0.i:"origin"]
    test.ok(dict[0+0.i] == "origin", "Complex as a dictionary key")
})()
test.done()
