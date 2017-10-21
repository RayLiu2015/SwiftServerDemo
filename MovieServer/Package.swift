// swift-tools-version:3.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MovieServer",
    targets: [
        Target(
            name: "MovieServer",
            dependencies: []),
        ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 3),
        .Package(url: "https://github.com/kylef/PathKit.git", majorVersion: 0, minor: 8)
    ]
)
