// swift-tools-version:4.2
//
//  Package.swift
//
import PackageDescription

let package = Package(
    name: "StreamScanner",
    products: [
        .library(
            name: "StreamScanner", targets: ["StreamScanner"])
    ],
    targets: [
        .target(name: "StreamScanner")
        .testTarget(name: "StreamScanner", dependencies: ["StreamScanner"])
    ],
    swiftLanguageVersions: [4]
)

