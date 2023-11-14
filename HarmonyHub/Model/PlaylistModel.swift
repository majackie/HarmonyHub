//
//  PlaylistModel.swift
//  HarmonyHub
//
//  Created by Jackie Ma on 2023-11-11.
//

import Foundation

struct PlaylistModel: Decodable {
    let collaborative: Bool?
    let description: String?
    let external_urls: ExternalUrls?
    let followers: Followers?
    let href: String?
    let id: String?
    let images: [Image]?
    let name: String?
    let owner: Owner?
    let isPublic: Bool?
    let snapshot_id: String?
    let tracks: Tracks?
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

    struct Owner: Decodable {
        let external_urls: ExternalUrls?
        let followers: Followers?
        let href: String?
        let id: String?
        let type: String?
        let uri: String?
        let display_name: String?
    }

    struct Tracks: Decodable {
        let href: String?
        let limit: Int?
        let next: String?
        let offset: Int?
        let previous: String?
        let total: Int?
        let items: [Item]?

        struct Item: Decodable {
            let added_at: String?
            let added_by: AddedBy?
            let is_local: Bool?
            let track: Track?

            struct AddedBy: Decodable {
                let external_urls: ExternalUrls?
                let followers: Followers?
                let href: String?
                let id: String?
                let type: String?
                let uri: String?
            }

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
                let is_playable: Bool?
                let linked_from: LinkedFrom?
                let restrictions: Restrictions?
                let name: String?
                let popularity: Int?
                let preview_url: String?
                let track_number: Int?
                let type: String?
                let uri: String?
                let is_local: Bool?

                struct Album: Decodable {
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
                }

                struct Artist: Decodable {
                    let external_urls: ExternalUrls?
                    let href: String?
                    let id: String?
                    let name: String?
                    let type: String?
                    let uri: String?
                    let followers: Followers?
                    let genres: [String]?
                    let images: [Image]?
                    let popularity: Int?
                }

                struct ExternalIds: Decodable {
                    let isrc: String?
                    let ean: String?
                    let upc: String?
                }

                struct LinkedFrom: Decodable {
                    let external_urls: ExternalUrls?
                    let href: String?
                    let id: String?
                    let type: String?
                    let uri: String?
                }

                struct Restrictions: Decodable {
                    let reason: String?
                }
            }
        }
    }
}
