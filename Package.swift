// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "Complex",
    products: [
      .library(
        name: "Complex",
        type: .dynamic,
        targets: ["Complex"]),

    ],
    dependencies: [
      .package(url: "https://github.com/dankogai/swift-bignum.git", from: "6.3.0"),
    ],
    targets: [
      .target(
        name: "Complex",
        dependencies: []),
      .executableTarget(
        name: "ComplexRun",
        dependencies: ["Complex"]),
      .testTarget(
        name: "ComplexTests",
        dependencies: [
          "Complex",
          .product(name: "BigNum", package: "swift-bignum"),
        ]),
    ],
    swiftLanguageModes: [.v5]
)
