//: [Previous](@previous)
//: ## CMath
//:
//: Following math functions are provided as static functions.
//:
//: * Complex.acos
//: * Complex.acosh
//: * Complex.asin
//: * Complex.asinh
//: * Complex.atan
//: * Complex.atanh
//: * Complex.cos
//: * Complex.cosh
//: * Complex.exp
//: * Complex.log
//: * Complex.log10
//: * Complex.sin
//: * Complex.sinh
//: * Complex.sqrt
//: * Complex.tan
//: * Complex.tanh
//: * Complex.atan2
//: * Complex.hypot
//: * Complex.pow
//:
//: All accept real or complex numbers and return complex numbers.

import Complex

Complex.sqrt(-1.0)          // (0.0+1.0.i)
Complex.sqrt(-1.0.i)        // (0.707106781186548-0.707106781186548.i)
Complex.exp(Double.pi.i)    // (-1.0+1.22464679914735e-16.i)
Complex.log(-1.0)           // (0.0+3.14159265358979.i)

//: [Next](@next)
