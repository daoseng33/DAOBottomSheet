// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "DAOBottomSheet",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "DAOBottomSheet",
            targets: ["DAOBottomSheet"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "DAOBottomSheet",
            dependencies: [
            ],
            path: "DAOBottomSheet/"),
    ]
)
