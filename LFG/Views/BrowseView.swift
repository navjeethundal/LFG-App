//
//  BrowseView.swift
//  LFG
//
//  Created by victor lieu on 2020-10-21.
//  Copyright © 2020 LFG-APP. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct BrowseView: View {
    
    @State var showPlatforms = false
    @State var currentPlatform = "PC"
    @State var platformImg = "pclogo"
    //@State var selectedGame = ""
    
    let layout = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
 
    @ObservedObject var gameViewModel = GameViewModel()
    var body: some View {
        NavigationView {
                    ZStack {
                        Color.black
                        // this scrollview contains the image grids for each game
                        ScrollView{
                            LazyVGrid(columns: layout, spacing: 20) {
                                ForEach(gameViewModel.games) { game in
                                    if (game.platforms.contains(currentPlatform)) {
                                        NavigationLink(destination: Posts(selectedGame: game.title, selectedPlatform: currentPlatform)) {
                                            VStack {
                                                Image(game.imagepath)
                                                .resizable()
                                                    .frame(height: 130)
                                                    .cornerRadius(15)
                                                    .overlay(
                                                        ZStack {
                                                        Text(game.title)
                                                            .font(.callout)
                                                            .padding(6)
                                                            .foregroundColor(.white)
                                                        }.background(Color.black)
                                                        .opacity(0.8)
                                                        .cornerRadius(10.0)
                                                        .padding(6),
                                                    alignment: .bottom)
                                            }
                                        }
                                    }
                                }
                            
                            }
                        }
                        .padding(.top, 20)
                        
                        // toggle platform selection menu
                        if (showPlatforms) {
                            GeometryReader {_ in
                                PlatformMenu(currentPlatform: self.$currentPlatform, platformImg: self.$platformImg, showPlatforms: self.$showPlatforms)
                            }.background(
                                Color.black.opacity(0.65)
                                .onTapGesture {
                                    self.showPlatforms.toggle()
                                }
                            )
                        }
                        
                        }
                        .navigationBarTitle("Browse", displayMode: .inline)
                        // this shows the current selected platform icon (left side of navbar)
                        .navigationBarItems(leading:
                            HStack {
                                Button(action: {
                                    self.showPlatforms.toggle()
                                }) {
                                    Image(platformImg)
                                        .resizable()
                                        .frame(width: 32.0, height: 32.0)
                                }
                            }
                        )
                
                    }

        }
}

// This view is used for selecting the desired platform
struct PlatformMenu: View {
    // Binding variables used to update state variables in BrowseView
    @Binding var currentPlatform: String
    @Binding var platformImg: String
    @Binding var showPlatforms: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            Button(action: {
                self.currentPlatform = "PC"
                self.platformImg = "pclogo"
                self.showPlatforms.toggle()
            }) {
                HStack(spacing: 12) {
                    Image("pclogo")
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                    Text("PC").foregroundColor(Color.white)
                }
            }
            
            Button(action: {
                self.currentPlatform = "PLAYSTATION"
                self.platformImg = "pslogo"
                self.showPlatforms.toggle()
            }) {
                HStack(spacing: 12) {
                    Image("pslogo")
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                    Text("Playstation").foregroundColor(Color.blue)
                }
            }
            
            Button(action: {
                self.currentPlatform = "SWITCH"
                self.platformImg = "switchlogo"
                self.showPlatforms.toggle()
            }) {
                HStack(spacing: 12) {
                    Image("switchlogo")
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                    Text("Nintendo Switch").foregroundColor(Color.red)
                }
            }
            
            Button(action: {
                self.currentPlatform = "XBOX"
                self.platformImg = "xboxlogo"
                self.showPlatforms.toggle()
            }) {
                HStack(spacing: 12) {
                    Image("xboxlogo")
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                    Text("Xbox").foregroundColor(Color.green)
                }
            }
            
        }
        .padding()
        .background(Color(red: 30 / 255, green: 30 / 255, blue: 30 / 255))
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 14.0, *) {
            BrowseView()
        } else {
            // Fallback on earlier versions
        }
    }
}
