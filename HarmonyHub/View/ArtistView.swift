//
//  ArtistView.swift
//  HarmonyHub
//
//  Created by Jonathan Liu on 2023-11-28.
//

import SwiftUI

struct ArtistView: View {
    @EnvironmentObject var functionViewModel: FunctionsViewModel
    var body: some View {
        HStack {
            Text("Artist ID: ")
            TextField("", text: $functionViewModel.artistId)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(.black)
        }
        .foregroundColor(.white)
        .padding(.top)
        
        Button("Submit") {
            functionViewModel.getArtistInfo()
        }
        .buttonStyle(.borderedProminent)
        .tint(Color(red: 29/255, green: 285/255, blue: 84/255))
        .foregroundColor(.black)
    
        if (functionViewModel.artistInfo != nil) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Artist: \(functionViewModel.artistInfo?.name ?? "")")
                        .font(.system(size: 20, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                    Divider().overlay(Color(.white))

                    Text(functionViewModel.artistInfo?.followers?.total ?? 0 > 0 ? "Followers: \(functionViewModel.artistInfo!.followers!.total!)" : "Followers: ")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .none, design: .monospaced))
                        .padding(.top)

                    if let genres = functionViewModel.artistInfo?.genres {
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
                    Text(functionViewModel.artistInfo?.popularity ?? 0 > 0 ? "Popularity: \(functionViewModel.artistInfo!.popularity!)" : "Popularity: ")
                        .foregroundColor(.black)

                }
                
                Spacer()
                
                AsyncImage(url: URL(string: functionViewModel.artistInfo?.images?.first?.url ?? "")) { image in
                    image.resizable()
                } placeholder: {
                    // ProgressView()
                }
                .frame(width: 120, height: 120, alignment: .topLeading)
            }
            .padding(.top)
        }
    }
}

#Preview {
    ArtistView()
}
