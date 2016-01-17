import Cocoa

public typealias F = Float // or Double

let maxDepth = 256
let maxIter = 64
let white = Pixel(a: 255, r:255, g:255, b:255)
let black = Pixel(a: 255, r:0, g:0, b:0)
func mandelbrot<T:RealType>(c:Complex<T>, iter:Int = maxIter)->Int {
    var z = c
    for i in 0..<iter {
        if z.norm > T(4.0) { return i }
        z = z * z + c
    }
    return iter;
}
/// plots Mandelbrot Set
///
/// - parameter re: range of real part
/// - parameter im: range of imag part
/// - parameter mag=128 : magnification
/// - returns: NSImage of Mandelbrot Set
public func mandelPlot(re re:(F,F), im:(F,F), mag:Int=128) -> NSImage {
    let dx = re.1 - re.0
    let dy = im.1 - im.0
    let w = Int(dx * F(mag))
    let h = Int(dy * F(mag))
    let sx = dx / F(w)
    let sy = dy / F(h)
    let xoff = F(w) * re.0/dx
    let yoff = F(h) * im.0/dy
    var pixels = [Pixel](count:w*h, repeatedValue:white)
    for y in (0..<h).reverse() {
        for x in 0..<w {
            let z = (F(x) + xoff)*sx + (F(y) + yoff)*sy.i
            let m = mandelbrot(z)
            let c = 255 * m / maxIter
            pixels[y * w + x] = m == maxIter ? black
                : Pixel(a:255, r:c, g:c, b:(128+c)&255)
        }
    }
    return imageFromARGB32Bitmap(&pixels, width:w, height:h)
}