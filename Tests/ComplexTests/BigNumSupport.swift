// Types with native math functions conform to RMath with an empty
// extension -- their own functions become the witnesses.
// (real clients spell it `extension BigRat: @retroactive RMath {}`;
// in here RMath comes from the same package, so no @retroactive)
import Complex
import BigNum

extension BigRat:   RMath {}
extension BigFloat: RMath {}
