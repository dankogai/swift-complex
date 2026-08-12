//
//  NumericsConformance.swift -- Float as an RMath, powered by apple/swift-numerics,
//  so that `Complex<Float>` gets its math functions from RealModule.
//
//  The library leaves Float's conformance deliberately vacant (see the
//  commented-out `extension Float : RMathViaDouble` in ElementaryFunctions.swift):
//  had it shipped one, this file could not exist -- a second conformance would be
//  redundant, and RealModule's members would tie with RMathViaDouble's defaults
//  in witness resolution.  An open slot costs nothing and lets the client choose.
//
//  RealModule already carries almost every plain requirement under the same name
//  and signature -- exp, log, sin ... atan2(y:x:), hypot, pow -- so they become
//  the witnesses by themselves.  The three it spells differently (root(x,3),
//  expMinusOne(_:), log(onePlus:)) fall back to RMath's defaults, which are built
//  from other requirements, i.e. still RealModule underneath.
//
//  What Float must say for itself:
//   - toDouble() and precision, the two members no protocol can guess;
//   - the precision:debug: requirements.  Float's precision is fixed, so the
//     arguments are accepted and ignored, exactly like RMathViaDouble does for
//     Double -- each one forwards to RealModule's plain version.
//
import Complex
import RealModule

extension Float: @retroactive RMath {
    public func toDouble()->Double { return Double(self) }
    public static var precision:Int { return significandBitCount }
    // precision is fixed for Float; the arguments are accepted and ignored
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
    // expm1's precision:debug: form is the one full-signature requirement with a
    // default (spelled from exp), so it is not needed here.
}
