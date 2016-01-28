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
    import Darwin
    import CoreGraphics
#endif
///
/// ArithmeticType: Minimum requirement for `T` of `Complex<T>`.
///
/// * currently `Int`, `Double` and `Float`
/// * and `CGFloat` if not os(Linux)
public protocol ArithmeticType: AbsoluteValuable, Equatable, Comparable, Hashable {
    // Initializers (predefined)
    init(_: Int)
    init(_: Double)
    init(_: Float)
    init(_: Self)
    // CGFloat if !os(Linux)
    #if !os(Linux)
    init(_: CGFloat)
    #endif
    // Operators (predefined)
    prefix func + (_: Self)->Self
    prefix func - (_: Self)->Self
    func + (_: Self, _: Self)->Self
    func - (_: Self, _: Self)->Self
    func * (_: Self, _: Self)->Self
    func / (_: Self, _: Self)->Self
    // used by Complex#description
    var isSignMinus:Bool { get }
}
// protocol extension !!!
public extension ArithmeticType {
    /// self * 1.0i
    public var i:Complex<Self>{ return Complex(Self(0), self) }
    /// abs(z)
    public static func abs(x:Self)->Self { return x.isSignMinus ? -x : x }
    /// failable initializer to conver the type
    /// - parameter x: `U:ArithmeticType` where U might not be T
    /// - returns: Self(x)
    public init<U:ArithmeticType>(_ x:U) {
        switch x {
        case let s as Self:     self.init(s)
        case let d as Double:   self.init(d)
        case let f as Float:    self.init(f)
        case let i as Int:      self.init(i)
        default:
            fatalError("init(\(x)) failed")
        }
    }
}
extension Int : ArithmeticType {
    /// true if self < 0
    /// used by Complex#description
    public var isSignMinus:Bool{ return self != abs(self) }
}
///
/// Complex of Integers or Floating-Point Numbers
///
public struct Complex<T:ArithmeticType> : Equatable, CustomStringConvertible, Hashable {
    public typealias Element = T
    public var (re, im): (T, T)
    /// standard init(r, i)
    public init(_ r:T, _ i:T) {
        (re, im) = (T(r), T(i))
    }
    /// default init() == init(0, 0)
    public init() {
        (re, im) = (T(0), T(0))
    }
    /// init(t:(r, i))
    public init(t:(T, T)) {
        (re, im) = t
    }
    /// Complex<U> -> Complex<T>
    public init<U:ArithmeticType>(_ z:Complex<U>) {
        self.init(T(z.re), T(z.im))
    }
    /// `self * i`
    public var i:Complex { return Complex(-im, re) }
    /// real part of self. also a setter.
    public var real:T { get{ return re } set(r){ re = r } }
    /// imaginary part of self. also a setter.
    public var imag:T { get{ return im } set(i){ im = i } }
    /// norm of self
    public var norm:T { return re*re + im*im }
    /// conjugate of self
    public var conj:Complex { return Complex(re, -im) }
    /// .description -- conforms to Printable
    public var description:String {
        let sig = im.isSignMinus ? "-" : "+"
        return "(\(re)\(sig)\(T.abs(im)).i)"
    }
    /// .hashValue -- conforms to Hashable
    public var hashValue:Int {
        let bits = sizeof(Int) * 4
        let mask = bits == 16 ? 0xffff : 0xffffFFFF
        // Apply different strategies by types.
        // this is ugly but you can't go like 're is RealType'
        // or implement separately at extension Complex where T:RealType
        //
        // take the most significant halves and join for floating-point
        if re is Double || re is Float {
            return (re.hashValue & ~mask) | (im.hashValue >> bits)
        }
        #if os(OSX) || os(Linux)
        if re is Float80 { // linux had it, too.
            return (re.hashValue & ~mask) | (im.hashValue >> bits)
        }
        #endif
        #if !os(Linux)
        if re is CGFloat {
            return (re.hashValue & ~mask) | (im.hashValue >> bits)
        }
        #endif
        // take the least significant halves and join for integer
        if re is Int || re is Int64 || re is Int32 || re is Int16 || re is Int8 {
            return (re.hashValue << bits) | (im.hashValue & mask)
        }
        // use description for last resort
        return self.description.hashValue
    }
    /// (re:real, im:imag)
    public var tuple:(T, T) {
        get{ return (re, im) }
        set(t){ (re, im) = t }
    }
    /// - returns: `Complex<Int>(self)`
    public var asComplexInt:Complex<Int>        { return Complex<Int>(self) }
    /// - returns: `Complex<Double>(self)`
    public var asComplexDouble:Complex<Double>  { return Complex<Double>(self) }
    /// - returns: `Complex<Float>(self)`
    public var asComplexFloat:Complex<Float>    { return Complex<Float>(self) }
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
///  RealType:  Types acceptable for "CMath"
///
/// * currently, `Double` and `Float`
///   * and `CGFloat` if not `os(Linux)`
public protocol RealType : ArithmeticType, FloatingPointType {
    static var EPSILON:Self { get } // for =~
}
/// POP!
extension RealType {
    /// Default type to store RealType
    public typealias Real = Double
    //typealias PKG = Darwin
    // math functions - needs extension for each struct
    #if os(Linux)
    public static func cos(x:Self)->    Self { return Self(Glibc.cos(Real(x))) }
    public static func cosh(x:Self)->   Self { return Self(Glibc.cosh(Real(x))) }
    public static func exp(x:Self)->    Self { return Self(Glibc.exp(Real(x))) }
    public static func log(x:Self)->    Self { return Self(Glibc.log(Real(x))) }
    public static func sin(x:Self)->    Self { return Self(Glibc.sin(Real(x))) }
    public static func sinh(x:Self)->   Self { return Self(Glibc.sinh(Real(x))) }
    public static func sqrt(x:Self)->   Self { return Self(Glibc.sqrt(Real(x))) }
    public static func hypot(x:Self, _ y:Self)->Self { return Self(Glibc.hypot(Real(x), Real(y))) }
    public static func atan2(y:Self, _ x:Self)->Self { return Self(Glibc.atan2(Real(y), Real(x))) }
    public static func pow(x:Self, _ y:Self)->  Self { return Self(Glibc.pow(Real(x), Real(y))) }
    #else
    public static func cos(x:Self)->    Self { return Self(Darwin.cos(Real(x))) }
    public static func cosh(x:Self)->   Self { return Self(Darwin.cosh(Real(x))) }
    public static func exp(x:Self)->    Self { return Self(Darwin.exp(Real(x))) }
    public static func log(x:Self)->    Self { return Self(Darwin.log(Real(x))) }
    public static func sin(x:Self)->    Self { return Self(Darwin.sin(Real(x))) }
    public static func sinh(x:Self)->   Self { return Self(Darwin.sinh(Real(x))) }
    public static func sqrt(x:Self)->   Self { return Self(Darwin.sqrt(Real(x))) }
    public static func hypot(x:Self, _ y:Self)->Self { return Self(Darwin.hypot(Real(x), Real(y))) }
    public static func atan2(y:Self, _ x:Self)->Self { return Self(Darwin.atan2(Real(y), Real(x))) }
    public static func pow(x:Self, _ y:Self)->  Self { return Self(Darwin.pow(Real(x), Real(y))) }
    #endif
}

// Double is default since floating-point literals are Double by default
extension Double : RealType {
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
extension Float : RealType {
    //
    // Deliberately not via protocol extension
    //
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
    public static func cos(x:Float)->Float  { return Darwin.cosf(x) }
    public static func cosh(x:Float)->Float { return Darwin.coshf(x) }
    public static func exp(x:Float)->Float  { return Darwin.expf(x) }
    public static func log(x:Float)->Float  { return Darwin.logf(x) }
    public static func sin(x:Float)->Float  { return Darwin.sinf(x) }
    public static func sinh(x:Float)->Float { return Darwin.sinhf(x) }
    public static func sqrt(x:Float)->Float { return Darwin.sqrtf(x) }
    public static func hypot(x:Float, _ y:Float)->Float { return Darwin.hypotf(x, y) }
    public static func atan2(y:Float, _ x:Float)->Float { return Darwin.atan2f(y, x) }
    public static func pow(x:Float, _ y:Float)->Float   { return Darwin.powf(x, y) }
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
        set(r){ let f = r / abs; re = re * f; im = im * f }
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
    lhs = lhs + rhs
}
public func += <T>(inout lhs:Complex<T>, rhs:T) {
    lhs.re = lhs.re + rhs
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
    lhs = lhs + rhs
}
public func -= <T>(inout lhs:Complex<T>, rhs:T) {
    lhs.re = lhs.re + rhs
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
    return (lhs * rhs.conj) / rhs.norm
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
    let ix = Int(rhs)
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
public typealias GaussianInt    = Complex<Int>
public typealias ComplexInt     = Complex<Int>
public typealias ComplexDouble  = Complex<Double>
public typealias ComplexFloat   = Complex<Float>
public typealias Complex64      = Complex<Double>
public typealias Complex32      = Complex<Float>
/// CGFloat if !os(Linux)
#if !os(Linux)
extension CGFloat : RealType {
    public init(_ value:CGFloat) {
        self = value
    }
    public init?<U:ArithmeticType>(_ x:U) {
        switch x {
        case let s as CGFloat:  self.init(s)
        case let d as Double:   self.init(d)
        case let f as Float:    self.init(f)
        case let i as Int:      self.init(i)
        default:
            return nil
        }
    }
    //
    public static var EPSILON = CGFloat(Double.EPSILON)
    // The following values are for convenience, not really needed for protocol conformance.
    public static var PI = CGFloat(Double.PI)
    public static var π = PI
    public static var E =  CGFloat(Double.E)
    public static var LN2 = CGFloat(Double.LN2)
    public static var LOG2E = CGFloat(Double.LOG2E)
    public static var LN10 = CGFloat(Double.LN10)
    public static var LOG10E = CGFloat(Double.LOG10E)
    public static var SQRT2 = CGFloat(Double.SQRT2)
    public static var SQRT1_2 = CGFloat(Double.SQRT1_2)
}
extension Complex {
    /// - paramater p: CGPoint
    /// - returns: `Complex<CGFloat>`
    public init(_ p:CGPoint) {
        self.init(T(p.x), T(p.y))
    }
    /// - returns: `Complex<Float>(self)`
    public var asComplexCGFloat:Complex<CGFloat> { return Complex<CGFloat>(self) }
    /// - returns: `CGPoint(x:self.re, y:self.im)`
    public var asCGPoint:CGPoint {
        return CGPoint(x:CGFloat(re)!, y:CGFloat(im)!)
    }
}
public typealias ComplexCGFloat = Complex<CGFloat>
#endif
//
// Type that supports the % operator
//
public protocol ModuloType : ArithmeticType, IntegerArithmeticType {
    func % (_: Self, _: Self)->Self
    func %= (inout _: Self, _: Self)
}
extension Int: ModuloType {}
/// % is defined only for Complex<T>
public func % <T:ModuloType>(lhs:Complex<T>, rhs:Complex<T>) -> Complex<T> {
    return lhs - (lhs / rhs) * rhs
}
public func % <T:ModuloType>(lhs:Complex<T>, rhs:T) -> Complex<T> {
    return lhs - (lhs / rhs) * rhs
}
public func % <T:ModuloType>(lhs:T, rhs:Complex<T>) -> Complex<T> {
    return Complex<T>(lhs, T(0)) % rhs
}
public func %= <T:ModuloType>(inout lhs:Complex<T>, rhs:Complex<T>) {
    lhs = lhs % rhs
}
public func %= <T:ModuloType>(inout lhs:Complex<T>, rhs:T) {
    lhs = lhs % rhs
}
