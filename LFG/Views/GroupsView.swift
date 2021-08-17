//
//  GroupsView.swift
//  LFG
//
//  Created by victor lieu on 2020-10-21.
//  Copyright © 2020 LFG-APP. All rights reserved.
//

import SwiftUI

struct GroupsView: View {
    @ObservedObject var postViewModel = PostViewModel()
    @State var groupName = ""
    @State var groupHasRequests = false
        
    var body: some View {
        NavigationView{
            ScrollView {
                VStack(spacing: 5) {
                    ForEach(postViewModel.userGroups.reversed()) { group in
                        VStack(alignment: .leading) {
                            // HStack is used to set width of each tile in Vstack
                            HStack {
                                Spacer(minLength: UIScreen.screenWidth - 50)
                            }
                            HStack{
                                Text(group.name)
                                    .font(.title)
                                    .foregroundColor(Color.white)
                                    .padding(.bottom, 5)
                                Spacer()
                                Text(group.game)
                                    .foregroundColor(Color.blue)
                            }
                            Divider().background(Color.blue)
                            Text(group.platform)
                                .foregroundColor(Color.blue)
                                .padding(.bottom, 5)
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
                                Image(systemName: "person.fill").resizable().frame(width: 10, height: 10)
                                Text(group.currentMembers + "/" + group.membersNeeded)
                                    .foregroundColor(Color.gray)
                            }
                           
                            if(!group.acceptedUsers.isEmpty) {
                                Text("Accepted users:")
                                    .font(.body)
                                    .foregroundColor(Color.blue)
                                
                                
                                ForEach(group.acceptedUsers, id: \.self) { user in
                                    Text(user)
                                        .font(.body)
                                        .foregroundColor(Color.gray)
                                }
 
 
                            }
 

 
                            if(postViewModel.hasRequests(groupName: group.name)) {
                                ForEach(postViewModel.requests) { request in
                                    if((request.groupName == group.name) && request.pending) {
                                    Text("Pending requests:")
                                        .font(.body)
                                        .foregroundColor(Color.yellow)
                                        .fixedSize(horizontal: false, vertical: true) // Allow text to overflow
                                        .padding(.bottom, 5)
                                    HStack{
                                        
                                            Text(request.username)
                                                .foregroundColor(Color.gray)
                                            
                                            Button(action: {
                                                var requestToUpdate = request
                                                var groupToUpdate = group
                                                requestToUpdate.accepted = true
                                                requestToUpdate.pending = false
                                                var currentMembers = Int(groupToUpdate.currentMembers)
                                                groupToUpdate.currentMembers = String(currentMembers! + 1)
                                                groupToUpdate.acceptedUsers.append(request.username)
                                                postViewModel.updateRequest(request: requestToUpdate)
                                                postViewModel.updateGroup(group: groupToUpdate)
                                            }) {
                                                Text("Accept")
                                                    .foregroundColor(.green)
                                                Image(systemName: "checkmark")
                                                    .resizable()
                                                    .frame(width: 20.0, height: 20.0)
                                                    .foregroundColor(.green)
                                            }
                                            .padding()
                                            Button(action: {
                                                var requestToUpdate = request
                                                requestToUpdate.accepted = false
                                                requestToUpdate.pending = false
                                                postViewModel.updateRequest(request: requestToUpdate)
                                            }) {
                                                Text("Decline")
                                                    .foregroundColor(.red)
                                                Image(systemName: "xmark")
                                                    .resizable()
                                                    .frame(width: 20.0, height: 20.0)
                                                    .foregroundColor(.red)
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color(red: 30/255, green: 30/255, blue: 30/255))
                        .cornerRadius(10)
                    }
                    ForEach(postViewModel.userRequests.reversed()) { request in
                        VStack(alignment: .leading) {
                            // HStack is used to set width of each tile in Vstack
                            HStack {
                                Spacer(minLength: UIScreen.screenWidth - 50)
                            }
                            HStack{
                                Text(request.groupName)
                                    .font(.title)
                                    .foregroundColor(Color.white)
                                    .padding(.bottom, 5)
                                Spacer()
                                Text(request.game)
                                    .foregroundColor(Color.blue)
                            }
                            Divider().background(Color.white)
                            Text(request.platform)
                                .foregroundColor(Color.blue)
                                .padding(.bottom, 5)
                            Text("Group owner: " + request.groupOwner)
                                .foregroundColor(Color.white)
                                .padding(.bottom, 5)
    
                            if(request.pending) {
                                Text(String("Request is pending"))
                                    .font(.body)
                                    .foregroundColor(Color.yellow)
                                    .padding(.bottom, 5)
                            }
                            else {
                                if(request.accepted!) {
                                    Text(String("Accepted"))
                                        .font(.body)
                                        .foregroundColor(Color.green)
                                        .padding(.bottom, 5)
                                }
                                else if(!request.accepted!) {
                                    Text(String("Declined"))
                                        .font(.body)
                                        .foregroundColor(Color.red)
                                        .padding(.bottom, 5)
                                }
                            }
                            
                        }
                        .padding()
                        .background(Color(red: 30/255, green: 30/255, blue: 30/255))
                        .cornerRadius(10)
                    }
                }
                .padding(.top, 5)
                .background(Color.black)
            }
            .navigationBarTitle("Groups", displayMode: .inline)
            .background(Color.black)
        }
    }
}

struct GroupsView_Previews: PreviewProvider {
    static var previews: some View {
        GroupsView()
    }
}

//struct GroupsList: View {
//    let group: Group
//    //var Int currentMembers = String(group.currentMemebers)
//    //var Int membersNeeded = String(group.membersNeeded)
//
//    var body : some View {
//
//        VStack(alignment: .leading) {
//            Text(group.name)
//                .font(.title)
//            HStack {
//                Text(group.leader)
//                    .font(.subheadline)
//                Spacer()
//                Text(group.currentMemebers)
//                    .font(.subheadline)
//                Text("/")
//                    .font(.subheadline)
//                Text(group.membersNeeded)
//                    .font(.subheadline)
//            }
//            Text(group.description)
//                .font(.subheadline)
//        }
//    }
//}
