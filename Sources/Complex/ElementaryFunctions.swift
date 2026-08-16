public protocol RMath : FloatingPoint & CustomDebugStringConvertible {
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
    // full-signature versions.  These are requirements -- not conveniences --
    // because generic code (the CMath layer above all) can only dispatch
    // through requirements: as mere overloads the precision argument would
    // silently bind to a forwarder and be discarded.  swift-bignum's
    // precision:debug: functions witness these as-is; the default argument
    // values they carry do not participate in witness matching.
    // (No default arguments here -- requirements cannot have them --
    // so generic callers spell out precision: and debug: in full.)
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

public typealias RealElementaryFunctions = RMath

// Every branch here is `canImport`, and the order matters: Android also
// has Glibc-shaped headers, and WASI would otherwise fall through.  This
// is the same preamble swift-bignum and swift-interval carry.
#if canImport(Darwin)
import Darwin
#elseif canImport(Bionic)
import Bionic
#elseif canImport(Android)
import Android
#elseif canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#elseif canImport(WASILibc)
import WASILibc
#elseif os(Windows)
import CRT
#endif

// Bound at file scope, where unqualified lookup still means libm's free
// functions -- inside the extensions below, `exp(x)` would mean the static
// member being declared, and recurse.  (`Foundation.exp` would do the same
// job on Apple platforms only; these work wherever libm does.)
private let c_acos  : @Sendable (Double) -> Double = acos
private let c_acosh : @Sendable (Double) -> Double = acosh
private let c_asin  : @Sendable (Double) -> Double = asin
private let c_asinh : @Sendable (Double) -> Double = asinh
private let c_atan  : @Sendable (Double) -> Double = atan
private let c_atanh : @Sendable (Double) -> Double = atanh
private let c_cbrt  : @Sendable (Double) -> Double = cbrt
private let c_cos   : @Sendable (Double) -> Double = cos
private let c_cosh  : @Sendable (Double) -> Double = cosh
private let c_exp   : @Sendable (Double) -> Double = exp
private let c_exp2  : @Sendable (Double) -> Double = exp2
private let c_expm1 : @Sendable (Double) -> Double = expm1
private let c_log   : @Sendable (Double) -> Double = log
private let c_log2  : @Sendable (Double) -> Double = log2
private let c_log10 : @Sendable (Double) -> Double = log10
private let c_log1p : @Sendable (Double) -> Double = log1p
private let c_sin   : @Sendable (Double) -> Double = sin
private let c_sinh  : @Sendable (Double) -> Double = sinh
private let c_sqrt  : @Sendable (Double) -> Double = sqrt
private let c_tan   : @Sendable (Double) -> Double = tan
private let c_tanh  : @Sendable (Double) -> Double = tanh
private let c_atan2 : @Sendable (Double, Double) -> Double = atan2
private let c_hypot : @Sendable (Double, Double) -> Double = hypot
private let c_pow   : @Sendable (Double, Double) -> Double = pow

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

// The precision:debug: forms are requirements now, so there are NO
// unconstrained forwarders here: a forwarder that discards precision would
// shadow the requirement at generic call sites (the very bug this block
// once caused), and any same-signature extension member would tie with
// swift-bignum's in witness resolution.  Only expm1, which swift-bignum
// spells expMinusOne, gets a default, built from other requirements so
// precision still propagates; and the unlabeled atan2 convenience stays,
// forwarding to the labeled requirement.
extension RMath {
    public static func expm1(_ x:Self, precision px:Int, debug db:Bool)->Self {
        return exp(x, precision:px, debug:db) - 1
    }
    public static func atan2(_ y:Self, _ x:Self, precision px:Int=Self.precision, debug db:Bool=false)->Self {
        return atan2(y:y, x:x, precision:px, debug:db)
    }
}

// Double and Float take their witnesses from the protocol extension below,
// NOT from concrete members: swift-bignum also declares the same-signature
// functions concretely on Double (as witnesses for its own protocols), and
// two concrete declarations from different modules make every direct call
// site ambiguous in code that imports both.  A protocol-extension member
// loses to a concrete one at call sites -- so `Double.exp(1.0)` resolves
// to swift-bignum's where both are visible -- but it still witnesses the
// conformance here, where swift-bignum is not imported.  BigRat and
// BigFloat never conform to the marker, so their witness resolution is
// untouched.
public protocol RMathViaDouble : RMath {}

extension RMathViaDouble {
    public static var precision:Int { return Double.significandBitCount }
    public static func acos (_ x:Self)->Self { return Self(c_acos(x.toDouble())) }
    public static func acosh(_ x:Self)->Self { return Self(c_acosh(x.toDouble())) }
    public static func asin (_ x:Self)->Self { return Self(c_asin(x.toDouble())) }
    public static func asinh(_ x:Self)->Self { return Self(c_asinh(x.toDouble())) }
    public static func atan (_ x:Self)->Self { return Self(c_atan(x.toDouble())) }
    public static func atanh(_ x:Self)->Self { return Self(c_atanh(x.toDouble())) }
    public static func cbrt (_ x:Self)->Self { return Self(c_cbrt(x.toDouble())) }
    public static func cos  (_ x:Self)->Self { return Self(c_cos(x.toDouble())) }
    public static func cosh (_ x:Self)->Self { return Self(c_cosh(x.toDouble())) }
    public static func exp  (_ x:Self)->Self { return Self(c_exp(x.toDouble())) }
    public static func exp2 (_ x:Self)->Self { return Self(c_exp2(x.toDouble())) }
    public static func expm1(_ x:Self)->Self { return Self(c_expm1(x.toDouble())) }
    public static func log  (_ x:Self)->Self { return Self(c_log(x.toDouble())) }
    public static func log2 (_ x:Self)->Self { return Self(c_log2(x.toDouble())) }
    public static func log10(_ x:Self)->Self { return Self(c_log10(x.toDouble())) }
    public static func log1p(_ x:Self)->Self { return Self(c_log1p(x.toDouble())) }
    public static func sin  (_ x:Self)->Self { return Self(c_sin(x.toDouble())) }
    public static func sinh (_ x:Self)->Self { return Self(c_sinh(x.toDouble())) }
    public static func sqrt (_ x:Self)->Self { return Self(c_sqrt(x.toDouble())) }
    public static func tan  (_ x:Self)->Self { return Self(c_tan(x.toDouble())) }
    public static func tanh (_ x:Self)->Self { return Self(c_tanh(x.toDouble())) }
    public static func atan2(y:Self, x:Self)->Self { return Self(c_atan2(y.toDouble(), x.toDouble())) }
    public static func hypot(_ x:Self, _ y:Self)->Self { return Self(c_hypot(x.toDouble(), y.toDouble())) }
    public static func pow  (_ x:Self, _ y:Self)->Self { return Self(c_pow(x.toDouble(), y.toDouble())) }
    // precision is fixed for these types; the arguments are accepted and ignored
    public static func acos (_ x:Self, precision:Int, debug:Bool)->Self { return acos (x) }
    public static func acosh(_ x:Self, precision:Int, debug:Bool)->Self { return acosh(x) }
    public static func asin (_ x:Self, precision:Int, debug:Bool)->Self { return asin (x) }
    public static func asinh(_ x:Self, precision:Int, debug:Bool)->Self { return asinh(x) }
    public static func atan (_ x:Self, precision:Int, debug:Bool)->Self { return atan (x) }
    public static func atanh(_ x:Self, precision:Int, debug:Bool)->Self { return atanh(x) }
    public static func cbrt (_ x:Self, precision:Int, debug:Bool)->Self { return cbrt (x) }
    public static func cos  (_ x:Self, precision:Int, debug:Bool)->Self { return cos  (x) }
    public static func cosh (_ x:Self, precision:Int, debug:Bool)->Self { return cosh (x) }
    public static func exp  (_ x:Self, precision:Int, debug:Bool)->Self { return exp  (x) }
    public static func exp2 (_ x:Self, precision:Int, debug:Bool)->Self { return exp2 (x) }
    public static func expm1(_ x:Self, precision:Int, debug:Bool)->Self { return expm1(x) }
    public static func log  (_ x:Self, precision:Int, debug:Bool)->Self { return log  (x) }
    public static func log2 (_ x:Self, precision:Int, debug:Bool)->Self { return log2 (x) }
    public static func log10(_ x:Self, precision:Int, debug:Bool)->Self { return log10(x) }
    public static func log1p(_ x:Self, precision:Int, debug:Bool)->Self { return log1p(x) }
    public static func sin  (_ x:Self, precision:Int, debug:Bool)->Self { return sin  (x) }
    public static func sinh (_ x:Self, precision:Int, debug:Bool)->Self { return sinh (x) }
    public static func sqrt (_ x:Self, precision:Int, debug:Bool)->Self { return sqrt (x) }
    public static func tan  (_ x:Self, precision:Int, debug:Bool)->Self { return tan  (x) }
    public static func tanh (_ x:Self, precision:Int, debug:Bool)->Self { return tanh (x) }
    public static func atan2(y:Self, x:Self, precision:Int, debug:Bool)->Self { return atan2(y:y, x:x) }
    public static func hypot(_ x:Self, _ y:Self, precision:Int, debug:Bool)->Self { return hypot(x, y) }
    public static func pow  (_ x:Self, _ y:Self, precision:Int, debug:Bool)->Self { return pow  (x, y) }
}

extension Double : RMathViaDouble {
    public func toDouble()->Double { return self }
}

//extension Float : RMathViaDouble {
//    public func toDouble()->Double { return Double(self) }
//}


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
