//
//  TabBarViewModel.swift
//  HarmonyHub
//
//  Created by Jonathan Liu on 2023-12-01.
//

import Foundation
import UIKit
import SwiftUI

class TabBarViewModel {
    func changeDefaultUITabBar() {
        //credit to https://medium.com/@sai.kante/how-to-style-tabviews-tab-bar-in-swiftui-f05932da64c5
        //for explaining how to set different UITabBarAppearance settings.
        let standardAppearance = UITabBarAppearance()
        standardAppearance.backgroundColor = UIColor(Color.white)
        standardAppearance.shadowColor = UIColor(Color.black)
//                standardAppearance.backgroundImage = UIImage(named: "custom_bg")
        
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = UIColor(Color.gray)
        itemAppearance.normal.badgeBackgroundColor = UIColor(Color.gray)
        itemAppearance.selected.iconColor = UIColor(Color(red: 29/255, green: 285/255, blue: 84/255))
        itemAppearance.selected.badgeBackgroundColor = UIColor(Color(red: 29/255, green: 285/255, blue: 84/255))
        standardAppearance.inlineLayoutAppearance = itemAppearance
        standardAppearance.stackedLayoutAppearance = itemAppearance
        standardAppearance.compactInlineLayoutAppearance = itemAppearance
        UITabBar.appearance().standardAppearance = standardAppearance
    }
}
