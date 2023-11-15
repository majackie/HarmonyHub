//
//  TopArtistModel.swift
//  HarmonyHub
//
//  Created by Jackie Ma on 2023-11-14.
//

import Foundation

struct TopArtistModel: Decodable {
    let href: String?
    let limit: Int?
    let next: String?
    let offset: Int?
    let previous: String?
    let total: Int?
    let items: [Item]?

    struct Item: Decodable {
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
    }

    struct ExternalUrls: Decodable {
        let spotify: String?
    }

    struct Followers: Decodable {
        let href: String?
        let total: Int?
    }

    struct Image: Decodable {
        let height: Int?
        let url: String?
        let width: Int?
    }
}
