import Testing
@testable import Complex

@Suite struct GaussianIntTests {
    typealias G = GaussianInt<Int>
    @Test func initialization() {
        #expect(G(real:3, imag:4) == G(1+2, 2*2))
        #expect(1.i == G(0, 1))
    }
    @Test func hash() {
        #expect(G(3, 4).hashValue != G(4, 3).hashValue)
    }
    @Test func add() {
        #expect(3+4.i == G(3, 4))
        #expect(+G(3, 4) == 3+4.i)
        let z11: G = 1+1.i
        let z23: G = 2+3.i
        #expect(z11 + z23 == 3+4.i)
        #expect(z11 + 2   == 3+1.i)
        #expect(1 + z23   == 3+3.i)
        var z: G = 1+1.i
        z += z
        #expect(z == 2+2.i)
        z += 1
        #expect(z == 3+2.i)
    }
    @Test func sub() {
        #expect(3-4.i == G(3, -4))
        #expect(-G(3, -4) == -3+4.i)
        let z11: G = 1+1.i
        let z23: G = 2+3.i
        #expect(z11 - z23 == -1-2.i)
        #expect(z11 - 2   == -1+1.i)
        #expect(1 - z23   == -1-3.i)
        var z: G = 1+1.i
        z -= z
        #expect(z == 0+0.i)
        z -= 1
        #expect(z == -1+0.i)
    }
    @Test func mul() {
        let z34: G = 3+4.i
        #expect(z34*z34 == -7+24.i)
        #expect(z34*2   == 6+8.i)
        #expect(2*z34   == 6+8.i)
        var z: G = 3+4.i
        z *= z
        #expect(z == -7+24.i)
        z *= 2
        #expect(z == -14+48.i)
    }
    @Test func div() {
        let z34: G = 3+4.i
        let z_724: G = -7+24.i
        #expect(z_724/z34 == z34)
        let z11: G = 1+1.i
        #expect(2/z11 == 1-1.i)
        var z: G = -7+24.i
        z /= z34
        #expect(z == 3+4.i)
        // z /= 0.5
        // #expect(z == 6+8.i)
    }
}
