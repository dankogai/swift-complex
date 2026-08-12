import Complex

// Complex<Double> is the one element type the library itself equips with
// math -- Double is the sole RMathViaDouble.  Float's slot is deliberately
// vacant; see SwiftNumericsExample for filling it with swift-numerics.
let z0 = 3.0 + 4.0.i
print(z0)                               // (3.0+4.0.i)
print(z0.abs)                           // 5.0
print(z0.conj)                          // (3.0-4.0.i)
print(z0.toString(.polar))              // (abs:5.0, arg:0.9272952180016122)
print(z0.toString(.cartesian, radix:16))// (real:0x1.8p+1, imag:0x1p+2)
print(Complex.sqrt(-4.0))               // (0.0+2.0.i)
print(Complex.exp(Double.pi.i))         // (-1.0+1.2246467991473532e-16.i)
