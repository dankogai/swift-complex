//: [Previous](@previous)
//
// Mandelbrot Set to stdout
//
// cf. https://en.wikipedia.org/wiki/Mandelbrot_set
//
let maxIter = 32
func mandelbrot<T:RealType>(c:Complex<T>)->Complex<T> {
    var z = c
    for _ in 0..<maxIter {
        if z.abs > T(2.0) { return z }
        z = z * z + c
    }
    return z;
}

typealias F = Float // or Double

let sy:F = 1.0 / 20;
let sx:F = 2.5 / 80;
for y in (-19...19).map({F($0)*sy}) {
    var line = ""
    for x in (-64..<16).map({F($0)*sx}) {
        line += mandelbrot(x + y.i).abs > 2.0 ? "*" : "."
    }
    print(line)
}
//: [Next](@next)

