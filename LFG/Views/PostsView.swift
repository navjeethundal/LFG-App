//
//  Posts.swift
//  LFG
//
//  Created by victor lieu on 2020-11-08.
//  Copyright © 2020 LFG-APP. All rights reserved.
//

import SwiftUI

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
}

@available(iOS 14.0, *)
struct Posts: View {
    @State var selectedGame: String
    @State var selectedPlatform: String
    var postHelper = PostHelper()
    @ObservedObject var postViewModel = PostViewModel()
    @State var postsAvailable = false // TODO: Update this so new posts are reflected for games who dont have any
    @State var isMakingPost = false
    @State var isMakingRequest = false
    @State var groupName = ""
    @State var groupOwner = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 5) {
                if(postsAvailable) {
                    ForEach(postViewModel.groups.reversed()) { group in
                        if(selectedGame == group.game && selectedPlatform == group.platform) {
                            VStack(alignment: .leading) {
                                // HStack is used to set width of each tile in Vstack
                                HStack {
                                    Spacer(minLength: UIScreen.screenWidth - 50)
                                }
                                Text(group.name)
                                    .font(.title)
                                    .foregroundColor(Color.white)
                                    .padding(.bottom, 5)
                                Divider()
                                    .background(Color.blue)
                                Text("Group owner: " + group.leader)
                                    .font(.body)
                                    .foregroundColor(Color.white)
                                    .padding(.bottom, 5)
                                Text(group.description)
                                    .font(.body)
                                    .foregroundColor(Color.white)
                                    .fixedSize(horizontal: false, vertical: true) // Allow text to overflow
                                    .padding(.bottom, 5)
                                HStack{
                                    if(!self.postViewModel.isFull(group: group)) {
                                        Image(systemName: "person.fill").resizable().frame(width: 10, height: 10)
                                        Text(group.currentMembers + "/" + group.membersNeeded)
                                            .foregroundColor(Color.gray)
                                        Spacer()
                                        if(!self.postViewModel.ownGroup(group: group)) {
                                            Button(action: {
                                                self.isMakingRequest.toggle()
                                                self.groupName = group.name
                                                self.groupOwner = group.leader
                                            }) {
                                                Text("Request to join!")
                                                    .foregroundColor(Color.blue)
                                                    .padding(5)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .stroke(Color.blue, lineWidth: 2)
                                                    )
                                            }
                                        }
                                    }
                                    else {
                                        Text("FULL")
                                            .foregroundColor(Color.red)
                                        Spacer()
                                    }
                                    
                                }
                            }
                            .padding()
                            .background(Color(red: 30/255, green: 30/255, blue: 30/255))
                            .cornerRadius(10)
                        }
                    }
                }
                else {
                    VStack {
                        HStack {
                            Spacer(minLength: UIScreen.screenWidth)
                        }
                        Text("There are no groups for this game! Why don't you create one? " + "\u{1F3AE}")
                            .padding()
                            .foregroundColor(Color.white)
                            .font(.title)
                            .padding(.bottom, 20)
                        Button(action: {
                            self.isMakingPost.toggle()
                        }) {
                            Text("Create a group!")
                                .foregroundColor(Color.blue)
                                .font(.title)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.blue, lineWidth: 2)
                                )
                        }
                    }
                    .padding(.top, 12)
                }
            }
            .padding(.top, 5)
            .background(Color.black)
        }
        .navigationBarTitle(selectedGame)
        .navigationBarItems(trailing:
            HStack {
                Button(action: {
                    self.isMakingPost.toggle()
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 20.0, height: 20.0)
                }
                .sheet(isPresented: $isMakingRequest, content: {
                    MakeRequest(isPresented: self.$isMakingRequest, groupName: self.$groupName, groupOwner: self.$groupOwner, platform: self.$selectedPlatform, game: self.$selectedGame, requests: {
                    request in
                        self.postViewModel.makeRequest(request: request)
                    })
                })
            }
        )
        .background(Color.black)
        .onAppear() {
            // call helper method to determine if there are any posts for the selected game
            // set postsAvailable state variable to boolean that is returned
            postsAvailable = self.postHelper.checkPosts(game: selectedGame, platform: selectedPlatform, groups: postViewModel.groups)
        }
        
        .sheet(isPresented: $isMakingPost, content: {
            MakePost(isPresented: self.$isMakingPost, selectedGame: $selectedGame, platform: $selectedPlatform, groupPosted: {
                group in
                self.postViewModel.makePost(group: group)
            })
        })
         
        
    }
}

struct MakeRequest: View {
    @Binding var isPresented: Bool
    @Binding var groupName: String
    @Binding var groupOwner: String
    @Binding var platform: String
    @Binding var game: String
    @State var username = ""
    @State var reusername = ""
    @State var pending = true
    @State var showAlert = false
    
