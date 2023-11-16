//
//  RecommendationModel.swift
//  HarmonyHub
//
//  Created by Jackie Ma on 2023-11-15.
//

import Foundation

struct RecommendationModel: Decodable {
    let tracks: [Track]?
    let seeds: [Seed]?
    
    struct Track: Decodable {
        let album: Album?
        let artists: [Artist]?
        let available_markets: [String]?
        let disc_number: Int?
        let duration_ms: Int?
        let explicit: Bool?
        let external_ids: ExternalIds?
        let external_urls: ExternalUrls?
        let href: String?
        let id: String?
        let is_local: Bool?
        let name: String?
        let popularity: Int?
        let preview_url: String?
        let track_number: Int?
        let type: String?
        let uri: String?
    }

    struct Album: Decodable {
        let album_type: String?
        let artists: [Artist]?
        let available_markets: [String]?
        let external_urls: ExternalUrls?
        let href: String?
        let id: String?
        let images: [Image]?
        let name: String?
        let release_date: String?
        let release_date_precision: String?
        let total_tracks: Int?
        let type: String?
        let uri: String?
    }

    struct Artist: Decodable {
        let external_urls: ExternalUrls?
        let href: String?
        let id: String?
        let name: String?
        let type: String?
        let uri: String?
    }

    struct ExternalIds: Decodable {
        let isrc: String?
    }

    struct ExternalUrls: Decodable {
        let spotify: String?
    }

    struct Image: Decodable {
        let height: Int?
        let url: String?
        let width: Int?
    }

    struct Seed: Decodable {
        let initialPoolSize: Int?
        let afterFilteringSize: Int?
        let afterRelinkingSize: Int?
        let id: String?
        let type: String?
        let href: String?
    }
}
