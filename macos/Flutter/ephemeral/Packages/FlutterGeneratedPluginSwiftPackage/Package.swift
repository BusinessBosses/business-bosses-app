// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
//  Generated file. Do not edit.
//

import PackageDescription

let package = Package(
    name: "FlutterGeneratedPluginSwiftPackage",
    platforms: [
        .macOS("10.14")
    ],
    products: [
        .library(name: "FlutterGeneratedPluginSwiftPackage", type: .static, targets: ["FlutterGeneratedPluginSwiftPackage"])
    ],
    dependencies: [
        .package(name: "app_links", path: "/Users/eawuku/.pub-cache/hosted/pub.dev/app_links-6.4.0/macos/app_links"),
        .package(name: "device_info_plus", path: "/Users/eawuku/.pub-cache/hosted/pub.dev/device_info_plus-11.5.0/macos/device_info_plus"),
        .package(name: "file_picker", path: "/Users/eawuku/.pub-cache/hosted/pub.dev/file_picker-10.2.0/macos/file_picker"),
        .package(name: "file_selector_macos", path: "/Users/eawuku/.pub-cache/hosted/pub.dev/file_selector_macos-0.9.4+3/macos/file_selector_macos"),
        .package(name: "firebase_analytics", path: "/Users/eawuku/.pub-cache/hosted/pub.dev/firebase_analytics-12.0.0/macos/firebase_analytics"),
        .package(name: "firebase_core", path: "/Users/eawuku/.pub-cache/hosted/pub.dev/firebase_core-4.0.0/macos/firebase_core"),
        .package(name: "firebase_messaging", path: "/Users/eawuku/.pub-cache/hosted/pub.dev/firebase_messaging-16.0.0/macos/firebase_messaging"),
        .package(name: "google_sign_in_ios", path: "/Users/eawuku/.pub-cache/hosted/pub.dev/google_sign_in_ios-6.1.0/darwin/google_sign_in_ios"),
        .package(name: "package_info_plus", path: "/Users/eawuku/.pub-cache/hosted/pub.dev/package_info_plus-8.3.0/macos/package_info_plus"),
        .package(name: "path_provider_foundation", path: "/Users/eawuku/.pub-cache/hosted/pub.dev/path_provider_foundation-2.4.1/darwin/path_provider_foundation"),
        .package(name: "share_plus", path: "/Users/eawuku/.pub-cache/hosted/pub.dev/share_plus-11.0.0/macos/share_plus"),
        .package(name: "shared_preferences_foundation", path: "/Users/eawuku/.pub-cache/hosted/pub.dev/shared_preferences_foundation-2.5.4/darwin/shared_preferences_foundation"),
        .package(name: "sqflite_darwin", path: "/Users/eawuku/.pub-cache/hosted/pub.dev/sqflite_darwin-2.4.2/darwin/sqflite_darwin"),
        .package(name: "url_launcher_macos", path: "/Users/eawuku/.pub-cache/hosted/pub.dev/url_launcher_macos-3.2.2/macos/url_launcher_macos"),
        .package(name: "webview_flutter_wkwebview", path: "/Users/eawuku/.pub-cache/hosted/pub.dev/webview_flutter_wkwebview-3.22.1/darwin/webview_flutter_wkwebview")
    ],
    targets: [
        .target(
            name: "FlutterGeneratedPluginSwiftPackage",
            dependencies: [
                .product(name: "app-links", package: "app_links"),
                .product(name: "device-info-plus", package: "device_info_plus"),
                .product(name: "file-picker", package: "file_picker"),
                .product(name: "file-selector-macos", package: "file_selector_macos"),
                .product(name: "firebase-analytics", package: "firebase_analytics"),
                .product(name: "firebase-core", package: "firebase_core"),
                .product(name: "firebase-messaging", package: "firebase_messaging"),
                .product(name: "google-sign-in-ios", package: "google_sign_in_ios"),
                .product(name: "package-info-plus", package: "package_info_plus"),
                .product(name: "path-provider-foundation", package: "path_provider_foundation"),
                .product(name: "share-plus", package: "share_plus"),
                .product(name: "shared-preferences-foundation", package: "shared_preferences_foundation"),
                .product(name: "sqflite-darwin", package: "sqflite_darwin"),
                .product(name: "url-launcher-macos", package: "url_launcher_macos"),
                .product(name: "webview-flutter-wkwebview", package: "webview_flutter_wkwebview")
            ]
        )
    ]
)
