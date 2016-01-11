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
/// The protocol that `T` of Complex<T> needs to conform.
///
/// Curently `Double` and `Float` are extented to conform this.
///
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
    // math functions - needs extension for each struct
    var int:Int { get }
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
// protocol extension !!!
public extension RealType {
    /// self * 1.0i
    public var i:Complex<Self>{ return Complex(Self(0), self) }
    /// abs(z)
    public static func abs(z:Self)->Self { return abs(z) }
}
// Double is default since floating-point literals are Double by default
extension Double : RealType {
    public var int:Int { return Int(self) }
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
    // these ought to be static let
    // but give users a chance to overwrite it
    public static var PI = M_PI
    public static var π = PI
    public static var E =  M_E
    public static var LN2 = M_LN2
    public static var LOG2E = M_LOG2E
    public static var LN10 = M_LN10
    public static var LOG10E = M_LOG10E
    public static var SQRT2 = M_SQRT2
    public static var SQRT1_2 = M_SQRT1_2
    public static var EPSILON = 0x1p-52
}
// But when explicitly typed you can use Float
extension Float : RealType {
    public var int:Int { return Int(self) }
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
    // these ought to be static let
    // but give users a chance to overwrite it
    public static var PI = Float(Double.PI)
    public static var π = PI
    public static var E =  Float(Double.E)
    public static var LN2 = Float(Double.LN2)
    public static var LOG2E = Float(Double.LOG2E)
    public static var LN10 = Float(Double.LN10)
    public static var LOG10E = Float(Double.LOG10E)
    public static var SQRT2 = Float(Double.SQRT2)
    public static var SQRT1_2 = Float(Double.SQRT1_2)
    public static var EPSILON:Float = 0x1p-23
}
/// Complex number of `RealType`
///
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
    /// real part of self in T:RealType
    public var real:T { get{ return re } set(r){ re = r } }
    /// imaginary part of self in T:RealType
    public var imag:T { get{ return im } set(i){ im = i } }
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
    /// norm of self in T:RealType
    public var norm:T { return T.hypot(re, im) }
    /// conjugate of self in Complex
    public var conj:Complex { return Complex(re, -im) }
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
    /// (real, imag)
    public var tuple:(T, T) {
        get { return (re, im) }
        set(t){ (re, im) = t}
    }
    /// self * i in Complex
    public var i:Complex { return Complex(-im, re) }
    /// .description -- conforms to Printable
    public var description:String {
        let plus = im.isSignMinus ? "-" : "+"
        return "(\(re)\(plus)\(T.abs(im)).i)"
    }
    /// .hashValue -- conforms to Hashable
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
/// - returns: e ** z in Complex
public func exp<T>(z:Complex<T>) -> Complex<T> {
    let r = T.exp(z.re)
    let a = z.im
    return Complex(r * T.cos(a), r * T.sin(a))
}
/// - returns: natural log of z in Complex
public func log<T>(z:Complex<T>) -> Complex<T> {
    return Complex(T.log(z.abs), z.arg)
}
/// - returns: log 10 of z in Complex
public func log10<T>(z:Complex<T>) -> Complex<T> { return log(z) / T(M_LN10) }
public func log10<T:RealType>(r:T) -> T { return T.log(r) / T(M_LN10) }
/// - returns: lhs ** rhs in Complex
public func pow<T>(lhs:Complex<T>, _ rhs:Complex<T>) -> Complex<T> {
    return exp(log(lhs) * rhs)
}
/// - returns: lhs ** rhs in Complex
public func pow<T>(lhs:Complex<T>, _ rhs:Int) -> Complex<T> {
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
public func pow<T>(lhs:Complex<T>, _ rhs:T) -> Complex<T> {
    if lhs == T(1) || rhs == T(0) {
        return Complex(T(1), T(0)) // x ** 0 == 1 for any x; 1 ** y == 1 for any y
    }
    if lhs == T(0) { return Complex(T.pow(lhs.re, rhs), T(0)) } // 0 ** y for any y
    // integer
    let ix = rhs.int
    if T(ix) == rhs { return pow(lhs, ix) }
    // integer/2
    let fx = rhs - T(ix)
    return fx*2 == T(1) ? pow(lhs, ix) * sqrt(lhs)
        : -fx*2 == T(1) ? pow(lhs, ix) / sqrt(lhs)
        : pow(lhs, Complex(rhs, T(0)))
}
/// - returns: lhs ** rhs in Complex
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
/// - returns: square root of z in Complex
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
/// - returns: cosine of z in Complex
public func cos<T>(z:Complex<T>) -> Complex<T> {
    //return (exp(z.i) + exp(-z.i)) / T(2)
    return Complex(T.cos(z.re)*T.cosh(z.im), -T.sin(z.re)*T.sinh(z.im))
}
/// - returns: sine of z in Complex
public func sin<T>(z:Complex<T>) -> Complex<T> {
    // return -(exp(z.i) - exp(-z.i)).i / T(2)
    return Complex(T.sin(z.re)*T.cosh(z.im), +T.cos(z.re)*T.sinh(z.im))
}
/// - returns: tangent of z in Complex
public func tan<T>(z:Complex<T>) -> Complex<T> {
    return sin(z) / cos(z)
}
/// - returns: arc tangent of z in Complex
public func atan<T>(z:Complex<T>) -> Complex<T> {
    let lp = log(T(1) - z.i), lm = log(T(1) + z.i)
    return (lp - lm).i / T(2)
}
/// - returns: arc sine of z in Complex
public func asin<T>(z:Complex<T>) -> Complex<T> {
    return -log(z.i + sqrt(T(1) - z*z)).i
}
/// - returns: arc cosine of z in Complex
public func acos<T>(z:Complex<T>) -> Complex<T> {
    return log(z - sqrt(T(1) - z*z).i).i
}
/// - returns: hyperbolic sine of z in Complex
public func sinh<T>(z:Complex<T>) -> Complex<T> {
    // return (exp(z) - exp(-z)) / T(2)
    return -sin(z.i).i;
}
/// - returns: hyperbolic cosine of z in Complex
public func cosh<T>(z:Complex<T>) -> Complex<T> {
    // return (exp(z) + exp(-z)) / T(2)
    return cos(z.i);
}
/// - returns: hyperbolic tangent of z in Complex
public func tanh<T>(z:Complex<T>) -> Complex<T> {
    // let ez = exp(z), e_z = exp(-z)
    // return (ez - e_z) / (ez + e_z)
    return sinh(z) / cosh(z)
}
/// - returns: inverse hyperbolic sine of z in Complex
public func asinh<T>(z:Complex<T>) -> Complex<T> {
    return log(z + sqrt(z*z + T(1)))
}
/// - returns: inverse hyperbolic cosine of z in Complex
public func acosh<T>(z:Complex<T>) -> Complex<T> {
    return log(z + sqrt(z*z - T(1)))
}
/// - returns: inverse hyperbolic tangent of z in Complex
public func atanh<T>(z:Complex<T>) -> Complex<T> {
    let tp = T(1) + z, tm = T(1) - z
    return log(tp / tm) / T(2)
}
/*
 * for the compatibility's sake w/ C++11
 */
/// absolute value of z in T:RealType
public func abs<T>(z:Complex<T>) -> T { return z.abs }
/// argument of z in T:RealType
public func arg<T>(z:Complex<T>) -> T { return z.arg }
/// real part of z in T:RealType
public func real<T>(z:Complex<T>) -> T { return z.real }
/// imaginary part of z in T:RealType
public func imag<T>(z:Complex<T>) -> T { return z.imag }
/// norm of z in T:RealType
public func norm<T>(z:Complex<T>) -> T { return z.norm }
/// conjugate of z in Complex
public func conj<T>(z:Complex<T>) -> Complex<T> { return z.conj }
/// projection of z in Complex
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
