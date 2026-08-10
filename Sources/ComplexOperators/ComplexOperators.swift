//
//  ComplexOperators.swift -- import to get `**` as pow(base, exponent).
//  A separate module so that plain `import Complex` does not add
//  operators to your namespace.
//
@_exported import Complex

precedencegroup ExponentiationPrecedence {
    associativity: right
    higherThan: MultiplicationPrecedence
}

infix operator ** : ExponentiationPrecedence

public func ** <R:RMath>(_ base:R, _ exponent:R)->R {
    return R.pow(base, exponent)
}
public func ** <Z:CMath>(_ base:Z, _ exponent:Z)->Z {
    return Z.pow(base, exponent)
}
public func ** <Z:CMath>(_ base:Z, _ exponent:Z.Element)->Z {
    return Z.pow(base, exponent)
}
public func ** <Z:CMath>(_ base:Z.Element, _ exponent:Z)->Z {
    return Z.pow(base, exponent)
}
