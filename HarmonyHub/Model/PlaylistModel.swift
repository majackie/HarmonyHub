//
//  PlaylistModel.swift
//  HarmonyHub
//
//  Created by Jackie Ma on 2023-11-11.
//

import Foundation

struct PlaylistModel: Codable {
    let id: String
    let name: String
    let owner: Owner

    struct Owner: Codable {
        let display_name: String
    }
}
