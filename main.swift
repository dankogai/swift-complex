
//
//  main.swift
//  complex
//
//  Created by Dan Kogai on 6/12/14.
//  Copyright (c) 2014 Dan Kogai. All rights reserved.
//

var tests = 0
func ok(p:@auto_closure ()->Bool, _ msg:String = "") {
    var result = (p() ? "" : "not ") + "ok"
    println("\(result) \(++tests) # \(msg)")
}
func done_testing(){ println("1..\(tests)") }

import Foundation
ok(1-1.i == Complex(1,-1), "1-1.i == Complex(1,-1)")
ok(0.i   == Complex(),     "0.i   == Complex()")
ok(1+0.i == 1,             "1+0.i == 1")
ok(1     == 1+0.i,         "1     == 1+0.i")
var z0 = Complex(abs:10, arg:atan2(3,4))
ok(z0.re == 8 && z0.im == 6,
    "Complex(abs:10, arg:atan2(3,4)) == 8+6.i")
ok(z0 - z0 == 0+0.i, "z - z = 0+0.i")
ok(z0 + z0 =~ z0 * 2, "z + z = z0 * 2")
var z1 = z0
z1 *= z0
ok(z1 =~ z0*z0, "*=")
ok(z1.abs =~ z0.abs ** 2, "(z0 * z1).abs = z0.abs * z1.abs")
ok(z1.arg =~ z0.arg *  2, "(z0 * z1).arg = z0.abs + z1.arg")
z1 /= z0
ok(z1 =~ z0, "/=")
z0 = exp(Double.PI.i)
ok(z0 =~ -1.0, "exp(PI.i) =~ -1.0 // Euler!")
z1 = log(z0)
ok(z1 == Double.PI.i, "log(exp(PI.i)) == PI.i")
ok(2 * 3 ** 4 == 162, "2 * 3 ** 4 == 2 * (3 ** 4)")
ok(Double.E ** Double.PI.i == exp(Double.PI.i), "exp(z) == e ** z")
ok(tan(z0) == sin(z0)/cos(z0), "tan(z) == sin(z)/cos(z)")
ok(sin(z0)**2 + cos(z0)**2 =~ 1, "sin**2 + cos**2")
ok(asin(sin(0.5)) =~ 0.5, "asin(sin(r)) =~ r")
ok(sin(asin(0.5)) =~ 0.5, "sin(asin(r)) =~ r")
ok(asin(sin(0.5.i)) =~ 0.5.i, "asin(sin(z)) =~ z")
ok(sin(asin(0.5.i)) =~ 0.5.i, "sin(asin(z)) =~ z")
ok(acos(cos(0.5)) =~ 0.5, "acos(cos(r)) =~ r")
ok(cos(acos(0.5)) =~ 0.5, "cos(acos(r)) =~ r")
ok(acos(cos(0.5.i)) =~ 0.5.i, "acos(cos(z)) =~ z")
ok(cos(acos(0.5.i)) =~ 0.5.i, "cos(acos(z)) =~ z")
ok(atan(tan(0.5)) =~ 0.5, "atan(tan(r)) =~ r")
ok(tan(atan(0.5)) =~ 0.5, "tan(atan(r)) =~ r")
ok(atan(tan(0.5.i)) =~ 0.5.i, "atan(tan(z)) =~ z")
ok(tan(atan(0.5.i)) =~ 0.5.i, "tan(atan(z)) =~ z")
ok(sinh(0.5) == -sin(0.5.i).i, "sinh(r) = -i*sin(r.i)")
ok(sinh(0.5.i) == -sin(0.5.i.i).i, "sinh(z) = -i*sin(z.i)")
ok(cosh(0.5) == cos(0.5.i), "cosh(r) == cos(r.i)")
ok(cosh(0.5.i) == cos(0.5.i.i), "cosh(z) == cos(z.i)")
ok(tanh(0.5) =~ -tan(0.5.i).i, "tanh(r) =~ -i*tan(r.i)")
ok(tanh(0.5.i) =~ -tan(0.5.i.i).i, "tanh(z) =~ -i*tan(z.i)")
ok(asinh(sinh(0.5)) =~ 0.5, "asinh(sinh(r)) =~ r")
ok(sinh(asinh(0.5)) =~ 0.5, "sinh(asinh(r)) =~ r")
ok(asinh(sinh(0.5.i)) =~ 0.5.i, "asinh(sinh(z)) =~ z")
ok(sinh(asinh(0.5.i)) =~ 0.5.i, "sinh(asinh(z)) =~ z")
ok(acosh(cosh(1.5)) =~ 1.5, "acosh(cosh(r)) =~ r")
ok(cosh(acosh(1.5)) =~ 1.5, "cosh(acosh(r)) =~ r")
ok(acosh(cosh(1.5.i)) =~ 1.5.i, "acosh(cosh(z)) =~ z")
ok(cosh(acosh(1.5.i)) =~ 1.5.i, "cosh(acosh(z)) =~ z")
ok(atanh(tanh(0.5)) =~ 0.5, "atanh(tanh(r)) =~ r")
ok(tanh(atanh(0.5)) =~ 0.5, "tanh(atanh(r)) =~ r")
ok(atanh(tanh(0.5.i)) =~ 0.5.i, "atanh(tanh(z)) =~ z")
ok(tanh(atanh(0.5.i)) =~ 0.5.i, "tanh(atanh(z)) =~ z")
z0 = -1.i
ok(abs(z0) =~ z0.abs,       "abs(z0) =~ z0.abs")
ok(abs(z0) == abs(-1),      "abs(-i) == abs(-1)")
ok(arg(z0) =~ z0.arg,       "arg(z0) =~ z0.arg")
ok(arg(z0) == -Double.PI/2, "arg(-i) == -π/2")
ok(real(z0) =~ z0.real,     "real(z0) =~ z0.real")
ok(imag(z0) =~ z0.imag,     "imag(z0) =~ z0.imag")
ok(norm(z0) =~ z0.norm,     "norm(z0) =~ z0.norm")
ok(norm(z0) =~ z0.abs ** 2, "norm(z0) =~ z0.abs ** 2")
ok(conj(z0) =~ z0.conj,     "conj(z0) =~ z0.conj")
ok(proj(z0) =~ z0.proj,     "conj(z0) =~ z0.proj")
z0 = 0+0.i
z0.real += 1
ok(z0 == 1,     ".real as a setter")
z0.imag += 1
ok(z0 == 1+1.i, ".imag as a setter")
z0.abs *= 2
ok(z0 == 2+2.i, ".abs as a setter")
z0.arg *= 2
ok(z0 =~ 0.0+2*sqrt(2).i, ".arg as a setter")
z0 = 1+1.i
var (r, i) = z0.tuple
ok(r == 1 && i == 1, "(r, i) = z.tuple")
z0.tuple = (2, 2)
ok(z0 == 2+2.i, "z.tuple = (r, i)")
done_testing()
