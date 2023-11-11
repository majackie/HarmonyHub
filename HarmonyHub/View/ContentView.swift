//
//  ContentView.swift
//  HarmonyHub
//
//  Created by Jackie Ma on 2023-11-09.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            AboutView()
                .tabItem {
                    Image(systemName: "person")
                    Text("About")
                }
        }
    }
}

#Preview {
    ContentView()
}
