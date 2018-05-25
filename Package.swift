// swift-tools-version:4.0

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
      .package(
        url: "https://github.com/dankogai/swift-floatingpointmath.git", from: "0.0.0"
      )
    ],
    targets: [
      .target(
        name: "Complex",
        dependencies: ["FloatingPointMath"]),
      .target(
        name: "ComplexRun",
        dependencies: ["Complex"]),
      .testTarget(
        name: "ComplexTests",
        dependencies: ["Complex"]),
    ]
)
