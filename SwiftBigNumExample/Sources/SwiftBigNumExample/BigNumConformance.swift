//
//  BigNumConformance.swift -- BigRat and BigFloat as RMaths, so that
//  `Complex<BigRat>` and `Complex<BigFloat>` work at arbitrary precision.
//
//  Two empty extensions, which is the whole point.  Every member RMath asks
//  for is already on these types under the same name and signature -- the
//  plain forms as BigNum's shims, the precision:debug: forms as BigNum's
//  originals (their default argument values do not participate in witness
//  matching).  The three RMath spells differently from BigNum -- cbrt via
//  root(x,3), expm1 via expMinusOne(_:), log1p via log(onePlus:) -- have
//  RMath defaults built from other requirements, so precision propagates
//  even there.
//
//  This only stays two lines because swift-complex ships no Double-roundtrip
//  defaults for the math requirements: a competing default would tie with
//  BigNum's members and witness resolution would fail rather than choose.
//
import Complex
import BigNum

extension BigRat:   @retroactive RMath {}
extension BigFloat: @retroactive RMath {}
