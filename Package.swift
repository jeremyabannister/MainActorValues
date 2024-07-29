// swift-tools-version: 5.10


///
import PackageDescription

///
let package = Package(
    name: "MainActorValues",
    platforms: [.macOS(.v10_15), .iOS(.v13), .watchOS(.v6), .tvOS(.v13)],
    products: [
        .library(
            name: "MainActorValues",
            targets: ["MainActorValues"]
        ),
    ],
    dependencies: [
        
        ///
        .package(
            url: "https://github.com/jeremyabannister/FoundationToolkit",
            "0.8.0" ..< "0.9.0"
        ),
        
        ///
        .package(
            url: "https://github.com/jeremyabannister/LeakTracker-package",
            "0.1.0" ..< "0.2.0"
        ),
    ],
    targets: expand([
        
        ///
        umbrellaTarget(
            name: "MainActorValues",
            submoduleDependencies: [
                "combine-compatibility",
                "main-actor-value",
                "main-actor-value-binding",
                "main-actor-value-source",
                "map",
                "subscribable-main-actor-value-binding",
            ]
        ),
        
        ///
        testedSubmoduleTarget(
            name: "combine-compatibility",
            submoduleDependencies: [
                "main-actor-value-source",
            ]
        ),
        submoduleTarget(
            name: "map",
            submoduleDependencies: [
                "interface-subscribable-main-actor-value",
                "main-actor-value",
                "mapped-main-actor-reaction-manager",
            ]
        ),
        submoduleTarget(
            name: "main-actor-value",
            submoduleDependencies: [
                "interface-readable-main-actor-value",
            ]
        ),
        testedSubmoduleTarget(
            name: "main-actor-value-source",
            submoduleDependencies: [
                "interface-main-actor-value-binding",
                "interface-subscribable-main-actor-value",
                "main-actor-reaction-managers",
            ],
            otherDependencies: ["FoundationToolkit"]
        ),
        submoduleTarget(
            name: "subscribable-main-actor-value-binding",
            submoduleDependencies: [
                "interface-main-actor-value-binding",
                "interface-subscribable-main-actor-value",
                "map",
            ]
        ),
        submoduleTarget(
            name: "main-actor-value-binding",
            submoduleDependencies: [
                "interface-main-actor-value-binding",
            ]
        ),
        submoduleTarget(
            name: "interface-subscribable-main-actor-value",
            submoduleDependencies: [
                "interface-main-actor-reaction-manager",
                "interface-readable-main-actor-value",
            ]
        ),
        submoduleTarget(
            name: "interface-main-actor-value-binding",
            submoduleDependencies: [
                "interface-readable-main-actor-value"
            ]
        ),
        submoduleTarget(
            name: "interface-readable-main-actor-value",
            submoduleDependencies: [
                "interface-main-actor-value-source-accessor"
            ]
        ),
        submoduleTarget(
            name: "interface-main-actor-value-source-accessor"
        ),
        
        
        ///
        testedSubmoduleTarget(
            name: "main-actor-reaction-managers",
            submoduleDependencies: [
                "mapped-main-actor-reaction-manager",
                "main-actor-reaction-manager",
                "ergonomics-interface-main-actor-reaction-manager",
                "interface-main-actor-reaction-manager",
            ]
        ),
        submoduleTarget(
            name: "mapped-main-actor-reaction-manager",
            submoduleDependencies: ["interface-main-actor-reaction-manager"]
        ),
        submoduleTarget(
            name: "main-actor-reaction-manager",
            submoduleDependencies: ["interface-main-actor-reaction-manager"]
        ),
        submoduleTarget(
            name: "ergonomics-interface-main-actor-reaction-manager",
            submoduleDependencies: ["interface-main-actor-reaction-manager"]
        ),
        submoduleTarget(
            name: "interface-main-actor-reaction-manager",
            otherDependencies: [
                .product(name: "LeakTracker-module", package: "LeakTracker-package"),
            ]
        ),
    ])
)

///
func umbrellaTarget(
    name: String,
    submoduleDependencies: [String] = [],
    otherDependencies: [Target.Dependency] = []
) -> Target {
    
    ///
    .target(
        name: name,
        dependencies: submoduleDependencies.map { .init(stringLiteral: submoduleName($0)) } + otherDependencies
    )
}

///
func testedSubmoduleTarget(
    name: String,
    submoduleDependencies: [String] = [],
    otherDependencies: [Target.Dependency] = [],
    nonstandardLocation: String? = nil
) -> [Target] {
    
    ///
    [
        submoduleTarget(
            name: name,
            submoduleDependencies: submoduleDependencies,
            otherDependencies: otherDependencies,
            nonstandardLocation: nonstandardLocation
        ),
        Target.testTarget(
            name: submoduleName(name) + "-tests",
            dependencies: [
                Target.Dependency(stringLiteral: submoduleName(name)),
                .product(name: "FoundationTestToolkit", package: "FoundationToolkit")
            ],
            path: "Tests/\(nonstandardLocation ?? name)"
        )
    ]
}

///
func submoduleTarget(
    name: String,
    submoduleDependencies: [String] = [],
    otherDependencies: [Target.Dependency] = [],
    nonstandardLocation: String? = nil
) -> Target {
    
    ///
    .target(
        name: submoduleName(name),
        dependencies: submoduleDependencies.map { .init(stringLiteral: submoduleName($0)) } + otherDependencies,
        path: "Sources/\(nonstandardLocation ?? name)"
    )
}

///
func submoduleName(
    _ name: String
) -> String {
    
    ///
    "MainActorValues-\(name)"
}



///
func expand(
    _ targetProviders: [any TargetProvider]
) -> [Target] {
    
    ///
    targetProviders
        .flatMap { $0.targets() }
}

///
extension Target: TargetProvider {
    func targets() -> [Target] {
        [self]
    }
}

extension [Target]: TargetProvider {
    func targets() -> [Target] {
        self
    }
}

///
protocol TargetProvider {
    func targets() -> [Target]
}
