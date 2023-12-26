//
//  FunctionsViewModel.swift
//  HarmonyHub
//
//  Created by Jonathan Liu on 2023-11-28.
//

import Foundation
import SafariServices

class FunctionsViewModel : ObservableObject {
    @Published var accessTokenGeneral: String = ""
    @Published var accessTokenUser: String = ""
    
    //empty string
    @Published var artistId: String = "0Y4inQK6OespitzD6ijMwb"
    @Published var albumId: String = "1HMLpmZAnNyl9pxvOnTovV"
    @Published var playlistId: String = "4zfgRmGv5piy8B2FbBuJx4"
    @Published var userId: String = "_beepee"
    
    @Published var artistInfo: ArtistModel? = nil
    @Published var albumInfo: AlbumModel? = nil
    @Published var playlistInfo: PlaylistModel? = nil
    @Published var userInfo: UserModel? = nil
    @Published var selfInfo: UserModel? = nil
    @Published var topArtistInfo: TopArtistModel? = nil
    @Published var topTrackInfo: TopTrackModel? = nil
    @Published var topArtistIdArray: [String]? = []
    @Published var topTrackIdArray: [String]? = []
    @Published var artistRecommendationInfo: RecommendationModel? = nil
    @Published var trackRecommendationInfo: RecommendationModel? = nil
    @Published var newPlaylistInfo: PlaylistModel? = nil
    @Published var artistRecommendationUriArray: [String]? = []
    @Published var trackRecommendationUriArray: [String]? = []
    
    @Published var error: String? = nil
    @Published var selectedType: String = "self"
    @Published var selectedTimeRange: String = "short_term"
    @Published var selectedLimit: String = "5"
    
