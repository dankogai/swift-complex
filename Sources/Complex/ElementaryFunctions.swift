public protocol ElementaryFunctions {
    init (_:Double)             // BinaryFloatingPoint already has one
    func toDouble()->Double  // you have to add it yourself
    /// bit width to which results are computed when `precision` is unspecified
    static var precision:Int { get }
    // full versions with precision and debug flag, as in swift-bignum.
    // types like BigRat and BigFloat already have these, so their
    // arbitrary-precision versions become the witnesses automatically.
    static func acos (_ x:Self, precision:Int, debug:Bool)->Self
    static func acosh(_ x:Self, precision:Int, debug:Bool)->Self
    static func asin (_ x:Self, precision:Int, debug:Bool)->Self
    static func asinh(_ x:Self, precision:Int, debug:Bool)->Self
    static func atan (_ x:Self, precision:Int, debug:Bool)->Self
    static func atanh(_ x:Self, precision:Int, debug:Bool)->Self
    static func cbrt (_ x:Self, precision:Int, debug:Bool)->Self
    static func cos  (_ x:Self, precision:Int, debug:Bool)->Self
    static func cosh (_ x:Self, precision:Int, debug:Bool)->Self
    static func exp  (_ x:Self, precision:Int, debug:Bool)->Self
    static func exp2 (_ x:Self, precision:Int, debug:Bool)->Self
    static func expm1(_ x:Self, precision:Int, debug:Bool)->Self
    static func log  (_ x:Self, precision:Int, debug:Bool)->Self
    static func log2 (_ x:Self, precision:Int, debug:Bool)->Self
    static func log10(_ x:Self, precision:Int, debug:Bool)->Self
    static func log1p(_ x:Self, precision:Int, debug:Bool)->Self
    static func sin  (_ x:Self, precision:Int, debug:Bool)->Self
    static func sinh (_ x:Self, precision:Int, debug:Bool)->Self
    static func sqrt (_ x:Self, precision:Int, debug:Bool)->Self
    static func tan  (_ x:Self, precision:Int, debug:Bool)->Self
    static func tanh (_ x:Self, precision:Int, debug:Bool)->Self
    static func atan2(y:Self, x:Self, precision:Int, debug:Bool)->Self
    static func hypot(_ x:Self, _ y:Self, precision:Int, debug:Bool)->Self
    static func pow  (_ x:Self, _ y:Self, precision:Int, debug:Bool)->Self
}

@available(*, deprecated, renamed: "ElementaryFunctions")
public typealias FloatingPointMath = ElementaryFunctions

import Foundation

