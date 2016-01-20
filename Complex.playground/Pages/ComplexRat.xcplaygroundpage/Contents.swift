//: [Previous](@previous)
/*:
## ToDo: Complex<Rat<T>>

Supposed to work but current swift crashes with signal 11.

* Swift 2.1 on Xcode 7.2 crashes at:

*/
//    extension Rat: ArithmeticType {}
/*:
* Swift 2.2 on Linux does not crash there but when you try to use it it fails:
*/
/*
$ ~/swift/usr/bin/swift -I../swift-rat -L../swift-rat -lRat -I../swift-complex -L../swift-complex -lComplex
Welcome to Swift version 2.2-dev (LLVM 3ebdbb2c7e, Clang f66c5bb67b, Swift 42591f7cba). Type :help for assistance.
1> import Complex
2> import Rat
3> extension Rat: ArithmeticType {}
4> Complex(Rat(2,12),Rat(2,12))
Execution interrupted. Enter code to recover and continue.
Enter LLDB commands to investigate (type :help for assistance.)
5>
*/

//: [Next](@next)
