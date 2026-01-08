// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ios-client",
    platforms: [
    .iOS(.v16),
    .macOS(.v10_15)
    ],

    products: [
        .library(name: "ios-client", targets: ["ItemsAPI"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-openapi-generator.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-openapi-runtime.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-openapi-urlsession.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "ItemsAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession")
            ],
            plugins: [
                .plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator")
            ]
        )
    ]
)
