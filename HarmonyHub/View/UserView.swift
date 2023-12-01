//
//  UserView.swift
//  HarmonyHub
//
//  Created by Jonathan Liu on 2023-11-28.
//

import SwiftUI

struct UserView: View {
    @EnvironmentObject var functionViewModel: FunctionsViewModel
    
    var body: some View {
        HStack {
            Text("User ID: ")
                .foregroundColor(.white)
            TextField("", text: $functionViewModel.userId)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(.black)
        }
        .padding(.top)
        .foregroundColor(.white)
        
        Button("Submit") {
            functionViewModel.getUserInfo()
        }
        .buttonStyle(.borderedProminent)
        .tint(Color(red: 29/255, green: 285/255, blue: 84/255))
        .foregroundColor(.black)
        if (functionViewModel.userInfo != nil) {
            HStack (alignment: .top){
                VStack(alignment: .leading) {
                    Text("Name: \(functionViewModel.userInfo?.display_name ?? "")")
                        .foregroundColor(.white)
                }
                .padding(.top)
                Spacer()
                
                AsyncImage(url: URL(string: functionViewModel.userInfo?.images?.first?.url ?? "")) { image in
                    image.resizable()
                } placeholder: {
                    // ProgressView()
                }
                .frame(width: 120, height: 120)
                .padding(.top)
            }
        }
    }
}

#Preview {
    UserView()
}
