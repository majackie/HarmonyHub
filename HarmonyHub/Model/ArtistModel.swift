//
//  ArtistModel.swift
//  HarmonyHub
//
//  Created by Jackie Ma on 2023-11-11.
//

import Foundation

struct ArtistModel: Decodable {
    let external_urls: ExternalUrls?
    let followers: Followers?
    let genres: [String]?
    let href: String?
    let id: String?
    let images: [Image]?
    let name: String?
    let popularity: Int?
    let type: String?
    let uri: String?

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
