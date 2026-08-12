import Testing
import Foundation
import Complex
import BigNum
@testable import SwiftBigNumExample

///
/// `Complex<BigRat>` and `Complex<BigFloat>`, which is the point of this
/// package.  The conformances are two empty extensions in
/// BigNumConformance.swift; what is worth checking from this side is that the
/// witnesses really are BigNum's -- native precision, honored precision: flags
/// -- and that the whole CMath layer holds together on top of them.
///
/// BigNum memoizes constants like E and LN2 in unsynchronized static vars,
/// which data-race under parallel test execution.  Everything runs serially.
///
@Suite(.serialized) struct BigNumSuites {
    @Suite struct BigRatComplexTests {
        typealias C = Complex<BigRat>
        @Test func arithmetic() {
            let z11: C = C(1, 1)
            let z23: C = C(2, 3)
            #expect(z11 + z23 == C(3, 4))
            #expect(z11 - z23 == C(-1, -2))
            let z34: C = C(3, 4)
            #expect(z34 * z34 == C(-7, 24))
            // rational arithmetic is exact, so division roundtrips exactly
            #expect(C(-7, 24) / z34 == z34)
            #expect(z34 / BigRat(1, 2) == C(6, 8))
            #expect(exactComplexDivision().roundTrips)
        }
        @Test func math() {
            #expect(C.sqrt(+4) == C(2, 0))
            #expect(C.sqrt(-4) == C(0, 2))
            #expect(C.exp(0) == C(1, 0))
            #expect(C.log(1) == C(0, 0))
            #expect(C(3, 4).abs == 5)
            #expect(BigRat(1).i == C(0, 1))
        }
    }

    @Suite struct BigFloatComplexTests {
        typealias C = Complex<BigFloat>
        @Test func arithmetic() {
            let z34: C = C(3, 4)
            #expect(z34 * z34 == C(-7, 24))
            #expect(C(-7, 24) / z34 == z34)
        }
        @Test func math() {
            #expect(C.sqrt(+4) == C(2, 0))
            #expect(C.sqrt(-4) == C(0, 2))
            #expect(C(3, 4).abs == 5)
        }
        @Test func eulerAt128Bits() {
            let (bf, d) = eulerIdentity()
            // both components within 1e-37 -- far beyond Double's reach
            let eps = BigFloat(sign:.plus, exponent:-123, significand:1)
            #expect((bf.real + 1).magnitude < eps)
            #expect(bf.imag.magnitude < eps)
            #expect(d.imag.magnitude > 1e-17)   // Double cannot do better
        }
    }

    @Suite struct PrecisionDispatchTests {
        /// generic code constrained to RMath dispatches to BigNum's natives
        /// at the element's own precision, not through Double
        @Test func nativeDispatch() {
            func e<T:RMath>(_ one:T)->T { return T.exp(one) }
            #expect(e(BigRat(1)) != BigRat(Foundation.exp(1.0)))
            #expect(e(BigFloat(1)) != BigFloat(Foundation.exp(1.0)))
            #expect(e(1.0) == Foundation.exp(1.0))  // Double keeps Foundation
        }
        /// the precision: flag is honored, generically and through Complex
        @Test func precisionFlag() {
            func gsqrt<T:RMath>(_ x:T, _ px:Int)->T { return T.sqrt(x, precision:px, debug:false) }
            let lo = gsqrt(BigFloat(2), 128)
            let hi = gsqrt(BigFloat(2), 256)
            #expect(lo != hi)
            #expect((hi - lo).magnitude < BigFloat(sign:.plus, exponent:-120, significand:1))
            #expect(gsqrt(2.0, 256) == Foundation.sqrt(2.0))    // fixed for Double
            let clo = squareRootOfI(precision:128).real
            let chi = squareRootOfI(precision:256).real
            #expect(clo != chi)
            #expect((chi - clo).magnitude < BigFloat(sign:.plus, exponent:-120, significand:1))
        }
    }

    @Suite struct BigIntGaussianTests {
        typealias G = GaussianInt<BigInt>
        @Test func arithmetic() {
            let z34: G = G(3, 4)
            #expect(z34 * z34 == G(-7, 24))
            #expect(G(-7, 24) / z34 == z34)
            #expect(BigInt(1).i == G(0, 1))
        }
        @Test func bigValues() {
            // exercise magnitudes beyond Int64
            let big = BigInt(1) << 100
            let z: G = G(big, big)
            #expect(z * z == G(0, big * big * 2))
            #expect((z * z) / z == z)
        }
    }
}
