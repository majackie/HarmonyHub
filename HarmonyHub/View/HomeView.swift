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
let redirectUri = "myapp://auth/callback"

struct HomeView: View {
    @State private var accessTokenGeneral: String = ""
    @State private var accessTokenUser: String = ""
    
    // empty string
    @State private var artistId: String = "0Y4inQK6OespitzD6ijMwb"
    @State private var albumId: String = "43uErencdmuTRFZPG3zXL1"
    @State private var playlistId: String = "37i9dQZF1DZ06evO0vFpVC"
    @State private var userId: String = "_beepee"
    
    @State private var artistInfo: ArtistModel? = nil
    @State private var albumInfo: AlbumModel? = nil
    @State private var playlistInfo: PlaylistModel? = nil
    @State private var userInfo: UserModel? = nil
    @State private var selfInfo: UserModel? = nil
    @State private var topArtistInfo: TopArtistModel? = nil
    @State private var topTrackInfo: TopTrackModel? = nil
    @State private var severalTrackIdArray: [String]? = []
    @State private var audioFeatureArray: AudioFeatureModel? = nil
    
    @State private var error: String? = nil
    @State private var selectedItem: String = ""
    @State private var selectedType: String = "self"
    @State private var selectedTimeRange: String = "short_term"
    @State private var selectedLimit: String = "5"
    
