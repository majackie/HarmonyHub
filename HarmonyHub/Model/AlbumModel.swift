//
//  AlbumModel.swift
//  HarmonyHub
//
//  Created by Jackie Ma on 2023-11-11.
//

import Foundation

struct AlbumModel: Codable {
    let id: String
    let name: String
    let artists: [Artist]
    let release_date: String
    let total_tracks: Int
    
    struct Artist: Codable {
        let id: String
        let name: String
    }
}
