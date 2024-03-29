// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Widgets",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Widgets",
            targets: ["Widgets"]
        ),
    ],
    dependencies: [
        .package(name: "Store", path: "../Store")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Widgets",
            dependencies: [
                .byName(name: "Store")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "WidgetsTests",
            dependencies: ["Widgets"]
        ),
    ]
)