    var body: some View {
        VStack(alignment: .leading) {
            Picker("Select Item", selection: $selectedItem) {
                Text("Artist").tag("Artist")
                Text("Album").tag("Album")
                Text("Playlist").tag("Playlist")
                Text("User").tag("User")
                Text("Self").tag("Self")
            }
            .pickerStyle(SegmentedPickerStyle())
            
            if selectedItem == "Artist" {
                HStack {
                    Text("Artist ID: ")
                    TextField("", text: $artistId)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Button("Submit") {
                    getArtistInfo()
                }
                .buttonStyle(.borderedProminent)
                
                if (artistInfo != nil) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Artist: \(artistInfo?.name ?? "")")
                            Text(artistInfo?.followers?.total ?? 0 > 0 ? "Followers: \(artistInfo!.followers!.total!)" : "Followers: ")
                            if let genres = artistInfo?.genres {
                                Text("Genres:")
                                ForEach(genres, id: \.self) { genre in
                                    Text("- \(genre)")
                                }
                            }
                            Text(artistInfo?.popularity ?? 0 > 0 ? "Popularity: \(artistInfo!.popularity!)" : "Popularity: ")
                        }
                        
                        Spacer()
                        
                        AsyncImage(url: URL(string: artistInfo?.images?.first?.url ?? "")) { image in
                            image.resizable()
                        } placeholder: {
                            // ProgressView()
                        }
                        .frame(width: 120, height: 120)
                    }
                }
            } else if selectedItem == "Album" {
                HStack {
                    Text("Album ID: ")
                    TextField("", text: $albumId)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Button("Submit") {
                    getAlbumInfo()
                }
                .buttonStyle(.borderedProminent)
                
                if (albumInfo != nil) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Album: \(albumInfo?.name ?? "")")
                            if let artists = albumInfo?.artists {
                                Text("Artists:")
                                ForEach(artists, id: \.id) { artist in
                                    Text("- \(artist.name ?? "")")
                                }
                            }
                            Text("Release Date: \(albumInfo?.release_date ?? "")")
                            Text(albumInfo?.total_tracks ?? 0 > 0 ? "Total Tracks: \(albumInfo!.total_tracks!)" : "Total Tracks: ")
                        }
                        
                        Spacer()
                        
                        AsyncImage(url: URL(string: albumInfo?.images?.first?.url ?? "")) { image in
                            image.resizable()
                        } placeholder: {
                            // ProgressView()
                        }
                        .frame(width: 120, height: 120)
                    }
                }
            } else if selectedItem == "Playlist" {
                HStack {
                    Text("Playlist ID: ")
                    TextField("", text: $playlistId)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Button("Submit") {
                    getPlaylistInfo()
                }
                .buttonStyle(.borderedProminent)
                
                if (playlistInfo != nil) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Playlist: \(playlistInfo?.name ?? "")")
                            Text("Owner: \(playlistInfo?.owner?.display_name ?? "")")
                        }
                        
                        Spacer()
                        
                        AsyncImage(url: URL(string: playlistInfo?.images?.first?.url ?? "")) { image in
                            image.resizable()
                        } placeholder: {
                            // ProgressView()
                        }
                        .frame(width: 120, height: 120)
                    }
                }
            } else if selectedItem == "User" {
                HStack {
                    Text("User ID: ")
                    TextField("", text: $userId)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Button("Submit") {
                    getUserInfo()
                }
                .buttonStyle(.borderedProminent)
                
                if (userInfo != nil) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Name: \(userInfo?.display_name ?? "")")
                        }
                        
                        Spacer()
                        
                        AsyncImage(url: URL(string: userInfo?.images?.first?.url ?? "")) { image in
                            image.resizable()
                        } placeholder: {
                            // ProgressView()
                        }
                        .frame(width: 120, height: 120)
                    }
                }
            } else if selectedItem == "Self" {
                if accessTokenUser.isEmpty {
                    Button("Authenticate") {
                        authenticateUser()
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    HStack{
                        Text("Type:")
                        Picker("Select Type", selection: $selectedType) {
                            Text("Self").tag("self")
                            Text("Artists").tag("artists")
                            Text("Tracks").tag("tracks")
                        }
                        
                        Spacer()
                        
                        if (selectedType != "self") {
                            Text("Time:")
                            Picker("Select Time", selection: $selectedTimeRange) {
                                Text("Four Weeks").tag("short_term")
                                Text("Six Months").tag("medium_term")
                                Text("Years").tag("long_term")
                            }
                        }
                    }
                    HStack {
                        Button("Submit") {
                            if (selectedType == "self") {
                                getSelfInfo()
                            } else if (selectedType == "artists") {
                                getTopArtistInfo()
                            } else if (selectedType == "tracks") {
                                getTopTrackInfo()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Spacer()
                        
                        if (selectedType == "tracks" && topTrackInfo != nil) {
                            Button("Generate") {
                                getSeveralTracks()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    
                    if (selectedType == "self" && selfInfo != nil) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Country: \(selfInfo?.country ?? "")")
                                Text("Display Name: \(selfInfo?.display_name ?? "")")
                                Text("Email: \(selfInfo?.email ?? "")")
                                Text(selfInfo?.followers?.total ?? 0 > 0 ? "Followers: \(selfInfo!.followers!.total!)" : "Followers: ")
                                Text("Premium: \(selfInfo?.product ?? "")")
                            }
                            
                            Spacer()
                            
                            AsyncImage(url: URL(string: selfInfo?.images?.first?.url ?? "")) { image in
                                image.resizable()
                            } placeholder: {
                                // ProgressView()
                            }
                            .frame(width: 120, height: 120)
                        }
                    } else if (selectedType == "artists" && topArtistInfo != nil) {
                        if let topItems = topArtistInfo?.items {
                            List(topItems, id: \.id) { topItem in
                                HStack{
                                    VStack(alignment: .leading) {
                                        Text("Artist: \(topItem.name ?? "")")
                                        Text(topItem.popularity ?? 0 > 0 ? "Popularity: \(topItem.popularity!)" : "Popularity: ")
                                        
                                        if let genres = topItem.genres {
                                            Text("Genres:")
                                            ForEach(genres, id: \.self) { genre in
                                                Text("- \(genre)")
                                            }
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    AsyncImage(url: URL(string: topItem.images?.first?.url ?? "")) { image in
                                        image.resizable()
                                    } placeholder: {
                                        // ProgressView()
                                    }
                                    .frame(width: 120, height: 120)
                                }
                            }
                            .listStyle(PlainListStyle())
                        }
                    } else if (selectedType == "tracks" && topTrackInfo != nil) {
                        if let topTracks = topTrackInfo?.items {
                            List(topTracks, id: \.id) { topTrack in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Track: \(topTrack.name ?? "")")
                                        if let album = topTrack.album {
                                            Text("Album: \(album.name ?? "")")
                                        }
                                        if let artists = topTrack.artists {
                                            Text("Artists:")
                                            ForEach(artists, id: \.id) { artist in
                                                Text("- \(artist.name ?? "")")
                                            }
                                        }
                                        Text(topTrack.popularity ?? 0 > 0 ? "Popularity: \(topTrack.popularity!)" : "Popularity: ")
                                    }
                                    
                                    Spacer()
                                    
                                    AsyncImage(url: URL(string: topTrack.album?.images?.first?.url ?? "")) { image in
                                        image.resizable()
                                    } placeholder: {
                                        // ProgressView()
                                    }
                                    .frame(width: 120, height: 120)
                                }
                            }
                            .listStyle(PlainListStyle())
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .onOpenURL { url in
            extractAccessToken(from: url)
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
    
    func authenticateUser() {
        let authURLString = "https://accounts.spotify.com/authorize" +
        "?client_id=\(clientId)" +
        "&response_type=token" +
        "&redirect_uri=\(redirectUri)" +
        "&scope=user-read-private" +
        "%20user-read-email" +
        "%20user-top-read"
        
        if let authURL = URL(string: authURLString) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let safariViewController = SFSafariViewController(url: authURL)
                windowScene.windows.first?.rootViewController?.present(safariViewController, animated: true, completion: nil)
            }
        }
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
            guard let url = URL(string: "https://api.spotify.com/v1/artists/\(artistId)") else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(accessTokenGeneral)", forHTTPHeaderField: "Authorization")
            
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
            guard let url = URL(string: "https://api.spotify.com/v1/albums/\(albumId)") else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(accessTokenGeneral)", forHTTPHeaderField: "Authorization")
            
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
            guard let url = URL(string: "https://api.spotify.com/v1/playlists/\(playlistId)") else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(accessTokenGeneral)", forHTTPHeaderField: "Authorization")
            
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
    
    func getUserInfo() {
        getAccessToken {
            guard let url = URL(string: "https://api.spotify.com/v1/users/\(userId)") else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(accessTokenGeneral)", forHTTPHeaderField: "Authorization")
            
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
    
    func getSeveralTracks() {
        self.severalTrackIdArray!.removeAll()
        if selectedType == "tracks" && topTrackInfo != nil {
            if let topTracks = topTrackInfo?.items {
                for topTrack in topTracks {
                    if let trackId = topTrack.id {
                        self.severalTrackIdArray!.append(trackId)
                    }
                }
            }
        }
        
        let encodedTrackIdsString = severalTrackIdArray!.joined(separator: "%2C")
        
        getAccessToken {
            guard let url = URL(string: "https://api.spotify.com/v1/audio-features?ids=\(encodedTrackIdsString)") else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(accessTokenGeneral)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    print("Response Data:\n\(String(data: data, encoding: .utf8) ?? "")")
                    do {
                        let user = try JSONDecoder().decode(AudioFeatureModel.self, from: data)
                        DispatchQueue.main.async {
                            self.audioFeatureArray = user
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