// Default implementations go through Double, so precision and debug are ignored.
extension ElementaryFunctions {
    public static var precision:Int { return Double.significandBitCount }
    public static func acos (_ x:Self, precision:Int, debug:Bool)->Self { return Self(Foundation.acos (x.toDouble())) }
    public static func acosh(_ x:Self, precision:Int, debug:Bool)->Self { return Self(Foundation.acosh(x.toDouble())) }
    public static func asin (_ x:Self, precision:Int, debug:Bool)->Self { return Self(Foundation.asin (x.toDouble())) }
    public static func asinh(_ x:Self, precision:Int, debug:Bool)->Self { return Self(Foundation.asinh(x.toDouble())) }
    public static func atan (_ x:Self, precision:Int, debug:Bool)->Self { return Self(Foundation.atan (x.toDouble())) }
    public static func atanh(_ x:Self, precision:Int, debug:Bool)->Self { return Self(Foundation.atanh(x.toDouble())) }
    public static func cbrt (_ x:Self, precision:Int, debug:Bool)->Self { return Self(Foundation.cbrt (x.toDouble())) }
    public static func cos  (_ x:Self, precision:Int, debug:Bool)->Self { return Self(Foundation.cos  (x.toDouble())) }
    public static func cosh (_ x:Self, precision:Int, debug:Bool)->Self { return Self(Foundation.cosh (x.toDouble())) }
    public static func exp  (_ x:Self, precision:Int, debug:Bool)->Self { return Self(Foundation.exp  (x.toDouble())) }
    public static func exp2 (_ x:Self, precision:Int, debug:Bool)->Self { return Self(Foundation.exp2 (x.toDouble())) }
    public static func expm1(_ x:Self, precision:Int, debug:Bool)->Self { return Self(Foundation.expm1(x.toDouble())) }
    public static func log  (_ x:Self, precision:Int, debug:Bool)->Self { return Self(Foundation.log  (x.toDouble())) }
    public static func log2 (_ x:Self, precision:Int, debug:Bool)->Self { return Self(Foundation.log2 (x.toDouble())) }
    public static func log10(_ x:Self, precision:Int, debug:Bool)->Self { return Self(Foundation.log10(x.toDouble())) }
    public static func log1p(_ x:Self, precision:Int, debug:Bool)->Self { return Self(Foundation.log1p(x.toDouble())) }
    public static func sin  (_ x:Self, precision:Int, debug:Bool)->Self { return Self(Foundation.sin  (x.toDouble())) }
    public static func sinh (_ x:Self, precision:Int, debug:Bool)->Self { return Self(Foundation.sinh (x.toDouble())) }
    public static func sqrt (_ x:Self, precision:Int, debug:Bool)->Self { return Self(Foundation.sqrt (x.toDouble())) }
    public static func tan  (_ x:Self, precision:Int, debug:Bool)->Self { return Self(Foundation.tan  (x.toDouble())) }
    public static func tanh (_ x:Self, precision:Int, debug:Bool)->Self { return Self(Foundation.tanh (x.toDouble())) }
    public static func atan2(y:Self, x:Self, precision:Int, debug:Bool)->Self { return Self(Foundation.atan2(y.toDouble(), x.toDouble())) }
    public static func hypot(_ x:Self, _ y:Self, precision:Int, debug:Bool)->Self { return Self(Foundation.hypot(x.toDouble(), y.toDouble())) }
    public static func pow  (_ x:Self, _ y:Self, precision:Int, debug:Bool)->Self { return Self(Foundation.pow  (x.toDouble(), y.toDouble())) }
}

// Short versions.  They go through the protocol requirements above
// so conforming types pick their own implementations dynamically.
extension ElementaryFunctions {
    public static func acos (_ x:Self)->Self { return acos(x, precision:precision, debug:false) }
    public static func acosh(_ x:Self)->Self { return acosh(x, precision:precision, debug:false) }
    public static func asin (_ x:Self)->Self { return asin(x, precision:precision, debug:false) }
    public static func asinh(_ x:Self)->Self { return asinh(x, precision:precision, debug:false) }
    public static func atan (_ x:Self)->Self { return atan(x, precision:precision, debug:false) }
    public static func atanh(_ x:Self)->Self { return atanh(x, precision:precision, debug:false) }
    public static func cbrt (_ x:Self)->Self { return cbrt(x, precision:precision, debug:false) }
    public static func cos  (_ x:Self)->Self { return cos(x, precision:precision, debug:false) }
    public static func cosh (_ x:Self)->Self { return cosh(x, precision:precision, debug:false) }
    public static func exp  (_ x:Self)->Self { return exp(x, precision:precision, debug:false) }
    public static func exp2 (_ x:Self)->Self { return exp2(x, precision:precision, debug:false) }
    public static func expm1(_ x:Self)->Self { return expm1(x, precision:precision, debug:false) }
    public static func log  (_ x:Self)->Self { return log(x, precision:precision, debug:false) }
    public static func log2 (_ x:Self)->Self { return log2(x, precision:precision, debug:false) }
    public static func log10(_ x:Self)->Self { return log10(x, precision:precision, debug:false) }
    public static func log1p(_ x:Self)->Self { return log1p(x, precision:precision, debug:false) }
    public static func sin  (_ x:Self)->Self { return sin(x, precision:precision, debug:false) }
    public static func sinh (_ x:Self)->Self { return sinh(x, precision:precision, debug:false) }
    public static func sqrt (_ x:Self)->Self { return sqrt(x, precision:precision, debug:false) }
    public static func tan  (_ x:Self)->Self { return tan(x, precision:precision, debug:false) }
    public static func tanh (_ x:Self)->Self { return tanh(x, precision:precision, debug:false) }
    public static func atan2(_ y:Self, _ x:Self)->Self { return atan2(y:y, x:x, precision:precision, debug:false) }
    public static func hypot(_ x:Self, _ y:Self)->Self { return hypot(x, y, precision:precision, debug:false) }
    public static func pow  (_ x:Self, _ y:Self)->Self { return pow  (x, y, precision:precision, debug:false) }
}


