//: [Previous](@previous)
//
// Mandelbrot set in NSImage
//
// cf. https://en.wikipedia.org/wiki/Mandelbrot_set
//
MandelPlot().plot(center:-1.0-0.0.i, radius:3.0, mag:256)

// "multibrot"
let origin = Float(0)+Float(0).i
(0...5).map{
    MandelPlot(dimension:Float($0)).plot(center:origin, radius:3.0)
}
// zoom into the Misiurewicz point
// cf. https://en.wikipedia.org/wiki/Misiurewicz_point
let misiurewicz4_1 = Float(-0.1010) + Float(0.9562).i
(-1...6).map{
    MandelPlot<Float>()
        .plot(center:misiurewicz4_1, radius:Float(2)**Float(-$0))
}
//: [Next](@next)
