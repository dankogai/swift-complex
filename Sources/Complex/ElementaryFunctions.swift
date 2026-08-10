public protocol RMath : FloatingPoint {
    init (_:Double)             // BinaryFloatingPoint already has one
    func toDouble()->Double  // you have to add it yourself
    /// bit width to which results are computed
    static var precision:Int { get }
    // plain versions only.  types like BigRat and BigFloat already have
    // them natively, so they become the witnesses automatically.
    static func acos (_ x:Self)->Self
    static func acosh(_ x:Self)->Self
    static func asin (_ x:Self)->Self
    static func asinh(_ x:Self)->Self
    static func atan (_ x:Self)->Self
    static func atanh(_ x:Self)->Self
    static func cbrt (_ x:Self)->Self
    static func cos  (_ x:Self)->Self
    static func cosh (_ x:Self)->Self
    static func exp  (_ x:Self)->Self
    static func exp2 (_ x:Self)->Self
    static func expm1(_ x:Self)->Self
    static func log  (_ x:Self)->Self
    static func log2 (_ x:Self)->Self
    static func log10(_ x:Self)->Self
    static func log1p(_ x:Self)->Self
    static func sin  (_ x:Self)->Self
    static func sinh (_ x:Self)->Self
    static func sqrt (_ x:Self)->Self
    static func tan  (_ x:Self)->Self
    static func tanh (_ x:Self)->Self
    static func atan2(y:Self, x:Self)->Self
    static func hypot(_ x:Self, _ y:Self)->Self
    static func pow  (_ x:Self, _ y:Self)->Self
}

public typealias RealElementaryFunctions = RMath

import Foundation

// Default implementations exist only for the requirements swift-bignum
// spells differently (root(x,3), expMinusOne(_:), log(onePlus:)).  They go
// through other requirements -- not Double -- so arbitrary-precision types
// do not silently lose precision.  Everything else is deliberately left to
// the conforming type: types that already have the math functions -- like
// BigRat and BigFloat -- conform with an empty extension, with no
// competing default to make witness resolution ambiguous.
extension RMath {
    public static func cbrt (_ x:Self)->Self { return x < 0 ? -pow(-x, 1/Self(3)) : pow(x, 1/Self(3)) }
    public static func expm1(_ x:Self)->Self { return exp(x) - 1 }
    public static func log1p(_ x:Self)->Self { return log(1 + x) }
}

// Versions with precision and debug flag, as in swift-bignum.
// They are NOT protocol requirements: precision and debug are used only
// when the element has the corresponding function (e.g. BigRat, BigFloat).
// Otherwise they simply forward to the plain versions above.
extension RMath {
    public static func acos (_ x:Self, precision px:Int=Self.precision, debug db:Bool=false)->Self { return acos(x) }
    public static func acosh(_ x:Self, precision px:Int=Self.precision, debug db:Bool=false)->Self { return acosh(x) }
    public static func asin (_ x:Self, precision px:Int=Self.precision, debug db:Bool=false)->Self { return asin(x) }
    public static func asinh(_ x:Self, precision px:Int=Self.precision, debug db:Bool=false)->Self { return asinh(x) }
    public static func atan (_ x:Self, precision px:Int=Self.precision, debug db:Bool=false)->Self { return atan(x) }
    public static func atanh(_ x:Self, precision px:Int=Self.precision, debug db:Bool=false)->Self { return atanh(x) }
    public static func cbrt (_ x:Self, precision px:Int=Self.precision, debug db:Bool=false)->Self { return cbrt(x) }
    public static func cos  (_ x:Self, precision px:Int=Self.precision, debug db:Bool=false)->Self { return cos(x) }
    public static func cosh (_ x:Self, precision px:Int=Self.precision, debug db:Bool=false)->Self { return cosh(x) }
    public static func exp  (_ x:Self, precision px:Int=Self.precision, debug db:Bool=false)->Self { return exp(x) }
    public static func exp2 (_ x:Self, precision px:Int=Self.precision, debug db:Bool=false)->Self { return exp2(x) }
    public static func expm1(_ x:Self, precision px:Int=Self.precision, debug db:Bool=false)->Self { return expm1(x) }
    public static func log  (_ x:Self, precision px:Int=Self.precision, debug db:Bool=false)->Self { return log(x) }
    public static func log2 (_ x:Self, precision px:Int=Self.precision, debug db:Bool=false)->Self { return log2(x) }
    public static func log10(_ x:Self, precision px:Int=Self.precision, debug db:Bool=false)->Self { return log10(x) }
    public static func log1p(_ x:Self, precision px:Int=Self.precision, debug db:Bool=false)->Self { return log1p(x) }
    public static func sin  (_ x:Self, precision px:Int=Self.precision, debug db:Bool=false)->Self { return sin(x) }
    public static func sinh (_ x:Self, precision px:Int=Self.precision, debug db:Bool=false)->Self { return sinh(x) }
    public static func sqrt (_ x:Self, precision px:Int=Self.precision, debug db:Bool=false)->Self { return sqrt(x) }
    public static func tan  (_ x:Self, precision px:Int=Self.precision, debug db:Bool=false)->Self { return tan(x) }
    public static func tanh (_ x:Self, precision px:Int=Self.precision, debug db:Bool=false)->Self { return tanh(x) }
    public static func atan2(y:Self, x:Self, precision px:Int=Self.precision, debug db:Bool=false)->Self { return atan2(y:y, x:x) }
    public static func atan2(_ y:Self, _ x:Self, precision px:Int=Self.precision, debug db:Bool=false)->Self { return atan2(y:y, x:x) }
    public static func hypot(_ x:Self, _ y:Self, precision px:Int=Self.precision, debug db:Bool=false)->Self { return hypot(x, y) }
    public static func pow  (_ x:Self, _ y:Self, precision px:Int=Self.precision, debug db:Bool=false)->Self { return pow  (x, y) }
}

