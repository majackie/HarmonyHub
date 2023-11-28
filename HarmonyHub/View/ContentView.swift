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
            Group {
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
            .toolbarColorScheme(.light, for: .tabBar)
        }
    }
}

#Preview {
    ContentView()
}
