//
//  GaussianInt.swift
//  Complex
//
//  Created by Dan Kogai on 2018/05/25.
//

public protocol ComplexInt : ComplexNumeric & CustomStringConvertible
    where Element: SignedInteger {
}

extension ComplexInt {
    /// description -- conforms to Printable
    public var description:String {
        let sig = imag < 0 ? "-" : "+"
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

public typealias GaussianIntElement = SignedInteger & Codable

public struct GaussianInt<I:GaussianIntElement> : ComplexInt {
    public typealias NumericType = I
    public var (real, imag):(I, I)
    public init(real r:I, imag i:I) {
        (real, imag) = (r, i)
    }
}

extension SignedInteger where Self:Codable {
    public var i:GaussianInt<Self> {
        return GaussianInt(0, self)
    }
}
