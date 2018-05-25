import XCTest

import ComplexTests

var tests = [XCTestCaseEntry]()
tests += ComplexTests.allTests()
XCTMain(tests)
