// swift-tools-version: 6.3
//
// A demo of using swift-complex with dankogai/swift-bignum for
// arbitrary-precision complex arithmetic, and a package of its own so that
// swift-complex's root manifest keeps its no-dependencies property.
//
//     cd SwiftBigNumExample && swift test
//
// The parent is a `path:` dependency, not a `url:` one.  A URL pointing at `..`
// makes SwiftPM clone the parent as a git working copy and resolve it to a
// *committed* revision, so uncommitted work in the checkout you are sitting in is
// invisible to the demo.  `path:` reads the directory itself, which is what a
// sibling demo wants.
//
import PackageDescription

let package = Package(
    name: "SwiftBigNumExample",
    products: [
        .library(
            name: "SwiftBigNumExample",
            targets: ["SwiftBigNumExample"]
        ),
    ],
    dependencies: [
      .package(url:"https://github.com/dankogai/swift-bignum.git", branch:"main"),
      .package(path:".."),
    ],
    targets: [
        .target(
            name: "SwiftBigNumExample",
            dependencies: [
                .product(name: "Complex", package: "swift-complex"),
                .product(name: "BigNum", package: "swift-bignum"),
            ]),
        .testTarget(
            name: "SwiftBigNumExampleTests",
            dependencies: ["SwiftBigNumExample"]),
    ],
    swiftLanguageModes: [.v6]
)
