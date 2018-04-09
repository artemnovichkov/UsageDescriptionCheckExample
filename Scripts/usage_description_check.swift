#!/usr/bin/env xcrun --sdk macosx swift

import Foundation

// Get project URL
guard let projectDirRawValue = getenv("PROJECT_DIR"),
    let projectDirectoryPath = String(utf8String: projectDirRawValue) else {
        exit(1)
}
let projectURL = URL(fileURLWithPath: projectDirectoryPath)

// Get Info.plist path
guard let productSettingsPathRawValue = getenv("PRODUCT_SETTINGS_PATH"),
    let productSettingsPath = String(utf8String: productSettingsPathRawValue) else {
        exit(1)
}

// Get Swift file URLs
guard let enumerator = FileManager.default.enumerator(at: projectURL, includingPropertiesForKeys: nil) else {
    exit(1)
}
var swiftFileURLs = enumerator.allObjects
    .compactMap { $0 as? URL }
    .filter { $0.pathExtension == "swift" }

// Get all keys for used patterns
let patterns = ["EKEventStore": "NSCalendarsUsageDescription"]
var keys: [String] = []

for url in swiftFileURLs {
    let contents = try String(contentsOf: url, encoding: .utf8)
    for (pattern, key) in patterns {
        if contents.contains(pattern) {
            keys.append(key)
        }
    }
}

// Check product settings for descriptions
guard let productSettings = NSDictionary(contentsOfFile: productSettingsPath) else {
    exit(1)
}
for key in keys {
    guard let value = productSettings[key] as? String else {
        print("error: Missing \(key)")
        exit(1)
    }
    if value.isEmpty {
        print("error: Empty description for \(key)")
        exit(1)
    }
}
