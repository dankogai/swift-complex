//
//  Complex.swift
//  Complex
//
//  Created by Dan Kogai on 2018/05/24.
//

public protocol ComplexNumeric : Hashable & Codable {
    associatedtype Element: SignedNumeric & Codable
    var real:Element { get set }
    var imag:Element { get set }
    init(real:Element, imag:Element)
}

extension ComplexNumeric {
    public init(_ real:Element, _ imag:Element) {
        self.init(real:real, imag:imag)
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

public protocol ComplexFloat : ComplexNumeric & CustomStringConvertible & FloatingPointMath
    where Element: FloatingPoint & FloatingPointMath {
}

extension ComplexFloat {
    ///
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
            return Element.hypot(real, imag)
        }
        set {
            let r = newValue / abs
            (real, imag) = (real * r, imag * r)
        }
    }
    /// argument
    public var arg:Element  {
        get { return Element.atan2(imag, real) }
        set {
            let m = abs
            (real, imag) = (m * Element.cos(newValue), m * Element.sin(newValue))
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
    /// description -- conforms to Printable
    public var description:String {
        let sig = imag.sign == .minus ? "-" : "+"
        return "(\(real)\(sig)\(imag.magnitude).i)"
    }
    /// /
    public static func /(_ lhs:Self, _ rhs:Element)->Self {
        return Self(lhs.real / rhs, lhs.imag / rhs)
    }
    public static func /(_ lhs:Self, _ rhs:Self)->Self {
        return lhs * rhs.conj / rhs.norm
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
}

extension ComplexFloat {
    /// - returns: square root of z in Complex
    public static func sqrt(_ z:Self) -> Self {
        let a = z.abs
        let r = Element.sqrt((a + z.real)/2)
        let i = Element.sqrt((a - z.real)/2)
        return Self(r, z.imag.sign == .minus ? -i : i)
    }
    public static func sqrt(_ x:Element)->Self { return sqrt(Self(x, 0)) }
    /// - returns: e ** z in Complex
    public static func exp(_ z:Self)->Self {
        let r = Element.exp(z.real)
        let a = z.imag
        return Self(r * Element.cos(a), r * Element.sin(a))
    }
    public static func exp(_ x:Element)->Self { return exp(Self(x, 0)) }
    /// - returns: natural log of z in Complex
    public static func log(_ z:Self)->Self {
        return Self(Element.log(z.abs), z.arg)
    }
    public static func log(_ x:Element)->Self { return log(Self(x, 0)) }
    /// - returns: base 10 log of z in Complex
    public static func log10(_ z:Self)->Self {
        return log(z) / Element.log(10)
    }
    public static func log10(_ x:Element)->Self { return log10(Self(x, 0)) }
    /// - returns: lhs ** rhs in Complex
    public static func pow(_ lhs:Self, _ rhs:Self)->Self {
        return exp(log(lhs) * rhs)
    }
    public static func pow(_ lhs:Self, _ rhs:Element)->Self { return pow(lhs, Self(rhs, 0)) }
    public static func pow(_ lhs:Element, _ rhs:Self)->Self { return pow(Self(lhs, 0), rhs) }
    public static func pow(_ lhs:Element, _ rhs:Element)->Self { return Self(Element.pow(lhs, rhs), 0) }
    /// - returns: cosine of z in Complex
    public static func cos(_ z:Self) -> Self {
        return Self(
            +Element.cos(z.real) * Element.cosh(z.imag),
            -Element.sin(z.real) * Element.sinh(z.imag)
        )
    }
    public static func cos(_ x:Element)->Self { return cos(Self(x, 0)) }
    /// - returns: sine of z in Complex
    public static func sin(_ z:Self) -> Self {
        return Self(
            +Element.sin(z.real) * Element.cosh(z.imag),
            +Element.cos(z.real) * Element.sinh(z.imag)
        )
    }
    public static func sin(_ x:Element)->Self { return sin(Self(x, 0)) }
    /// - returns: tangent of z in Complex
    public static func tan(_ z:Self) -> Self {
        return sin(z) / cos(z)
    }
    public static func tan(_ x:Element) -> Self { return tan(Self(x, 0)) }
    /// - returns: arc cosine of z in Complex
    public static func acos(_ z:Self) -> Self {
        return log(z - sqrt(1 - z*z).i).i
    }
    public static func acos(_ x:Element) -> Self { return acos(Self(x, 0)) }
    /// - returns: arc sine of z in Complex
    public static func asin(_ z:Self) -> Self {
        return -log(z.i + sqrt(1 - z*z)).i
    }
    public static func asin(_ x:Element) -> Self { return asin(Self(x, 0)) }
    /// - returns: arc tangent of z in Complex
    public static func atan(_ z:Self) -> Self {
        let lp = log(1 - z.i)
        let lm = log(1 + z.i)
        return (lp - lm).i / 2
    }
    public static func atan(_ x:Element) -> Self { return atan(Self(x, 0)) }
    /// - returns: hyperbolic cosine of z in Complex
    public static func cosh(_ z:Self) -> Self {
        // return (exp(z) + exp(-z)) / T(2)
        return cos(z.i)
    }
    public static func cosh(_ x:Element) -> Self { return cosh(Self(x, 0)) }
    /// - returns: hyperbolic sine of z in Complex
    public static func sinh(_ z:Self) -> Self {
        // return (exp(z) - exp(-z)) / T(2)
        return -sin(z.i).i;
    }
    public static func sinh(_ x:Element) -> Self { return sinh(Self(x, 0)) }
    /// - returns: hyperbolic tangent of z in Complex
    public static func tanh(_ z:Self) -> Self {
        // let ez = exp(z), e_z = exp(-z)
        // return (ez - e_z) / (ez + e_z)
        return sinh(z) / cosh(z)
    }
    public static func tanh(_ x:Element) -> Self { return tanh(Self(x, 0)) }
    /// - returns: inverse hyperbolic cosine of z in Complex
    public static func acosh(_ z:Self) -> Self {
        return log(z + sqrt(z+1)*sqrt(z-1))
    }
    public static func acosh(_ x:Element) -> Self { return acosh(Self(x, 0)) }
    /// - returns: inverse hyperbolic cosine of z in Complex
    public static func asinh(_ z:Self) -> Self {
        return log(z + sqrt(z*z+1))
    }
    public static func asinh(_ x:Element) -> Self { return asinh(Self(x, 0)) }
    /// - returns: inverse hyperbolic tangent of z in Complex
    public static func atanh(_ z:Self) -> Self {
        return (log(1 + z) - log(1 - z)) / 2
    }
    public static func atanh(_ x:Element) -> Self { return atanh(Self(x, 0)) }
    /// - returns: hypot
    public static func hypot(_ lhs:Self, _ rhs:Self) -> Self {
        fatalError("Not applicable for Complex")
    }
    public static func hypot(_ lhs:Self, _ rhs:Element)->Self { return hypot(lhs, Self(rhs, 0)) }
    public static func hypot(_ lhs:Element, _ rhs:Self)->Self { return hypot(Self(lhs, 0), rhs) }
    public static func hypot(_ lhs:Element, _ rhs:Element)->Self { return Self(Element.hypot(lhs, rhs), 0) }
    /// - returns: atan2
    public static func atan2(_ lhs:Self, _ rhs:Self) -> Self {
        return Self(Element.nan, Element.nan)
    }
    public static func atan2(_ lhs:Self, _ rhs:Element)->Self { return atan2(lhs, Self(rhs, 0)) }
    public static func atan2(_ lhs:Element, _ rhs:Self)->Self { return atan2(Self(lhs, 0), rhs) }
    public static func atan2(_ lhs:Element, _ rhs:Element)->Self { return Self(Element.atan2(lhs, rhs), 0) }
}

public typealias ComplexElement = FloatingPoint & FloatingPointMath & Codable

public struct Complex<R:ComplexElement> : ComplexFloat  {
    public typealias NumericType = R
    public var (real, imag):(R, R)
    public init(real r:R, imag i:R) {
        (real, imag) = (r, i)
    }
}

extension FloatingPoint where Self:ComplexElement {
    public var i:Complex<Self> {
        return Complex(0, self)
    }
}
