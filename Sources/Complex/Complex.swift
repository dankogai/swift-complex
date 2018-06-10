//
//  Complex.swift
//  Complex
//
//  Created by Dan Kogai on 2018/05/24.
//

public protocol ComplexNumeric : Hashable {
    associatedtype Element: SignedNumeric
    var real:Element { get set }
    var imag:Element { get set }
    init(real:Element, imag:Element)
}

extension ComplexNumeric {
    public init(_ r:Element, _ i:Element) {
        self.init(real:r, imag:i)
    }
    ///
    public init(_ r:Element) {
        self.init(r, 0)
    }
    public var i:Self {
        return Self(-imag, real)
    }
    // +
    public static prefix func +(_ z:Self)->Self {
        return z
    }
    public static func +(_ lhs:Self, _ rhs:Self)->Self {
        return Self(lhs.real + rhs.real, lhs.imag + rhs.imag)
    }
    public static func +(_ lhs:Self, _ rhs:Element)->Self {
        return Self(lhs.real + rhs, lhs.imag)
    }
    public static func +(_ lhs:Element, _ rhs:Self)->Self {
        return rhs + lhs
    }
    public static func +=(_ lhs:inout Self, _ rhs:Self) {
        lhs = lhs + rhs
    }
    public static func +=(_ lhs:inout Self, _ rhs:Element) {
        lhs = lhs + rhs
    }
    // -
    public static prefix func -(_ z:Self)->Self {
        return Self(-z.real, -z.imag)
    }
    public static func -(_ lhs:Self, _ rhs:Self)->Self {
        return Self(lhs.real - rhs.real, lhs.imag - rhs.imag)
    }
    public static func -(_ lhs:Self, _ rhs:Element)->Self {
        return Self(lhs.real - rhs, lhs.imag)
    }
    public static func -(_ lhs:Element, _ rhs:Self)->Self {
        return -rhs + lhs
    }
    public static func -=(_ lhs:inout Self, _ rhs:Self) {
        lhs = lhs - rhs
    }
    public static func -=(_ lhs:inout Self, _ rhs:Element) {
        lhs = lhs - rhs
    }
    // *
    public static func *(_ lhs:Self, _ rhs:Self)->Self {
        return Self(
            lhs.real * rhs.real - lhs.imag * rhs.imag,
            lhs.real * rhs.imag + lhs.imag * rhs.real
        )
    }
    public static func *(_ lhs:Self, _ rhs:Element)->Self {
        return Self(lhs.real * rhs, lhs.imag * rhs)
    }
    public static func *(_ lhs:Element, _ rhs:Self)->Self {
        return rhs * lhs
    }
    public static func *=(_ lhs:inout Self, _ rhs:Self) {
        lhs = lhs * rhs
    }
    public static func *=(_ lhs:inout Self, _ rhs:Element) {
        lhs = lhs * rhs
    }
    public var norm:Element {
        return self.real * self.real + self.imag * self.imag
    }
    /// conjugate
    public var conj:Self {
        return Self(real, -imag)
    }
}

#if os(Linux)
import Glibc
#else
import Darwin
#endif

import FloatingPointMath

public typealias ComplexFloatElement = FloatingPoint & FloatingPointMath

public protocol ComplexFloat : ComplexNumeric & CustomStringConvertible
    where Element: ComplexFloatElement {
}

