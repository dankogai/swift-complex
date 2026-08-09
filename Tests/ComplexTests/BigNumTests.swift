import Testing
import Foundation
import BigNum
@testable import Complex

@Suite struct BigRatComplexTests {
    typealias C = Complex<BigRat>
    @Test func initialization() {
        #expect(C(real:3, imag:4) == C(1+2, 2*2))
        #expect(BigRat(1).i == C(0, 1))
    }
    @Test func hash() {
        #expect(C(3, 4).hashValue != C(4, 3).hashValue)
    }
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
        var z: C = C(3, 4)
        z *= z
        #expect(z == C(-7, 24))
        z /= z34
        #expect(z == z34)
    }
    @Test func math() {
        #expect(C.sqrt(+4) == C(2, 0))
        #expect(C.sqrt(-4) == C(0, 2))
        #expect(C.exp(0) == C(1, 0))
        #expect(C.log(1) == C(0, 0))
        #expect(C.cos(0) == C(1, 0))
        #expect(C.sinh(0) == C(0, 0))
        #expect(C(3, 4).abs == 5)
    }
}

@Suite struct BigFloatComplexTests {
    typealias C = Complex<BigFloat>
    @Test func initialization() {
        #expect(C(real:3, imag:4) == C(1+2, 2*2))
        #expect(BigFloat(1).i == C(0, 1))
    }
    @Test func hash() {
        #expect(C(3, 4).hashValue != C(4, 3).hashValue)
    }
    @Test func arithmetic() {
        let z11: C = C(1, 1)
        let z23: C = C(2, 3)
        #expect(z11 + z23 == C(3, 4))
        #expect(z11 - z23 == C(-1, -2))
        let z34: C = C(3, 4)
        #expect(z34 * z34 == C(-7, 24))
        #expect(C(-7, 24) / z34 == z34)
        #expect(z34 / BigFloat(0.5) == C(6, 8))
        var z: C = C(3, 4)
        z *= z
        #expect(z == C(-7, 24))
        z /= z34
        #expect(z == z34)
    }
    @Test func math() {
        #expect(C.sqrt(+4) == C(2, 0))
        #expect(C.sqrt(-4) == C(0, 2))
        #expect(C.exp(0) == C(1, 0))
        #expect(C.log(1) == C(0, 0))
        #expect(C.cos(0) == C(1, 0))
        #expect(C.sinh(0) == C(0, 0))
        #expect(C(3, 4).abs == 5)
    }
}

@Suite struct PrecisionDispatchTests {
    // the plain forms are protocol requirements, so generic code dispatches
    // to BigNum's native implementations at the element's own precision
    func e<T:ComplexFloatElement>(_ one:T)->T { return T.exp(one) }
    @Test func nativeDispatch() {
        // a Double roundtrip would return exactly BigRat(Foundation.exp(1.0));
        // the native 128-bit result must be more precise than that
        #expect(e(BigRat(1)) != BigRat(Foundation.exp(1.0)))
        #expect(e(BigFloat(1)) != BigFloat(Foundation.exp(1.0)))
        // Double itself keeps using Foundation directly
        #expect(e(1.0) == Foundation.exp(1.0))
    }
    @Test func precisionFlag() {
        // precision and debug are used when the element has the corresponding
        // function, as BigRat and BigFloat do
        #expect(BigRat.exp(BigRat(1), precision:24, debug:false) != BigRat.exp(BigRat(1), precision:128, debug:false))
        #expect(BigFloat.exp(BigFloat(1), precision:24, debug:false) != BigFloat.exp(BigFloat(1), precision:128, debug:false))
    }
    @Test func complexReachesNative() {
        // the native implementations are reached through Complex as well
        typealias C = Complex<BigRat>
        #expect(C.precision == 128)
        let e1 = C.exp(C(1, 0)).real
        #expect(e1 != BigRat(Foundation.exp(1.0)))
        #expect(e1 == BigRat.exp(BigRat(1), precision:BigRat.precision, debug:false))
    }
}

@Suite struct BigIntGaussianTests {
    typealias G = GaussianInt<BigInt>
    @Test func initialization() {
        #expect(G(real:3, imag:4) == G(1+2, 2*2))
        #expect(BigInt(1).i == G(0, 1))
    }
    @Test func hash() {
        #expect(G(3, 4).hashValue != G(4, 3).hashValue)
    }
    @Test func arithmetic() {
        let z11: G = G(1, 1)
        let z23: G = G(2, 3)
        #expect(z11 + z23 == G(3, 4))
        #expect(z11 - z23 == G(-1, -2))
        let z34: G = G(3, 4)
        #expect(z34 * z34 == G(-7, 24))
        #expect(G(-7, 24) / z34 == z34)
        var z: G = G(3, 4)
        z *= z
        #expect(z == G(-7, 24))
        z /= z34
        #expect(z == z34)
    }
    @Test func bigValues() {
        // exercise magnitudes beyond Int64
        let big = BigInt(1) << 100
        let z: G = G(big, big)
        #expect(z + z == G(big * 2, big * 2))
        #expect(z * z == G(0, big * big * 2))
        #expect((z * z) / z == z)
    }
}
