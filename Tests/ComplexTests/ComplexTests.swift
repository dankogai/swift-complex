import Testing
import Foundation
@testable import Complex

@Suite struct ComplexTests {
    typealias C = Complex<Double>
    @Test func initialization() {
        #expect(C(real:3, imag:4) == C(1.0+2.0, 2.0*2.0))
        #expect(1.0.i == C(0.0, 1.0))
    }
    @Test func hash() {
        #expect(C(3.0, 4.0).hashValue != C(4.0, 3.0).hashValue)
    }
    @Test func add() {
        #expect(3.0+4.0.i == C(3.0, 4.0))
        #expect(+C(3.0, 4.0) == 3.0+4.0.i)
        let z11: C = 1.0+1.0.i
        let z23: C = 2.0+3.0.i
        #expect(z11 + z23 == 3.0+4.0.i)
        #expect(z11 + 2.0 == 3.0+1.0.i)
        #expect(1.0 + z23 == 3.0+3.0.i)
        var z: C = 1.0+1.0.i
        z += z
        #expect(z == 2.0+2.0.i)
        z += 1.0
        #expect(z == 3.0+2.0.i)
    }
    @Test func sub() {
        #expect(3.0-4.0.i == C(3.0, -4.0))
        #expect(-C(3.0, -4.0) == -3.0+4.0.i)
        let z11: C = 1.0+1.0.i
        let z23: C = 2.0+3.0.i
        #expect(z11 - z23 == -1.0-2.0.i)
        #expect(z11 - 2.0 == -1.0+1.0.i)
        #expect(1.0 - z23 == -1.0-3.0.i)
        var z: C = 1.0+1.0.i
        z -= z
        #expect(z == 0.0+0.0.i)
        z -= 1.0
        #expect(z == -1.0+0.0.i)
    }
    @Test func mul() {
        let z34: C = 3.0+4.0.i
        #expect(z34*z34 == -7.0+24.0.i)
        #expect(z34*2.0 == 6.0+8.0.i)
        #expect(2.0*z34 == 6.0+8.0.i)
        var z: C = 3.0+4.0.i
        z *= z
        #expect(z == -7.0+24.0.i)
        z *= 2.0
        #expect(z == -14.0+48.0.i)
    }
    @Test func div() {
        let z34: C = 3.0+4.0.i
        #expect((-7.0+24.0.i)/z34 == z34)
        #expect(z34/0.5 == 6.0+8.0.i)
        let z11: C = 1.0+1.0.i
        #expect(2.0/z11 == 1.0-1.0.i)
        var z: C = -7.0+24.0.i
        z /= z34
        #expect(z == 3.0+4.0.i)
        z /= 0.5
        #expect(z == 6.0+8.0.i)
    }
    @Test func math() {
        typealias D = Double
        #expect(C.sqrt(+4) == 2.0+0.0.i)
        #expect(C.sqrt(-4) == 0.0+2.0.i)
        #expect(C.exp(D.pi.i).real == -1.0)
        #expect(C.log(-1) == D.pi.i)
        #expect(C.cos(0) == 1.0+0.0.i)
        #expect(C.sin(D.pi/2) == 1.0+0.0.i)
        let (spi_2, cpi_2) = (C.sin(D.pi/2), C.cos(D.pi/2))
        #expect(C.tan(D.pi/2) == spi_2/cpi_2)
        #expect(C.acos(1.0) == 0.0+0.0.i)
        #expect(C.asin(1.0) == D.pi/2+0.0.i)
        #expect(C.atan(1.0) == D.pi/4+0.0.i)
        #expect(C.cosh(0.0) == 1.0+0.0.i)
        #expect(C.sinh(0.0) == 0.0+0.0.i)
        #expect(C.tanh(0.0) == 0.0+0.0.i)
        #expect(C.acosh(0.0) == D.pi.i/2)
        #expect(C.asinh(0.0) == 0.0+0.0.i)
        #expect(C.atanh(D.pi/4).imag == 0.0)
    }
    @Test func abs() {
        let z: C = 3.0+4.0.i
        #expect(z.abs == 5.0)
    }
    @Test func elementaryFunctions() {
        // Complex itself conforms to ElementaryFunctions,
        // so it works in generic code constrained to it
        func f<T:ElementaryFunctions>(_ x:T)->T { return T.exp(x) }
        #expect(f(C(0.0, Double.pi)).real == -1.0)
        #expect(f(1.0) == Foundation.exp(1.0))
        // CMath == ComplexElementaryFunctions constrains to complex types
        func g<T:CMath>(_ z:T)->T { return T.sqrt(z) }
        #expect(g(C(-4.0, 0.0)) == C(0.0, 2.0))
        // cbrt and exp2, added for the conformance
        #expect(Swift.abs(C.exp2(C(3.0, 0.0)).real - 8.0) < 1e-14)
        #expect(Swift.abs(C.cbrt(C(8.0, 0.0)).real - 2.0) < 1e-14)
        #expect(C.cbrt(C(8.0, 0.0)).imag.isZero)
    }
}

@Suite struct CodableTests {
    let decoder  = JSONDecoder()
    let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        return encoder
    }()
    let cx: Complex<Double>   = 3.0 + 4.0.i
    let gi: GaussianInt<Int>  = 3   + 4.i
    let str = "{\"imag\":4,\"real\":3}"
    @Test func encodeComplex() throws {
        #expect(String(data:try encoder.encode(cx), encoding: .utf8) == str)
    }
    @Test func encodeGaussianInt() throws {
        #expect(String(data:try encoder.encode(gi), encoding: .utf8) == str)
    }
    @Test func decodeComplex() throws {
        #expect(try decoder.decode(Complex<Double>.self, from:str.data(using:.utf8)!) == cx)
    }
    @Test func decodeGaussianInt() throws {
        #expect(try decoder.decode(GaussianInt<Int>.self, from:str.data(using:.utf8)!) == gi)
    }
}
