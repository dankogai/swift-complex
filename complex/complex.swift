//
//  complex.swift
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
public protocol RealType : FloatingPointType, AbsoluteValuable, Equatable, Comparable, Hashable {
    // Initializers (predefined)
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
    init(_ value: Double)
    init(_ value: Float)
    // Built-in operators (predefined)
    prefix func + (_: Self)->Self
    prefix func - (_: Self)->Self
    func + (_: Self, _: Self)->Self
    func - (_: Self, _: Self)->Self
    func * (_: Self, _: Self)->Self
    func / (_: Self, _: Self)->Self
    func += (inout _: Self, _: Self)
    func -= (inout _: Self, _: Self)
    func *= (inout _: Self, _: Self)
    func /= (inout _: Self, _: Self)
    // math functions
    static func abs(_:Self)->Self
    static func cos(_:Self)->Self
    static func exp(_:Self)->Self
    static func log(_:Self)->Self
    static func sin(_:Self)->Self
    static func sqrt(_:Self)->Self
    static func hypot(_:Self, _:Self)->Self
    static func atan2(_:Self, _:Self)->Self
    static func pow(_:Self, _:Self)->Self
    static var EPSILON:Self { get }
}
// protocol extension !!!
public extension RealType {
    /// self * 1.0i
    public var i:Complex<Self>{ return Complex(Self(0), self) }
}
// Double is default since floating-point literals are Double by default
extension Double : RealType {
    public static func abs(x:Double)->Double { return abs(x) }
    #if os(Linux)
    public static func cos(x:Double)->Double { return Glibc.cos(x) }
    public static func exp(x:Double)->Double { return Glibc.exp(x) }
    public static func log(x:Double)->Double { return Glibc.log(x) }
    public static func sin(x:Double)->Double { return Glibc.sin(x) }
    public static func sqrt(x:Double)->Double { return Glibc.sqrt(x) }
    public static func hypot(x:Double, _ y:Double)->Double { return Glibc.hypot(x, y) }
    public static func atan2(y:Double, _ x:Double)->Double { return Glibc.atan2(y, x) }
    public static func pow(x:Double, _ y:Double)->Double { return Glibc.pow(x, y) }
    #else
    public static func cos(x:Double)->Double { return Foundation.cos(x) }
    public static func exp(x:Double)->Double { return Foundation.exp(x) }
    public static func log(x:Double)->Double { return Foundation.log(x) }
    public static func sin(x:Double)->Double { return Foundation.sin(x) }
    public static func sqrt(x:Double)->Double { return Foundation.sqrt(x) }
    public static func hypot(x:Double, _ y:Double)->Double { return Foundation.hypot(x, y) }
    public static func atan2(y:Double, _ x:Double)->Double { return Foundation.atan2(y, x) }
    public static func pow(x:Double, _ y:Double)->Double { return Foundation.pow(x, y) }
    #endif
    // these ought to be static let
    // but give users a chance to overwrite it
    public static var PI = 3.14159265358979323846264338327950288419716939937510
    public static var π = PI
    public static var E =  2.718281828459045235360287471352662497757247093699
    public static var LN2 =
    0.6931471805599453094172321214581765680755001343602552
    public static var LOG2E = 1 / LN2
    public static var LN10 =
    2.3025850929940456840179914546843642076011014886287729
    public static var LOG10E = 1/LN10
    public static var SQRT2 =
    1.4142135623730950488016887242096980785696718753769480
    public static var SQRT1_2 = 1/SQRT2
    public static var EPSILON = 0x1p-52
}
// But when explicitly typed you can use Float
extension Float : RealType {
    public static func abs(x:Float)->Float { return abs(x) }
    #if os(Linux)
    public static func cos(x:Float)->Float { return Glibc.cosf(x) }
    public static func exp(x:Float)->Float { return Glibc.expf(x) }
    public static func log(x:Float)->Float { return Glibc.logf(x) }
    public static func sin(x:Float)->Float { return Glibc.sinf(x) }
    public static func sqrt(x:Float)->Float { return Glibc.sqrtf(x) }
    public static func hypot(x:Float, _ y:Float)->Float { return Glibc.hypotf(x, y) }
    public static func atan2(y:Float, _ x:Float)->Float { return Glibc.atan2f(y, x) }
    public static func pow(x:Float, _ y:Float)->Float { return Glibc.powf(x, y) }
    #else
    public static func cos(x:Float)->Float { return Foundation.cosf(x) }
    public static func exp(x:Float)->Float { return Foundation.expf(x) }
    public static func log(x:Float)->Float { return Foundation.logf(x) }
    public static func sin(x:Float)->Float { return Foundation.sinf(x) }
    public static func sqrt(x:Float)->Float { return Foundation.sqrtf(x) }
    public static func hypot(x:Float, _ y:Float)->Float { return Foundation.hypotf(x, y) }
    public static func atan2(y:Float, _ x:Float)->Float { return Foundation.atan2f(y, x) }
    public static func pow(x:Float, _ y:Float)->Float { return Foundation.powf(x, y) }
    #endif
    // these ought to be static let
    // but give users a chance to overwrite it
    public static var PI:Float = 3.14159265358979323846264338327950288419716939937510
    public static var π:Float = PI
    public static var E:Float =  2.718281828459045235360287471352662497757247093699
    public static var LN2:Float =
    0.6931471805599453094172321214581765680755001343602552
    public static var LOG2E:Float = 1 / LN2
    public static var LN10:Float =
    2.3025850929940456840179914546843642076011014886287729
    public static var LOG10E:Float = 1/LN10
    public static var SQRT2:Float =
    1.4142135623730950488016887242096980785696718753769480
    public static var SQRT1_2:Float = 1/SQRT2
    public static var EPSILON:Float = 0x1p-23
}
// el corazon
public struct Complex<T:RealType> : Equatable, CustomStringConvertible, Hashable {
    public var (re, im): (T, T)
    public init(_ re:T, _ im:T) {
        self.re = re
        self.im = im
    }
    public init(abs:T, arg:T) {
        self.re = abs * T.cos(arg)
        self.im = abs * T.sin(arg)
    }
    /// real part thereof
    public var real:T { get{ return re } set(r){ re = r } }
    /// imaginary part thereof
    public var imag:T { get{ return im } set(i){ im = i } }
    /// absolute value thereof
    public var abs:T {
        get { return T.hypot(re, im) }
        set(r){ let f = r / abs; re *= f; im *= f }
    }
    /// argument thereof
    public var arg:T  {
        get { return T.atan2(im, re) }
        set(t){ let m = abs; re = m * T.cos(t); im = m * T.sin(t) }
    }
    /// norm thereof
    public var norm:T { return T.hypot(re, im) }
    /// conjugate thereof
    public var conj:Complex { return Complex(re, -im) }
    /// projection thereof
    public var proj:Complex {
        if re.isFinite && im.isFinite {
            return self
        } else {
            return Complex(
                T(1)/T(0), im.isSignMinus ? -T(0) : T(0)
            )
        }
    }
    /// (real, imag)
    public var tuple:(T, T) {
        get { return (re, im) }
        set(t){ (re, im) = t}
    }
    /// z * i
    public var i:Complex { return Complex(-im, re) }
    /// .description -- conforms to Printable
    public var description:String {
        let plus = im.isSignMinus ? "" : "+"
        return "(\(re)\(plus)\(im).i)"
    }
    /// .hashvalue -- conforms to Hashable
    public var hashValue:Int { // take most significant halves and join
        let bits = sizeof(Int) * 4
        let mask = bits == 16 ? 0xffff : 0xffffFFFF
        return (re.hashValue & ~mask) | (im.hashValue >> bits)
    }
}
// operator definitions
infix operator ** { associativity right precedence 170 }
infix operator **= { associativity right precedence 90 }
infix operator =~ { associativity none precedence 130 }
infix operator !~ { associativity none precedence 130 }
// ==
public func == <T>(lhs:Complex<T>, rhs:Complex<T>) -> Bool {
    return lhs.re == rhs.re && lhs.im == rhs.im
}
public func == <T>(lhs:Complex<T>, rhs:T) -> Bool {
    return lhs.re == rhs && lhs.im == T(0)
}
public func == <T>(lhs:T, rhs:Complex<T>) -> Bool {
    return rhs.re == lhs && rhs.im == T(0)
}
// != is NOT autogenerated for T != U
public func != <T>(lhs:Complex<T>, rhs:T) -> Bool {
    return lhs.re != rhs && lhs.im == T(0)
}
public func != <T>(lhs:T, rhs:Complex<T>) -> Bool {
    return rhs.re != lhs && rhs.im == T(0)
}
// +, +=
public prefix func + <T>(z:Complex<T>) -> Complex<T> {
    return z
}
public func + <T>(lhs:Complex<T>, rhs:Complex<T>) -> Complex<T> {
    return Complex(lhs.re + rhs.re, lhs.im + rhs.im)
}
public func + <T>(lhs:Complex<T>, rhs:T) -> Complex<T> {
    return lhs + Complex(rhs, T(0))
}
public func + <T>(lhs:T, rhs:Complex<T>) -> Complex<T> {
    return Complex(lhs, T(0)) + rhs
}
public func += <T>(inout lhs:Complex<T>, rhs:Complex<T>) {
    lhs.re += rhs.re ; lhs.im += rhs.im
}
public func += <T>(inout lhs:Complex<T>, rhs:T) {
    lhs.re += rhs
}
// -, -=
public prefix func - <T>(z:Complex<T>) -> Complex<T> {
    return Complex<T>(-z.re, -z.im)
}
public func - <T>(lhs:Complex<T>, rhs:Complex<T>) -> Complex<T> {
    return Complex(lhs.re - rhs.re, lhs.im - rhs.im)
}
public func - <T>(lhs:Complex<T>, rhs:T) -> Complex<T> {
    return lhs - Complex(rhs, T(0))
}
public func - <T>(lhs:T, rhs:Complex<T>) -> Complex<T> {
    return Complex(lhs, T(0)) - rhs
}
public func -= <T>(inout lhs:Complex<T>, rhs:Complex<T>) {
    lhs.re -= rhs.re ; lhs.im -= rhs.im
}
public func -= <T>(inout lhs:Complex<T>, rhs:T) {
    lhs.re -= rhs
}
// *, *=
public func * <T>(lhs:Complex<T>, rhs:Complex<T>) -> Complex<T> {
    return Complex(
        lhs.re * rhs.re - lhs.im * rhs.im,
        lhs.re * rhs.im + lhs.im * rhs.re
    )
}
public func * <T>(lhs:Complex<T>, rhs:T) -> Complex<T> {
    return Complex(lhs.re * rhs, lhs.im * rhs)
}
public func * <T>(lhs:T, rhs:Complex<T>) -> Complex<T> {
    return Complex(lhs * rhs.re, lhs * rhs.im)
}
public func *= <T>(inout lhs:Complex<T>, rhs:Complex<T>) {
    lhs = lhs * rhs
}
public func *= <T>(inout lhs:Complex<T>, rhs:T) {
    lhs = lhs * rhs
}
// /, /=
//
// cf. https://github.com/dankogai/swift-complex/issues/3
//
public func / <T>(lhs:Complex<T>, rhs:Complex<T>) -> Complex<T> {
    if abs(rhs.re) >= abs(rhs.im) {
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
public func / <T>(lhs:Complex<T>, rhs:T) -> Complex<T> {
    return Complex(lhs.re / rhs, lhs.im / rhs)
}
public func / <T>(lhs:T, rhs:Complex<T>) -> Complex<T> {
    return Complex(lhs, T(0)) / rhs
}
public func /= <T>(inout lhs:Complex<T>, rhs:Complex<T>) {
    lhs = lhs / rhs
}
public func /= <T>(inout lhs:Complex<T>, rhs:T) {
    lhs = lhs / rhs
}
// exp(z)
public func exp<T>(z:Complex<T>) -> Complex<T> {
    let abs = T.exp(z.re)
    let arg = z.im
    return Complex(abs * T.cos(arg), abs * T.sin(arg))
}
// log(z)
public func log<T>(z:Complex<T>) -> Complex<T> {
    return Complex(T.log(z.abs), z.arg)
}
// log10(z) -- just because C++ has it
public func log10<T>(z:Complex<T>) -> Complex<T> { return log(z) / T.log(T(10)) }
public func log10<T:RealType>(r:T) -> T { return T.log(r) / T.log(T(10)) }
// pow(b, x)
public func pow<T>(lhs:Complex<T>, _ rhs:Complex<T>) -> Complex<T> {
    if lhs == T(0) { return Complex(T(1), T(0)) } // 0 ** 0 == 1
    let z = log(lhs) * rhs
    return exp(z)
}
public func pow<T>(lhs:Complex<T>, _ rhs:T) -> Complex<T> {
    return pow(lhs, Complex(rhs, T(0)))
}
public func pow<T>(lhs:T, _ rhs:Complex<T>) -> Complex<T> {
    return pow(Complex(lhs, T(0)), rhs)
}
// **, **=
public func **<T:RealType>(lhs:T, rhs:T) -> T {
    return T.pow(lhs, rhs)
}
public func ** <T>(lhs:Complex<T>, rhs:Complex<T>) -> Complex<T> {
    return pow(lhs, rhs)
}
public func ** <T>(lhs:T, rhs:Complex<T>) -> Complex<T> {
    return pow(lhs, rhs)
}
public func ** <T>(lhs:Complex<T>, rhs:T) -> Complex<T> {
    return pow(lhs, rhs)
}
public func **= <T:RealType>(inout lhs:T, rhs:T) {
    lhs = T.pow(lhs, rhs)
}
public func **= <T>(inout lhs:Complex<T>, rhs:Complex<T>) {
    lhs = pow(lhs, rhs)
}
public func **= <T>(inout lhs:Complex<T>, rhs:T) {
    lhs = pow(lhs, rhs)
}
// sqrt(z)
public func sqrt<T>(z:Complex<T>) -> Complex<T> {
    // return z ** 0.5
    let d = T.hypot(z.re, z.im)
    let r = T.sqrt((z.re + d)/T(2))
    if z.im < T(0) {
        return Complex(r, -T.sqrt((-z.re + d)/T(2)))
    } else {
        return Complex(r,  T.sqrt((-z.re + d)/T(2)))
    }
}
// cos(z)
public func cos<T>(z:Complex<T>) -> Complex<T> {
    // return (exp(i*z) + exp(-i*z)) / 2
    return (exp(z.i) + exp(-z.i)) / T(2)
}
// sin(z)
public func sin<T>(z:Complex<T>) -> Complex<T> {
    // return (exp(i*z) - exp(-i*z)) / (2*i)
    return -(exp(z.i) - exp(-z.i)).i / T(2)
}
// tan(z)
public func tan<T>(z:Complex<T>) -> Complex<T> {
    // return sin(z) / cos(z)
    let ezi = exp(z.i), e_zi = exp(-z.i)
    return (ezi - e_zi) / (ezi + e_zi).i
}
// atan(z)
public func atan<T>(z:Complex<T>) -> Complex<T> {
    let l0 = log(T(1) - z.i), l1 = log(T(1) + z.i)
    return (l0 - l1).i / T(2)
}
public func atan<T:RealType>(r:T) -> T { return atan(Complex(r, T(0))).re }
// asin(z)
public func asin<T>(z:Complex<T>) -> Complex<T> {
    return -log(z.i + sqrt(T(1) - z*z)).i
}
// acos(z)
public func acos<T>(z:Complex<T>) -> Complex<T> {
    return log(z - sqrt(T(1) - z*z).i).i
}
// sinh(z)
public func sinh<T>(z:Complex<T>) -> Complex<T> {
    return (exp(z) - exp(-z)) / T(2)
}
// cosh(z)
public func cosh<T>(z:Complex<T>) -> Complex<T> {
    return (exp(z) + exp(-z)) / T(2)
}
// tanh(z)
public func tanh<T>(z:Complex<T>) -> Complex<T> {
    let ez = exp(z), e_z = exp(-z)
    return (ez - e_z) / (ez + e_z)
}
// asinh(z)
public func asinh<T>(z:Complex<T>) -> Complex<T> {
    return log(z + sqrt(z*z + T(1)))
}
// acosh(z)
public func acosh<T>(z:Complex<T>) -> Complex<T> {
    return log(z + sqrt(z*z - T(1)))
}
// atanh(z)
public func atanh<T>(z:Complex<T>) -> Complex<T> {
    let t0 = T(1) + z
    let t1 = T(1) - z
    return log(t0 / t1) / T(2)
}
// for the compatibility's sake w/ C++11
public func abs<T>(z:Complex<T>) -> T { return z.abs }
public func arg<T>(z:Complex<T>) -> T { return z.arg }
public func real<T>(z:Complex<T>) -> T { return z.real }
public func imag<T>(z:Complex<T>) -> T { return z.imag }
public func norm<T>(z:Complex<T>) -> T { return z.norm }
public func conj<T>(z:Complex<T>) -> Complex<T> { return z.conj }
public func proj<T>(z:Complex<T>) -> Complex<T> { return z.proj }
//
// approximate comparisons
//
public func =~ <T:RealType>(lhs:T, rhs:T) -> Bool {
    if lhs == rhs { return true }
    let al = abs(lhs)
    if rhs == 0 { return lhs < T.EPSILON }
    let ar = abs(rhs)
    if lhs == 0 { return rhs < T.EPSILON }
    let da = abs(al - ar) / (al + ar) // delta / average < 2*epsilon
    return da < T(2)*T.EPSILON
}
public func =~ <T>(lhs:Complex<T>, rhs:Complex<T>) -> Bool {
    return lhs.abs =~ rhs.abs
}
public func =~ <T>(lhs:Complex<T>, rhs:T) -> Bool {
    return lhs.abs =~ rhs
}
public func =~ <T>(lhs:T, rhs:Complex<T>) -> Bool {
    return lhs =~ rhs.abs
}
public func !~ <T:RealType>(lhs:T, rhs:T) -> Bool {
    return !(lhs =~ rhs)
}
public func !~ <T>(lhs:Complex<T>, rhs:Complex<T>) -> Bool {
    return !(lhs =~ rhs)
}
public func !~ <T>(lhs:Complex<T>, rhs:T) -> Bool {
    return !(lhs =~ rhs)
}
public func !~ <T>(lhs:T, rhs:Complex<T>) -> Bool {
    return !(lhs =~ rhs)
}
// typealiases
public typealias Complex64 = Complex<Double>
public typealias Complex32 = Complex<Float>
