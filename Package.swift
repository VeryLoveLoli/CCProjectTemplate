// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CCProjectTemplate",
    platforms: [
        .macOS(.v10_13), .iOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "CCProjectTemplate",
            targets: ["CCProjectTemplate"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://gitee.com/cchsora/JSONValue", .branch("1.0.0")),
        .package(url: "https://gitee.com/cchsora/Network", .branch("2.0.0")),
        .package(url: "https://gitee.com/cchsora/Prompt", .branch("2.0.0")),
        .package(url: "https://gitee.com/cchsora/DragLoad", .branch("2.0.0")),
        .package(url: "https://gitee.com/cchsora/CryptoSwift", .upToNextMinor(from: "1.3.8")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "CCProjectTemplate",
            dependencies: ["JSONValue", "Network", "Prompt", "DragLoad", "CryptoSwift"]),
        .testTarget(
            name: "CCProjectTemplateTests",
            dependencies: ["CCProjectTemplate"]),
    ]
)
