//
// cf. http://blog.human-friendly.com/drawing-images-from-pixel-data-in-swift
//
import Cocoa
public struct Pixel {
    var a:UInt8 = 255
    var r:UInt8
    var g:UInt8
    var b:UInt8
    public init(a:Int, r:Int, g:Int, b:Int) {
        self.a = UInt8(a)
        self.r = UInt8(r)
        self.g = UInt8(g)
        self.b = UInt8(b)
    }
}
private let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
private let bitmapInfo = CGBitmapInfo(
    rawValue:CGImageAlphaInfo.PremultipliedFirst.rawValue
)
public func imageFromARGB32Bitmap(inout pixels:[Pixel], width:Int, height:Int)->NSImage {
    let bitsPerComponent = 8
    let bitsPerPixel = 32
    assert(pixels.count == width * height)
    let providerRef = CGDataProviderCreateWithCFData(
        NSData(bytes: &pixels, length: pixels.count * sizeof(Pixel))
    )
    let cgim = CGImageCreate(
        width,
        height,
        bitsPerComponent,
        bitsPerPixel,
        width * sizeof(Pixel),
        rgbColorSpace,
        bitmapInfo,
        providerRef,
        nil,
        true,
        CGColorRenderingIntent.RenderingIntentDefault
        )!
    return NSImage(CGImage:cgim, size:NSZeroSize)
}