    func getUserInfo() {
        getAccessToken {
            guard let url = URL(string: "https://api.spotify.com/v1/users/\(self.userId)") else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(self.accessTokenGeneral)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        let user = try JSONDecoder().decode(UserModel.self, from: data)
                        DispatchQueue.main.async {
                            self.userInfo = user
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
    
    func getAccessToken(completion: @escaping () -> Void) {
        if let storedAccessToken = UserDefaults.standard.string(forKey: "accessToken"),
           let expirationDate = UserDefaults.standard.object(forKey: "accessTokenExpirationDate") as? Date,
           Date() < expirationDate {
            self.accessTokenGeneral = storedAccessToken
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
                        self.accessTokenGeneral = accessToken
                        completion()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }

    
    func extractAccessToken(from url: URL) {
        if let fragment = url.fragment {
            let parameters = fragment
                .components(separatedBy: "&")
                .map { $0.components(separatedBy: "=") }
                .reduce(into: [String: String]()) { result, pair in
                    if pair.count == 2 {
                        result[pair[0]] = pair[1]
                    }
                }
            
            if let accessTokenUser = parameters["access_token"] {
                self.accessTokenUser = accessTokenUser
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootViewController = windowScene.windows.first?.rootViewController {
                    if let presentedViewController = rootViewController.presentedViewController as? SFSafariViewController {
                        presentedViewController.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func getArtistInfo() {
        getAccessToken {
            guard let url = URL(string: "https://api.spotify.com/v1/artists/\(self.artistId)") else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(self.accessTokenGeneral)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        let artist = try JSONDecoder().decode(ArtistModel.self, from: data)
                        DispatchQueue.main.async {
                            self.artistInfo = artist
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
            guard let url = URL(string: "https://api.spotify.com/v1/albums/\(self.albumId)") else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(self.accessTokenGeneral)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        let album = try JSONDecoder().decode(AlbumModel.self, from: data)
                        DispatchQueue.main.async {
                            self.albumInfo = album
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
            guard let url = URL(string: "https://api.spotify.com/v1/playlists/\(self.playlistId)") else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(self.accessTokenGeneral)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        let playlist = try JSONDecoder().decode(PlaylistModel.self, from: data)
                        DispatchQueue.main.async {
                            self.playlistInfo = playlist
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
    
    
    func getSelfInfo() {
        guard let url = URL(string: "https://api.spotify.com/v1/me") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessTokenUser)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let user = try JSONDecoder().decode(UserModel.self, from: data)
                    DispatchQueue.main.async {
                        self.selfInfo = user
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
    
    func getTopArtistInfo() {
        guard let url = URL(string: "https://api.spotify.com/v1/me/top/\(selectedType)?time_range=\(selectedTimeRange)&limit=\(selectedLimit)&offset=0") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessTokenUser)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let user = try JSONDecoder().decode(TopArtistModel.self, from: data)
                    DispatchQueue.main.async {
                        self.topArtistInfo = user
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
    
    func getTopTrackInfo() {
        guard let url = URL(string: "https://api.spotify.com/v1/me/top/\(selectedType)?time_range=\(selectedTimeRange)&limit=\(selectedLimit)&offset=0") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessTokenUser)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let user = try JSONDecoder().decode(TopTrackModel.self, from: data)
                    DispatchQueue.main.async {
                        self.topTrackInfo = user
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
    
    func getRecommendationArtists() {
        self.topArtistIdArray!.removeAll()
        if selectedType == "artists" && topArtistInfo != nil {
            if let topArtists = topArtistInfo?.items {
                for topArtist in topArtists {
                    if let artistId = topArtist.id {
                        self.topArtistIdArray!.append(artistId)
                    }
                }
            }
        }
        
        let encodedString = topArtistIdArray!.joined(separator: "%2C")
        
        getAccessToken {
            guard let url = URL(string: "https://api.spotify.com/v1/recommendations?seed_artists=\(encodedString)") else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(self.accessTokenGeneral)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        let user = try JSONDecoder().decode(RecommendationModel.self, from: data)
                        DispatchQueue.main.async {
                            self.artistRecommendationInfo = user
                            self.createPlaylist()
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
    
    func getRecommendationTracks() {
        self.topTrackIdArray!.removeAll()
        if selectedType == "tracks" && topTrackInfo != nil {
            if let topTracks = topTrackInfo?.items {
                for topTrack in topTracks {
                    if let trackId = topTrack.id {
                        self.topTrackIdArray!.append(trackId)
                    }
                }
            }
        }
        
        let encodedString = topTrackIdArray!.joined(separator: "%2C")
        
        getAccessToken {
            guard let url = URL(string: "https://api.spotify.com/v1/recommendations?seed_tracks=\(encodedString)") else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(self.accessTokenGeneral)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        let user = try JSONDecoder().decode(RecommendationModel.self, from: data)
                        DispatchQueue.main.async {
                            self.trackRecommendationInfo = user
                            self.createPlaylist()
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
    
    func createPlaylist() {
        guard let url = URL(string: "https://api.spotify.com/v1/users/\(selfInfo!.id!)/playlists") else {
            return
        }
        
        let playlistName = Int(Date().timeIntervalSince1970 * 1000)
        let playlistData: [String: Any] = [
            "name": "\(playlistName)"
        ]
        
        guard let requestBody = try? JSONSerialization.data(withJSONObject: playlistData) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessTokenUser)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let user = try JSONDecoder().decode(PlaylistModel.self, from: data)
                    DispatchQueue.main.async {
                        self.newPlaylistInfo = user
                        self.addTrackToPlaylist()
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
    
    func addTrackToPlaylist() {
        var playlistData: [String: Any] = [:]
        
        if selectedType == "artists" && topArtistInfo != nil {
            self.artistRecommendationUriArray!.removeAll()
            if let artistRecommendation = artistRecommendationInfo?.tracks {
                for item in artistRecommendation {
                    if let artistUri = item.uri {
                        self.artistRecommendationUriArray!.append(artistUri)
                    }
                }
            }
            playlistData["uris"] = self.artistRecommendationUriArray!
        }
        
        if selectedType == "tracks" && topTrackInfo != nil {
            self.trackRecommendationUriArray!.removeAll()
            if let trackRecommendation = trackRecommendationInfo?.tracks {
                for item in trackRecommendation {
                    if let trackUri = item.uri {
                        self.trackRecommendationUriArray!.append(trackUri)
                    }
                }
            }
            playlistData["uris"] = self.trackRecommendationUriArray!
        }
        
        guard let url = URL(string: "https://api.spotify.com/v1/playlists/\(newPlaylistInfo!.id!)/tracks") else {
            return
        }
        
        guard let requestBody = try? JSONSerialization.data(withJSONObject: playlistData) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessTokenUser)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            self.openSpotifyPlaylist()
        }.resume()
    }
    
    func openSpotifyPlaylist() {
        DispatchQueue.main.async {
            if let url = URL(string: "https://open.spotify.com/playlist/\(self.newPlaylistInfo!.id!)") {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    let safariViewController = SFSafariViewController(url: url)
                    windowScene.windows.first?.rootViewController?.present(safariViewController, animated: true, completion: nil)
                }
            }
        }
    }
}
