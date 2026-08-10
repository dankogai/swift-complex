import BigNum
@testable import Complex

// Trampolines constrained to BigFloatingPoint alone, so calls inside resolve
// unambiguously to BigNum's native arbitrary-precision implementations.
private enum BN {
    static func acos<T:BigFloatingPoint>(_ x:T, _ px:Int, _ db:Bool)->T { return T.acos(x, precision:px, debug:db) }
    static func acosh<T:BigFloatingPoint>(_ x:T, _ px:Int, _ db:Bool)->T { return T.acosh(x, precision:px, debug:db) }
    static func asin<T:BigFloatingPoint>(_ x:T, _ px:Int, _ db:Bool)->T { return T.asin(x, precision:px, debug:db) }
    static func asinh<T:BigFloatingPoint>(_ x:T, _ px:Int, _ db:Bool)->T { return T.asinh(x, precision:px, debug:db) }
    static func atan<T:BigFloatingPoint>(_ x:T, _ px:Int, _ db:Bool)->T { return T.atan(x, precision:px, debug:db) }
    static func atanh<T:BigFloatingPoint>(_ x:T, _ px:Int, _ db:Bool)->T { return T.atanh(x, precision:px, debug:db) }
    static func cbrt<T:BigFloatingPoint>(_ x:T, _ px:Int, _ db:Bool)->T { return T.cbrt(x, precision:px, debug:db) }
    static func cos<T:BigFloatingPoint>(_ x:T, _ px:Int, _ db:Bool)->T { return T.cos(x, precision:px, debug:db) }
    static func cosh<T:BigFloatingPoint>(_ x:T, _ px:Int, _ db:Bool)->T { return T.cosh(x, precision:px, debug:db) }
    static func exp<T:BigFloatingPoint>(_ x:T, _ px:Int, _ db:Bool)->T { return T.exp(x, precision:px, debug:db) }
    static func exp2<T:BigFloatingPoint>(_ x:T, _ px:Int, _ db:Bool)->T { return T.exp2(x, precision:px, debug:db) }
    static func expm1<T:BigFloatingPoint>(_ x:T, _ px:Int, _ db:Bool)->T { return T.expMinusOne(x, precision:px, debug:db) }
    static func log<T:BigFloatingPoint>(_ x:T, _ px:Int, _ db:Bool)->T { return T.log(x, precision:px, debug:db) }
    static func log2<T:BigFloatingPoint>(_ x:T, _ px:Int, _ db:Bool)->T { return T.log2(x, precision:px, debug:db) }
    static func log10<T:BigFloatingPoint>(_ x:T, _ px:Int, _ db:Bool)->T { return T.log10(x, precision:px, debug:db) }
    static func log1p<T:BigFloatingPoint>(_ x:T, _ px:Int, _ db:Bool)->T { return T.log1p(x, precision:px, debug:db) }
    static func sin<T:BigFloatingPoint>(_ x:T, _ px:Int, _ db:Bool)->T { return T.sin(x, precision:px, debug:db) }
    static func sinh<T:BigFloatingPoint>(_ x:T, _ px:Int, _ db:Bool)->T { return T.sinh(x, precision:px, debug:db) }
    static func sqrt<T:BigFloatingPoint>(_ x:T, _ px:Int, _ db:Bool)->T { return T.sqrt(x, precision:px, debug:db) }
    static func tan<T:BigFloatingPoint>(_ x:T, _ px:Int, _ db:Bool)->T { return T.tan(x, precision:px, debug:db) }
    static func tanh<T:BigFloatingPoint>(_ x:T, _ px:Int, _ db:Bool)->T { return T.tanh(x, precision:px, debug:db) }
    static func atan2<T:BigFloatingPoint>(_ y:T, _ x:T, _ px:Int, _ db:Bool)->T { return T.atan2(y:y, x:x, precision:px, debug:db) }
    static func hypot<T:BigFloatingPoint>(_ x:T, _ y:T, _ px:Int, _ db:Bool)->T { return T.hypot(x, y, precision:px, debug:db) }
    static func pow  <T:BigFloatingPoint>(_ x:T, _ y:T, _ px:Int, _ db:Bool)->T { return T.pow(x, y, precision:px, debug:db) }
}

