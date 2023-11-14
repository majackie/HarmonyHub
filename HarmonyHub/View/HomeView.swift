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
let redirectUri = "https://github.com/majackie"

struct HomeView: View {
    @State private var accessToken: String = ""
    @State private var authenticateToken: String = ""
    
    @State private var artistId: String = "0Y4inQK6OespitzD6ijMwb"
    @State private var albumId: String = "43uErencdmuTRFZPG3zXL1"
    @State private var playlistId: String = "37i9dQZF1DZ06evO0vFpVC"
    
    @State private var artistInfo: String = ""
    @State private var albumInfo: String = ""
    @State private var playlistInfo: String = ""
    @State private var userInfo: String = ""
    
    @State private var error: String? = nil
    @State private var selectedItem: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("accessToken:\n\(accessToken)")
            Text("authenticateToken:\n\(authenticateToken)")
            
            Picker("Select Item", selection: $selectedItem) {
                Text("Artist").tag("Artist")
                Text("Album").tag("Album")
                Text("Playlist").tag("Playlist")
                Text("User").tag("User")
            }
            .pickerStyle(SegmentedPickerStyle())
            
            if selectedItem == "Artist" {
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
            } else if selectedItem == "User" {
                HStack {
                    Text("User: ")
                }
                Button("Submit") {
                    getUserInfo()
                }
                Text(userInfo)
                    .padding(.top)
            }
            
            Spacer()
        }
        .padding()
    }
    
    func getAccessToken(completion: @escaping () -> Void) {
        if let storedAccessToken = UserDefaults.standard.string(forKey: "accessToken"),
           let expirationDate = UserDefaults.standard.object(forKey: "accessTokenExpirationDate") as? Date,
           Date() < expirationDate {
            self.accessToken = storedAccessToken
            completion()
            return
        }

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
                    if let accessToken = jsonResponse?["access_token"] as? String,
                       let expiresIn = jsonResponse?["expires_in"] as? TimeInterval {
                        let expirationDate = Date().addingTimeInterval(expiresIn)
                        UserDefaults.standard.set(accessToken, forKey: "accessToken")
                        UserDefaults.standard.set(expirationDate, forKey: "accessTokenExpirationDate")
                        self.accessToken = accessToken
                        completion()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    func getArtistInfo() {
        getAccessToken {
            guard let url = URL(string: "https://api.spotify.com/v1/artists/\(artistId)") else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    print("Response Data: \(String(data: data, encoding: .utf8) ?? "")")
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
    }
    
    func getAlbumInfo() {
        getAccessToken {
            guard let url = URL(string: "https://api.spotify.com/v1/albums/\(albumId)") else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    print("Response Data: \(String(data: data, encoding: .utf8) ?? "")")
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
    }
    
    func getPlaylistInfo() {
        getAccessToken {
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
    
    func getUserInfo() {
        getAccessToken {
            guard let url = URL(string: "https://api.spotify.com/v1/me") else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    print("Response Data: \(String(data: data, encoding: .utf8) ?? "")")
                    do {
                        let user = try JSONDecoder().decode(UserModel.self, from: data)
                        DispatchQueue.main.async {
                            self.userInfo = "Country: \(user.country)\nDisplay Name: \(user.display_name)\nEmail: \(user.email)\nFollowers: \(user.followers.total)\nProduct: \(user.product)"
                        }
                    } catch {
                        print(error.localizedDescription)
                        self.error = "Error parsing user info: \(error.localizedDescription)"
                    }
                } else if let error = error {
                    self.error = "Network error: \(error.localizedDescription)"
                }
            }.resume()
        }
    }
}

#Preview {
    HomeView()
}
