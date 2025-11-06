// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// swiftlint:disable:next prefixed_toplevel_constant
let package = Package(
    name: "Domain",
    platforms: [ .iOS(.v17) ],
    products: [
        .library(
            name: "Domain",
            targets: [
                "Domain"
            ]
        )
    ],
    dependencies: [
        .package(name: "ExternalDependencies", path: "./ExternalDependencies"),
        .package(path: "../Data")
    ],
    targets: [
        .target(
            name: "Domain",
            dependencies: [
                "Data",
                .product(
                    name: "DomainDependencies",
                    package: "ExternalDependencies"
                )
            ]
        ),
        .testTarget(
            name: "DomainTests",
            dependencies: [
                "Domain",
                .product(
                    name: "DomainTestsDependencies",
                    package: "ExternalDependencies"
                )
            ]
        )
    ]
)
