//: [Previous](@previous)
/*:
## Advanced Topic: Using Complex<CustomNumberType>

So long as `CustomNumberType` conforms to `ArithmeticType`, Complex<CustomNumberType> works (with issues.  See ([ComplexRat](@next) for such cases that are supposed to work but crashes Swift).
*/
/*:
### Example: TinyInt

To demonstrate that, let us make `TinyInt`, consisting only of `-1`, `0`, and '1'.

*/
public enum TinyInt:Int8 {
    case Z =  0
    case P =  1
    case N = -1
}
//: cross-platform import
#if os(Linux)
    import Glibc
#else
    import Foundation
#endif
//: required initializers
public extension TinyInt {
    public init(_ t:TinyInt) { self = t }
    public init(_ i:Int8) {
        self = i < 0 ? .N : i > 0 ? .P : .Z
    }
    public init(_ d:Int)    { self.init(Int8(d)) }
    public init(_ d:Double) { self.init(Int8(d)) }
    public init(_ f:Float)  { self.init(Int8(f)) }
    #if !os(Linux)
    public init(_ c:CGFloat)    { self.init(Int(c)) }
    #endif
}
//: protocol conformance
extension TinyInt : Comparable, IntegerLiteralConvertible, CustomStringConvertible {
    public typealias IntegerLiteralType = Int
    public init(integerLiteral i:Int) {
        self.init(Int(i))
    }
    public var description:String {
        return self.rawValue.description
    }
}
public func < (lhs:TinyInt, rhs:TinyInt)->Bool {
    return lhs.rawValue < rhs.rawValue
}
//: and arithmetic operators
public prefix func + (t:TinyInt)->TinyInt {
    return t
}
public prefix func - (t:TinyInt)->TinyInt {
    switch t {
    case .N: return .P
    case .P: return .N
    default: return .Z
    }
}
public func + (lhs:TinyInt, rhs:TinyInt)->TinyInt {
    return TinyInt(lhs.rawValue + rhs.rawValue)
}
public func - (lhs:TinyInt, rhs:TinyInt)->TinyInt {
    return TinyInt(lhs.rawValue - rhs.rawValue)
}
public func * (lhs:TinyInt, rhs:TinyInt)->TinyInt {
    return TinyInt(lhs.rawValue * rhs.rawValue)
}
public func / (lhs:TinyInt, rhs:TinyInt)->TinyInt {
    return TinyInt(lhs.rawValue / rhs.rawValue)
}
//: let's first see TynyInt works as expected.
TinyInt.Z + TinyInt.Z
TinyInt.Z + TinyInt.P
TinyInt.Z + TinyInt.N
TinyInt.P + TinyInt.Z
TinyInt.P + TinyInt.P
TinyInt.P + TinyInt.N
TinyInt.N + TinyInt.Z
TinyInt.N + TinyInt.P
TinyInt.N + TinyInt.N
TinyInt.Z * TinyInt.Z
TinyInt.Z * TinyInt.P
TinyInt.Z * TinyInt.N
TinyInt.P * TinyInt.Z
TinyInt.P * TinyInt.P
TinyInt.P * TinyInt.N
TinyInt.N * TinyInt.Z
TinyInt.N * TinyInt.P
TinyInt.N * TinyInt.N
//: now let's tell Swift `TinyInt` conforms to `ArithmeticType`
extension TinyInt:ArithmeticType {}
//: and enjoy!
let z = Complex(TinyInt.P, TinyInt.P)
z.i
z.i.i == -z
z.i.i.i == z.conj
z.i.i.i.i == z
//: [Next](@next)
