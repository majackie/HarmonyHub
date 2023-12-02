//
//  ContentView.swift
//  HarmonyHub
//
//  Created by Jackie Ma on 2023-11-09.
//

import SwiftUI

struct ContentView: View {
    var tabBarViewModel = TabBarViewModel()
    var body: some View {
        TabView {
            Group {
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                            .foregroundColor(Color(red: 29/255, green: 285/255, blue: 84/255))
                        Text("Home")
                            .foregroundColor(Color(red: 29/255, green: 285/255, blue: 84/255))
                    }
                    .toolbar(.visible, for: .tabBar)
                AboutView()
                    .tabItem {
                        Image(systemName: "person")
                            .foregroundColor(Color(red: 29255, green: 285/255, blue: 84/255))
                        Text("About")
                    }
            }
        }
        .tint(Color(red: 29/255, green: 285/255, blue: 84/255)) // Set accent color for the entire TabView
        .onAppear() {
            tabBarViewModel.changeDefaultUITabBar()
        }
    }
}

#Preview {
    ContentView()
}