// Plain witnesses are explicit because both Complex's Double-based defaults
// and BigNum's own functions match the requirements, which is ambiguous.
// The precision/debug versions forward to BigNum's natives so that the flags
// are honored on BigRational.
extension BigRational : RMath {
    public static func acos(_ x:Self)->Self { return BN.acos(x, precision, false) }
    public static func acos(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.acos(x, px, db) }
    public static func acosh(_ x:Self)->Self { return BN.acosh(x, precision, false) }
    public static func acosh(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.acosh(x, px, db) }
    public static func asin(_ x:Self)->Self { return BN.asin(x, precision, false) }
    public static func asin(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.asin(x, px, db) }
    public static func asinh(_ x:Self)->Self { return BN.asinh(x, precision, false) }
    public static func asinh(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.asinh(x, px, db) }
    public static func atan(_ x:Self)->Self { return BN.atan(x, precision, false) }
    public static func atan(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.atan(x, px, db) }
    public static func atanh(_ x:Self)->Self { return BN.atanh(x, precision, false) }
    public static func atanh(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.atanh(x, px, db) }
    public static func cbrt(_ x:Self)->Self { return BN.cbrt(x, precision, false) }
    public static func cbrt(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.cbrt(x, px, db) }
    public static func cos(_ x:Self)->Self { return BN.cos(x, precision, false) }
    public static func cos(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.cos(x, px, db) }
    public static func cosh(_ x:Self)->Self { return BN.cosh(x, precision, false) }
    public static func cosh(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.cosh(x, px, db) }
    public static func exp(_ x:Self)->Self { return BN.exp(x, precision, false) }
    public static func exp(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.exp(x, px, db) }
    public static func exp2(_ x:Self)->Self { return BN.exp2(x, precision, false) }
    public static func exp2(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.exp2(x, px, db) }
    public static func expm1(_ x:Self)->Self { return BN.expm1(x, precision, false) }
    public static func expm1(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.expm1(x, px, db) }
    public static func log(_ x:Self)->Self { return BN.log(x, precision, false) }
    public static func log(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.log(x, px, db) }
    public static func log2(_ x:Self)->Self { return BN.log2(x, precision, false) }
    public static func log2(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.log2(x, px, db) }
    public static func log10(_ x:Self)->Self { return BN.log10(x, precision, false) }
    public static func log10(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.log10(x, px, db) }
    public static func log1p(_ x:Self)->Self { return BN.log1p(x, precision, false) }
    public static func log1p(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.log1p(x, px, db) }
    public static func sin(_ x:Self)->Self { return BN.sin(x, precision, false) }
    public static func sin(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.sin(x, px, db) }
    public static func sinh(_ x:Self)->Self { return BN.sinh(x, precision, false) }
    public static func sinh(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.sinh(x, px, db) }
    public static func sqrt(_ x:Self)->Self { return BN.sqrt(x, precision, false) }
    public static func sqrt(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.sqrt(x, px, db) }
    public static func tan(_ x:Self)->Self { return BN.tan(x, precision, false) }
    public static func tan(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.tan(x, px, db) }
    public static func tanh(_ x:Self)->Self { return BN.tanh(x, precision, false) }
    public static func tanh(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.tanh(x, px, db) }
    public static func atan2(y:Self, x:Self)->Self { return BN.atan2(y, x, precision, false) }
    public static func atan2(y:Self, x:Self, precision px:Int, debug db:Bool)->Self { return BN.atan2(y, x, px, db) }
    public static func hypot(_ x:Self, _ y:Self)->Self { return BN.hypot(x, y, precision, false) }
    public static func hypot(_ x:Self, _ y:Self, precision px:Int, debug db:Bool)->Self { return BN.hypot(x, y, px, db) }
    public static func pow  (_ x:Self, _ y:Self)->Self { return BN.pow(x, y, precision, false) }
    public static func pow  (_ x:Self, _ y:Self, precision px:Int, debug db:Bool)->Self { return BN.pow(x, y, px, db) }
}

