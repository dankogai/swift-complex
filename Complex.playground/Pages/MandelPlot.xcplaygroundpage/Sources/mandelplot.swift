import Cocoa

public class MandelPlot<T:RealType> {
    let white = Pixel(a: 255, r:255, g:255, b:255)
    let black = Pixel(a: 255, r:0, g:0, b:0)
    var maxIter = 64
    var mandelbrot:(Complex<T>, Int)->Int
    public init(){
        mandelbrot = { (c:Complex<T>, iter:Int)->Int in
            var z = Complex<T>(0, 0)
            for i in 0..<iter {
                if z.norm > T(4.0) { return i }
                z = z * z + c
            }
            return iter;
        }
    }
    public init(_ f:(Complex<T>, Int)->Int) {
        mandelbrot = f
    }
    public init(dimension:T) {
        mandelbrot = { (c, iter) in
            var z = Complex<T>(0, 0)
            for i in 0..<iter {
                if z.norm > T(4.0) { return i }
                z = z ** dimension + c
            }
            return iter;
        }
    }
    /// plots Mandelbrot Set
    ///
    /// - parameter center: center in Complex<T>
    /// - parameter radius: radius in T
    /// - parameter mag=128 : number of pixels per radius
    /// - returns: NSImage of Mandelbrot Set
    public func plot(center center: Complex<T>, radius:T, mag:Int=128) -> NSImage {
        let w = Int(2 * T(mag))!
        let h = Int(2 * T(mag))!
        let sx = radius / T(w)
        let sy = radius / T(h)
        let ox = T(mag)
        let oy = T(mag)
        let palette = (0..<maxIter)
            .map{ $0 * 256 / maxIter }
            .map { Pixel(a:255, r:$0, g:$0, b:(128+$0)&255) }
        var pixels = [Pixel](count:w*h, repeatedValue:white)
        for y in (0..<h) {
            for x in 0..<w {
                let re = (T(x) - ox)*sx
                let im = (T(y) - oy)*sy
                let z = center + re-im.i
                let m = mandelbrot(z, maxIter)
                pixels[y * w + x] = m == maxIter ? black : palette[m]
            }
        }
        return imageFromARGB32Bitmap(&pixels, width:w, height:h)
    }
}