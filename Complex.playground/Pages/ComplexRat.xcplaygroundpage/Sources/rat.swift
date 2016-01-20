//
//  rat.swift
//  rat
//
//  Created by Dan Kogai on 1/19/16.
//  Copyright © 2016 Dan Kogai. All rights reserved.
//
#if os(Linux)
    import Glibc
#else
    import Foundation
#endif

public protocol RatElement: SignedIntegerType, IntegerArithmeticType {
    init(_: Int)
    init(_: Double)
    init(_: Float)
    init(_: Self)
    #if !os(Linux)
    init(_: CGFloat)
    #endif
}
public extension RatElement {
    public init<U:RatElement>(_ x:U) {
        switch x {
        case let s as Self:     self.init(s)
        case let i as Int:      self.init(i)
        default:
            fatalError("init(\(x)) failed!")
        }
    }
}

extension Int:   RatElement {}

public struct Rat<T:RatElement> : AbsoluteValuable, Equatable, Comparable, CustomStringConvertible, Hashable {
    public typealias Element = T
    public typealias IntegerLiteralType = T.IntegerLiteralType
    private let (num, den):(T, T)
    public init (var _ n:T, var _ d:T, _ reduced:Bool = false) {
        if d < 0 && n != 0 {
            n *= -1; d *= -1;
        }
        let g = reduced ? 1 : Rat.gcd(n, d)
        self.num = n/g
        self.den = d/g
    }
    public init(integerLiteral i:T.IntegerLiteralType) {
        self.init(T(integerLiteral:i), 1)
    }
    public init(_ i:T) {
        self.init(i, 1)
    }
    public init() {
        self.init(T(0), 1)
    }
    public init(_ r:Double) {
        var num = r
        var den = 1
        for _ in 0..<53 {
            if Double(Int64(num)) == num { break }
            num *= 2
            den *= 2
        }
        self.init(T(num),T(den))
    }
    public init(_ r:Float) {
        self.init(Double(r))
    }
    #if !os(Linux)
    public init(_ r:CGFloat) {
        self.init(Double(r))
    }
    #endif
    public var inv:Rat<T> { return Rat(self.den, self.num, true) }
    public var numerator:T   { return num }
    public var denominator:T { return den }
    public static func gcd(var x: T, var _ y: T) -> T {
        guard x != 0 else { return 1 }
        guard y != 0 else { return 1 }
        if x <  0 { x *= -1 }
        if y <  0 { y *= -1 }
        var r = x % y
        while r > 0 {
            x = y
            y = r
            r = x % y
        }
        return y
    }
    public var description:String {
        return "(\(num)/\(den))"
    }
    public var hashValue:Int {
        return Double(self).hashValue
    }
    public static func abs(q:Rat<T>)->Rat<T> {
        return Rat(q.num < 0 ? -q.num : q.num, q.den, true)
    }
}

extension Double {
    init<T:RatElement>(_ i:T) {
        self = Double(Int(i))
    }
    init<T:RatElement>(_ q:Rat<T>) {
        self = Double(q.num) / Double(q.den)
    }
}
public func ==<T:RatElement>(lhs:Rat<T>, rhs:Rat<T>)->Bool {
    return lhs.num == rhs.num && lhs.den == rhs.den
}
public func < <T:RatElement>(lhs:Rat<T>, rhs:Rat<T>)->Bool {
    return Double(lhs) < Double(rhs)
}
public func * <T:RatElement>(lhs:Rat<T>, rhs:Rat<T>)->Rat<T> {
    // return Rat(lhs.num*rhs.num, lhs.den*rhs.den)
    var ln = lhs.num, ld = lhs.den, rn = rhs.num, rd = rhs.den;
    let gn = Rat.gcd(ln, rd), gd = Rat.gcd(ld, rn);
    ln /= gn; rn /= gd;
    ld /= gd; rd /= gn;
    return Rat(ln * rn, ld * rd, true)
}
public func / <T:RatElement>(lhs:Rat<T>, rhs:Rat<T>)->Rat<T> {
    return lhs * rhs.inv
}
public prefix func + <T:RatElement>(q:Rat<T>)->Rat<T> {
    return q
}
public func + <T:RatElement>(lhs:Rat<T>, rhs:Rat<T>)->Rat<T> {
    guard lhs.den != rhs.den else { return Rat(lhs.num + rhs.num, lhs.den) }
    // return Rat(lhs.num*rhs.den + rhs.num*lhs.den, lhs.den*rhs.den)
    var ld = lhs.den, rd = rhs.den;
    let gd = Rat.gcd(ld, rd)
    ld /= gd; rd /= gd;
    return Rat(lhs.num*rd + rhs.num*ld, lhs.den*rd)
}
public prefix func - <T:RatElement>(q:Rat<T>)->Rat<T> {
    return Rat(-q.num, q.den, true)
}
public func - <T:RatElement>(lhs:Rat<T>, rhs:Rat<T>)->Rat<T> {
    return lhs + (-rhs)
}

func *= <T:RatElement>(inout lhs:Rat<T>, rhs:Rat<T>) { lhs = lhs * rhs }
func /= <T:RatElement>(inout lhs:Rat<T>, rhs:Rat<T>) { lhs = lhs / rhs }
func += <T:RatElement>(inout lhs:Rat<T>, rhs:Rat<T>) { lhs = lhs + rhs }
func -= <T:RatElement>(inout lhs:Rat<T>, rhs:Rat<T>) { lhs = lhs - rhs }

typealias RatInt    = Rat<Int>
