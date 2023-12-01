//
//  AlbumView.swift
//  HarmonyHub
//
//  Created by Jonathan Liu on 2023-11-28.
//

import SwiftUI

struct AlbumView: View {
    @EnvironmentObject var functionViewModel: FunctionsViewModel

    var body: some View {
        HStack {
            Text("Album ID: ")
                .foregroundStyle(.white)
            TextField("", text: $functionViewModel.albumId)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(.black)
        }
        .padding(.top)
        
        Button("Submit") {
            functionViewModel.getAlbumInfo()
        }
        .buttonStyle(.borderedProminent)
        .tint(Color(red: 29/255, green: 285/255, blue: 84/255))
        .foregroundColor(.black)
        if (functionViewModel.albumInfo != nil) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Album: \(functionViewModel.albumInfo?.name ?? "")")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold, design: .serif))
                    Divider().overlay(Color(.white))

                    if let artists = functionViewModel.albumInfo?.artists {
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
                    Text("Release Date: \(functionViewModel.albumInfo?.release_date ?? "")")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .none, design: .monospaced))
                    Text(functionViewModel.albumInfo?.total_tracks ?? 0 > 0 ? "Total Tracks: \(functionViewModel.albumInfo!.total_tracks!)" : "Total Tracks: ")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .none, design: .monospaced))
                }
                
                Spacer()
                
                AsyncImage(url: URL(string: functionViewModel.albumInfo?.images?.first?.url ?? "")) { image in
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
    AlbumView()
}
