//
//  HomeView.swift
//  HarmonyHub
//
//  Created by Jackie Ma on 2023-11-11.
//

import Foundation
import SwiftUI
import SafariServices

let clientId = "012cd446b8764125b30398495b54511f"
let clientSecret = "902a0891d63146d988e6b11b7e332bcb"
let redirectUri = "https://github.com/majackie"
let test = "BQDRUR_oBAbIHuJhC3zF0Pc4nyT7-oNHAvG7jNxQ7qsxD1nQ98RCbxqQPdtv8Gp64gffIFTNFZMptfS9bak11wk_Cp9ZkGCWypzRKcUazVmImZvnd82JhbarupTcLAN3Xm8-GHo5Cu4l9RYR88UTpislNK1f89McYG18ca2vKNiSdQ3dTddNqNlFiBB4nKeGSAD4QFYGXX-ywJR0"

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
            
            Button("Authenticate with Spotify") {
                authenticateUser()
            }
            
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
        .onOpenURL { url in
            print(url)
            print("above")
            // Check if the URL contains the access token
            if let authenticateToken = extractAccessToken(from: url) {
                // Print the access token
                print("Authenticate Token: \(authenticateToken)")
                
                // You can store the access token wherever you need it in your app
                
            }
        }
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
            request.setValue("Bearer \(test)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    print("Response Data:\n\(String(data: data, encoding: .utf8) ?? "")")
                    do {
                        let user = try JSONDecoder().decode(UserModel.self, from: data)
                        DispatchQueue.main.async {
                            self.userInfo = "Country: \(user.country)\nDisplay Name: \(user.display_name)\nEmail: \(user.email ?? "")\nFollowers: \(user.followers.total)\nProduct: \(user.product)"
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
    
    func authenticateUser() {
        // Define the Spotify authentication URL
        let authURLString = "https://accounts.spotify.com/authorize" +
        "?client_id=\(clientId)" +
        "&response_type=token" +
        "&redirect_uri=\(redirectUri)" +
        "&scope=user-read-private" // Add the required scopes
        
        if let authURL = URL(string: authURLString) {
            // Use the first window scene to present the SafariViewController
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let safariViewController = SFSafariViewController(url: authURL)
                windowScene.windows.first?.rootViewController?.present(safariViewController, animated: true, completion: nil)
            }
        }
    }
    
    func extractAccessToken(from url: URL) -> String? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let fragment = components.fragment else {
            return nil
        }
        
        let queryParams = fragment.components(separatedBy: "&")
        for queryParam in queryParams {
            let keyValue = queryParam.components(separatedBy: "=")
            if keyValue.count == 2 && keyValue[0] == "access_token" {
                return keyValue[1]
            }
        }

        return nil
    }
}

#Preview {
    HomeView()
}