    var alert: Alert {
            Alert(title: Text("In-game Username Does Not Match"), message: Text("Please make sure both fields have the same In-game Username and that there is no extra space after the last letter."),
                                         dismissButton: .default(Text("Dismiss")))
        }
    var requests: (Request) -> ()
    
    var body: some View {
        ZStack {
            Color.black
        VStack(alignment: .center, spacing: 22, content: {
            Text("In-game Username:").foregroundColor(.white)
            HStack{
                Image(systemName: "person.fill").resizable().frame(width: 20, height: 20)
                TextField("Enter In-game Username", text: $username).padding(.leading, 12).font(.system(size: 20))
            }.padding(12)
            .background(Color("grey"))
            .cornerRadius(20)
            Text("Re-enter In-game Username:").foregroundColor(.white)
            HStack{
                Image(systemName: "person.fill").resizable().frame(width: 20, height: 20)
                TextField("Re-enter In-game Username", text: $reusername).padding(.leading, 12).font(.system(size: 20))
            }.padding(12)
            .background(Color("grey"))
            .cornerRadius(20)
            
           
            
            Button(action: {
                if(self.username == self.reusername && self.username != "")
                {
                    self.requests(.init(groupName: self.groupName, username: self.username, pending: self.pending, groupOwner: self.groupOwner, platform: self.platform, game: self.game))
                    self.isPresented = false
                }
                else
                {
                    self.showAlert.toggle()
                    
                }
                
                
            }) {
                Text("Request To Join").foregroundColor(.white).padding().frame(width: 180)
            }
            .alert(isPresented: $showAlert, content: { self.alert })
            .background(Color.blue)
            .cornerRadius(20)
            
          
            
            
        })
        .padding(.horizontal, 18)
    }
    }
    }



struct MakePost: View {
    @Binding var isPresented: Bool
    @Binding var selectedGame: String
    @Binding var platform: String
    @State var leader = ""
    @State var groupName = ""
    @State var description = ""
    @State var membersNeeded = ""
    @State var currentMembers = ""
    @State var acceptedUsers = [String]()
    @State var showAlert = false
    
    var alert: Alert {
            Alert(title: Text("Missing Fields"), message: Text("Please make sure all required fields are filled out."),
                                         dismissButton: .default(Text("Dismiss")))
        }
    
    var groupPosted: (Group) -> ()
    
    var body: some View {
        
        ZStack {
            Color.black
        VStack(alignment: .center, spacing: 8, content: {
            Text("Group Name:").foregroundColor(.white)
            HStack{
                TextField("Enter a name for your group", text: $groupName).padding(.leading, 12).font(.system(size: 20))
            }.padding(10)
            .background(Color("grey"))
            .cornerRadius(20)
            Text("Host's In-game Username:").foregroundColor(.white)
            HStack{
                TextField("Enter In-game Username", text: $leader).padding(.leading, 12).font(.system(size: 20))
            }.padding(10)
            .background(Color("grey"))
            .cornerRadius(20)
          
            VStack(alignment: .center,spacing: 3, content: {
                Text("Description (Optional)").foregroundColor(.white)
                HStack{
                   // Text("Description (Optional)").foregroundColor(.white)
                    TextField("Enter a description (Optional)", text: $description).padding(.leading, 12).font(.system(size: 20))
                }.padding(10)
                .background(Color("grey"))
                .cornerRadius(20)
                Text("Members Needed:").foregroundColor(.white)
                HStack{
                    //Text("Members Needed:").foregroundColor(.white)
                    TextField("Members Needed", text: $membersNeeded).padding(.leading, 12).font(.system(size: 20))
                }.padding(10)
                .background(Color("grey"))
                .cornerRadius(20)
                Text("Current Members:").foregroundColor(.white)
                HStack{
                    //Text("Current Members:").foregroundColor(.white)
                    TextField("Current Members", text: $currentMembers).padding(.leading, 12).font(.system(size: 20))
                }.padding(10)
                .background(Color("grey"))
                .cornerRadius(20)
                
               
                
             
                
                
            })
            
           
            
           
            
            Button(action: {
                if(self.leader != "" && self.groupName != "" && self.membersNeeded != "" && self.currentMembers != "")
                {
                    self.groupPosted(.init(game: self.selectedGame, leader: self.leader, name: self.groupName, membersNeeded: self.membersNeeded, currentMembers: self.currentMembers, description: self.description, acceptedUsers: self.acceptedUsers, platform: self.platform))
                    self.isPresented = false
                }
                else
                {
                    self.showAlert.toggle()
                }
               
                
                
            }) {
                Text("Make Post").foregroundColor(.white).padding().frame(width: 180)
            }
            .alert(isPresented: $showAlert, content: { self.alert })
            .background(Color.blue)
            .cornerRadius(20)
            
            Button(action: {
               
                self.isPresented = false
                
                
            }) {
                Text("Cancel").foregroundColor(.white).padding().frame(width: 180)
            }
            .background(Color.blue)
            .cornerRadius(20)
            
            
        })
        .padding(.horizontal, 16)
    }
    }
}

