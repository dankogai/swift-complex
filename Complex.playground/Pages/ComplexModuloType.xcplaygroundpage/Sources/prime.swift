public class Prime {
    public static var primes:[Int] = {
        var ps = [2];
        loop: for n in (1...0x8000).map({$0*2+1}) {
            for p in ps {
                if n % p == 0 { break }
                if p * p > n {
                    ps.append(n);
                    break;
                }
            }
        }
        return ps
    }()
    // naive trial division edition.
    // good only up to Int32.max
    public static func isPrime(n:Int)->Bool {
        for p in Prime.primes {
            if n < 2 { return false }
            if n % p == 0 { return n == p }
            if n < p * p  { break }
        }
        return true
    }
}