extension ComplexFloat {
    /// construct by polar coodinates
    public init(abs:Element, arg:Element) {
        self.init(abs * Element.cos(arg), abs * Element.sin(arg))
    }
    ///
    public init(_ r:Double) {
        self.init(Element(r), 0)
    }
    ///
    public var asDouble:Double {
        return self.real.asDouble
    }
    /// absolute value
    public var abs:Element {
        get {
            return imag.isZero ? Swift.abs(real) : Element.hypot(real, imag)
        }
        set {
            self = Self(abs:newValue, arg:self.arg)
        }
    }
    /// magnitude = abs
    public var magnitude:Element {
        return self.abs
    }
    /// argument
    public var arg:Element  {
        get { return Element.atan2(imag, real) }
        set {
            self = Self(abs:self.abs, arg:newValue)
        }
    }
    /// projection
    public var proj:Self {
        if real.isFinite && imag.isFinite {
            return self
        } else {
            return Self(.infinity, imag.sign == .minus ? -Element(0): +Element(0))
        }
    }
    /// description -- conforms to CustomStringConvertible
    public var description:String {
        let sig = imag.sign == .minus ? "-" : "+"
        return "(\(real)\(sig)\(imag.magnitude).i)"
    }
    /// /
    public static func /(_ lhs:Self, _ rhs:Element)->Self {
        return Self(lhs.real / rhs, lhs.imag / rhs)
    }
    public static func /(_ lhs:Self, _ rhs:Self)->Self {
        return rhs.imag.isZero ? lhs / rhs.real : lhs * rhs.conj / rhs.norm
    }
    public static func /(_ lhs:Element, _ rhs:Self)->Self {
        return Self(lhs, 0) / rhs
    }
    public static func /=(_ lhs:inout Self, _ rhs:Self) {
        lhs = lhs / rhs
    }
    public static func /=(_ lhs:inout Self, _ rhs:Element) {
        lhs = lhs / rhs
    }
    /// nan
    public static var nan:Self { return Self(real:Element.nan, imag:Element.nan)}
    /// check if either real or imag is nan
    public var isNaN:Bool { return real.isNaN || imag.isNaN }
    /// infinity + infinity.i
    public static var infinity:Self { return Self(real:Element.infinity, imag:Element.infinity)}
    /// check if either real or imag is infinite
    public var isInfinite:Bool { return real.isInfinite || imag.isInfinite }
    /// 0.0 + 0.0.i, aka "origin"
    public static var zero:Self { return Self(0, 0) }
    /// check if both real and imag are zeros
    public var isZero:Bool { return real.isZero && imag.isZero }
}
// CMath
extension ComplexFloat {
    /// square root of z in Complex
    public static func sqrt(_ z:Self) -> Self {
        let a = z.abs
        let r = Element.sqrt((a + z.real)/2)
        let i = Element.sqrt((a - z.real)/2)
        return Self(r, z.imag.sign == .minus ? -i : i)
    }
    public static func sqrt(_ x:Element)->Self { return sqrt(Self(x)) }
    /// e ** z in Complex
    public static func exp(_ z:Self)->Self {
        let r = Element.exp(z.real)
        let a = z.imag
        return Self(r * Element.cos(a), r * Element.sin(a))
    }
    public static func exp(_ x:Element)->Self { return Self(Element.exp(x)) }
    /// e ** z - 1.0 in Complex
    public static func expm1(_ z:Self)->Self {
        // cf. https://lists.gnu.org/archive/html/octave-maintainers/2008-03/msg00174.html
        return -exp(z/2) * 2 * sin(z.i/2).i
    }
    public static func expm1(_ x:Element)->Self { return Self(Element.expm1(x)) }
    /// natural log of z in Complex
    public static func log(_ z:Self)->Self {
        return Self(Element.log(z.abs), z.arg)
    }
    public static func log(_ x:Element)->Self { return log(Self(x)) }
    /// natural log of (z + 1) in Complex
    public static func log1p(_ z:Self)->Self {
        return 2*atanh(z/(z+2))
    }
    public static func log1p(_ x:Element)->Self { return Self(Element.log1p(x)) }
    /// base 2 log of z in Complex
    public static func log2(_ z:Self)->Self {
        return log(z) / Element.log(2)
    }
    public static func log2(_ x:Element)->Self { return log2(Self(x)) }
    /// base 10 log of z in Complex
    public static func log10(_ z:Self)->Self {
        return log(z) / Element.log(10)
    }
    public static func log10(_ x:Element)->Self { return log10(Self(x)) }
    /// lhs ** rhs in Complex
    public static func pow(_ lhs:Self, _ rhs:Self)->Self {
        return exp(log(lhs) * rhs)
    }
    public static func pow(_ lhs:Self, _ rhs:Element)->Self { return pow(lhs, Self(rhs)) }
    public static func pow(_ lhs:Element, _ rhs:Self)->Self { return pow(Self(lhs), rhs) }
    public static func pow(_ lhs:Element, _ rhs:Element)->Self { return Self(Element.pow(lhs, rhs)) }
    /// cosine of z in Complex
    public static func cos(_ z:Self) -> Self {
        return Self(
            +Element.cos(z.real) * Element.cosh(z.imag),
            -Element.sin(z.real) * Element.sinh(z.imag)
        )
    }
    public static func cos(_ x:Element)->Self { return cos(Self(x)) }
    /// sine of z in Complex
    public static func sin(_ z:Self) -> Self {
        return Self(
            +Element.sin(z.real) * Element.cosh(z.imag),
            +Element.cos(z.real) * Element.sinh(z.imag)
        )
    }
    public static func sin(_ x:Element)->Self { return sin(Self(x)) }
    /// tangent of z in Complex
    public static func tan(_ z:Self) -> Self {
        return sin(z) / cos(z)
    }
    public static func tan(_ x:Element) -> Self { return tan(Self(x)) }
    /// arc cosine of z in Complex
    public static func acos(_ z:Self) -> Self {
        return log(z - sqrt(1 - z*z).i).i
    }
    public static func acos(_ x:Element) -> Self { return acos(Self(x)) }
    /// arc sine of z in Complex
    public static func asin(_ z:Self) -> Self {
        return -log(z.i + sqrt(1 - z*z)).i
    }
    public static func asin(_ x:Element) -> Self { return asin(Self(x)) }
    /// arc tangent of z in Complex
    public static func atan(_ z:Self) -> Self {
        let lp = log(1 - z.i)
        let lm = log(1 + z.i)
        return (lp - lm).i / 2
    }
    public static func atan(_ x:Element) -> Self { return atan(Self(x)) }
    /// hyperbolic cosine of z in Complex
    public static func cosh(_ z:Self) -> Self {
        // return (exp(z) + exp(-z)) / T(2)
        return cos(z.i)
    }
    public static func cosh(_ x:Element) -> Self { return cosh(Self(x)) }
    /// hyperbolic sine of z in Complex
    public static func sinh(_ z:Self) -> Self {
        // return (exp(z) - exp(-z)) / T(2)
        return -sin(z.i).i;
    }
    public static func sinh(_ x:Element) -> Self { return sinh(Self(x)) }
    /// hyperbolic tangent of z in Complex
    public static func tanh(_ z:Self) -> Self {
        // let ez = exp(z), e_z = exp(-z)
        // return (ez - e_z) / (ez + e_z)
        return sinh(z) / cosh(z)
    }
    public static func tanh(_ x:Element) -> Self { return tanh(Self(x)) }
    /// inverse hyperbolic cosine of z in Complex
    public static func acosh(_ z:Self) -> Self {
        return log(z + sqrt(z+1)*sqrt(z-1))
    }
    public static func acosh(_ x:Element) -> Self { return acosh(Self(x)) }
    /// inverse hyperbolic cosine of z in Complex
    public static func asinh(_ z:Self) -> Self {
        return log(z + sqrt(z*z+1))
    }
    public static func asinh(_ x:Element) -> Self { return asinh(Self(x)) }
    /// inverse hyperbolic tangent of z in Complex
    public static func atanh(_ z:Self) -> Self {
        return (log(1 + z) - log(1 - z)) / 2
    }
    public static func atanh(_ x:Element) -> Self { return atanh(Self(x)) }
    /// hypotenuse. defined as √(lhs**2 + rhs**2) though its need for Complex is moot.
    public static func hypot(_ lhs:Self, _ rhs:Self) -> Self {
        return sqrt(lhs*lhs + rhs*rhs)
    }
    public static func hypot(_ lhs:Self, _ rhs:Element)->Self { return hypot(lhs, Self(rhs)) }
    public static func hypot(_ lhs:Element, _ rhs:Self)->Self { return hypot(Self(lhs), rhs) }
    public static func hypot(_ lhs:Element, _ rhs:Element)->Self { return Self(Element.hypot(lhs, rhs)) }
    /// atan2 = atan(lhs/rhs)
    public static func atan2(_ lhs:Self, _ rhs:Self) -> Self {
        return atan(lhs/rhs)
    }
    public static func atan2(_ lhs:Self, _ rhs:Element)->Self { return atan2(lhs, Self(rhs, 0)) }
    public static func atan2(_ lhs:Element, _ rhs:Self)->Self { return atan2(Self(lhs, 0), rhs) }
    public static func atan2(_ lhs:Element, _ rhs:Element)->Self { return Self(Element.atan2(lhs, rhs)) }
}

public struct Complex<R:ComplexFloatElement> : ComplexFloat  {
    public typealias NumericType = R
    public var (real, imag):(R, R)
    public init(real r:R, imag i:R) {
        (real, imag) = (r, i)
    }
}

extension Complex : Codable where Element: Codable {
    public enum CodingKeys : String, CodingKey {
        public typealias RawValue = String
        case real, imag
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.real = try values.decode(Element.self, forKey: .real)
        self.imag = try values.decode(Element.self, forKey: .imag)
     }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.real, forKey: .real)
        try container.encode(self.imag, forKey: .imag)
    }
}

extension FloatingPoint where Self:ComplexFloatElement {
    public var i:Complex<Self> {
        return Complex(0, self)
    }
}
