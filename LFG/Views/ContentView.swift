//
//  ContentView.swift
//  LFG
//
//  Created by victor lieu on 2020-10-21.
//  Copyright © 2020 LFG-APP. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    init() {
      setupTabBar()
    }
    
    var body: some View {
        TabView {
            if #available(iOS 14.0, *) {
                BrowseView()
                    .tabItem {
                        Image(systemName: "gamecontroller")
                        Text("Browse")
                    }
            } else {
                // Fallback on earlier versions
            }
            GroupsView()
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Groups")
                }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
    }
}

extension ContentView {
  func setupTabBar() {
    UITabBar.appearance().barTintColor = .black
    UITabBar.appearance().tintColor = .blue
    UITabBar.appearance().layer.borderColor = UIColor.clear.cgColor
    UITabBar.appearance().clipsToBounds = true
  }
}
