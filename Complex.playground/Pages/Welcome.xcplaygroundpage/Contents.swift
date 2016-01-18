//: Playground - noun: a place where people can play
let z0 = 1.0 + 1.0.i // (1.0+0.0.i)
let z1 = 1.0 - 1.0.i // (1.0-0.0.i)
z0.conj == z1        // true
z0 * z1              // (2.0+0.0.i)
z0 * z1 == z0 + z1   // true
z0 * z1 == 2         // true
//: [Next](@next)
