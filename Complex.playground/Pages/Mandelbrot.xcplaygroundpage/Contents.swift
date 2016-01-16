//: [Previous](@previous)
//
// cf. http://rosettacode.org/wiki/Mandelbrot_set
//
func mandelbrot(c:ComplexDouble)->ComplexDouble {
    var z = c
    for _ in 0..<20 {
        if z.abs > 2.0 { return z }
        z = z * z + c
    }
    return z;
}

let sy = 1.0 / 20;
let sx = 2.5 / 80;
for y in (-19...19).map({Double($0)*sy}) {
    var line = ""
    for x in (-64..<16).map({Double($0)*sx}) {
        line += mandelbrot(x + y.i).abs < 2.0 ? "*" : "."
    }
    print(line)
}
//: [Next](@next)
