//: [Previous](@previous)
/*:
## Advanced Topic: Using Complex<CustomNumberType>

So long as `CustomNumberType` conforms to `ArithmeticType`, Complex<CustomNumberType> works (with issues.  See ([ComplexRat](@next) for such cases that are supposed to work but crashes Swift).

### Complex<Bool>

To demonstrate that, let us make `Complex<Bool>`.  To do so, we first make `Bool` conform to `ArithmeticType`

*/
public prefix func +(b:Bool)->Bool {
    return b
}
public prefix func -(b:Bool)->Bool {
    return !b
}
public func +(lhs:Bool, rhs:Bool)->Bool {
    return lhs || rhs
}
public func *(lhs:Bool, rhs:Bool)->Bool {
    return lhs && rhs
}
public func -(lhs:Bool, rhs:Bool)->Bool {
    return lhs + (-rhs)
}
public func /(lhs:Bool, rhs:Bool)->Bool {
    return lhs * rhs
}
public func <(lhs:Bool, rhs:Bool)->Bool {
    return lhs == false && rhs == true
}
extension Bool : IntegerLiteralConvertible {
    public typealias IntegerLiteralType = Int
    public init(integerLiteral i:Int) {
        self.init(Int(i))
    }
}
extension Bool: ArithmeticType {}
//: Now let's see if it behaves as a complex number
let one = Complex(true, false)
one.i == one.conj
one.i.i == -one
one.i.i.i ==  (-one).conj
one.i.i.i.i == one
//: [Next](@next)
