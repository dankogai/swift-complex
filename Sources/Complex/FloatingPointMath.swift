public protocol FloatingPointMath {
    init (_:Double)             // BinaryFloatingPoint already has one
    var asDouble:Double { get } // you have to add it yourself
}

import Foundation

// Default implementations
extension FloatingPointMath {
    public static func acos (_ x:Self)->Self { return Self(Foundation.acos (x.asDouble)) }
    public static func acosh(_ x:Self)->Self { return Self(Foundation.acosh(x.asDouble)) }
    public static func asin (_ x:Self)->Self { return Self(Foundation.asin (x.asDouble)) }
    public static func asinh(_ x:Self)->Self { return Self(Foundation.asinh(x.asDouble)) }
    public static func atan (_ x:Self)->Self { return Self(Foundation.atan (x.asDouble)) }
    public static func atanh(_ x:Self)->Self { return Self(Foundation.atanh(x.asDouble)) }
    public static func cos  (_ x:Self)->Self { return Self(Foundation.cos  (x.asDouble)) }
    public static func cbrt (_ x:Self)->Self { return Self(Foundation.cbrt (x.asDouble)) }
    public static func cosh (_ x:Self)->Self { return Self(Foundation.cosh (x.asDouble)) }
    public static func exp  (_ x:Self)->Self { return Self(Foundation.exp  (x.asDouble)) }
    public static func exp2 (_ x:Self)->Self { return Self(Foundation.exp2 (x.asDouble)) }
    public static func expm1(_ x:Self)->Self { return Self(Foundation.expm1(x.asDouble)) }
    public static func log  (_ x:Self)->Self { return Self(Foundation.log  (x.asDouble)) }
    public static func log2 (_ x:Self)->Self { return Self(Foundation.log2 (x.asDouble)) }
    public static func log10(_ x:Self)->Self { return Self(Foundation.log10(x.asDouble)) }
    public static func log1p(_ x:Self)->Self { return Self(Foundation.log1p(x.asDouble)) }
    public static func sin  (_ x:Self)->Self { return Self(Foundation.sin  (x.asDouble)) }
    public static func sinh (_ x:Self)->Self { return Self(Foundation.sinh (x.asDouble)) }
    public static func sqrt (_ x:Self)->Self { return Self(Foundation.sqrt (x.asDouble)) }
    public static func tan  (_ x:Self)->Self { return Self(Foundation.tan  (x.asDouble)) }
    public static func tanh (_ x:Self)->Self { return Self(Foundation.tanh (x.asDouble)) }
    public static func atan2(_ x:Self, _ y:Self)->Self { return Self(Foundation.atan2(x.asDouble, y.asDouble)) }
    public static func hypot(_ x:Self, _ y:Self)->Self { return Self(Foundation.hypot(x.asDouble, y.asDouble)) }
    public static func pow(_ x:Self, _ y:Self)->Self   { return Self(Foundation.pow  (x.asDouble, y.asDouble)) }
}
// Overrides default
extension Double : FloatingPointMath {
    public var asDouble:Double { return self }
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

extension Float : FloatingPointMath {
    public var asDouble:Double { return Double(self) }
}

//Todo:
//public protocol FloatingPointMathGeneric: FloatingPoint & FloatingPointMath {}
//
//extension FloatingPointMathGeneric {
//    public static func sqrt (_ x:Self)->Self {
//        return x.squareRoot()
//    }
//}
//
//extension Float80 : FloatingPointMathGeneric {
//    public var asDouble:Double { return Double(self) }
//}
