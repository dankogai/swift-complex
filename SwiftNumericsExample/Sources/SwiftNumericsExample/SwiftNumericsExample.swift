//
//  SwiftNumericsExample.swift -- swift-complex and apple/swift-numerics together.
//
//  What this package is for: `Complex<Float>` with RealModule doing the real math.
//  NumericsConformance.swift is the part that makes it compile; this file is what
//  it is good for.
//
//  Everything printed here is asserted in the test suite, so the comments are
//  checked rather than claimed.
//
import Complex

/// `exp(iπ) == -1` over `Complex<Float>`.  The cosine and sine behind it come
/// from RealModule, not Foundation: the library itself never taught Float any math.
public func eulerIdentity() -> Complex<Float> {
    return Complex<Float>.exp(Complex<Float>(0, Float.pi))
}

/// √-4 = 2i, which no real Float can say.
public func squareRootOfMinusFour() -> Complex<Float> {
    return Complex<Float>.sqrt(-4)
}

/// The polar rendering of 3+4i -- toString(_:radix:) is generic over the element,
/// so Float gets every format, hexfloat included, for free.
public func polarAndHex() -> (polar: String, hex: String) {
    let z = Complex<Float>(3, 4)
    return (z.toString(.polar), z.toString(.cartesian, radix:16))
}

/// Prints the three above.  Not a test -- `swift test` is where the checking is.
public func demo() {
    let e = eulerIdentity()
    print("Complex<Float>: exp(iπ) = \(e)  (imag off by \(e.imag.magnitude))")
    print("Complex<Float>: √-4 = \(squareRootOfMinusFour())")
    let (polar, hex) = polarAndHex()
    print("Complex<Float>: 3+4i is \(polar) in polar, \(hex) in hex")
}
