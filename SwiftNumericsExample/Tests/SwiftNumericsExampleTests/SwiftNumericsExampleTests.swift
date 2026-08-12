import Testing
import Complex
import RealModule
@testable import SwiftNumericsExample

///
/// `Complex<Float>` with RealModule as the math, which is the point of this
/// package.  The conformance is in NumericsConformance.swift; these tests check
/// that the witnesses really are swift-numerics' and that the RMath surface --
/// plain, precision:debug:, and the CMath layer above -- all hold together.
///
@Suite struct ConformanceTests {
    typealias C = Complex<Float>

    /// generic code constrained to RMath dispatches to RealModule's Float
    @Test func genericDispatch() {
        func f<T:RMath>(_ x:T)->T { return T.exp(x) }
        #expect(f(Float(1)) == Float.exp(1))
    }

    /// the three requirements RealModule spells differently fall back to
    /// RMath's defaults, built from RealModule's own functions
    @Test func spelledDifferently() {
        #expect(Float.cbrt(8) == 2)
        #expect(Float.expm1(0) == 0)
        #expect(Float.log1p(0) == 0)
    }

    /// the precision arguments are accepted and ignored
    @Test func precisionIsFixed() {
        #expect(Float.precision == Float.significandBitCount)
        #expect(Float.exp(1, precision:512, debug:false) == Float.exp(1))
    }

    /// Complex<Float> math, end to end through the CMath layer
    @Test func complexFloat() {
        #expect(squareRootOfMinusFour() == C(0, 2))
        let e = eulerIdentity()
        #expect(e.real == -1.0)
        #expect(e.imag.magnitude < 1e-6)
        #expect(C(3, 4).abs == 5)
    }

    /// toString is generic over the element, so Float renders everywhere
    @Test func rendering() {
        let z = C(3, 4)
        #expect("\(z)" == "(3.0+4.0.i)")
        #expect(z.toString(.tuple) == "(3.0, 4.0)")
        #expect(C(1.5, -2).toString(.cartesian, radix:16) == "(real:0x1.8p+0, imag:-0x1p+1)")
    }
}
