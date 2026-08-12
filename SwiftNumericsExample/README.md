# SwiftNumericsExample

`Complex<Float>`, using [swift-complex](..) for the complex part and
[apple/swift-numerics]' `RealModule` for the real math.

```bash
cd SwiftNumericsExample && swift test
```

A package of its own, so that swift-complex's own manifest keeps fetching
nothing — SwiftPM resolves every declared dependency whether the target using it
is being built or not.

## The conformance

```swift
import Complex
import RealModule

extension Float: @retroactive RMath {
    public func toDouble()->Double { return Double(self) }
    public static var precision:Int { return significandBitCount }
    // ... and the precision:debug: requirements, each one line:
    public static func exp(_ x:Self, precision:Int, debug:Bool)->Self { return exp(x) }
    // ...
}
```

The library leaves Float's conformance deliberately vacant — see the
commented-out `extension Float : RMathViaDouble` in ElementaryFunctions.swift.
Had it shipped one, this package could not exist: a second conformance would be
redundant, and RealModule's members would tie with `RMathViaDouble`'s defaults in
witness resolution.  An open slot costs nothing and lets the client choose the
math they want under `Complex<Float>`.

With the slot open, RealModule's `Float` members — `exp`, `log`, `sin` …
`atan2(y:x:)`, `hypot`, `pow`, same names and signatures as `RMath`'s plain
requirements — become the witnesses by themselves.  Three requirements it spells
differently (`root(x,3)`, `expMinusOne(_:)`, `log(onePlus:)`) fall back to
`RMath`'s defaults for `cbrt`, `expm1` and `log1p`, which are built from other
requirements, i.e. still RealModule underneath.  What is left for Float to say is
`toDouble()`, `precision`, and the `precision:debug:` forms — Float's precision
is fixed, so those accept and ignore the arguments, exactly like `RMathViaDouble`
does for `Double`.

## REPL

```bash
cd SwiftNumericsExample && swift run --repl
```

```swift
  1> import Complex
  2> import SwiftNumericsExample
  3> Complex.sqrt(Complex(0, Float(1)))
$R0: Complex.Complex<Float> = {
  real = 0.707106769
  imag = 0.707106769
}
```

Both imports matter.  `Complex` names the types; `SwiftNumericsExample` is
where the `Float: RMath` conformance is declared, and Swift only lets you use
a conformance in code that imports the module declaring it.  Leave it out and
`Complex(0, Float(1))` still constructs — the struct itself only asks
`FloatingPoint` of its element — but the math functions are gone, and the
compiler says so in a roundabout way: it falls back to the `Element`-argument
overload of `sqrt` and complains that `Complex<Complex<Float>>` requires
`Complex<Float>: FloatingPoint`.

## What it buys you

- `Complex<Float>.exp(Complex<Float>(0, .pi))` — Euler's identity with cosine
  and sine from swift-numerics; the library itself never taught Float any math.
- `Complex<Float>.sqrt(-4) == 2i`, which no real `Float` can say.
- `toString(_:radix:)`, hexfloat rendering included, generic over the element.

Everything above is asserted in `Tests/`, so the claims are checked, not made.

[apple/swift-numerics]: https://github.com/apple/swift-numerics
