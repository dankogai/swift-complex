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

What you get out of `Complex<R>` depends on what `R` can do.

* `R: FloatingPoint` is all the struct itself asks.  Construction, `+` `-` `*` `/`, `conj`, `norm`, `.i`, `description`, and `Codable` (when `R` is) — everything that is plain arithmetic works for any element.
* `R: RMath` is where the math comes from.  When `R` conforms, `Complex<R>` conforms to `CMath` (typealias `ComplexElementaryFunctions`) and gains `exp`, `log`, `sqrt` and friends, `abs`/`arg` and polar construction, and `toString(_:radix:)`.

`RMath` (typealias `RealElementaryFunctions`; deliberately not named `ElementaryFunctions`, which would collide with [apple/swift-numerics] and friends) asks of the element:

* `init(_:Double)` and `toDouble()` — the two conversions no protocol can guess;
* `static var precision:Int` — the bit width results are computed to;
* the math functions, `exp(_:)` through `atan2(y:x:)`, in plain form *and* with `precision:debug:` flags.  The full forms are requirements, not conveniences, so that a `precision:` you pass dispatches to the element instead of being silently dropped; fixed-precision elements accept and ignore the flags.  (`cbrt`, `expm1`, and `log1p` come with defaults built from the other requirements.)

Out of the box **only `Double` is predefined**, by way of `RMathViaDouble` — a sub-protocol that implements every math requirement by round-tripping through `Double`; adopt it and `toDouble()` is all your type owes.  Every other element is a conformance you, or a sibling package, declare:

* [SwiftNumericsExample](SwiftNumericsExample) fills `Float`'s deliberately vacant slot with [apple/swift-numerics]' `RealModule`.
* [SwiftBigNumExample](SwiftBigNumExample) adopts `BigRat` and `BigFloat` of [dankogai/swift-bignum] with an empty extension each, for arbitrary precision — `Complex<BigFloat>.sqrt(z, precision:256)` really is 256 bits, and `Complex<BigRat>` arithmetic is exact.

`CMath` also has a settable `precision`, defaulting to `128`: the default `precision:` handed down to the element, likewise ignored by elements whose precision is fixed.

[dankogai/swift-bignum]: https://github.com/dankogai/swift-bignum

### ComplexOperators

`**` — `pow(base, exponent)` as an operator — lives in a separate module so that plain `import Complex` does not add operators to your namespace:

```swift
import ComplexOperators // @_exported imports Complex, too
2.0 ** 3.0              // 8.0
(1.0+1.0.i) ** 2.0      // (0.0+2.0.i)
2.0 ** 3.0 ** 2.0       // 512.0 -- binds tighter than *, associates right
```

## Usage

### build

```sh
$ git clone https://github.com/dankogai/swift-complex.git
$ cd swift-complex # the following assumes your $PWD is here
$ swift build
```

### test

The test suites live in the sibling example packages — written in [Swift Testing], the modern successor of `XCTest`:

```sh
$ (cd SwiftNumericsExample && swift test)
```

```sh
$ (cd SwiftBigNumExample && swift test)
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

## Swift Numerics vs. this module

This section used to be a CAVEAT that began "You should consider using `ComplexModule` of `Numerics` instead of this."  No longer.  With [apple/swift-numerics] complex number support on Swift is [official at last] — and as of 6.3 this module is fully resurrected, for the parts officialdom does not cover.

* **The element is open.**  `Complex<R>` asks only `FloatingPoint` of `R`; the math functions arrive when `R` conforms to `RMath`, whose slot is deliberately left for you to fill.  `ComplexModule` requires `RealType: Real`, its own hierarchy.  Here the element's math is whatever you choose — [SwiftNumericsExample](SwiftNumericsExample) fills the slot with swift-numerics' own `RealModule`, [SwiftBigNumExample](SwiftBigNumExample) with [dankogai/swift-bignum], an empty `extension` each.  This module does not compete with swift-numerics; it runs happily *on top of* it.
* **Arbitrary precision, all the way down.**  Every math function comes in a `precision:debug:` form, as in swift-bignum, and `Complex` hands the flag to every element call underneath — `Complex<BigFloat>.sqrt(z, precision:256)` really is 256 bits.  Exact types stay exact: `(1+2i)/(3+4i)` over `Complex<BigRat>` is `(11+2i)/25`, not a rounding of it.  `ComplexModule` has no such channel.
* **No [point at infinity].**  `ComplexModule` adopts it; while mathematically more correct, it may technically cause unexpected results because real operations on complex numbers are no longer isomorphic to real operations on real numbers: `Complex(-1.0, 0.0) / Complex(0.0, 0.0)` is `Complex(+infinity, 0.0)` there, not `Complex(-infinity, nan)` like many other platforms.  This module keeps the componentwise semantics of C++'s `std::complex` and friends.
* **Gaussian integers.**  `GaussianInt<I>` for any `SignedInteger`, `BigInt` included.  swift-numerics has no counterpart.
* **Ergonomics.**  `1.0 + 2.0.i` literals; `abs`, `arg`, `magnitude` and `argument` that are settable, not just readable; polar construction; `toString(_:radix:)` down to hexfloat; `**` via `import ComplexOperators`, opt-in so it never sneaks into your namespace.
* **Nothing to fetch.**  The library depends on nothing but the standard library.  The examples that do depend on things are packages of their own, so `swift build` here fetches exactly nothing.

[apple/swift-numerics]: https://github.com/apple/swift-numerics
[official at last]: https://swift.org/blog/numerics/
[point at infinity]: https://en.wikipedia.org/wiki/Point_at_infinity
