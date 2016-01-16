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
///
/// The protocol that `T` of Complex<T> needs to conform.
///
/// Curently `Int`, `Double` and `Float` are extented to conform this.
///
public protocol ArithmeticType: AbsoluteValuable, Equatable, Comparable, Hashable {
    // Initializers (predefined)
    init(_: Int)
    init(_: Int16)
    init(_: Int32)
    init(_: Int64)
    init(_: Int8)
    init(_: UInt)
    init(_: UInt16)
    init(_: UInt32)
    init(_: UInt64)
    init(_: UInt8)
    init(_: Double)
    init(_: Float)
    init(_: Self)
    // Operators (predefined)
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
    // Converters (extension needed
    static func toInt(_:Self)->Int
    static func toDouble(_:Self)->Double
}
// protocol extension !!!
public extension ArithmeticType {
    /// self * 1.0i
    public var i:Complex<Self>{ return Complex(Self(0), self) }
    /// abs(z)
    public static func abs(z:Self)->Self { return Swift.abs(z) }
}
extension Int : ArithmeticType {
    public static func toInt(x:Int)->Int { return x }
    public static func toDouble(x:Int)->Double { return Double(x) }
}
///
/// Complex of Integers or Floating-Point Numbers
///
public struct Complex<T:ArithmeticType> : Equatable, CustomStringConvertible, Hashable {
    public var (re, im): (T, T)
    public init(_ re:T, _ im:T) {
        self.re = re
        self.im = im
    }
    public init() {
        re = T(0); im = T(0)
    }
    /// self * i in Complex
    public var i:Complex { return Complex(-im, re) }
    /// real part of self
    public var real:T { get{ return re } set(r){ re = r } }
    /// imaginary part of self
    public var imag:T { get{ return im } set(i){ im = i } }
    /// norm of self
    public var norm:T { return re*re + im*im }
    /// conjugate of self
    public var conj:Complex { return Complex(re, -im) }
    /// .description -- conforms to Printable
    public var description:String {
        let ims = "\(self.im)"
        let sig = ims.hasPrefix("-") ? "" : "+"
        return "(\(re)\(sig)\(ims).i)"
    }
    /// .hashValue -- conforms to Hashable
    public var hashValue:Int { // take most significant halves and join
        let bits = sizeof(Int) * 4
        let mask = bits == 16 ? 0xffff : 0xffffFFFF
        return re is Int
            ? ((re.hashValue & mask) << bits) | (im.hashValue & mask) // Complex<Int>
            :  (re.hashValue & ~mask) | (im.hashValue >> bits)        // Complex<RealType>
    }
    /// (real, imag)
    public var tuple:(T, T) {
        get{ return (re, im) }
        set(t){ (re, im) = t }
    }
    /// Type Conversion
    public var asComplexInt:Complex<Int> {
        return Complex<Int>(T.toInt(re), T.toInt(im))
    }
    public var asComplexDouble:Complex<Double> {
        return Complex<Double>(T.toDouble(re), T.toDouble(im))
    }
}
/// real part of z
public func real<T>(z:Complex<T>) -> T { return z.re }
/// imaginary part of z
public func imag<T>(z:Complex<T>) -> T { return z.im }
/// norm of z
public func norm<T>(z:Complex<T>) -> T { return z.norm }
/// conjugate of z
public func conj<T>(z:Complex<T>) -> Complex<T> { return Complex(z.re, -z.im) }
///
/// Curently `Double` and `Float` are extented to conform this.
///
public protocol RealType : ArithmeticType, FloatingPointType {
    // math functions - needs extension for each struct
    static func cos(_:Self)->Self
    static func cosh(_:Self)->Self
    static func exp(_:Self)->Self
    static func log(_:Self)->Self
    static func sin(_:Self)->Self
    static func sinh(_:Self)->Self
    static func sqrt(_:Self)->Self
    static func hypot(_:Self, _:Self)->Self
    static func atan2(_:Self, _:Self)->Self
    static func pow(_:Self, _:Self)->Self
    static var EPSILON:Self { get } // for =~
}
// Double is default since floating-point literals are Double by default
extension Double : RealType {
    public static func toInt(x:Double)->Int { return Int(x) }
    public static func toDouble(x:Double)->Double { return x }
    #if os(Linux)
    public static func cos(x:Double)->Double    { return Glibc.cos(x) }
    public static func cosh(x:Double)->Double   { return Glibc.cosh(x) }
    public static func exp(x:Double)->Double    { return Glibc.exp(x) }
    public static func log(x:Double)->Double    { return Glibc.log(x) }
    public static func sin(x:Double)->Double    { return Glibc.sin(x) }
    public static func sinh(x:Double)->Double   { return Glibc.sinh(x) }
    public static func sqrt(x:Double)->Double   { return Glibc.sqrt(x) }
    public static func hypot(x:Double, _ y:Double)->Double { return Glibc.hypot(x, y) }
    public static func atan2(y:Double, _ x:Double)->Double { return Glibc.atan2(y, x) }
    public static func pow(x:Double, _ y:Double)->Double   { return Glibc.pow(x, y) }
    #else
    public static func cos(x:Double)->Double    { return Foundation.cos(x) }
    public static func cosh(x:Double)->Double   { return Foundation.cosh(x) }
    public static func exp(x:Double)->Double    { return Foundation.exp(x) }
    public static func log(x:Double)->Double    { return Foundation.log(x) }
    public static func sin(x:Double)->Double    { return Foundation.sin(x) }
    public static func sinh(x:Double)->Double   { return Foundation.sinh(x) }
    public static func sqrt(x:Double)->Double   { return Foundation.sqrt(x) }
    public static func hypot(x:Double, _ y:Double)->Double { return Foundation.hypot(x, y) }
    public static func atan2(y:Double, _ x:Double)->Double { return Foundation.atan2(y, x) }
    public static func pow(x:Double, _ y:Double)->Double { return Foundation.pow(x, y) }
    #endif
    public static var EPSILON = 0x1p-52
    // The following values are for convenience, not really needed for protocol conformance.
    public static var PI = M_PI
    public static var π = PI
    public static var E =  M_E
    public static var LN2 = M_LN2
    public static var LOG2E = M_LOG2E
    public static var LN10 = M_LN10
    public static var LOG10E = M_LOG10E
    public static var SQRT2 = M_SQRT2
    public static var SQRT1_2 = M_SQRT1_2
}
// But when explicitly typed you can use Float
extension Float : RealType {
    public static func toInt(x:Float)->Int { return Int(x) }
    public static func toDouble(x:Float)->Double { return Double(x) }
    #if os(Linux)
    public static func cos(x:Float)->Float  { return Glibc.cosf(x) }
    public static func cosh(x:Float)->Float { return Glibc.coshf(x) }
    public static func exp(x:Float)->Float  { return Glibc.expf(x) }
    public static func log(x:Float)->Float  { return Glibc.logf(x) }
    public static func sin(x:Float)->Float  { return Glibc.sinf(x) }
    public static func sinh(x:Float)->Float { return Glibc.sinhf(x) }
    public static func sqrt(x:Float)->Float { return Glibc.sqrtf(x) }
    public static func hypot(x:Float, _ y:Float)->Float { return Glibc.hypotf(x, y) }
    public static func atan2(y:Float, _ x:Float)->Float { return Glibc.atan2f(y, x) }
    public static func pow(x:Float, _ y:Float)->Float   { return Glibc.powf(x, y) }
    #else
    public static func cos(x:Float)->Float  { return Foundation.cosf(x) }
    public static func cosh(x:Float)->Float { return Foundation.coshf(x) }
    public static func exp(x:Float)->Float  { return Foundation.expf(x) }
    public static func log(x:Float)->Float  { return Foundation.logf(x) }
    public static func sin(x:Float)->Float  { return Foundation.sinf(x) }
    public static func sinh(x:Float)->Float { return Foundation.sinhf(x) }
    public static func sqrt(x:Float)->Float { return Foundation.sqrtf(x) }
    public static func hypot(x:Float, _ y:Float)->Float { return Foundation.hypotf(x, y) }
    public static func atan2(y:Float, _ x:Float)->Float { return Foundation.atan2f(y, x) }
    public static func pow(x:Float, _ y:Float)->Float   { return Foundation.powf(x, y) }
    #endif
    public static var EPSILON:Float = 0x1p-23
    // The following values are for convenience, not really needed for protocol conformance.
    public static var PI = Float(Double.PI)
    public static var π = PI
    public static var E =  Float(Double.E)
    public static var LN2 = Float(Double.LN2)
    public static var LOG2E = Float(Double.LOG2E)
    public static var LN10 = Float(Double.LN10)
    public static var LOG10E = Float(Double.LOG10E)
    public static var SQRT2 = Float(Double.SQRT2)
    public static var SQRT1_2 = Float(Double.SQRT1_2)
}
/// Complex of Floting Point Numbers
extension Complex where T:RealType {
    public init(abs:T, arg:T) {
        self.re = abs * T.cos(arg)
        self.im = abs * T.sin(arg)
    }
    /// absolute value of self in T:RealType
    public var abs:T {
        get { return T.hypot(re, im) }
        set(r){ let f = r / abs; re *= f; im *= f }
    }
    /// argument of self in T:RealType
    public var arg:T  {
        get { return T.atan2(im, re) }
        set(t){ let m = abs; re = m * T.cos(t); im = m * T.sin(t) }
    }
    /// projection of self in Complex
    public var proj:Complex {
        if re.isFinite && im.isFinite {
            return self
        } else {
            return Complex(
                T(1)/T(0), im.isSignMinus ? -T(0) : T(0)
            )
        }
    }
}
/// absolute value of z
public func abs<T:RealType>(z:Complex<T>) -> T { return z.abs }
/// argument of z
public func arg<T:RealType>(z:Complex<T>) -> T { return z.arg }
/// projection of z
public func proj<T:RealType>(z:Complex<T>) -> Complex<T> { return z.proj }
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
    return !(lhs == rhs)
}
public func != <T>(lhs:T, rhs:Complex<T>) -> Bool {
    return !(rhs == lhs)
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
// *
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
// *=
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
/// - returns: e ** z in Complex
public func exp<T:RealType>(z:Complex<T>) -> Complex<T> {
    let r = T.exp(z.re)
    let a = z.im
    return Complex(r * T.cos(a), r * T.sin(a))
}
/// - returns: natural log of z in Complex
public func log<T:RealType>(z:Complex<T>) -> Complex<T> {
    return Complex(T.log(z.abs), z.arg)
}
/// - returns: log 10 of z in Complex
public func log10<T:RealType>(z:Complex<T>) -> Complex<T> { return log(z) / T(M_LN10) }
public func log10<T:RealType>(r:T) -> T { return T.log(r) / T(M_LN10) }
/// - returns: lhs ** rhs in Complex
public func pow<T:RealType>(lhs:Complex<T>, _ rhs:Complex<T>) -> Complex<T> {
    return exp(log(lhs) * rhs)
}
/// - returns: lhs ** rhs in Complex
public func pow<T:RealType>(lhs:Complex<T>, _ rhs:Int) -> Complex<T> {
    if rhs == 1 { return lhs }
    var r = Complex(T(1), T(0))
    if rhs == 0 { return r }
    if lhs == 0 { return Complex(T(1)/T(0), T(0)) }
    var ux = abs(rhs), b = lhs
    while (ux > 0) {
        if ux & 1 == 1 { r *= b }
        ux >>= 1; b *= b
    }
    return rhs < 0 ? T(1) / r : r
}
/// - returns: lhs ** rhs in Complex
public func pow<T:RealType>(lhs:Complex<T>, _ rhs:T) -> Complex<T> {
    if lhs == T(1) || rhs == T(0) {
        return Complex(T(1), T(0)) // x ** 0 == 1 for any x; 1 ** y == 1 for any y
    }
    if lhs == T(0) { return Complex(T.pow(lhs.re, rhs), T(0)) } // 0 ** y for any y
    // integer
    let ix = T.toInt(rhs)
    if T(ix) == rhs { return pow(lhs, ix) }
    // integer/2
    let fx = rhs - T(ix)
    return fx*2 == T(1) ? pow(lhs, ix) * sqrt(lhs)
        : -fx*2 == T(1) ? pow(lhs, ix) / sqrt(lhs)
        : pow(lhs, Complex(rhs, T(0)))
}
/// - returns: lhs ** rhs in Complex
public func pow<T:RealType>(lhs:T, _ rhs:Complex<T>) -> Complex<T> {
    return pow(Complex(lhs, T(0)), rhs)
}
/// - returns: square root of z in Complex
public func sqrt<T:RealType>(z:Complex<T>) -> Complex<T> {
    // return z ** 0.5
    let d = T.hypot(z.re, z.im)
    let r = T.sqrt((z.re + d)/T(2))
    if z.im < T(0) {
        return Complex(r, -T.sqrt((-z.re + d)/T(2)))
    } else {
        return Complex(r,  T.sqrt((-z.re + d)/T(2)))
    }
}
/// - returns: cosine of z in Complex
public func cos<T:RealType>(z:Complex<T>) -> Complex<T> {
    //return (exp(z.i) + exp(-z.i)) / T(2)
    return Complex(T.cos(z.re)*T.cosh(z.im), -T.sin(z.re)*T.sinh(z.im))
}
/// - returns: sine of z in Complex
public func sin<T:RealType>(z:Complex<T>) -> Complex<T> {
    // return -(exp(z.i) - exp(-z.i)).i / T(2)
    return Complex(T.sin(z.re)*T.cosh(z.im), +T.cos(z.re)*T.sinh(z.im))
}
/// - returns: tangent of z in Complex
public func tan<T:RealType>(z:Complex<T>) -> Complex<T> {
    return sin(z) / cos(z)
}
/// - returns: arc tangent of z in Complex
public func atan<T:RealType>(z:Complex<T>) -> Complex<T> {
    let lp = log(T(1) - z.i), lm = log(T(1) + z.i)
    return (lp - lm).i / T(2)
}
/// - returns: arc sine of z in Complex
public func asin<T:RealType>(z:Complex<T>) -> Complex<T> {
    return -log(z.i + sqrt(T(1) - z*z)).i
}
/// - returns: arc cosine of z in Complex
public func acos<T:RealType>(z:Complex<T>) -> Complex<T> {
    return log(z - sqrt(T(1) - z*z).i).i
}
/// - returns: hyperbolic sine of z in Complex
public func sinh<T:RealType>(z:Complex<T>) -> Complex<T> {
    // return (exp(z) - exp(-z)) / T(2)
    return -sin(z.i).i;
}
/// - returns: hyperbolic cosine of z in Complex
public func cosh<T:RealType>(z:Complex<T>) -> Complex<T> {
    // return (exp(z) + exp(-z)) / T(2)
    return cos(z.i);
}
/// - returns: hyperbolic tangent of z in Complex
public func tanh<T:RealType>(z:Complex<T>) -> Complex<T> {
    // let ez = exp(z), e_z = exp(-z)
    // return (ez - e_z) / (ez + e_z)
    return sinh(z) / cosh(z)
}
/// - returns: inverse hyperbolic sine of z in Complex
public func asinh<T:RealType>(z:Complex<T>) -> Complex<T> {
    return log(z + sqrt(z*z + T(1)))
}
/// - returns: inverse hyperbolic cosine of z in Complex
public func acosh<T:RealType>(z:Complex<T>) -> Complex<T> {
    return log(z + sqrt(z*z - T(1)))
}
/// - returns: inverse hyperbolic tangent of z in Complex
public func atanh<T:RealType>(z:Complex<T>) -> Complex<T> {
    let tp = T(1) + z, tm = T(1) - z
    return log(tp / tm) / T(2)
}
// typealiases
public typealias ComplexInt     = Complex<Int>
public typealias ComplexDouble  = Complex<Double>
public typealias Complex64      = Complex<Double>
public typealias Complex32      = Complex<Float>
