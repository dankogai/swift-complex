// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "Complex",
    products: [
      .library(
        name: "Complex",
        type: .dynamic,
        targets: ["Complex", "ComplexOperators"]),

    ],
    dependencies: [],
    targets: [
      .target(
        name: "Complex",
        dependencies: []),
      .target(
        name: "ComplexOperators",
        dependencies: ["Complex"]),
      .executableTarget(
        name: "ComplexRun",
        dependencies: ["Complex"]),
    ],
    swiftLanguageModes: [.v5]
)
