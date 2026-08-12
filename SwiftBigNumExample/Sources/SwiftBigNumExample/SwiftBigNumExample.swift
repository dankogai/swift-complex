//
//  SwiftBigNumExample.swift -- swift-complex and swift-bignum together.
//
//  What this package is for: `Complex<BigRat>` and `Complex<BigFloat>`.
//  BigNumConformance.swift is the part that makes them compile; this file is
//  what they are good for.
//
//  Everything printed here is asserted in the test suite, so the comments are
//  checked rather than claimed.
//
import Complex
import BigNum

/// Complex division over an *exact* type.
///
/// `(1+2i)/(3+4i)` is `(11+2i)/25` -- 0.44 + 0.08i -- and 25 is not a power of
/// two, so no binary float lands on either component.  Over `BigRat` the answer
/// is the number itself, and multiplying back returns exactly what you started
/// with.
public func exactComplexDivision() -> (quotient: Complex<BigRat>, roundTrips: Bool) {
    let q = Complex<BigRat>(1, 2) / Complex<BigRat>(3, 4)
    return (q, q * Complex<BigRat>(3, 4) == Complex<BigRat>(1, 2))
}

/// Complex transcendentals at more precision than a `Double` has.
///
/// `exp(iπ) == -1`, with cosine and sine from BigNum at its default 128 bits:
/// both components land about 1e-38 from where they should be, where a
/// `Double`'s imaginary part is 1.22e-16 out and cannot do better.
public func eulerIdentity() -> (bigFloat: Complex<BigFloat>, double: Complex<Double>) {
    return (Complex<BigFloat>.exp(Complex<BigFloat>(0, BigFloat.PI())),
            Complex<Double>.exp(Complex<Double>(0, Double.pi)))
}

/// √i = (1+i)/√2 over `BigFloat`, at the precision you ask for --
/// swift-complex hands `precision:` down to every BigNum call underneath.
public func squareRootOfI(precision px:Int = 128) -> Complex<BigFloat> {
    return Complex<BigFloat>.sqrt(Complex<BigFloat>(0, 1), precision:px)
}

/// Prints the three above.  Not a test -- `swift test` is where the checking is.
public func demo() {
    let (q, roundTrips) = exactComplexDivision()
    print("Complex<BigRat>: (1+2i)/(3+4i) = \(q)")
    print("                exact 11/25 and 2/25? \(q.real == BigRat(11, 25) && q.imag == BigRat(2, 25))")
    print("                multiplies back exactly? \(roundTrips)")

    let (bf, d) = eulerIdentity()
    print("Complex<BigFloat>: exp(iπ) off by  re \((bf.real + 1).magnitude.toDouble()), im \(bf.imag.magnitude.toDouble())")
    print("Complex<Double>:   exp(iπ) off by  re \((d.real + 1).magnitude), im \(d.imag.magnitude)")

    let r = squareRootOfI(precision: 256)
    print("Complex<BigFloat>: √i = \(r.real.toDouble()) + \(r.imag.toDouble())i, to 256 bits")
}
