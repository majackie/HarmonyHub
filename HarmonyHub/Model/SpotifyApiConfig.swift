//
//  SpotifyApiConfig.swift
//  HarmonyHub
//
//  Created by Jackie Ma on 2023-11-11.
//

import Foundation

struct SpotifyAPIConfig {
    static let shared = SpotifyAPIConfig()

    private let plistFileName = "SpotifyAPIConfig"

    var clientID: String {
        guard let value = readFromPlist(key: "SpotifyClientID") as? String else {
            fatalError("SpotifyClientID not found in plist")
        }
        return value
    }

    var clientSecret: String {
        guard let value = readFromPlist(key: "SpotifyClientSecret") as? String else {
            fatalError("SpotifyClientSecret not found in plist")
        }
        return value
    }

    var redirectURI: String {
        guard let value = readFromPlist(key: "SpotifyRedirectURI") as? String else {
            fatalError("SpotifyRedirectURI not found in plist")
        }
        return value
    }

    private func readFromPlist(key: String) -> Any? {
        if let plistPath = Bundle.main.path(forResource: plistFileName, ofType: "plist"),
           let plistData = FileManager.default.contents(atPath: plistPath) {
            do {
                let plist = try PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: Any]
                return plist?[key]
            } catch {
                print("Error reading plist: \(error)")
            }
        }
        return nil
    }
}
