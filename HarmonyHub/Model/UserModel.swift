//
//  UserModel.swift
//  HarmonyHub
//
//  Created by Jackie Ma on 2023-11-11.
//

import Foundation

struct UserModel: Decodable {
    let country: String?
    let display_name: String?
    let email: String?
    let explicit_content: ExplicitContent?
    let external_urls: ExternalUrls?
    let followers: Followers?
    let href: String?
    let id: String?
    let images: [Image]?
    let product: String?
    let type: String?
    let uri: String?

    struct ExplicitContent: Decodable {
        let filter_enabled: Bool?
        let filter_locked: Bool?
    }

    struct ExternalUrls: Decodable {
        let spotify: String?
    }

    struct Followers: Decodable {
        let href: String?
        let total: Int?
    }

    struct Image: Decodable {
        let url: String?
        let height: Int?
        let width: Int?
    }
}
