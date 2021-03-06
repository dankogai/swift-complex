import XCTest
@testable import Complex

final class ComplexTests: XCTestCase {
    func testInit() {
        XCTAssertEqual(Complex(real:3, imag:4),Complex(1.0+2.0, 2.0*2.0))
        XCTAssertEqual(1.0.i, Complex(0.0, 1.0))
    }
    func testHash() {
        XCTAssertNotEqual(Complex(3.0, 4.0).hashValue, Complex(4.0, 3.0).hashValue)
    }
    func testAdd() {
        XCTAssertEqual(3.0+4.0.i, Complex(3.0, 4.0))
        XCTAssertEqual(+Complex(3.0, 4.0), 3.0+4.0.i)
        XCTAssertEqual((1.0+1.0.i) + (2.0+3.0.i), 3.0+4.0.i)
        XCTAssertEqual((1.0+1.0.i) + 2.0,       3.0+1.0.i)
        XCTAssertEqual(1.0       + (2.0+3.0.i), 3.0+3.0.i)
        var z = 1.0+1.0.i
        z += z
        XCTAssertEqual(z, 2.0+2.0.i)
        z += 1.0
        XCTAssertEqual(z, 3.0+2.0.i)
    }
    func testSub() {
        XCTAssertEqual(3.0-4.0.i, Complex(3.0, -4.0))
        XCTAssertEqual(-Complex(3.0, -4.0), -3.0+4.0.i)
        XCTAssertEqual((1.0+1.0.i) - (2.0+3.0.i), -1.0-2.0.i)
        XCTAssertEqual((1.0+1.0.i) - 2.0,         -1.0+1.0.i)
        XCTAssertEqual(1.0         - (2.0+3.0.i), -1.0-3.0.i)
        var z = 1.0+1.0.i
        z -= z
        XCTAssertEqual(z, 0.0+0.0.i)
        z -= 1.0
        XCTAssertEqual(z, -1.0+0.0.i)
    }
    func testMul() {
        XCTAssertEqual((3.0+4.0.i)*(3.0+4.0.i), -7.0+24.0.i)
        XCTAssertEqual((3.0+4.0.i)*2.0,       6.0+8.0.i)
        XCTAssertEqual(2.0*(3.0+4.0.i),       6.0+8.0.i)
        var z = 3.0+4.0.i
        z *= z
        XCTAssertEqual(z, -7.0+24.0.i)
        z *= 2.0
        XCTAssertEqual(z, -14.0+48.0.i)
    }
    func testDiv() {
        XCTAssertEqual((-7.0+24.0.i)/(3.0+4.0.i), 3.0+4.0.i)
        XCTAssertEqual((3.0+4.0.i)/0.5,       6.0+8.0.i)
        XCTAssertEqual(2.0/(1.0+1.0.i),       1.0-1.0.i)
        var z = -7.0+24.0.i
        z /= 3.0+4.0.i
        XCTAssertEqual(z, 3.0+4.0.i)
        z /= 0.5
        XCTAssertEqual(z, 6.0+8.0.i)
    }
    func testMath() {
        typealias C = Complex
        typealias D = Double
        XCTAssertEqual(C.sqrt(+4), 2.0+0.0.i)
        XCTAssertEqual(C.sqrt(-4), 0.0+2.0.i)
        XCTAssertEqual(C.exp(D.pi.i).real, -1.0)
        XCTAssertEqual(C.log(-1), D.pi.i)
        XCTAssertEqual(C.cos(0), 1.0+0.0.i)
        XCTAssertEqual(C.sin(D.pi/2), 1.0+0.0.i)
        let (spi_2, cpi_2) = (C.sin(D.pi/2), C.cos(D.pi/2))
        XCTAssertEqual(C.tan(D.pi/2), spi_2/cpi_2)
        XCTAssertEqual(C.acos(1.0), 0.0+0.0.i)
        XCTAssertEqual(C.asin(1.0), D.pi/2+0.0.i)
        XCTAssertEqual(C.atan(1.0), D.pi/4+0.0.i)
        XCTAssertEqual(C.cosh(0.0), 1.0+0.0.i)
        XCTAssertEqual(C.sinh(0.0), 0.0+0.0.i)
        XCTAssertEqual(C.tanh(0.0), 0.0+0.0.i)
        XCTAssertEqual(C.acosh(0.0), D.pi.i/2)
        XCTAssertEqual(C.asinh(0.0), 0.0+0.0.i)
        XCTAssertEqual(C.atanh(D.pi/4).imag, 0.0)
    }
    func testAbs() {
        XCTAssertEqual((3.0+4.0.i).abs, 5.0)
    }
    static var allTests = [
        ("testInit", testInit),
        ("testHash", testHash),
        ("testAdd",  testAdd),
        ("testSub",  testSub),
        ("testMul",  testMul),
        ("testDiv",  testDiv),
        ("testMath", testMath)
    ]
}

#if !os(Linux)
import Foundation
#endif

final class CodableTests: XCTestCase {
    let decoder  = JSONDecoder()
    let encoder  = JSONEncoder()
    let cx   = 3.0 + 4.0.i
    let gi   = 3   + 4.i
    let str = "{\"imag\":4,\"real\":3}"
    func testEC() { XCTAssertEqual(String(data:try! encoder.encode(cx), encoding: .utf8), str) }
    func testEG() { XCTAssertEqual(String(data:try! encoder.encode(gi), encoding: .utf8), str) }
    func testDC() { XCTAssertEqual(try! decoder.decode(Complex.self, from:str.data(using:.utf8)!), cx) }
    func testDG() { XCTAssertEqual(try! decoder.decode(GaussianInt.self, from:str.data(using:.utf8)!), gi) }
}
