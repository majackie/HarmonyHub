//
//  AudioFeatureModel.swift
//  HarmonyHub
//
//  Created by Jackie Ma on 2023-11-15.
//

import Foundation

struct AudioFeatureModel: Decodable {
    let audio_features: [Item]?
    
    struct Item: Decodable {
        let acousticness: Double?
        let analysis_url: String?
        let danceability: Double?
        let duration_ms: Int?
        let energy: Double?
        let id: String?
        let instrumentalness: Double?
        let key: Int?
        let liveness: Double?
        let loudness: Double?
        let mode: Int?
        let speechiness: Double?
        let tempo: Double?
        let time_signature: Int?
        let track_href: String?
        let type: String?
        let uri: String?
        let valence: Double?
    }
}
