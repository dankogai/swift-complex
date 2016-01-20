//
//  exops.swift
//  complex
//
//  Created by Dan Kogai on 1/16/16.
//  Copyright © 2016 Dan Kogai. All rights reserved.
//
// Non-builtin operators
#if os(Linux)
    import Glibc
#else
    import Foundation
#endif
// **, **= // pow(lhs, rhs)
infix operator ** { associativity right precedence 170 }
infix operator **= { associativity right precedence 90 }
public func **<T:RealType>(lhs:T, rhs:T) -> T {
    return T.pow(lhs, rhs)
}
public func ** <T:RealType>(lhs:Complex<T>, rhs:Complex<T>) -> Complex<T> {
    return pow(lhs, rhs)
}
public func ** <T:RealType>(lhs:T, rhs:Complex<T>) -> Complex<T> {
    return pow(lhs, rhs)
}
public func ** <T:RealType>(lhs:Complex<T>, rhs:T) -> Complex<T> {
    return pow(lhs, rhs)
}
public func **= <T:RealType>(inout lhs:T, rhs:T) {
    lhs = T.pow(lhs, rhs)
}
public func **= <T:RealType>(inout lhs:Complex<T>, rhs:Complex<T>) {
    lhs = pow(lhs, rhs)
}
public func **= <T:RealType>(inout lhs:Complex<T>, rhs:T) {
    lhs = pow(lhs, rhs)
}
// =~ // approximate comparisons
infix operator =~ { associativity none precedence 130 }
public func =~ <T:RealType>(lhs:T, rhs:T) -> Bool {
    if lhs == rhs { return true }
    // if either side is zero, simply compare to epsilon
    if rhs == 0 { return abs(lhs) < T.EPSILON }
    if lhs == 0 { return abs(rhs) < T.EPSILON }
    // sign must match
    if lhs.isSignMinus != rhs.isSignMinus { return false }
    // delta / average < epsilon
    let num = lhs - rhs
    let den = lhs + rhs
    return num/den < T(2)*T.EPSILON
}
public func =~ <T:RealType>(lhs:Complex<T>, rhs:Complex<T>) -> Bool {
    return lhs.abs =~ rhs.abs
}
public func =~ <T:RealType>(lhs:Complex<T>, rhs:T) -> Bool {
    return lhs.abs =~ abs(rhs)
}
public func =~ <T:RealType>(lhs:T, rhs:Complex<T>) -> Bool {
    return abs(lhs) =~ rhs.abs
}
// !~
infix operator !~ { associativity none precedence 130 }
public func !~ <T:RealType>(lhs:T, rhs:T) -> Bool {
    return !(lhs =~ rhs)
}
public func !~ <T:RealType>(lhs:Complex<T>, rhs:Complex<T>) -> Bool {
    return !(lhs =~ rhs)
}
public func !~ <T:RealType>(lhs:Complex<T>, rhs:T) -> Bool {
    return !(lhs =~ rhs)
}
public func !~ <T:RealType>(lhs:T, rhs:Complex<T>) -> Bool {
    return !(lhs =~ rhs)
}
