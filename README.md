[![Swift 5](https://img.shields.io/badge/swift-5-blue.svg)](https://swift.org)
[![MIT LiCENSE](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![build status](https://secure.travis-ci.org/dankogai/swift-complex.png)](http://travis-ci.org/dankogai/swift-complex)

# CAVEAT: Swift Numerics vs. this module

With [apple/swift-numerics] complex number support on swift is [official at last].  You should consider using `ComplexModule` of `Numerics` instead of this.  I am switching to `swift-numerics` myself whereever I can. But there are still a few things that make you want to use this module in spite of that.

* `swift-numerics` relies 100% on swift package manager.  You cannot use it on Swift Playgrounds.
* As of version 0.0.6 `ComplexModule` of `swift-numerics` still does not conform to `ElementaryFunctions`.  You are on your own if you need functions like   So you are at your own if you need functions like:
`exp`, `expMinusOne`,
`log`, `log(onePlus:)`,
`cos`, `sin`, `tan`,
`acos`, `asin`, `atan`,
`cosh`, `sinh`, `tanh`,
`acosh`, `asinh`, `atanh`,
`pow`, `sqrt`, and `root`

  * https://github.com/apple/swift-numerics/issues/2
* `ComplexModule` may be too swifty on some respects.
  * `ComplexModule` adopts [point at infinity].  While this is mathmatically more correct, technically it may cause unexpected results because real operation on complex numbers is no longer isomorphic to real operations on real numbers.  For instance, `Complex(-1.0, 0.0) / Complex(0.0, 0.0)` is `Complex(+infinity, 0.0)`, not `Complex(-infinity, nan)` like many other platforms. 

[apple/swift-numerics]: https://github.com/apple/swift-numerics
[official at last]: https://swift.org/blog/numerics/
[point at infinity]: https://en.wikipedia.org/wiki/Point_at_infinity

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

* Protocol-Oriented  * Complex numbers are `Complex<R>` where `R` is a type of `.real` and `.imag` that conforms to the `ComplexElement` protocol or `GaussianIntElement` protocol.
  * In addition to basic arithmetic operations like `+`, `-`, `*`, `/` and `abs()`, `Complex<T:RealType>` gets `libm` functions like `exp()`, `log()`, `sin()`, `cos()`.

### unlike C++11

* Instead of defining the constant `i`, `Double` and `Complex` have a property `.i` which returns `self * Complex(0,1)` so it does not pollute the identifier `i`, too popularly used for iteration to make it a constant.
* Following functions are provided as compouted properties:
  * `z.abs` for `abs(z)`
  * `z.arg` for `arg(z)`
  * `z.norm` for `norm(z)`
  * `z.conj` for `conj(z)`
  * `z.proj` for `proj(z)`
* Construct a complex number via polar notation as:
  * `Complex(abs:magnitude, arg:argument)`

## Usage

### build

```sh
$ git clone https://github.com/dankogai/swift-complex.git
$ cd swift-complex # the following assumes your $PWD is here
$ swift build
```

### REPL

Simply

```sh
$ swift run --repl
```

or

```sh
$ scripts/run-repl.sh
```

or

```sh
$ swift build && swift -I.build/debug -L.build/debug -lComplex

```

and in your repl,

```sh
Welcome to Apple Swift version 4.2 (swiftlang-1000.11.37.1 clang-1000.11.45.1). Type :help for assistance.
  1> import Complex
  2> Complex.sqrt(1.i)
$R0: Complex.Complex<Double> = {
  real = 0.70710678118654757
  imag = 0.70710678118654757
}
````

### Xcode

Xcode project is deliberately excluded from the repository because it should be generated via `swift package generate-xcodeproj` . For convenience, you can

```
$ scripts/prep-xcode
```

And the Workspace opens up for you with Playground on top.  The playground is written as a manual.

### iOS and Swift Playground

Unfortunately Swift Package Manager does not support iOS.  To make matters worse Swift Playgrounds does not support modules.

Fortunately Playgrounds allow you to include swift source codes under `Sources` directory.  Just run:

```shell
$ scripts/ios-prep.sh
```

and you are all set.  `iOS/Complex.playground` now runs on Xcode and Playgrounds on macOS, and Playgrounds on iOS (Well, it is supposed to iPadOS but it is still labeled iOS).

![](img/playground.png)

### From Your SwiftPM-Managed Projects

Add the following to the `dependencies` section:

```swift
.package(
  url: "https://github.com/dankogai/swift-complex.git", from: "5.0.0"
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

Swift 5 or better, OS X or Linux to build.
