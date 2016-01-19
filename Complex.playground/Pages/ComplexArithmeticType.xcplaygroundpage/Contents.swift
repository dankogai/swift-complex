//: [Previous](@previous)
/*:
## Complex<T:ArithmeticType>

`Complex<T:ArithmeticType>` supports basic operations like `+`, `-`, `*`, and `/`.  It also adds basic properties like `.conj` and `.norm`

Note `.abs` and `.proj` are missing since they may return noninteger values.

*/
let z0 = 1 + 1.i    // (1.0+1.0.i)
let z1 = 1 - 1.i    // (1.0-1.0.i)
z0.conj // (1.0-1.0.i)
z0.i    // (-1.0+1.0.i)
z0.norm // 2
z0 + z1 // (2.0+0.0.i)
z0 - z1 // (0.0+2.0.i)
z0 * z1 // (2.0+0.0.i)
z0 / z1 // (0.0+1.0.i)
//: [Next](@next)
