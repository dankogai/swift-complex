swift-complex
=============

Complex numbers in Swift

Usage:
------

### In your project:

Just add complex.swift to it

### via command line

````shell
xcrun swift main.swift complex.swift
````

Synopsis:
````swift
let z0 = 1 + 1.i
let z1 = 1 - 1.i
println(z0 * z1)            // (2.0+0.0.i)
println(z0 * z1 == z0 + z1) // true
println(z0 * z1 == 2)       // true
````

Description
-----------

complex.swift implements all the functionality of [complex in c++11], arguably more intuitively. 


[complex in c++11]: http://www.cplusplus.com/reference/complex/

### Difference from C++11

* Property functions are provided as properties:
  * `real`
  * `imag`
  * `norm`
  * `conj`
  * `proj`
* Construct a complex number via polar notation as:
  * `Complex(abs:magnitude, arg:argument)`
* In addition to `pow()`, it comes with the `**` operator
