//
//  UserModel.swift
//  HarmonyHub
//
//  Created by Jackie Ma on 2023-11-11.
//

import Foundation

struct UserModel: Codable {
    let country: String
    let display_name: String
    let email: String
    let followers: Followers
    let images: [Image]
    let product: String
    
    struct Followers: Codable {
        let total: Int
    }
    
    struct Image: Codable {
        let url: String
    }
}
