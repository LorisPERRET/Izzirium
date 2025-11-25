// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let useApiMock = true

// swiftlint:disable:next prefixed_toplevel_constant
let package = Package(
    name: "Data",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Data",
            targets: [
                "Data"
            ]
        )
    ],
    dependencies: [
        .package(name: "ExternalDependencies", path: "./ExternalDependencies")
    ],
    targets: [
        .target(
            name: "Data",
            dependencies: [
                .product(
                    name: "DataDependencies",
                    package: "ExternalDependencies"
                )
            ],
//            resources: useApiMock ? [.process("Resources/Mocks")] : nil,
            swiftSettings: [
                useApiMock ? .define("API_MOCK") : nil,
            ].compactMap { $0 }
        ),
        .testTarget(
            name: "DataTests",
            dependencies: [
                "Data",
                .product(
                    name: "DataTestsDependencies",
                    package: "ExternalDependencies"
                )
            ]
        )
    ]
)
