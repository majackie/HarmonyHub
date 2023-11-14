//
//  UserModel.swift
//  HarmonyHub
//
//  Created by Jackie Ma on 2023-11-11.
//

import Foundation

struct UserModel: Decodable {
    let id: String?
    let country: String?
    let display_name: String?
    let email: String?
    let followers: Followers?
    let product: String?
    let images: [Image]?
    
    struct Followers: Decodable {
        let total: Int?
    }
    
    struct Image: Decodable {
        let url: String?
    }
}
