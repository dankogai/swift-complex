//: [Previous](@previous)
//:## Types
/*:
 
 `Complex` offers two `Struct`s. `GaussianInt` is for  integers and `Complex` is for floating-point numbers.
 
 */

import Complex

let gi =   1 +   1.i    // gi is GaussianInt<Int>
let cd = 1.0 + 1.0.i    // cd is Complex<Double>

/*:
 
 Both are generic so any integral types can be an element of `GaussianInt` and any floating-point types can be an element of `Complex`.

 */

//:### struct GaussianInt<I:GaussianIntElement> : ComplexInt

/*:
 
`GaussianInt` accepts any integral types that conform to `GaussianIntElement` protocol.  All built-in integers already do.
 
 */

let gi8  = Int8(0x7f)                   +                   Int8(-0x80).i
let gi16 = Int16(0x7fff)                +                Int16(-0x8000).i
let gi32 = Int32(0x7fff_ffff)           +            Int32(-0x80000000).i
let gi64 = Int64(0x7fff_ffff_ffff_ffff) + Int64(-0x8000_0000_0000_0000).i

/*:
 `GaussianIntElement` is simply `SignedInteger & Codable` so if your custom integer conforms to that, you can use it with no extension.  For instance, [attaswift/BigInt] does conform so:

 [attaswift/BigInt]: https://github.com/attaswift/BigInt

 ```
 import BigInt
 import Complex
 
 func factorial(_ n: Int) -> BigInt {
   return (1 ... n).map { BigInt($0) }.reduce(BigInt(1), *)
 }
 
 let bgi = factorial(100)+factorial(100).i
 print(bgi)
 ```
 does simply work if you add it to your package dependency.
 
  */

//:### struct Complex<R:ComplexElement> : ComplexFloat

/*:
 
 `GaussianInt` accepts any floating-point types that conform to `ComplexElement` protocol.  `Float` and `Double` already do.
 
 */

let cf32 = Float32.pi + Float32.pi.i  // cd is Complex<Double>
let cf64 = Float64.pi + Float64.pi.i

/*:
 
 `ComplexElement` is `FloatingPoint & FloatingPointMath & Codable`.  Meaning it is a bit trikier to comply.  Unlike built-in `FloatingPoint` and `Codable`, [FloatingPointMath] is externaly defined to ensure necessary math functions exist. But if your type is already `FloatingPoint & Codable`, Complying to `FloatingPointMath` should be relatively easy.  All you need is:
 
 [FloatingPointMath]: https://github.com/dankogai/swift-floatingpointmath
 
 ```
 extension YourFloat: FloatingPointMath {
   init(_:Double) {
     // convert from Double
   }
   var asDouble:Double {
     // convert to Double
   }
 }
 ```
 
 */

//: [Next](@next)