// Overrides default
extension Double : ElementaryFunctions {
    public func toDouble()->Double { return self }
    public static func acos (_ x:Double)->Double { return Foundation.acos(x) }
    public static func asin (_ x:Double)->Double { return Foundation.asin(x) }
    public static func atan (_ x:Double)->Double { return Foundation.atan(x) }
    public static func acosh(_ x:Double)->Double { return Foundation.acosh(x) }
    public static func asinh(_ x:Double)->Double { return Foundation.asinh(x) }
    public static func atanh(_ x:Double)->Double { return Foundation.atanh(x) }
    public static func cbrt (_ x:Double)->Double { return Foundation.cbrt(x) }
    public static func cos  (_ x:Double)->Double { return Foundation.cos(x) }
    public static func cosh (_ x:Double)->Double { return Foundation.cosh(x) }
    public static func exp  (_ x:Double)->Double { return Foundation.exp(x) }
    public static func exp2 (_ x:Double)->Double { return Foundation.exp2(x) }
    public static func expm1(_ x:Double)->Double { return Foundation.expm1(x) }
    public static func log  (_ x:Double)->Double { return Foundation.log(x) }
    public static func log2 (_ x:Double)->Double { return Foundation.log2(x) }
    public static func log10(_ x:Double)->Double { return Foundation.log10(x) }
    public static func log1p(_ x:Double)->Double { return Foundation.log1p(x) }
    public static func sin  (_ x:Double)->Double { return Foundation.sin(x) }
    public static func sinh (_ x:Double)->Double { return Foundation.sinh(x) }
    public static func sqrt (_ x:Double)->Double { return Foundation.sqrt(x) }
    public static func tan  (_ x:Double)->Double { return Foundation.tan(x) }
    public static func tanh (_ x:Double)->Double { return Foundation.tanh(x) }
    public static func atan2(_ y:Double, _ x:Double)->Double { return Foundation.atan2(y, x) }
    public static func hypot(_ x:Double, _ y:Double)->Double { return Foundation.hypot(x, y) }
    public static func pow  (_ x:Double, _ y:Double)->Double { return Foundation.pow(x, y) }
}

extension Float : ElementaryFunctions {
    public func toDouble()->Double { return Double(self) }
}

//Todo:
//public protocol ElementaryFunctionsGeneric: FloatingPoint & ElementaryFunctions {}
//
//extension ElementaryFunctionsGeneric {
//    public static func sqrt (_ x:Self)->Self {
//        return x.squareRoot()
//    }
//}
//
//extension Float80 : ElementaryFunctionsGeneric {
//    public func toDouble()->Double { return Double(self) }
//}

// default precision for the CMath functions below.  it is passed down to
// Element, which may ignore it (e.g. Double).
private var complexFloatPrecision:Int = 128
extension ComplexFloat {
    public static var precision:Int {
        get { return complexFloatPrecision }
        set { complexFloatPrecision = newValue }
    }
}