// Plain witnesses are explicit because both Complex's Double-based defaults
// and BigNum's own functions match the requirements, which is ambiguous.
// The precision/debug versions forward to BigNum's natives so that the flags
// are honored on BigFloat.
extension BigFloat : RMath {
    public static func acos(_ x:Self)->Self { return BN.acos(x, precision, false) }
    public static func acos(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.acos(x, px, db) }
    public static func acosh(_ x:Self)->Self { return BN.acosh(x, precision, false) }
    public static func acosh(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.acosh(x, px, db) }
    public static func asin(_ x:Self)->Self { return BN.asin(x, precision, false) }
    public static func asin(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.asin(x, px, db) }
    public static func asinh(_ x:Self)->Self { return BN.asinh(x, precision, false) }
    public static func asinh(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.asinh(x, px, db) }
    public static func atan(_ x:Self)->Self { return BN.atan(x, precision, false) }
    public static func atan(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.atan(x, px, db) }
    public static func atanh(_ x:Self)->Self { return BN.atanh(x, precision, false) }
    public static func atanh(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.atanh(x, px, db) }
    public static func cbrt(_ x:Self)->Self { return BN.cbrt(x, precision, false) }
    public static func cbrt(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.cbrt(x, px, db) }
    public static func cos(_ x:Self)->Self { return BN.cos(x, precision, false) }
    public static func cos(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.cos(x, px, db) }
    public static func cosh(_ x:Self)->Self { return BN.cosh(x, precision, false) }
    public static func cosh(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.cosh(x, px, db) }
    public static func exp(_ x:Self)->Self { return BN.exp(x, precision, false) }
    public static func exp(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.exp(x, px, db) }
    public static func exp2(_ x:Self)->Self { return BN.exp2(x, precision, false) }
    public static func exp2(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.exp2(x, px, db) }
    public static func expm1(_ x:Self)->Self { return BN.expm1(x, precision, false) }
    public static func expm1(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.expm1(x, px, db) }
    public static func log(_ x:Self)->Self { return BN.log(x, precision, false) }
    public static func log(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.log(x, px, db) }
    public static func log2(_ x:Self)->Self { return BN.log2(x, precision, false) }
    public static func log2(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.log2(x, px, db) }
    public static func log10(_ x:Self)->Self { return BN.log10(x, precision, false) }
    public static func log10(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.log10(x, px, db) }
    public static func log1p(_ x:Self)->Self { return BN.log1p(x, precision, false) }
    public static func log1p(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.log1p(x, px, db) }
    public static func sin(_ x:Self)->Self { return BN.sin(x, precision, false) }
    public static func sin(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.sin(x, px, db) }
    public static func sinh(_ x:Self)->Self { return BN.sinh(x, precision, false) }
    public static func sinh(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.sinh(x, px, db) }
    public static func sqrt(_ x:Self)->Self { return BN.sqrt(x, precision, false) }
    public static func sqrt(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.sqrt(x, px, db) }
    public static func tan(_ x:Self)->Self { return BN.tan(x, precision, false) }
    public static func tan(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.tan(x, px, db) }
    public static func tanh(_ x:Self)->Self { return BN.tanh(x, precision, false) }
    public static func tanh(_ x:Self, precision px:Int, debug db:Bool)->Self { return BN.tanh(x, px, db) }
    public static func atan2(y:Self, x:Self)->Self { return BN.atan2(y, x, precision, false) }
    public static func atan2(y:Self, x:Self, precision px:Int, debug db:Bool)->Self { return BN.atan2(y, x, px, db) }
    public static func hypot(_ x:Self, _ y:Self)->Self { return BN.hypot(x, y, precision, false) }
    public static func hypot(_ x:Self, _ y:Self, precision px:Int, debug db:Bool)->Self { return BN.hypot(x, y, px, db) }
    public static func pow  (_ x:Self, _ y:Self)->Self { return BN.pow(x, y, precision, false) }
    public static func pow  (_ x:Self, _ y:Self, precision px:Int, debug db:Bool)->Self { return BN.pow(x, y, px, db) }
}
