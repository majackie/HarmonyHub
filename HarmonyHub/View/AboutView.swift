//
//  AboutView.swift
//  HarmonyHub
//
//  Created by Jackie Ma on 2023-11-11.
//

import Foundation
import SwiftUI

struct AboutView: View {
    var body: some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea()
            VStack {
                Text("A00889988 | Jackie Ma")
                Text("A01256345 | Jonathan Liu")
                Text("A01295107 | Wyman Ng")
            }
            .foregroundColor(.white)
        }
    }
}

#Preview {
    AboutView()
}
