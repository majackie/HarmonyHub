//
//  PlaylistView.swift
//  HarmonyHub
//
//  Created by Jonathan Liu on 2023-11-28.
//

import SwiftUI

struct PlaylistView: View {
    @EnvironmentObject var functionViewModel: FunctionsViewModel
    var body: some View {
        HStack {
            Text("Playlist ID: ")
                .foregroundColor(.white)
            TextField("", text: $functionViewModel.playlistId)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(.black)
        }
        .padding(.top)
        .foregroundColor(.white)
        
        Button("Submit") {
            functionViewModel.getPlaylistInfo()
        }
        .buttonStyle(.borderedProminent)
        .tint(Color(red: 29/255, green: 285/255, blue: 84/255))
        .foregroundColor(.black)
        if (functionViewModel.playlistInfo != nil) {
            HStack (alignment: .top){
                VStack(alignment: .leading) {
                    Text("Playlist: \(functionViewModel.playlistInfo?.name ?? "")")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold, design: .serif))
                    
                    Divider().overlay(Color(.white))
                    
                    Text("Owner: \(functionViewModel.playlistInfo?.owner?.display_name ?? "")")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .none, design: .monospaced))
                        .padding(.top)
                    Text(functionViewModel.playlistInfo?.tracks?.total ?? 0 > 0 ?
                         "Total Tracks: \(functionViewModel.playlistInfo!.tracks!.total!)" : "Total Tracks: ")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .none, design: .monospaced))
                }
                
                Spacer()
                
                AsyncImage(url: URL(string: functionViewModel.playlistInfo?.images?.first?.url ?? "")) { image in
                    image.resizable()
                } placeholder: {
                    // ProgressView()
                }
                .frame(width: 120, height: 120)
            }
            .padding(.top)
        }
    }
}

#Preview {
    PlaylistView()
}
