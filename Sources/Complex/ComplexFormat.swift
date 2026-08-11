//
//  ComplexFormat.swift -- toString(_:radix:) and the Format enum,
//  plus description and debugDescription implemented on top of it.
//

extension Complex {
    ///
    /// How `toString(_:radix:)` should render a value.
    ///
    public enum Format : Sendable {
        /// like `description`: `(3.0+4.0.i)`
        case math
        /// polar coordinates: `(abs:5.0, arg:0.9272952180016122)`
        case polar
        /// labeled rectangular coordinates: `(real:3.0, imag:4.0)`
        case cartesian
        /// unlabeled rectangular coordinates: `(3.0, 4.0)`
        case tuple
    }
}

/// Renders one element.  radix 10 is the plain description; radices
/// 16, 8 and 2 print hexfloat-style -- `0x1.8p+1`, `0o1.4p+1`, `0b1.1p+1` --
/// significand digits in the radix, binary exponent after `p`.
internal func elementToString<F:FloatingPoint>(_ x:F, radix:Int)->String {
    if radix == 10 { return "\(x)" }
    precondition([2, 8, 16].contains(radix), "radix must be 2, 8, 10, or 16")
    let sign   = x.sign == .minus ? "-" : ""
    let prefix = radix == 16 ? "0x" : radix == 8 ? "0o" : "0b"
    if x.isNaN      { return "nan" }
    if x.isInfinite { return sign + "inf" }
    if x.isZero     { return sign + prefix + "0p+0" }
    let m = x.magnitude
    let chars = Array("0123456789abcdef")
    var digits = ""
    var frac = m.significand - 1   // significand is normalized to [1, 2)
    var cap = 1 << 12              // in case frac never reaches zero (e.g. BigRat(1, 3))
    while !frac.isZero && 0 < cap {
        frac = frac * F(radix)
        let d = frac.rounded(.towardZero)
        var di = 0
        for i in 1..<radix where F(i) == d { di = i; break }
        digits.append(chars[di])
        frac = frac - d
        cap -= 1
    }
    let e = m.exponent
    return sign + prefix + "1" + (digits.isEmpty ? "" : "." + digits)
        + "p" + (e < 0 ? "" : "+") + "\(e)"
}

extension Complex where R: RMath {
    /// `self` as a `String`, rendered per `format` in `radix`
    /// (10, or 16, 8, and 2 for the hexfloat-style forms).
    public func toString(_ format:Format = .math, radix:Int = 10)->String {
        func es(_ x:R)->String { return elementToString(x, radix:radix) }
        switch format {
        case .math:
            let sig = imag.sign == .minus ? "-" : "+"
            return "(\(es(real))\(sig)\(es(imag.magnitude)).i)"
        case .polar:
            return "(abs:\(es(self.abs)), arg:\(es(self.arg)))"
        case .cartesian:
            return "(real:\(es(real)), imag:\(es(imag)))"
        case .tuple:
            return "(\(es(real)), \(es(imag)))"
        }
    }
}

// description lives on ComplexFloat so that it works for every
// FloatingPoint element; its output equals toString(.math).

extension Complex : CustomDebugStringConvertible where R: RMath {
    /// `toString(.cartesian, radix:16)`
    public var debugDescription:String { return toString(.cartesian, radix:16) }
}
