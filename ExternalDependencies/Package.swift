// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// swiftlint:disable:next prefixed_toplevel_constant
let package = Package(
    name: "ExternalDependencies",
    platforms: [ .iOS(.v17) ],
    products: [
        .library(
            name: "ApplicationDependencies",
            targets: ["ApplicationDependencies"]
        ),
        .library(
            name: "DataDependencies",
            targets: ["DataDependencies"]
        ),
        .library(
            name: "DataTestsDependencies",
            targets: ["DataTestsDependencies"]
        ),
        .library(
            name: "DomainDependencies",
            targets: ["DomainDependencies"]
        ),
        .library(
            name: "DomainTestsDependencies",
            targets: ["DomainTestsDependencies"]
        ),
        .library(
            name: "DesignSystemDependencies",
            targets: ["DesignSystemDependencies"]
        )
    ],
    dependencies: [
//        .package(
//            url: "https://gitea.openium.fr/openium/kastor.ios",
//            branch: "main"
//        ),
        .package(
            // Releases: https://gitea.openium.fr/openium/SKDevKit/releases
            url: "https://gitea.openium.fr/openium/SKDevKit",
            exact: "1.2.0"
        ),
//        .package(
//            // Releases: https://firebase.google.com/support/release-notes/ios
//            url: "https://github.com/firebase/firebase-ios-sdk",
//            .upToNextMajor(from: "11.10.0")
//        ),
//        .package(
//            url: "https://github.com/openium/papyrus.git",
//            branch: "updated-swift-syntax-601.0.1"
//        ),
        .package(
            url: "https://github.com/exyte/PopupView.git",
            .upToNextMajor(from: "4.1.14")
        )
    ],
    targets: [

        // Application
        .target(
            name: "ApplicationDependencies",
            dependencies: [
                .product(name: "SKDependencyInjection", package: "SKDevKit"),
                .product(name: "SKLocalStorage", package: "SKDevKit"),
                .product(name: "SKState", package: "SKDevKit"),
                .product(name: "SKToast", package: "SKDevKit"),
                .product(name: "SKUI", package: "SKDevKit"),
//                .product(name: "KastorBoard", package: "kastor.ios"),
//                .product(name: "Kastor", package: "kastor.ios"),
//                .product(
//                    name: "FirebaseMessaging",
//                    package: "firebase-ios-sdk"
//                ),
            ],
            path: "Sources",
            sources: ["ApplicationDependencies.swift"]
        ),
        
        // Data
        .target(
            name: "DataDependencies",
            dependencies: [
                .product(name: "SKDependencyInjection", package: "SKDevKit"),
                .product(name: "SKLocalStorage", package: "SKDevKit"),
//                .product(name: "Kastor", package: "kastor.ios"),
//                .product(name: "PapyrusAlamofire", package: "papyrus")
            ],
            path: "Sources",
            sources: ["DataDependencies.swift"]
        ),
        
        // Data
        .target(
            name: "DataTestsDependencies",
            path: "Sources",
            sources: ["DataTestsDependencies.swift"]
        ),

        // Domain
        .target(
            name: "DomainDependencies",
            dependencies: [
                .product(name: "SKDependencyInjection", package: "SKDevKit"),
                .product(name: "SKLocalStorage", package: "SKDevKit"),
//                .product(name: "Kastor", package: "kastor.ios"),
            ],
            path: "Sources",
            sources: ["DomainDependencies.swift"]
        ),

        // Domain
        .target(
            name: "DomainTestsDependencies",
            path: "Sources",
            sources: ["DomainTestsDependencies.swift"]
        ),

        // DesignSystem
        .target(
            name: "DesignSystemDependencies",
            dependencies: [
                .product(name: "SKUI", package: "SKDevKit"),
                .product(name: "SKToast", package: "SKDevKit"),
                .product(name: "SKState", package: "SKDevKit"),
                "PopupView",
            ],
            path: "Sources",
            sources: ["DesignSystemDependencies.swift"]
        ),
    ]
)
