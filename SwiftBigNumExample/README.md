# SwiftBigNumExample

`Complex<BigRat>` and `Complex<BigFloat>`, using [swift-complex](..) for the
complex part and [dankogai/swift-bignum] for arbitrary-precision reals.

```bash
cd SwiftBigNumExample && swift test
```

A package of its own, so that swift-complex's own manifest keeps fetching
nothing — SwiftPM resolves every declared dependency whether the target using it
is being built or not.

## The whole conformance

```swift
import Complex
import BigNum

extension BigRat:   @retroactive RMath {}
extension BigFloat: @retroactive RMath {}
```

That is it.  Every member `RMath` asks for is already on these types under the
same name and signature — the plain forms as BigNum's shims, the
`precision:debug:` forms as BigNum's originals (their default argument values do
not participate in witness matching).  The three `RMath` spells differently from
BigNum — `cbrt` via `root(x,3)`, `expm1` via `expMinusOne(_:)`, `log1p` via
`log(onePlus:)` — have `RMath` defaults built from other requirements, so
precision propagates even there.

It only stays two lines because swift-complex ships no Double-roundtrip defaults
for the math requirements: a competing default would tie with BigNum's members,
and a requirement with two equally good witnesses is unsatisfied rather than
overloaded.

## What it buys you

- `(1+2i)/(3+4i) == (11+2i)/25`, *exactly* — 25 is not a power of two, so no
  binary float lands on either component; `BigRat` does, and multiplying back
  returns exactly what you started with.
- `exp(iπ)` within 1e-39 of −1 over `Complex<BigFloat>` at BigNum's default 128
  bits, where a `Double`'s imaginary part is 1.22e-16 out and cannot do better.
- `Complex<BigFloat>.sqrt(z, precision:256)` — the flag is handed down to every
  BigNum call underneath, so more precision in really is more precision out.

Everything above is asserted in `Tests/`, so the claims are checked, not made.

## REPL

```bash
cd SwiftBigNumExample && swift run --repl
```

```swift
  1> import Complex
  2> import SwiftBigNumExample
  3> demo()
Complex<BigRat>: (1+2i)/(3+4i) = ((11/25)+(2/25).i)
                exact 11/25 and 2/25? true
                multiplies back exactly? true
Complex<BigFloat>: exp(iπ) off by  re 1.0894599246168831e-39, im 1.0064895870342754e-39
Complex<Double>:   exp(iπ) off by  re 0.0, im 1.2246467991473532e-16
Complex<BigFloat>: √i = 0.7071067811865476 + 0.7071067811865476i, to 256 bits
```

As in [SwiftNumericsExample](../SwiftNumericsExample), both imports matter:
`Complex` names the types, `SwiftBigNumExample` declares the conformances, and
Swift only lets you use a conformance in code that imports the module declaring
it.  Add `import BigNum` when you want to name `BigRat` and `BigFloat` yourself.

[dankogai/swift-bignum]: https://github.com/dankogai/swift-bignum
