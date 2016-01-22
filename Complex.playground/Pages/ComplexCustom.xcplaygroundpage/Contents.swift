//: [Previous](@previous)
/*:
## Advanced Topic: Using Complex<CustomNumberType>

So long as `CustomNumberType` conforms to `ArithmeticType`, Complex<CustomNumberType> works (with issues.  See ([ComplexRat](@next) for such cases that are supposed to work but crashes Swift).
*/
/*:
### Example: TinyInt

To demonstrate that, let us make `TinyInt`, consisting only of `-1`, `0`, and '1'.

*/
public enum TinyInt {
    case Z
    case P
    case N
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
    public init(_ i:Int) {
        self = i < 0 ? .N : i > 0 ? .P : .Z
    }
    public init(_ d:Double) { self.init(Int(d)) }
    public init(_ f:Float)  { self.init(Int(f)) }
    #if !os(Linux)
    public init(_ c:CGFloat)    { self.init(Int(c)) }
    #endif
}
//: protocol conformance
extension TinyInt : Comparable, IntegerLiteralConvertible  {
    public typealias IntegerLiteralType = Int
    public init(integerLiteral i:Int) {
        self.init(Int(i))
    }
    public var isSignMinus:Bool { return self == .N }
    public static func abs(t:TinyInt)->TinyInt {
        return t == .N ? .P : t
    }
}
extension Int {
    init(_ t:TinyInt) {
        switch t {
        case .N: self.init(-1)
        case .P: self.init(1)
        default: self.init(0)
        }
    }
}
public func < (lhs:TinyInt, rhs:TinyInt)->Bool {
    return Int(lhs) < Int(rhs)
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
    return TinyInt(Int(lhs) + Int(rhs))
}
public func - (lhs:TinyInt, rhs:TinyInt)->TinyInt {
    return TinyInt(Int(lhs) - Int(rhs))
}
public func * (lhs:TinyInt, rhs:TinyInt)->TinyInt {
    return TinyInt(Int(lhs) * Int(rhs))
}
public func / (lhs:TinyInt, rhs:TinyInt)->TinyInt {
    return TinyInt(Int(lhs) / Int(rhs))
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
z.hashValue
//: [Next](@next)
