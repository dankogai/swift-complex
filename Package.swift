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
    dependencies: [],
    targets: [
      .target(
        name: "Complex",
        dependencies: []),
      .target(
        name: "ComplexRun",
        dependencies: ["Complex"]),
      .testTarget(
        name: "ComplexTests",
        dependencies: ["Complex"]),
    ]
)
