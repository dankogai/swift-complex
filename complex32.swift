//
//  complex32.swift
//  complex
//
//  Created by Dan Kogai on 11/6/14.
//  Copyright (c) 2014 Dan Kogai. All rights reserved.
//

import Foundation // We now need String(format:...)

extension Float {
    // these ought to be static let
    // but give users a chance to overwrite it
    static var PI:Float = 3.14159265358979323846264338327950288419716939937510
    static var π:Float = PI
    static var E:Float =  2.718281828459045235360287471352662497757247093699
    static var e:Float = E
    static var LN2:Float =
    0.6931471805599453094172321214581765680755001343602552
    static var LOG2E:Float = 1 / LN2
    static var LN10:Float =
    2.3025850929940456840179914546843642076011014886287729
    static var LOG10E:Float = 1/LN10
    static var SQRT2:Float =
    1.4142135623730950488016887242096980785696718753769480
    static var SQRT1_2:Float = 1/SQRT2
    static var epsilon:Float = 0x1p-23
    /// self * 1i
    var i:Complex32 { return Complex32(0 as Float, self) }
}

struct Complex32: Printable, DebugPrintable, Equatable, Hashable {
    var (re:Float, im:Float) = (0.0, 0.0)
    init(){}
    init(_ re:Float, _ im:Float) {
        self.re = re
        self.im = im
    }
    init(abs:Float, arg:Float) {
        self.re = abs * cos(arg)
        self.im = abs * sin(arg)
    }
    var description:String {
        let plus = im.isSignMinus ? "" : "+"
        return "(\(re)\(plus)\(im).i)"
    }
    var debugDescription:String {
        return String(format:"Complex(%a, %a)", re, im)
    }
    /// You can use Complex as a dictionary key
    var hashValue:Int { // take most significant halves and join
        let bits = sizeof(Int) * 4
        let mask = bits == 16 ? 0xffff : 0xffffFFFF
        return (re.hashValue & ~mask) | (im.hashValue >> bits)
    }
    static var I:Complex32 { return Complex32(0, 1) }
    var real:Float { get{ return re } set(r){ re = r } }
    var imag:Float { get{ return im } set(i){ im = i } }
    var abs:Float  {
        get { return hypot(re, im) }
        set(r){ let f = r / abs; re *= f; im *= f }
    }
    var arg:Float  {
        get { return atan2(im, re) }
        set(t){ let m = abs; re = m * cos(t); im = m * sin(t) }
    }
    var norm:Float { return hypot(re, im) }
    var conj:Complex32 { return Complex32(re, -im) }
    var proj:Complex32 {
        if re.isFinite && im.isFinite {
            return self
        } else {
            return Complex32(
                Float.infinity, im.isSignMinus ? -0.0 : 0.0
            )
        }
    }
    var tuple:(Float, Float) {
        get { return (re, im) }
        set(t){ (re, im) = t}
    }
    var i:Complex32 { return Complex32(-im, re) }
}
// != is auto-generated thanks to Equatable
func == (lhs:Complex32, rhs:Complex32) -> Bool {
    return lhs.re == rhs.re && lhs.im == rhs.im
}
func == (lhs:Complex32, rhs:Float) -> Bool {
    return lhs.re == rhs && lhs.im == 0
}
func == (lhs:Float, rhs:Complex32) -> Bool {
    return lhs == rhs.re && rhs.im == 0
}
// +, +=
prefix func + (z:Complex32) -> Complex32 {
    return z
}
func + (lhs:Complex32, rhs:Complex32) -> Complex32 {
    return Complex32(lhs.re + rhs.re, lhs.im + rhs.im)
}
func + (lhs:Complex32, rhs:Float) -> Complex32 {
    return lhs + Complex32(rhs, 0)
}
func + (lhs:Float, rhs:Complex32) -> Complex32 {
    return Complex32(lhs, 0) + rhs
}
func += (inout lhs:Complex32, rhs:Complex32) -> Complex32 {
    lhs.re += rhs.re ; lhs.im += rhs.im
    return lhs
}
func += (inout lhs:Complex32, rhs:Float) -> Complex32 {
    lhs.re += rhs
    return lhs
}
// -, -=
prefix func - (z:Complex32) -> Complex32 {
    return Complex32(-z.re, -z.im)
}
func - (lhs:Complex32, rhs:Complex32) -> Complex32 {
    return Complex32(lhs.re - rhs.re, lhs.im - rhs.im)
}
func - (lhs:Complex32, rhs:Float) -> Complex32 {
    return lhs - Complex32(rhs, 0)
}
func - (lhs:Float, rhs:Complex32) -> Complex32 {
    return Complex32(lhs, 0) - rhs
}
func -= (inout lhs:Complex32, rhs:Complex32) -> Complex32 {
    lhs.re -= rhs.re ; lhs.im -= rhs.im
    return lhs
}
func -= (inout lhs:Complex32, rhs:Float) -> Complex32 {
    lhs.re -= rhs
    return lhs
}
// *, *=
func * (lhs:Complex32, rhs:Complex32) -> Complex32 {
    return Complex32(
        lhs.re * rhs.re - lhs.im * rhs.im,
        lhs.re * rhs.im + lhs.im * rhs.re
    )
}
func * (lhs:Complex32, rhs:Float) -> Complex32 {
    return Complex32(lhs.re * rhs, lhs.im * rhs)
}
func * (lhs:Float, rhs:Complex32) -> Complex32 {
    return Complex32(lhs * rhs.re, lhs * rhs.im)
}
func *= (inout lhs:Complex32, rhs:Complex32) -> Complex32 {
    lhs = lhs * rhs
    return lhs
}
func *= (inout lhs:Complex32, rhs:Float) -> Complex32 {
    lhs = lhs * rhs
    return lhs
}
// /, /=
//
// cf. https://github.com/dankogai/swift-complex/issues/3
//
func / (lhs:Complex32, rhs:Complex32) -> Complex32 {
    if abs(rhs.re) >= abs(rhs.im) {
        let r = rhs.im / rhs.re
        let d = rhs.re + rhs.im * r
        return Complex32 (
            (lhs.re + lhs.im * r) / d,
            (lhs.im - lhs.re * r) / d
        )
    } else {
        let r = rhs.re / rhs.im
        let d = rhs.re * r + rhs.im
        return Complex32 (
            (lhs.re * r + lhs.im) / d,
            (lhs.im * r - lhs.re) / d
        )
        
    }
}
func / (lhs:Complex32, rhs:Float) -> Complex32 {
    return Complex32(lhs.re / rhs, lhs.im / rhs)
}
func / (lhs:Float, rhs:Complex32) -> Complex32 {
    return Complex32(lhs, 0) / rhs
}
func /= (inout lhs:Complex32, rhs:Complex32) -> Complex32 {
    lhs = lhs / rhs
    return lhs
}
func /= (inout lhs:Complex32, rhs:Float) -> Complex32 {
    lhs = lhs / rhs
    return lhs
}
// exp(z)
func exp(z:Complex32) -> Complex32 {
    let abs = exp(z.re)
    let arg = z.im
    return Complex32(abs * cos(arg), abs * sin(arg))
}
// log(z)
func log(z:Complex32) -> Complex32 {
    return Complex32(log(z.abs), z.arg)
}
// log10(z) -- just because C++ has it
func log10(z:Complex32) -> Complex32 { return log(z) / log(10) }
func log10(r:Float) -> Float { return log(r) / log(10) }
// pow(b, x)
func pow(lhs:Complex32, rhs:Complex32) -> Complex32 {
    let z = log(lhs) * rhs
    return exp(z)
}
func pow(lhs:Complex32, rhs:Float) -> Complex32 {
    return pow(lhs, Complex32(rhs, 0))
}
func pow(lhs:Float, rhs:Complex32) -> Complex32 {
    return pow(Complex32(lhs, 0), rhs)
}
// **, **=
// infix operator ** { associativity right precedence 170 }
func ** (lhs:Float, rhs:Float) -> Float {
    return pow(lhs, rhs)
}
func ** (lhs:Complex32, rhs:Complex32) -> Complex32 {
    return pow(lhs, rhs)
}
func ** (lhs:Float, rhs:Complex32) -> Complex32 {
    return pow(lhs, rhs)
}
func ** (lhs:Complex32, rhs:Float) -> Complex32 {
    return pow(lhs, rhs)
}
infix operator **= { associativity right precedence 90 }
func **= (inout lhs:Float, rhs:Float) -> Float {
    lhs = pow(lhs, rhs)
    return lhs
}
func **= (inout lhs:Complex32, rhs:Complex32) -> Complex32 {
    lhs = pow(lhs, rhs)
    return lhs
}
func **= (inout lhs:Complex32, rhs:Float) -> Complex32 {
    lhs = pow(lhs, rhs)
    return lhs
}
// sqrt(z)
func sqrt(z:Complex32) -> Complex32 {
    // return z ** (0.5 as Float)
    let d = hypot(z.re, z.im)
    let re = sqrt((z.re + d)/2)
    let im = z.im < 0 ? -sqrt((-z.re + d)/2) : sqrt((-z.re + d)/2)
    return Complex32(re, im)
}
// cos(z)
func cos(z:Complex32) -> Complex32 {
    // return (exp(i*z) + exp(-i*z)) / 2
    return (exp(z.i) + exp(-z.i)) * (0.5 as Float)
}
// sin(z)
func sin(z:Complex32) -> Complex32 {
    // return (exp(i*z) - exp(-i*z)) / (2*i)
    return (exp(z.i) - exp(-z.i)) * -(0.5 as Float).i
}
// tan(z)
func tan(z:Complex32) -> Complex32 {
    // return sin(z) / cos(z)
    let ezi = exp(z.i), e_zi = exp(-z.i)
    return (ezi - e_zi) / (ezi + e_zi).i
}
// atan(z)
func atan(z:Complex32) -> Complex32 {
    return (0.5 as Float).i * (log(1 - z.i) - log(1 + z.i))
}
func atan(r:Float) -> Float { return atan(Complex32(r, 0)).re }
// atan2(z, zz)
func atan2(z:Complex32, zz:Complex32) -> Complex32 {
    return atan(z / zz)
}
// asin(z)
func asin(z:Complex32) -> Complex32 {
    return -(1.0 as Float).i * log(z.i + sqrt(1 - z*z))
}
// acos(z)
func acos(z:Complex32) -> Complex32 {
    return (1.0 as Float).i * log(z - sqrt(1 - z*z).i)
}
// sinh(z)
func sinh(z:Complex32) -> Complex32 {
    return (0.5 as Float) * (exp(z) - exp(-z))
}
// cosh(z)
func cosh(z:Complex32) -> Complex32 {
    return (0.5 as Float) * (exp(z) + exp(-z))
}
// tanh(z)
func tanh(z:Complex32) -> Complex32 {
    let ez = exp(z), e_z = exp(-z)
    return (ez - e_z) / (ez + e_z)
}
// asinh(z)
func asinh(z:Complex32) -> Complex32 {
    return log(z + sqrt(z*z + 1))
}
// acosh(z)
func acosh(z:Complex32) -> Complex32 {
    return log(z + sqrt(z*z - 1))
}
// atanh(z)
func atanh(z:Complex32) -> Complex32 {
    return (0.5 as Float) * log((1 + z)/(1 - z))
}
// for the compatibility's sake w/ C++11
func abs(z:Complex32) -> Float { return z.abs }
func arg(z:Complex32) -> Float { return z.arg }
func real(z:Complex32) -> Float { return z.real }
func imag(z:Complex32) -> Float { return z.imag }
func norm(z:Complex32) -> Float { return z.norm }
func conj(z:Complex32) -> Complex32 { return z.conj }
func proj(z:Complex32) -> Complex32 { return z.proj }
//
// approximate comparisons
//
// infix operator =~ { associativity none precedence 130 }
func =~ (lhs:Float, rhs:Float) -> Bool {
    if lhs == rhs { return true }
    return abs((1.0 as Float) - lhs/rhs) <= (2.0 as Float) * Float.epsilon
}
func =~ (lhs:Complex32, rhs:Complex32) -> Bool {
    if lhs == rhs { return true }
    return lhs.abs =~ rhs.abs
}
func =~ (lhs:Complex32, rhs:Float) -> Bool {
    return lhs.abs =~ abs(rhs)
}
func =~ (lhs:Float, rhs:Complex32) -> Bool {
    return abs(lhs) =~ rhs.abs
}
infix operator !~ { associativity none precedence 130 }
func !~ (lhs:Float, rhs:Float) -> Bool {
    return !(lhs =~ rhs)
}
func !~ (lhs:Complex32, rhs:Complex32) -> Bool {
    return !(lhs =~ rhs)
}
func !~ (lhs:Complex32, rhs:Float) -> Bool {
    return !(lhs =~ rhs)
}
func !~ (lhs:Float, rhs:Complex32) -> Bool {
    return !(lhs =~ rhs)
}
