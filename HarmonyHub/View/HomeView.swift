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
    @StateObject var functionViewModel = FunctionsViewModel()
    @State private var accessTokenGeneral: String = ""
    @State private var accessTokenUser: String = ""
    
    @State private var selfInfo: UserModel? = nil
    @State private var topArtistInfo: TopArtistModel? = nil
    @State private var topTrackInfo: TopTrackModel? = nil
    @State private var topArtistIdArray: [String]? = []
    @State private var topTrackIdArray: [String]? = []
    @State private var artistRecommendationInfo: RecommendationModel? = nil
    @State private var trackRecommendationInfo: RecommendationModel? = nil
    @State private var newPlaylistInfo: PlaylistModel? = nil
    @State private var artistRecommendationUriArray: [String]? = []
    @State private var trackRecommendationUriArray: [String]? = []
    
    @State private var error: String? = nil
    @State private var selectedItem: String = ""
    @State private var selectedType: String = "self"
    @State private var selectedTimeRange: String = "short_term"
    @State private var selectedLimit: String = "5"
    
    var body: some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                Picker("Select Item", selection: $selectedItem) {
                    Text("Artist").tag("Artist")
                    Text("Album").tag("Album")
                    Text("Playlist").tag("Playlist")
                    Text("User").tag("User")
                    Text("Self").tag("Self")
                }
                .background(Color(red: 83/255, green: 83/255, blue: 83/255))
                .pickerStyle(SegmentedPickerStyle())
                .foregroundColor(.white)
                
                
                if selectedItem == "Artist" {
                    ArtistView()
                } else if selectedItem == "Album" {
                    AlbumView()
                } else if selectedItem == "Playlist" {
                    PlaylistView()
                } else if selectedItem == "User" {
                    UserView()
                } else if selectedItem == "Self" {
                    if accessTokenUser.isEmpty {
                        Button("Authenticate") {
                            authenticateUser()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color(red: 29/255, green: 285/255, blue: 84/255))
                        .foregroundColor(.black)
                    } else {
                        HStack{
                            Text("Type:")
                                .foregroundColor(Color(red: 29/255, green: 285/255, blue: 84/255))
                            Picker("Select Type", selection: $selectedType) {
                                Text("Self").tag("self")
                                Text("Artists").tag("artists")
                                Text("Tracks").tag("tracks")
                            }
                            .tint(.white)
                            
                            Spacer()
                            
                            if (selectedType != "self") {
                                Text("Time:")
                                    .foregroundColor(Color(red: 29/255, green: 285/255, blue: 84/255))
                                Picker("Select Time", selection: $selectedTimeRange) {
                                    Text("Four Weeks").tag("short_term")
                                    Text("Six Months").tag("medium_term")
                                    Text("Years").tag("long_term")
                                }
                                .tint(.white)
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
                            .tint(Color(red: 29/255, green: 285/255, blue: 84/255))
                            .foregroundColor(.black)
                            
                            Spacer()
                            
                            if (selectedType == "artists" && topArtistInfo != nil  && selfInfo != nil) {
                                Button("Generate") {
                                    getRecommendationArtists()
                                }
                                .buttonStyle(.borderedProminent)
                                .foregroundColor(.black)
                                .tint(Color(red: 29/255, green: 285/255, blue: 84/255))
                            } else if (selectedType == "tracks" && topTrackInfo != nil  && selfInfo != nil) {
                                Button("Generate") {
                                    getRecommendationTracks()
                                }
                                .buttonStyle(.borderedProminent)
                                .foregroundColor(.black)
                                .tint(Color(red: 29/255, green: 285/255, blue: 84/255))
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
        .environmentObject(functionViewModel)
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
        "%20user-top-read" +
        "%20playlist-modify-public"
        
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
            request.setValue("Bearer \(accessTokenGeneral)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        let user = try JSONDecoder().decode(RecommendationModel.self, from: data)
                        DispatchQueue.main.async {
                            self.artistRecommendationInfo = user
                            createPlaylist()
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
            request.setValue("Bearer \(accessTokenGeneral)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        let user = try JSONDecoder().decode(RecommendationModel.self, from: data)
                        DispatchQueue.main.async {
                            self.trackRecommendationInfo = user
                            createPlaylist()
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
                        addTrackToPlaylist()
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
            openSpotifyPlaylist()
        }.resume()
    }
    
    func openSpotifyPlaylist() {
        DispatchQueue.main.async {
            if let url = URL(string: "https://open.spotify.com/playlist/\(newPlaylistInfo!.id!)") {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    let safariViewController = SFSafariViewController(url: url)
                    windowScene.windows.first?.rootViewController?.present(safariViewController, animated: true, completion: nil)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
