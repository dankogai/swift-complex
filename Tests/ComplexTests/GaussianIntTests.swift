import XCTest
@testable import Complex

final class GaussianIntTests: XCTestCase {
    func testInit() {
        XCTAssertEqual(GaussianInt(real:3, imag:4),GaussianInt(1+2, 2*2))
        XCTAssertEqual(1.i, GaussianInt(0, 1))
    }
    func testHash() {
        XCTAssertNotEqual(GaussianInt(3, 4).hashValue, GaussianInt(4, 3).hashValue)
    }
    func testAdd() {
        XCTAssertEqual(3+4.i, GaussianInt(3, 4))
        XCTAssertEqual(+GaussianInt(3, 4), 3+4.i)
        XCTAssertEqual((1+1.i) + (2+3.i), 3+4.i)
        XCTAssertEqual((1+1.i) + 2,       3+1.i)
        XCTAssertEqual(1       + (2+3.i), 3+3.i)
        var z = 1+1.i
        z += z
        XCTAssertEqual(z, 2+2.i)
        z += 1
        XCTAssertEqual(z, 3+2.i)
    }
    func testSub() {
        XCTAssertEqual(3-4.i, GaussianInt(3, -4))
        XCTAssertEqual(-GaussianInt(3, -4), -3+4.i)
        XCTAssertEqual((1+1.i) - (2+3.i), -1-2.i)
        XCTAssertEqual((1+1.i) - 2,         -1+1.i)
        XCTAssertEqual(1         - (2+3.i), -1-3.i)
        var z = 1+1.i
        z -= z
        XCTAssertEqual(z, 0+0.i)
        z -= 1
        XCTAssertEqual(z, -1+0.i)
    }
    func testMul() {
        XCTAssertEqual((3+4.i)*(3+4.i), -7+24.i)
        XCTAssertEqual((3+4.i)*2,       6+8.i)
        XCTAssertEqual(2*(3+4.i),       6+8.i)
        var z = 3+4.i
        z *= z
        XCTAssertEqual(z, -7+24.i)
        z *= 2
        XCTAssertEqual(z, -14+48.i)
    }
    func testDiv() {
        XCTAssertEqual((-7+24.i)/(3+4.i), 3+4.i)
        XCTAssertEqual((3+4.i)/0.5,       6+8.i)
        XCTAssertEqual(2/(1+1.i),       1-1.i)
        var z = -7+24.i
        z /= 3+4.i
        XCTAssertEqual(z, 3+4.i)
        // z /= 0.5
        // XCTAssertEqual(z, 6+8.i)
    }
    static var allTests = [
        ("testInit", testInit),
        ("testHash", testHash),
        ("testAdd", testAdd),
        ("testSub",  testSub),
        ("testMul",  testMul),
        ("testDiv",  testDiv),
    ]
}