// CMath.  precision and debug propagate down to every Element call.
extension ComplexFloat {
    /// arc cosine of z in Complex
    public static func acos(_ z:Self, precision px:Int=Self.precision, debug db:Bool=false) -> Self {
        return log(z - sqrt(1 - z*z, precision:px, debug:db).i, precision:px, debug:db).i
    }
    public static func acos(_ x:Element, precision px:Int=Self.precision, debug db:Bool=false) -> Self { return acos(Self(x), precision:px, debug:db) }
    /// inverse hyperbolic cosine of z in Complex
    public static func acosh(_ z:Self, precision px:Int=Self.precision, debug db:Bool=false) -> Self {
        return log(z + sqrt(z+1, precision:px, debug:db)*sqrt(z-1, precision:px, debug:db), precision:px, debug:db)
    }
    public static func acosh(_ x:Element, precision px:Int=Self.precision, debug db:Bool=false) -> Self { return acosh(Self(x), precision:px, debug:db) }
    /// arc sine of z in Complex
    public static func asin(_ z:Self, precision px:Int=Self.precision, debug db:Bool=false) -> Self {
        return -log(z.i + sqrt(1 - z*z, precision:px, debug:db), precision:px, debug:db).i
    }
    public static func asin(_ x:Element, precision px:Int=Self.precision, debug db:Bool=false) -> Self { return asin(Self(x), precision:px, debug:db) }
    /// inverse hyperbolic sine of z in Complex
    public static func asinh(_ z:Self, precision px:Int=Self.precision, debug db:Bool=false) -> Self {
        return log(z + sqrt(z*z+1, precision:px, debug:db), precision:px, debug:db)
    }
    public static func asinh(_ x:Element, precision px:Int=Self.precision, debug db:Bool=false) -> Self { return asinh(Self(x), precision:px, debug:db) }
    /// arc tangent of z in Complex
    public static func atan(_ z:Self, precision px:Int=Self.precision, debug db:Bool=false) -> Self {
        let lp = log(1 - z.i, precision:px, debug:db)
        let lm = log(1 + z.i, precision:px, debug:db)
        return (lp - lm).i / 2
    }
    public static func atan(_ x:Element, precision px:Int=Self.precision, debug db:Bool=false) -> Self { return atan(Self(x), precision:px, debug:db) }
    /// inverse hyperbolic tangent of z in Complex
    public static func atanh(_ z:Self, precision px:Int=Self.precision, debug db:Bool=false) -> Self {
        return (log(1 + z, precision:px, debug:db) - log(1 - z, precision:px, debug:db)) / 2
    }
    public static func atanh(_ x:Element, precision px:Int=Self.precision, debug db:Bool=false) -> Self { return atanh(Self(x), precision:px, debug:db) }
    /// cosine of z in Complex
    public static func cos(_ z:Self, precision px:Int=Self.precision, debug db:Bool=false) -> Self {
        return Self(
            +Element.cos(z.real, precision:px, debug:db) * Element.cosh(z.imag, precision:px, debug:db),
            -Element.sin(z.real, precision:px, debug:db) * Element.sinh(z.imag, precision:px, debug:db)
        )
    }
    public static func cos(_ x:Element, precision px:Int=Self.precision, debug db:Bool=false) -> Self { return cos(Self(x), precision:px, debug:db) }
    /// hyperbolic cosine of z in Complex
    public static func cosh(_ z:Self, precision px:Int=Self.precision, debug db:Bool=false) -> Self {
        // return (exp(z) + exp(-z)) / T(2)
        return cos(z.i, precision:px, debug:db)
    }
    public static func cosh(_ x:Element, precision px:Int=Self.precision, debug db:Bool=false) -> Self { return cosh(Self(x), precision:px, debug:db) }
    /// e ** z in Complex
    public static func exp(_ z:Self, precision px:Int=Self.precision, debug db:Bool=false) -> Self {
        let r = Element.exp(z.real, precision:px, debug:db)
        let a = z.imag
        return Self(r * Element.cos(a, precision:px, debug:db), r * Element.sin(a, precision:px, debug:db))
    }
    public static func exp(_ x:Element, precision px:Int=Self.precision, debug db:Bool=false) -> Self { return Self(Element.exp(x, precision:px, debug:db)) }
    /// e ** z - 1.0 in Complex
    public static func expm1(_ z:Self, precision px:Int=Self.precision, debug db:Bool=false) -> Self {
        // cf. https://lists.gnu.org/archive/html/octave-maintainers/2008-03/msg00174.html
        return -exp(z/2, precision:px, debug:db) * 2 * sin(z.i/2, precision:px, debug:db).i
    }
    public static func expm1(_ x:Element, precision px:Int=Self.precision, debug db:Bool=false) -> Self { return Self(Element.expm1(x, precision:px, debug:db)) }
    /// natural log of z in Complex
    public static func log(_ z:Self, precision px:Int=Self.precision, debug db:Bool=false) -> Self {
        let a = z.imag.isZero ? Swift.abs(z.real) : Element.hypot(z.real, z.imag, precision:px, debug:db)
        return Self(Element.log(a, precision:px, debug:db), Element.atan2(y:z.imag, x:z.real, precision:px, debug:db))
    }
    public static func log(_ x:Element, precision px:Int=Self.precision, debug db:Bool=false) -> Self { return log(Self(x), precision:px, debug:db) }
    /// base 2 log of z in Complex
    public static func log2(_ z:Self, precision px:Int=Self.precision, debug db:Bool=false) -> Self {
        return log(z, precision:px, debug:db) / Element.log(2, precision:px, debug:db)
    }
    public static func log2(_ x:Element, precision px:Int=Self.precision, debug db:Bool=false) -> Self { return log2(Self(x), precision:px, debug:db) }
    /// base 10 log of z in Complex
    public static func log10(_ z:Self, precision px:Int=Self.precision, debug db:Bool=false) -> Self {
        return log(z, precision:px, debug:db) / Element.log(10, precision:px, debug:db)
    }
    public static func log10(_ x:Element, precision px:Int=Self.precision, debug db:Bool=false) -> Self { return log10(Self(x), precision:px, debug:db) }
    /// natural log of (z + 1) in Complex
    public static func log1p(_ z:Self, precision px:Int=Self.precision, debug db:Bool=false) -> Self {
        return 2*atanh(z/(z+2), precision:px, debug:db)
    }
    public static func log1p(_ x:Element, precision px:Int=Self.precision, debug db:Bool=false) -> Self { return Self(Element.log1p(x, precision:px, debug:db)) }
    /// sine of z in Complex
    public static func sin(_ z:Self, precision px:Int=Self.precision, debug db:Bool=false) -> Self {
        return Self(
            +Element.sin(z.real, precision:px, debug:db) * Element.cosh(z.imag, precision:px, debug:db),
            +Element.cos(z.real, precision:px, debug:db) * Element.sinh(z.imag, precision:px, debug:db)
        )
    }
    public static func sin(_ x:Element, precision px:Int=Self.precision, debug db:Bool=false) -> Self { return sin(Self(x), precision:px, debug:db) }
    /// hyperbolic sine of z in Complex
    public static func sinh(_ z:Self, precision px:Int=Self.precision, debug db:Bool=false) -> Self {
        // return (exp(z) - exp(-z)) / T(2)
        return -sin(z.i, precision:px, debug:db).i
    }
    public static func sinh(_ x:Element, precision px:Int=Self.precision, debug db:Bool=false) -> Self { return sinh(Self(x), precision:px, debug:db) }
    /// square root of z in Complex
    public static func sqrt(_ z:Self, precision px:Int=Self.precision, debug db:Bool=false) -> Self {
        let a = z.imag.isZero ? Swift.abs(z.real) : Element.hypot(z.real, z.imag, precision:px, debug:db)
        let r = Element.sqrt((a + z.real)/2, precision:px, debug:db)
        let i = Element.sqrt((a - z.real)/2, precision:px, debug:db)
        return Self(r, z.imag.sign == .minus ? -i : i)
    }
    public static func sqrt(_ x:Element, precision px:Int=Self.precision, debug db:Bool=false) -> Self { return sqrt(Self(x), precision:px, debug:db) }
    /// tangent of z in Complex
    public static func tan(_ z:Self, precision px:Int=Self.precision, debug db:Bool=false) -> Self {
        return sin(z, precision:px, debug:db) / cos(z, precision:px, debug:db)
    }
    public static func tan(_ x:Element, precision px:Int=Self.precision, debug db:Bool=false) -> Self { return tan(Self(x), precision:px, debug:db) }
    /// hyperbolic tangent of z in Complex
    public static func tanh(_ z:Self, precision px:Int=Self.precision, debug db:Bool=false) -> Self {
        // let ez = exp(z), e_z = exp(-z)
        // return (ez - e_z) / (ez + e_z)
        return sinh(z, precision:px, debug:db) / cosh(z, precision:px, debug:db)
    }
    public static func tanh(_ x:Element, precision px:Int=Self.precision, debug db:Bool=false) -> Self { return tanh(Self(x), precision:px, debug:db) }
    /// atan2 = atan(lhs/rhs)
    public static func atan2(_ lhs:Self, _ rhs:Self, precision px:Int=Self.precision, debug db:Bool=false) -> Self {
        return atan(lhs/rhs, precision:px, debug:db)
    }
    public static func atan2(_ lhs:Self, _ rhs:Element, precision px:Int=Self.precision, debug db:Bool=false) -> Self { return atan2(lhs, Self(rhs, 0), precision:px, debug:db) }
    public static func atan2(_ lhs:Element, _ rhs:Self, precision px:Int=Self.precision, debug db:Bool=false) -> Self { return atan2(Self(lhs, 0), rhs, precision:px, debug:db) }
    public static func atan2(_ lhs:Element, _ rhs:Element, precision px:Int=Self.precision, debug db:Bool=false) -> Self { return Self(Element.atan2(y:lhs, x:rhs, precision:px, debug:db)) }
    /// hypotenuse. defined as √(lhs**2 + rhs**2) though its need for Complex is moot.
    public static func hypot(_ lhs:Self, _ rhs:Self, precision px:Int=Self.precision, debug db:Bool=false) -> Self {
        return sqrt(lhs*lhs + rhs*rhs, precision:px, debug:db)
    }
    public static func hypot(_ lhs:Self, _ rhs:Element, precision px:Int=Self.precision, debug db:Bool=false) -> Self { return hypot(lhs, Self(rhs), precision:px, debug:db) }
    public static func hypot(_ lhs:Element, _ rhs:Self, precision px:Int=Self.precision, debug db:Bool=false) -> Self { return hypot(Self(lhs), rhs, precision:px, debug:db) }
    public static func hypot(_ lhs:Element, _ rhs:Element, precision px:Int=Self.precision, debug db:Bool=false) -> Self { return Self(Element.hypot(lhs, rhs, precision:px, debug:db)) }
    /// lhs ** rhs in Complex
    public static func pow(_ lhs:Self, _ rhs:Self, precision px:Int=Self.precision, debug db:Bool=false) -> Self {
        return exp(log(lhs, precision:px, debug:db) * rhs, precision:px, debug:db)
    }
    public static func pow(_ lhs:Self, _ rhs:Element, precision px:Int=Self.precision, debug db:Bool=false) -> Self { return pow(lhs, Self(rhs), precision:px, debug:db) }
    public static func pow(_ lhs:Element, _ rhs:Self, precision px:Int=Self.precision, debug db:Bool=false) -> Self { return pow(Self(lhs), rhs, precision:px, debug:db) }
    public static func pow(_ lhs:Element, _ rhs:Element, precision px:Int=Self.precision, debug db:Bool=false) -> Self { return Self(Element.pow(lhs, rhs, precision:px, debug:db)) }
}
