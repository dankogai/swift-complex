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

// import ElementaryFunctions

public typealias RealElementaryFunctions = FloatingPoint & ElementaryFunctions

@available(*, deprecated, renamed: "RealElementaryFunctions")
public typealias ComplexFloatElement = RealElementaryFunctions

public protocol ComplexFloat : ComplexNumeric & CustomStringConvertible
    where Element: FloatingPoint {
}

/// Complex version of ElementaryFunctions
public protocol ComplexElementaryFunctions : ComplexFloat & ElementaryFunctions
    where Element: RealElementaryFunctions {
}

/// CMath for short
public typealias CMath = ComplexElementaryFunctions

extension ComplexFloat {
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

extension ComplexElementaryFunctions {
    /// construct by polar coodinates
    public init(abs:Element, arg:Element) {
        self.init(abs * Element.cos(arg), abs * Element.sin(arg))
    }
    ///
    public init(_ r:Double) {
        self.init(Element(r), 0)
    }
    ///
    public func toDouble()->Double {
        return self.real.toDouble()
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
}

public struct Complex<R:FloatingPoint> : ComplexFloat  {
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

extension Complex : ElementaryFunctions where R: RealElementaryFunctions {}
extension Complex : ComplexElementaryFunctions where R: RealElementaryFunctions {}

extension FloatingPoint {
    public var i:Complex<Self> {
        return Complex(0, self)
    }
}
