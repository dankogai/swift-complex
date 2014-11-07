//
//  complex.swift
//  complex
//
//  Created by Dan Kogai on 6/12/14.
//  Copyright (c) 2014 Dan Kogai. All rights reserved.
//

import Foundation
// protocol RealType : FloatingPointType // sadly crashes as of Swift 1.1 :-(
protocol RealType {
    // copied from FloatingPointType
    init(_ value: UInt8)
    init(_ value: Int8)
    init(_ value: UInt16)
    init(_ value: Int16)
    init(_ value: UInt32)
    init(_ value: Int32)
    init(_ value: UInt64)
    init(_ value: Int64)
    init(_ value: UInt)
    init(_ value: Int)
    class var infinity: Self { get }
    class var NaN: Self { get }
    class var quietNaN: Self { get }
    var floatingPointClass: FloatingPointClassification { get }
    var isSignMinus: Bool { get }
    var isNormal: Bool { get }
    var isFinite: Bool { get }
    var isZero: Bool { get }
    var isSubnormal: Bool { get }
    var isInfinite: Bool { get }
    var isNaN: Bool { get }
    var isSignaling: Bool { get }
    // Built-in operators
    func ==(Self, Self)->Bool
    func !=(Self, Self)->Bool
    func < (Self, Self)->Bool
    func <= (Self, Self)->Bool
    func > (Self, Self)->Bool
    func >= (Self, Self)->Bool
    prefix func + (Self)->Self
    prefix func - (Self)->Self
    func + (Self, Self)->Self
    func - (Self, Self)->Self
    func * (Self, Self)->Self
    func / (Self, Self)->Self
    func += (inout Self, Self)
    func -= (inout Self, Self)
    func *= (inout Self, Self)
    func /= (inout Self, Self)
    // methodized functions for protocol's sake
    var abs:Self { get }
    func cos()->Self
    func exp()->Self
    func log()->Self
    func sin()->Self
    func sqrt()->Self
    func hypot(Self)->Self
    func atan2(Self)->Self
    func pow(Self)->Self
    class var LN10:Self { get }
    class var epsilon:Self { get }
}
// Double is default since floating-point literals are Double by default
extension Double : RealType {
    var abs:Double { return Swift.abs(self) }
    func cos()->Double { return Foundation.cos(self) }
    func exp()->Double { return Foundation.exp(self) }
    func log()->Double { return Foundation.log(self) }
    func sin()->Double { return Foundation.sin(self) }
    func sqrt()->Double { return Foundation.sqrt(self) }
    func atan2(y:Double)->Double { return Foundation.atan2(self, y) }
    func hypot(y:Double)->Double { return Foundation.hypot(self, y) }
    func pow(y:Double)->Double { return Foundation.pow(self, y) }
    // these ought to be static let
    // but give users a chance to overwrite it
    static var PI = 3.14159265358979323846264338327950288419716939937510
    static var π = PI
    static var E =  2.718281828459045235360287471352662497757247093699
    static var e = E
    static var LN2 =
    0.6931471805599453094172321214581765680755001343602552
    static var LOG2E = 1 / LN2
    static var LN10 =
    2.3025850929940456840179914546843642076011014886287729
    static var LOG10E = 1/LN10
    static var SQRT2 =
    1.4142135623730950488016887242096980785696718753769480
    static var SQRT1_2 = 1/SQRT2
    static var epsilon = 0x1p-52
    /// self * 1.0i
    var i:Complex<Double>{ return Complex<Double>(0.0, self) }
}
// But when explicitly typed you can use Float
extension Float : RealType {
    var abs:Float { return Swift.abs(self) }
    func cos()->Float { return Foundation.cos(self) }
    func exp()->Float { return Foundation.exp(self) }
    func log()->Float { return Foundation.log(self) }
    func sin()->Float { return Foundation.sin(self) }
    func sqrt()->Float { return Foundation.sqrt(self) }
    func hypot(y:Float)->Float { return Foundation.hypot(self, y) }
    func atan2(y:Float)->Float { return Foundation.atan2(self, y) }
    func pow(y:Float)->Float { return Foundation.pow(self, y) }
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
    /// self * 1.0i
    var i:Complex<Float>{ return Complex<Float>(0.0 as Float, self) }
}
// el corazon
struct Complex<T:RealType> : Equatable, Printable {
    var (re:T, im:T)
    init(_ re:T, _ im:T) {
        self.re = re
        self.im = im
    }
    init(){ self.init(T(0), T(0)) }
    init(abs:T, arg:T) {
        self.re = abs * arg.cos()
        self.im = abs * arg.sin()
    }
    var description:String {
        let plus = im.isSignMinus ? "" : "+"
        return "(\(re)\(plus)\(im).i)"
    }
    var real:T { get{ return re } set(r){ re = r } }
    var imag:T { get{ return im } set(i){ im = i } }
    var abs:T {
        get { return re.hypot(im) }
        set(r){ let f = r / abs; re *= f; im *= f }
    }
    var arg:T  {
        get { return im.atan2(re) }
        set(t){ let m = abs; re = m * t.cos(); im = m * t.sin() }
    }
    var norm:T { return re.hypot(im) }
    var conj:Complex { return Complex(re, -im) }
    var proj:Complex {
        if re.isFinite && im.isFinite {
            return self
        } else {
            return Complex(
                T.infinity, im.isSignMinus ? -T(0) : T(0)
            )
        }
    }
    var tuple:(T, T) {
        get { return (re, im) }
        set(t){ (re, im) = t}
    }
    var i:Complex { return Complex(-im, re) }
}
// operator definitions
infix operator ** { associativity right precedence 170 }
infix operator **= { associativity right precedence 90 }
infix operator =~ { associativity none precedence 130 }
infix operator !~ { associativity none precedence 130 }
// != is auto-generated thanks to Equatable
func == <T>(lhs:Complex<T>, rhs:Complex<T>) -> Bool {
    return lhs.re == rhs.re && lhs.im == rhs.im
}
func == <T>(lhs:Complex<T>, rhs:T) -> Bool {
    return lhs.re == rhs && lhs.im == T(0)
}
func == <T>(lhs:T, rhs:Complex<T>) -> Bool {
    return rhs.re == lhs && rhs.im == T(0)
}
// +, +=
prefix func + <T>(z:Complex<T>) -> Complex<T> {
    return z
}
func + <T>(lhs:Complex<T>, rhs:Complex<T>) -> Complex<T> {
    return Complex(lhs.re + rhs.re, lhs.im + rhs.im)
}
func + <T>(lhs:Complex<T>, rhs:T) -> Complex<T> {
    return lhs + Complex(rhs, T(0))
}
func + <T>(lhs:T, rhs:Complex<T>) -> Complex<T> {
    return Complex(lhs, T(0)) + rhs
}
func += <T>(inout lhs:Complex<T>, rhs:Complex<T>) {
    lhs.re += rhs.re ; lhs.im += rhs.im
}
func += <T>(inout lhs:Complex<T>, rhs:T) {
    lhs.re += rhs
}
// -, -=
prefix func - <T>(z:Complex<T>) -> Complex<T> {
    return Complex<T>(-z.re, -z.im)
}
func - <T>(lhs:Complex<T>, rhs:Complex<T>) -> Complex<T> {
    return Complex(lhs.re - rhs.re, lhs.im - rhs.im)
}
func - <T>(lhs:Complex<T>, rhs:T) -> Complex<T> {
    return lhs - Complex(rhs, T(0))
}
func - <T>(lhs:T, rhs:Complex<T>) -> Complex<T> {
    return Complex(lhs, T(0)) - rhs
}
func -= <T>(inout lhs:Complex<T>, rhs:Complex<T>) {
    lhs.re -= rhs.re ; lhs.im -= rhs.im
}
func -= <T>(inout lhs:Complex<T>, rhs:T) {
    lhs.re -= rhs
}
// *, *=
func * <T>(lhs:Complex<T>, rhs:Complex<T>) -> Complex<T> {
    return Complex(
        lhs.re * rhs.re - lhs.im * rhs.im,
        lhs.re * rhs.im + lhs.im * rhs.re
    )
}
func * <T>(lhs:Complex<T>, rhs:T) -> Complex<T> {
    return Complex(lhs.re * rhs, lhs.im * rhs)
}
func * <T>(lhs:T, rhs:Complex<T>) -> Complex<T> {
    return Complex(lhs * rhs.re, lhs * rhs.im)
}
func *= <T>(inout lhs:Complex<T>, rhs:Complex<T>) {
    lhs = lhs * rhs
}
func *= <T>(inout lhs:Complex<T>, rhs:T) {
    lhs = lhs * rhs
}
// /, /=
//
// cf. https://github.com/dankogai/swift-complex/issues/3
//
func / <T>(lhs:Complex<T>, rhs:Complex<T>) -> Complex<T> {
    if rhs.re.abs >= rhs.im.abs {
        let r = rhs.im / rhs.re
        let d = rhs.re + rhs.im * r
        return Complex (
            (lhs.re + lhs.im * r) / d,
            (lhs.im - lhs.re * r) / d
        )
    } else {
        let r = rhs.re / rhs.im
        let d = rhs.re * r + rhs.im
        return Complex (
            (lhs.re * r + lhs.im) / d,
            (lhs.im * r - lhs.re) / d
        )
        
    }
}
func / <T>(lhs:Complex<T>, rhs:T) -> Complex<T> {
    return Complex(lhs.re / rhs, lhs.im / rhs)
}
func / <T>(lhs:T, rhs:Complex<T>) -> Complex<T> {
    return Complex(lhs, T(0)) / rhs
}
func /= <T>(inout lhs:Complex<T>, rhs:Complex<T>) {
    lhs = lhs / rhs
}
func /= <T>(inout lhs:Complex<T>, rhs:T) {
    lhs = lhs / rhs
}
// exp(z)
func exp<T>(z:Complex<T>) -> Complex<T> {
    let abs = z.re.exp()
    let arg = z.im
    return Complex(abs * arg.cos(), abs * arg.sin())
}
// log(z)
func log<T>(z:Complex<T>) -> Complex<T> {
    return Complex(z.abs.log(), z.arg)
}
// log10(z) -- just because C++ has it
func log10<T>(z:Complex<T>) -> Complex<T> { return log(z) / T.LN10 }
func log10<T:RealType>(r:T) -> T { return r.log() / T.LN10 }
// pow(b, x)
func pow<T>(lhs:Complex<T>, rhs:Complex<T>) -> Complex<T> {
    let z = log(lhs) * rhs
    return exp(z)
}
func pow<T>(lhs:Complex<T>, rhs:T) -> Complex<T> {
    return pow(lhs, Complex(rhs, T(0)))
}
func pow<T>(lhs:T, rhs:Complex<T>) -> Complex<T> {
    return pow(Complex(lhs, T(0)), rhs)
}
// **, **=
func **<T:RealType>(lhs:T, rhs:T) -> T {
    return lhs.pow(rhs)
}
func ** <T>(lhs:Complex<T>, rhs:Complex<T>) -> Complex<T> {
    return pow(lhs, rhs)
}
func ** <T>(lhs:T, rhs:Complex<T>) -> Complex<T> {
    return pow(lhs, rhs)
}
func ** <T>(lhs:Complex<T>, rhs:T) -> Complex<T> {
    return pow(lhs, rhs)
}
func **= <T:RealType>(inout lhs:T, rhs:T) {
    lhs = lhs.pow(rhs)
}
func **= <T>(inout lhs:Complex<T>, rhs:Complex<T>) {
    lhs = pow(lhs, rhs)
}
func **= <T>(inout lhs:Complex<T>, rhs:T) {
    lhs = pow(lhs, rhs)
}
// sqrt(z)
func sqrt<T>(z:Complex<T>) -> Complex<T> {
    // return z ** 0.5
    let d = z.re.hypot(z.im)
    let re = ((z.re + d)/T(2)).sqrt()
    let im = z.im < T(0) ? -((-z.re + d)/T(2)).sqrt() : ((-z.re + d)/T(2)).sqrt()
    return Complex(re, im)
}
// cos(z)
func cos<T>(z:Complex<T>) -> Complex<T> {
    // return (exp(i*z) + exp(-i*z)) / 2
    return (exp(z.i) + exp(-z.i)) / T(2)
}
// sin(z)
func sin<T>(z:Complex<T>) -> Complex<T> {
    // return (exp(i*z) - exp(-i*z)) / (2*i)
    return -(exp(z.i) - exp(-z.i)).i / T(2)
}
// tan(z)
func tan<T>(z:Complex<T>) -> Complex<T> {
    // return sin(z) / cos(z)
    let ezi = exp(z.i), e_zi = exp(-z.i)
    return (ezi - e_zi) / (ezi + e_zi).i
}
// atan(z)
func atan<T>(z:Complex<T>) -> Complex<T> {
    let t = log(T(1) - z.i) - log(T(1) + z.i)
    return t.i / T(2)
}
func atan<T:RealType>(r:T) -> T { return atan(Complex(r, T(0))).re }
// atan2(z, zz)
func atan2<T>(z:Complex<T>, zz:Complex<T>) -> Complex<T> {
    return atan(z / zz)
}
// asin(z)
func asin<T>(z:Complex<T>) -> Complex<T> {
    return -log(z.i + sqrt(T(1) - z*z)).i
}
// acos(z)
func acos<T>(z:Complex<T>) -> Complex<T> {
    return log(z - sqrt(T(1) - z*z).i).i
}
// sinh(z)
func sinh<T>(z:Complex<T>) -> Complex<T> {
    return (exp(z) - exp(-z)) / T(2)
}
// cosh(z)
func cosh<T>(z:Complex<T>) -> Complex<T> {
    return (exp(z) + exp(-z)) / T(2)
}
// tanh(z)
func tanh<T>(z:Complex<T>) -> Complex<T> {
    let ez = exp(z), e_z = exp(-z)
    return (ez - e_z) / (ez + e_z)
}
// asinh(z)
func asinh<T>(z:Complex<T>) -> Complex<T> {
    return log(z + sqrt(z*z + T(1)))
}
// acosh(z)
func acosh<T>(z:Complex<T>) -> Complex<T> {
    return log(z + sqrt(z*z - T(1)))
}
// atanh(z)
func atanh<T>(z:Complex<T>) -> Complex<T> {
    let t = log((T(1) + z)/(T(1) - z))
    return t / T(2)
}
// for the compatibility's sake w/ C++11
func abs<T>(z:Complex<T>) -> T { return z.abs }
func arg<T>(z:Complex<T>) -> T { return z.arg }
func real<T>(z:Complex<T>) -> T { return z.real }
func imag<T>(z:Complex<T>) -> T { return z.imag }
func norm<T>(z:Complex<T>) -> T { return z.norm }
func conj<T>(z:Complex<T>) -> Complex<T> { return z.conj }
func proj<T>(z:Complex<T>) -> Complex<T> { return z.proj }
//
// approximate comparisons
//
func =~ <T:RealType>(lhs:T, rhs:T) -> Bool {
    if lhs == rhs { return true }
    let t = (rhs - lhs) / rhs
    return t.abs <= T(2) * T.epsilon
}
func =~ <T>(lhs:Complex<T>, rhs:Complex<T>) -> Bool {
    if lhs == rhs { return true }
    return lhs.abs =~ rhs.abs
}
func =~ <T>(lhs:Complex<T>, rhs:T) -> Bool {
    return lhs.abs =~ rhs.abs
}
func =~ <T>(lhs:T, rhs:Complex<T>) -> Bool {
    return lhs.abs =~ rhs.abs
}
func !~ <T:RealType>(lhs:T, rhs:T) -> Bool {
    return !(lhs =~ rhs)
}
func !~ <T>(lhs:Complex<T>, rhs:Complex<T>) -> Bool {
    return !(lhs =~ rhs)
}
func !~ <T>(lhs:Complex<T>, rhs:T) -> Bool {
    return !(lhs =~ rhs)
}
func !~ <T>(lhs:T, rhs:Complex<T>) -> Bool {
    return !(lhs =~ rhs)
}
// typealiases
typealias Complex64 = Complex<Double>
typealias Complex32 = Complex<Float>

