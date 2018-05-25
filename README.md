[![Swift 4.1](https://img.shields.io/badge/swift-4.1-brightgreen.svg)](https://swift.org)
[![MIT LiCENSE](https://img.shields.io/badge/license-MIT-brightgreen.svg)](LICENSE)
[![build status](https://secure.travis-ci.org/dankogai/swift-complex.png)](http://travis-ci.org/dankogai/swift-complex)

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

```shell
$ git clone https://github.com/dankogai/swift-complex.git
$ cd swift-complex # the following assumes your $PWD is here
$ swift build
```

### REPL

```
$ swift build 
$ swift -I.build/debug -L.build/debug -lComplex

```

````
Welcome to Apple Swift version 4.1 (swiftlang-902.0.48 clang-902.0.39.1). Type :help for assistance.
  1> import Complex
  2> Complex.sqrt(1.i)
$R0: Complex.Complex<Double> = {
  real = 0.70710678118654757
  imag = 0.70710678118654757
}
````

### From Your SwiftPM-Managed Projects

Add the following to the `dependencies` section:

```
.package(
  url: "https://github.com/dankogai/swift-complex.git", from: "4.0.0"
)
```

and the following to the `.target` argument:

```
.target(
  name: "YourSwiftyPackage",
  dependencies: ["Complex"])
```

Now all you have to do is:

```
import Complex
```

in your code.  Enjoy!

# Prerequisite

Swift 4.1 or better, OS X or Linux to build.
