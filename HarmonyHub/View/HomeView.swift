//
//  HomeView.swift
//  HarmonyHub
//
//  Created by Jackie Ma on 2023-11-11.
//

import Foundation
import SwiftUI

let clientId = "012cd446b8764125b30398495b54511f"
let clientSecret = "902a0891d63146d988e6b11b7e332bcb"
let redirectUri = "https://github.com/majackie/HarmonyHub"

struct HomeView: View {
    @State private var accessToken: String = ""
    @State private var artistId: String = "0Y4inQK6OespitzD6ijMwb"
    @State private var albumId: String = "43uErencdmuTRFZPG3zXL1"
    @State private var playlistId: String = "37i9dQZF1DZ06evO0vFpVC"
    @State private var artistInfo: String = ""
    @State private var albumInfo: String = ""
    @State private var playlistInfo: String = ""
    @State private var error: String? = nil
    @State private var selectedItem: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Picker("Select Item", selection: $selectedItem) {
                Text("Token").tag("Token")
                Text("Artist").tag("Artist")
                Text("Album").tag("Album")
                Text("Playlist").tag("Playlist")
            }
            .pickerStyle(SegmentedPickerStyle())
            
            if selectedItem == "Token" {
                HStack{
                    Text("Acess Token")
                }
                Button("Request") {
                    getAccessToken()
                }
                Text(accessToken)
                    .padding(.top)
            } else if selectedItem == "Artist" {
                HStack {
                    Text("Artist ID: ")
                    TextField("", text: $artistId)
                }
                Button("Submit") {
                    getArtistInfo()
                }
                Text(artistInfo)
                    .padding(.top)
            } else if selectedItem == "Album" {
                HStack {
                    Text("Album ID: ")
                    TextField("", text: $albumId)
                }
                Button("Submit") {
                    getAlbumInfo()
                }
                Text(albumInfo)
                    .padding(.top)
            } else if selectedItem == "Playlist" {
                HStack {
                    Text("Playlist ID: ")
                    TextField("", text: $playlistId)
                }
                Button("Submit") {
                    getPlaylistInfo()
                }
                Text(playlistInfo)
                    .padding(.top)
            }
            
            Spacer()
        }
        .padding()
    }
    
    func getAccessToken() {
        let base64Credentials = "\(clientId):\(clientSecret)".data(using: .utf8)?.base64EncodedString()
        guard let base64Credentials = base64Credentials else {
            return
        }
        
        let headers = [
            "Authorization": "Basic \(base64Credentials)",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let requestBody = "grant_type=client_credentials"
        
        guard let url = URL(string: "https://accounts.spotify.com/api/token") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = requestBody.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let accessToken = jsonResponse?["access_token"] as? String {
                        DispatchQueue.main.async {
                            self.accessToken = accessToken
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    func getArtistInfo() {
        guard let url = URL(string: "https://api.spotify.com/v1/artists/\(artistId)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let artist = try JSONDecoder().decode(ArtistModel.self, from: data)
                    DispatchQueue.main.async {
                        self.artistInfo = "Artist Name: \(artist.name)\nFollowers: \(artist.followers.total)\nGenres: \(artist.genres.joined(separator: ", "))\nPopularity: \(artist.popularity)"
                    }
                } catch {
                    print(error.localizedDescription)
                    self.error = "Error parsing artist info: \(error.localizedDescription)"
                }
            } else if let error = error {
                self.error = "Network error: \(error.localizedDescription)"
            }
        }.resume()
    }
    
    func getAlbumInfo() {
        guard let url = URL(string: "https://api.spotify.com/v1/albums/\(albumId)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let album = try JSONDecoder().decode(AlbumModel.self, from: data)
                    DispatchQueue.main.async {
                        self.albumInfo = "Album Name: \(album.name)\nArtist: \(album.artists[0].name)\nRelease Date: \(album.release_date)\nTotal Tracks: \(album.total_tracks)"
                    }
                } catch {
                    print(error.localizedDescription)
                    self.error = "Error parsing album info: \(error.localizedDescription)"
                }
            } else if let error = error {
                self.error = "Network error: \(error.localizedDescription)"
            }
        }.resume()
    }
    
    func getPlaylistInfo() {
        guard let url = URL(string: "https://api.spotify.com/v1/playlists/\(playlistId)") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print("Response Data: \(String(data: data, encoding: .utf8) ?? "")")
                do {
                    let playlist = try JSONDecoder().decode(PlaylistModel.self, from: data)
                    DispatchQueue.main.async {
                        self.playlistInfo = "Playlist Name: \(playlist.name)\nOwner: \(playlist.owner.display_name)"
                    }
                } catch {
                    print(error.localizedDescription)
                    self.error = "Error parsing playlist info: \(error.localizedDescription)"
                }
            } else if let error = error {
                self.error = "Network error: \(error.localizedDescription)"
            }
        }.resume()
    }

}

#Preview {
    HomeView()
}
