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
    @State private var albumId: String = "1HMLpmZAnNyl9pxvOnTovV"
    @State private var playlistId: String = "4zfgRmGv5piy8B2FbBuJx4"
    @State private var userId: String = "_beepee"
    
    @State private var artistInfo: ArtistModel? = nil
    @State private var albumInfo: AlbumModel? = nil
    @State private var playlistInfo: PlaylistModel? = nil
    @State private var userInfo: UserModel? = nil
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
                    HStack {
                        Text("Artist ID: ")
                        TextField("", text: $artistId)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .foregroundColor(.black)
                    }
                    .foregroundColor(.white)
                    .padding(.top)
                    
                    Button("Submit") {
                        getArtistInfo()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(red: 29/255, green: 285/255, blue: 84/255))
                    .foregroundColor(.black)
                
                    if (artistInfo != nil) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Text("Artist: \(artistInfo?.name ?? "")")
                                    .font(.system(size: 20, weight: .bold, design: .serif))
                                    .foregroundColor(.white)
                                Divider().overlay(Color(.white))

                                Text(artistInfo?.followers?.total ?? 0 > 0 ? "Followers: \(artistInfo!.followers!.total!)" : "Followers: ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .none, design: .monospaced))
                                    .padding(.top)

                                if let genres = artistInfo?.genres {
                                    Text("Genres:")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16, weight: .none, design: .monospaced))

                                    ForEach(genres, id: \.self) { genre in
                                        Text("- \(genre)")
                                            .foregroundColor(.white)
                                            .padding(.leading, 20)
                                            .font(.system(size: 16, weight: .none, design: .monospaced))

                                    }
                                }
                                Text(artistInfo?.popularity ?? 0 > 0 ? "Popularity: \(artistInfo!.popularity!)" : "Popularity: ")
                                    .foregroundColor(.black)

                            }
                            
                            Spacer()
                            
                            AsyncImage(url: URL(string: artistInfo?.images?.first?.url ?? "")) { image in
                                image.resizable()
                            } placeholder: {
                                // ProgressView()
                            }
                            .frame(width: 120, height: 120, alignment: .topLeading)
                        }
                        .padding(.top)
                    }
                } else if selectedItem == "Album" {
                    HStack {
                        Text("Album ID: ")
                            .foregroundStyle(.white)
                        TextField("", text: $albumId)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .foregroundColor(.black)
                    }
                    .padding(.top)
                    
                    Button("Submit") {
                        getAlbumInfo()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(red: 29/255, green: 285/255, blue: 84/255))
                    .foregroundColor(.black)
                    if (albumInfo != nil) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Text("Album: \(albumInfo?.name ?? "")")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .bold, design: .serif))
                                Divider().overlay(Color(.white))

                                if let artists = albumInfo?.artists {
                                    Text("Artists:")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16, weight: .none, design: .monospaced))
                                        .padding(.top)

                                    ForEach(artists, id: \.id) { artist in
                                        Text("- \(artist.name ?? "")")
                                    }
                                    .foregroundColor(.white)
                                    .padding(.leading, 20)
                                    .font(.system(size: 16, weight: .none, design: .monospaced))
                                }
                                Text("Release Date: \(albumInfo?.release_date ?? "")")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .none, design: .monospaced))
                                Text(albumInfo?.total_tracks ?? 0 > 0 ? "Total Tracks: \(albumInfo!.total_tracks!)" : "Total Tracks: ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .none, design: .monospaced))
                            }
                            
                            Spacer()
                            
                            AsyncImage(url: URL(string: albumInfo?.images?.first?.url ?? "")) { image in
                                image.resizable()
                            } placeholder: {
                                // ProgressView()
                            }
                            .frame(width: 120, height: 120)
                        }
                        .padding(.top)
                    }
                } else if selectedItem == "Playlist" {
                    HStack {
                        Text("Playlist ID: ")
                            .foregroundColor(.white)
                        TextField("", text: $playlistId)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .foregroundColor(.black)
                    }
                    .padding(.top)
                    .foregroundColor(.white)
                    
                    Button("Submit") {
                        getPlaylistInfo()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(red: 29/255, green: 285/255, blue: 84/255))
                    .foregroundColor(.black)
                    if (playlistInfo != nil) {
                        HStack (alignment: .top){
                            VStack(alignment: .leading) {
                                Text("Playlist: \(playlistInfo?.name ?? "")")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .bold, design: .serif))
                                
                                Divider().overlay(Color(.white))
                                
                                Text("Owner: \(playlistInfo?.owner?.display_name ?? "")")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .none, design: .monospaced))
                                    .padding(.top)
                                Text(playlistInfo?.tracks?.total ?? 0 > 0 ?
                                     "Total Tracks: \(playlistInfo!.tracks!.total!)" : "Total Tracks: ")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .none, design: .monospaced))
                            }
                            
                            Spacer()
                            
                            AsyncImage(url: URL(string: playlistInfo?.images?.first?.url ?? "")) { image in
                                image.resizable()
                            } placeholder: {
                                // ProgressView()
                            }
                            .frame(width: 120, height: 120)
                        }
                        .padding(.top)
                    }
                } else if selectedItem == "User" {
                    HStack {
                        Text("User ID: ")
                            .foregroundColor(.white)
                        TextField("", text: $userId)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .foregroundColor(.black)
                    }
                    .padding(.top)
                    .foregroundColor(.white)
                    
                    Button("Submit") {
                        getUserInfo()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(red: 29/255, green: 285/255, blue: 84/255))
                    .foregroundColor(.black)
                    if (userInfo != nil) {
                        HStack (alignment: .top){
                            VStack(alignment: .leading) {
                                Text("Name: \(userInfo?.display_name ?? "")")
                                    .foregroundColor(.white)
                            }
                            .padding(.top)
                            Spacer()
                            
                            AsyncImage(url: URL(string: userInfo?.images?.first?.url ?? "")) { image in
                                image.resizable()
                            } placeholder: {
                                // ProgressView()
                            }
                            .frame(width: 120, height: 120)
                            .padding(.top)
                        }
                    }
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
                            
                            if (selectedType == "artists" && topArtistInfo != nil && selfInfo != nil) {
                                Button("Generate") {
                                    getRecommendationArtists()
                                }
                                .buttonStyle(.borderedProminent)
                            } else if (selectedType == "tracks" && topTrackInfo != nil && selfInfo != nil) {
                                Button("Generate") {
                                    getRecommendationTracks()
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