// Concrete members always win witness resolution, so Double and Float
// carry their witnesses directly.
extension Double : RMath {
    public func toDouble()->Double { return self }
    public static var precision:Int { return significandBitCount }
    public static func acos (_ x:Double)->Double { return Foundation.acos (x) }
    public static func acosh(_ x:Double)->Double { return Foundation.acosh(x) }
    public static func asin (_ x:Double)->Double { return Foundation.asin (x) }
    public static func asinh(_ x:Double)->Double { return Foundation.asinh(x) }
    public static func atan (_ x:Double)->Double { return Foundation.atan (x) }
    public static func atanh(_ x:Double)->Double { return Foundation.atanh(x) }
    public static func cbrt (_ x:Double)->Double { return Foundation.cbrt (x) }
    public static func cos  (_ x:Double)->Double { return Foundation.cos  (x) }
    public static func cosh (_ x:Double)->Double { return Foundation.cosh (x) }
    public static func exp  (_ x:Double)->Double { return Foundation.exp  (x) }
    public static func exp2 (_ x:Double)->Double { return Foundation.exp2 (x) }
    public static func expm1(_ x:Double)->Double { return Foundation.expm1(x) }
    public static func log  (_ x:Double)->Double { return Foundation.log  (x) }
    public static func log2 (_ x:Double)->Double { return Foundation.log2 (x) }
    public static func log10(_ x:Double)->Double { return Foundation.log10(x) }
    public static func log1p(_ x:Double)->Double { return Foundation.log1p(x) }
    public static func sin  (_ x:Double)->Double { return Foundation.sin  (x) }
    public static func sinh (_ x:Double)->Double { return Foundation.sinh (x) }
    public static func sqrt (_ x:Double)->Double { return Foundation.sqrt (x) }
    public static func tan  (_ x:Double)->Double { return Foundation.tan  (x) }
    public static func tanh (_ x:Double)->Double { return Foundation.tanh (x) }
    public static func atan2(y:Double, x:Double)->Double { return Foundation.atan2(y, x) }
    public static func hypot(_ x:Double, _ y:Double)->Double { return Foundation.hypot(x, y) }
    public static func pow  (_ x:Double, _ y:Double)->Double { return Foundation.pow  (x, y) }
}

extension Float : RMath {
    public func toDouble()->Double { return Double(self) }
    public static var precision:Int { return Double.significandBitCount }
    public static func acos (_ x:Float)->Float { return Float(Foundation.acos (Double(x))) }
    public static func acosh(_ x:Float)->Float { return Float(Foundation.acosh(Double(x))) }
    public static func asin (_ x:Float)->Float { return Float(Foundation.asin (Double(x))) }
    public static func asinh(_ x:Float)->Float { return Float(Foundation.asinh(Double(x))) }
    public static func atan (_ x:Float)->Float { return Float(Foundation.atan (Double(x))) }
    public static func atanh(_ x:Float)->Float { return Float(Foundation.atanh(Double(x))) }
    public static func cbrt (_ x:Float)->Float { return Float(Foundation.cbrt (Double(x))) }
    public static func cos  (_ x:Float)->Float { return Float(Foundation.cos  (Double(x))) }
    public static func cosh (_ x:Float)->Float { return Float(Foundation.cosh (Double(x))) }
    public static func exp  (_ x:Float)->Float { return Float(Foundation.exp  (Double(x))) }
    public static func exp2 (_ x:Float)->Float { return Float(Foundation.exp2 (Double(x))) }
    public static func expm1(_ x:Float)->Float { return Float(Foundation.expm1(Double(x))) }
    public static func log  (_ x:Float)->Float { return Float(Foundation.log  (Double(x))) }
    public static func log2 (_ x:Float)->Float { return Float(Foundation.log2 (Double(x))) }
    public static func log10(_ x:Float)->Float { return Float(Foundation.log10(Double(x))) }
    public static func log1p(_ x:Float)->Float { return Float(Foundation.log1p(Double(x))) }
    public static func sin  (_ x:Float)->Float { return Float(Foundation.sin  (Double(x))) }
    public static func sinh (_ x:Float)->Float { return Float(Foundation.sinh (Double(x))) }
    public static func sqrt (_ x:Float)->Float { return Float(Foundation.sqrt (Double(x))) }
    public static func tan  (_ x:Float)->Float { return Float(Foundation.tan  (Double(x))) }
    public static func tanh (_ x:Float)->Float { return Float(Foundation.tanh (Double(x))) }
    public static func atan2(y:Float, x:Float)->Float { return Float(Foundation.atan2(Double(y), Double(x))) }
    public static func hypot(_ x:Float, _ y:Float)->Float { return Float(Foundation.hypot(Double(x), Double(y))) }
    public static func pow  (_ x:Float, _ y:Float)->Float { return Float(Foundation.pow  (Double(x), Double(y))) }
}

