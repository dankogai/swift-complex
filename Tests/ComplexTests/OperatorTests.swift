import Testing
import Foundation
@testable import Complex
import ComplexOperators

@Suite struct ComplexOperatorsTests {
    typealias C = Complex<Double>
    @Test func realPower() {
        #expect(2.0 ** 3.0 == 8.0)
        // ** binds tighter than *
        #expect(2.0 * 2.0 ** 3.0 == 16.0)
        // and associates to the right: 2 ** (3 ** 2)
        #expect(2.0 ** 3.0 ** 2.0 == 512.0)
    }
    @Test func complexPower() {
        let z = (1.0+1.0.i) ** 2.0          // (1+i)² == 2i
        #expect(Swift.abs(z.real) < 1e-15)
        #expect(Swift.abs(z.imag - 2.0) < 1e-15)
        let w = 2.0 ** (2.0+0.0.i)          // Element ** Complex
        #expect(Swift.abs(w.real - 4.0) < 1e-14)
        let v = (1.0+1.0.i) ** (1.0+1.0.i)  // Complex ** Complex vs pow
        #expect(v == C.pow(1.0+1.0.i, 1.0+1.0.i))
    }
}
