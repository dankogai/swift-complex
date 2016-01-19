//: [Previous](@previous)
/*:
## Complex<T:ModuloType>

`ModuloType` adds `%` to `ArithmeticType`.

This type of complex number is also known as [Gaussian integer].
`GaussianInt` is already `typealias` thereof.

[Gaussian Integer]: https://en.wikipedia.org/wiki/Gaussian_integer

*/

let zr = 5-2.i, zl = -1+2.i
zr / zl
zr % zl

/*:

### Example: Gaussian Integer

The following example adds `.isGaussianInt` method to `Complex<T:ModuloType>`.


*/

extension ModuloType {
    // class Prime is defined at ../Sources/prime.swift
    var isPrime:Bool { return Prime.isPrime(Int(self)!) }
    var abs:Int { return Int(self)! < 0 ? Int(-self)! : Int(+self)! }
}
extension Complex where T:ModuloType {
    var isGaussianPrime:Bool {
        let norm = self.norm
        if norm <  2 { return false } // exclude unit
        if norm == 2 { return true  } // smallest primes
        if self.re == 0 {
            return self.im.abs.isPrime && (self.im % 4).abs == 3
        }
        if self.im == 0 {
            return self.re.abs.isPrime && (self.re % 4).abs == 3
        }
        return norm.isPrime
    }
}

(+3+0.i).isGaussianPrime
(-3+0.i).isGaussianPrime
(+0+3.i).isGaussianPrime
(-0+3.i).isGaussianPrime
(+5+0.i).isGaussianPrime
(-5+0.i).isGaussianPrime
(+0+5.i).isGaussianPrime
(-0+5.i).isGaussianPrime
(+5-2.i).isGaussianPrime
//: [Next](@next)
