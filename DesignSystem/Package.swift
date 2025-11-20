// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// swiftlint:disable:next prefixed_toplevel_constant
let package = Package(
    name: "DesignSystem",
    platforms: [ .iOS(.v17) ],
    products: [
        .library(
            name: "DesignSystem",
            targets: [
                "DesignSystem"
            ]
        )
    ],
    dependencies: [
        .package(name: "ExternalDependencies", path: "./ExternalDependencies")
    ],
    targets: [
        .target(
            name: "DesignSystem",
            dependencies: [
                .product(
                    name: "DesignSystemDependencies",
                    package: "ExternalDependencies"
                )
            ],
            resources: [
                .process("Core/Foundation/Typographies/Fonts")
            ]
        )
    ]
)
