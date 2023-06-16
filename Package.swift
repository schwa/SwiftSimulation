// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftSimulation",
    platforms: [
        .iOS("16.0"),
        .macOS("13.0"),
        .macCatalyst("16.0"),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SwiftSimulation",
            targets: ["SwiftSimulation"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
         .package(url: "https://github.com/schwa/Everything", from: "0.0.1")
    ],
    targets: [

        .target(name: "SwiftSimulation", dependencies: ["Everything"], resources: [
            .copy("Life/Patterns/acorn_105.lif"),
            .copy("Life/Patterns/bigglider_105.lif"),
            .copy("Life/Patterns/glider_105.lif"),
            .copy("Life/Patterns/gliderloop_105.lif"),
            .copy("Life/Patterns/gosperglidergun_105.lif"),
            .copy("Life/Patterns/gunstar_105.lif"),
            .copy("Life/Patterns/hacksaw_105.lif"),
            .copy("Life/Patterns/newgun2_105.lif"),
        ]),
        .testTarget(
            name: "SimulationTests",
            dependencies: ["SwiftSimulation"]),
    ]
)
