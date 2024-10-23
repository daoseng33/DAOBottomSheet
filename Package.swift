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
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
    ],
    targets: [
        .target(
            name: "DAOBottomSheet",
            dependencies: [
                "SnapKit",
            ],
            path: "DAOBottomSheet/"),
    ]
)
