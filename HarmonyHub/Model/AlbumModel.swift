//
//  AlbumModel.swift
//  HarmonyHub
//
//  Created by Jackie Ma on 2023-11-11.
//

import Foundation

struct AlbumModel: Decodable {
    let album_type: String?
    let total_tracks: Int?
    let available_markets: [String]?
    let external_urls: ExternalUrls?
    let href: String?
    let id: String?
    let images: [Image]?
    let name: String?
    let release_date: String?
    let release_date_precision: String?
    let restrictions: Restrictions?
    let type: String?
    let uri: String?
    let artists: [Artist]?
    let tracks: Tracks?
    let copyrights: [Copyright]?
    let external_ids: ExternalIds?
    let genres: [String]?
    let label: String?
    let popularity: Int?
    
    struct ExternalUrls: Decodable {
        let spotify: String?
    }
    
    struct Image: Decodable {
        let url: String?
        let height: Int?
        let width: Int?
    }
    
    struct Restrictions: Decodable {
        let reason: String?
    }
    
    struct Artist: Decodable {
        let external_urls: ExternalUrls?
        let href: String?
        let id: String?
        let name: String?
        let type: String?
        let uri: String?
    }
    
    struct Tracks: Decodable {
        let href: String?
        let limit: Int?
        let next: String?
        let offset: Int?
        let previous: String?
        let total: Int?
        let items: [Track]?
        
        struct Track: Decodable {
            let artists: [Artist]?
            let available_markets: [String]?
            let disc_number: Int?
            let duration_ms: Int?
            let explicit: Bool?
            let external_urls: ExternalUrls?
            let href: String?
            let id: String?
            let is_playable: Bool?
            let linked_from: LinkedFrom?
            let restrictions: Restrictions?
            let name: String?
            let preview_url: String?
            let track_number: Int?
            let type: String?
            let uri: String?
            let is_local: Bool?
            
            struct Artist: Decodable {
                let external_urls: ExternalUrls?
                let href: String?
                let id: String?
                let name: String?
                let type: String?
                let uri: String?
            }
            
            struct LinkedFrom: Decodable {
                let external_urls: ExternalUrls?
                let href: String?
                let id: String?
                let type: String?
                let uri: String?
            }
        }
    }
    
    struct Copyright: Decodable {
        let text: String?
        let type: String?
    }
    
    struct ExternalIds: Decodable {
        let isrc: String?
        let ean: String?
        let upc: String?
    }
}
