//
//  ArtistModel.swift
//  HarmonyHub
//
//  Created by Jackie Ma on 2023-11-11.
//

import Foundation

struct ArtistModel: Codable {
    let id: String?
    let name: String?
    let followers: Followers?
    let genres: [String]?
    let popularity: Int?
    
    struct Followers: Codable {
        let total: Int?
    }
}
