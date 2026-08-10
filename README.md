[![Swift 6](https://img.shields.io/badge/swift-6-blue.svg)](https://swift.org)
[![MIT LiCENSE](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![CI via GitHub Actions](https://github.com/dankogai/swift-complex/actions/workflows/swift.yml/badge.svg)](https://github.com/dankogai/swift-complex/actions/workflows/swift.yml)

# swift-complex

Complex numbers in Swift and Swift Package Manager.

## Synopsis

````swift
import Complex
let z0 = 1.0 + 1.0.i    // (1.0+1.0.i)
let z1 = 1.0 - 1.0.i    // (1.0-1.0.i)
z0.conj // (1.0-1.0.i)
z0.i    // (-1.0+1.0.i)
z0.norm // 2
z0 + z1 // (2.0+0.0.i)
z0 - z1 // (0.0+2.0.i)
z0 * z1 // (2.0+0.0.i)
z0 / z1 // (0.0+1.0.i)
````

## Description

complex.swift implements all the functionality of [std::complex in c++11], arguably more intuitively. 

[std::complex in c++11]: http://www.cplusplus.com/reference/complex/

### like C++11

* Protocol-Oriented
  * Complex numbers are `Complex<R>` where `R` is the type of `.real` and `.imag` that conforms to `FloatingPoint`.  Math functions become available when `R` also conforms to `RMath`, aka `RealElementaryFunctions`.
  * Gaussian integers are `GaussianInt<I>` where `I` conforms to the `GaussianIntElement` protocol, that is, `SignedInteger`.
  * In addition to basic arithmetic operations like `+`, `-`, `*`, `/` and `abs()`, `Complex<R>` gets `libm` functions like `exp()`, `log()`, `sin()`, `cos()`.

### unlike C++11

* Instead of defining the constant `i`, `Double` and `Complex` have a property `.i` which returns `self * Complex(0,1)` so it does not pollute the identifier `i`, too popularly used for iteration to make it a constant.
* Following functions are provided as computed properties:
  * `z.abs` for `abs(z)`
  * `z.arg` for `arg(z)`
  * `z.norm` for `norm(z)`
  * `z.conj` for `conj(z)`
  * `z.proj` for `proj(z)`
* Construct a complex number via polar notation as:
  * `Complex(abs:magnitude, arg:argument)`

## RMath and CMath

`Complex<R>` itself only requires `R` to be `FloatingPoint`.  When `R` also conforms to `RMath : FloatingPoint` (typealias `RealElementaryFunctions`), `Complex<R>` conforms to `CMath` (typealias `ComplexElementaryFunctions`) and gets the math functions.  `RMath` is deliberately not named `ElementaryFunctions`, which would collide with [apple/swift-numerics] and [dankogai/swift-bignum].  `RMath` is defined in this module to ensure necessary math functions exist.  If your type already has the math functions — like `BigRat` and `BigFloat` of [dankogai/swift-bignum] — they become the witnesses of the protocol requirements, and an empty conformance is all you need:

```swift
import Complex
import BigNum

extension BigRat:   @retroactive RMath {}
extension BigFloat: @retroactive RMath {}
```

Otherwise you provide the math functions yourself, along with `init(_:Double)`, `toDouble()`, and `precision`.  `RMath` deliberately ships no `Double`-round-trip defaults for them: a competing default would make witness resolution ambiguous for types like the above, and would silently lose precision.

### precision and debug

Every math function also comes in a version with `precision` and `debug` flag, as in [dankogai/swift-bignum]:

```swift
BigRat.exp(1, precision: 256)           // e to 256-bit precision
Complex<BigRat>.exp(z)                  // computed natively at BigRat.precision
```

They are *not* protocol requirements.  `precision` and `debug` are used only when the element has the corresponding function — like `BigRat` and `BigFloat` of [dankogai/swift-bignum].  For elements like `Double` they are simply ignored.

`ComplexFloat` also has a settable `precision` which defaults to `128`.  It is handed down to the element as the default precision of the math functions, and likewise ignored for cases like `Element == Double`.

[dankogai/swift-bignum]: https://github.com/dankogai/swift-bignum

### ComplexOperators

`**` — `pow(base, exponent)` as an operator — lives in a separate module so that plain `import Complex` does not add operators to your namespace:

```swift
import ComplexOperators // @_exported imports Complex, too
2.0 ** 3.0              // 8.0
(1.0+1.0.i) ** 2.0      // (0.0+2.0.i)
2.0 ** 3.0 ** 2.0       // 512.0 -- binds tighter than *, associates right
```

### arbitrary precision

This module is tested against [dankogai/swift-bignum] — `Complex<BigRat>`, `Complex<BigFloat>`, and `GaussianInt<BigInt>`.  Since `BigRat` and `BigFloat` natively offer arbitrary-precision math functions, `Complex` math on them is computed natively — not by way of `Double`.  See [Tests/ComplexTests/BigNumSupport.swift] for how to bridge them to `RMath`.  Note swift-bignum is a test-only dependency; the library itself depends on nothing but the standard library.

[Tests/ComplexTests/BigNumSupport.swift]: Tests/ComplexTests/BigNumSupport.swift

## Usage

### build

```sh
$ git clone https://github.com/dankogai/swift-complex.git
$ cd swift-complex # the following assumes your $PWD is here
$ swift build
```

### test

The test suite is written in [Swift Testing], the modern successor of `XCTest`.  Simply:

```sh
$ swift test
```

[Swift Testing]: https://developer.apple.com/documentation/testing/

### REPL

Simply

```sh
$ swift run --repl
```

or

```sh
$ scripts/run-repl.sh
```

and in your repl,

```sh
Welcome to Swift!  Type :help for assistance.
  1> import Complex
  2> Complex.sqrt(1.i)
$R0: Complex.Complex<Double> = {
  real = 0.70710678118654757
  imag = 0.70710678118654757
}
```

### Xcode

Just open the package directory — Xcode natively supports Swift Package Manager:

```sh
$ open ./Package.swift
```

### From Your SwiftPM-Managed Projects

Add the following to the `dependencies` section:

```swift
.package(
  url: "https://github.com/dankogai/swift-complex.git", from: "6.3.0"
)
```

and the following to the `.target` argument:

```swift
.target(
  name: "YourSwiftyPackage",
  dependencies: ["Complex"])
```

Now all you have to do is:

```swift
import Complex
```

in your code.  Enjoy!

### Prerequisite

Swift 6 or better, macOS or Linux to build.

## CAVEAT: Swift Numerics vs. this module

With [apple/swift-numerics] complex number support on swift is [official at last].  You should consider using `ComplexModule` of `Numerics` instead of this.  I am switching to `swift-numerics` myself wherever I can. But there are still a few things that make you want to use this module in spite of that.

* `swift-numerics` relies 100% on swift package manager.  You cannot use it on Swift Playgrounds.
* `ComplexModule` may be too swifty on some respects.
  * `ComplexModule` adopts [point at infinity].  While this is mathematically more correct, technically it may cause unexpected results because real operation on complex numbers is no longer isomorphic to real operations on real numbers.  For instance, `Complex(-1.0, 0.0) / Complex(0.0, 0.0)` is `Complex(+infinity, 0.0)`, not `Complex(-infinity, nan)` like many other platforms. 

[apple/swift-numerics]: https://github.com/apple/swift-numerics
[official at last]: https://swift.org/blog/numerics/
[point at infinity]: https://en.wikipedia.org/wiki/Point_at_infinity