//Todo:
//extension Float80 : RMath {
//    public func toDouble()->Double { return Double(self) }
//}

// default precision for the CMath functions below.  it is passed down to
// Element, which may ignore it (e.g. Double).
private var complexFloatPrecision:Int = 128
extension CMath {
    public static var precision:Int {
        get { return complexFloatPrecision }
        set { complexFloatPrecision = newValue }
    }
}

// CMath.  precision and debug propagate down to every Element call.
extension CMath {
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
    /// principal cube root of z in Complex
    public static func cbrt(_ z:Self, precision px:Int=Self.precision, debug db:Bool=false) -> Self {
        return exp(log(z, precision:px, debug:db) / 3, precision:px, debug:db)
    }
    public static func cbrt(_ x:Element, precision px:Int=Self.precision, debug db:Bool=false) -> Self { return cbrt(Self(x), precision:px, debug:db) }
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
    /// 2 ** z in Complex
    public static func exp2(_ z:Self, precision px:Int=Self.precision, debug db:Bool=false) -> Self {
        return pow(2, z, precision:px, debug:db)
    }
    public static func exp2(_ x:Element, precision px:Int=Self.precision, debug db:Bool=false) -> Self { return Self(Element.exp2(x, precision:px, debug:db)) }
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

// The plain versions below witness the CMath requirements by forwarding to the versions above --
// without them the Double-based defaults would be picked, dropping .imag.
extension CMath {
    public static func acos (_ z:Self)->Self { return acos(z, precision:Self.precision, debug:false) }
    public static func acosh(_ z:Self)->Self { return acosh(z, precision:Self.precision, debug:false) }
    public static func asin (_ z:Self)->Self { return asin(z, precision:Self.precision, debug:false) }
    public static func asinh(_ z:Self)->Self { return asinh(z, precision:Self.precision, debug:false) }
    public static func atan (_ z:Self)->Self { return atan(z, precision:Self.precision, debug:false) }
    public static func atanh(_ z:Self)->Self { return atanh(z, precision:Self.precision, debug:false) }
    public static func cbrt (_ z:Self)->Self { return cbrt(z, precision:Self.precision, debug:false) }
    public static func cos  (_ z:Self)->Self { return cos(z, precision:Self.precision, debug:false) }
    public static func cosh (_ z:Self)->Self { return cosh(z, precision:Self.precision, debug:false) }
    public static func exp  (_ z:Self)->Self { return exp(z, precision:Self.precision, debug:false) }
    public static func exp2 (_ z:Self)->Self { return exp2(z, precision:Self.precision, debug:false) }
    public static func expm1(_ z:Self)->Self { return expm1(z, precision:Self.precision, debug:false) }
    public static func log  (_ z:Self)->Self { return log(z, precision:Self.precision, debug:false) }
    public static func log2 (_ z:Self)->Self { return log2(z, precision:Self.precision, debug:false) }
    public static func log10(_ z:Self)->Self { return log10(z, precision:Self.precision, debug:false) }
    public static func log1p(_ z:Self)->Self { return log1p(z, precision:Self.precision, debug:false) }
    public static func sin  (_ z:Self)->Self { return sin(z, precision:Self.precision, debug:false) }
    public static func sinh (_ z:Self)->Self { return sinh(z, precision:Self.precision, debug:false) }
    public static func sqrt (_ z:Self)->Self { return sqrt(z, precision:Self.precision, debug:false) }
    public static func tan  (_ z:Self)->Self { return tan(z, precision:Self.precision, debug:false) }
    public static func tanh (_ z:Self)->Self { return tanh(z, precision:Self.precision, debug:false) }
    public static func atan2(y:Self, x:Self)->Self { return atan2(y, x, precision:Self.precision, debug:false) }
    public static func hypot(_ x:Self, _ y:Self)->Self { return hypot(x, y, precision:Self.precision, debug:false) }
    public static func pow  (_ x:Self, _ y:Self)->Self { return pow  (x, y, precision:Self.precision, debug:false) }
}
