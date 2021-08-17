//
//  PostViewModel.swift
//  LFG
//
//  Created by victor lieu on 2020-11-08.
//  Copyright © 2020 LFG-APP. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class PostViewModel: ObservableObject {
    @Published var groups = [Group]()
    @Published var userGroups = [Group]()
    @Published var userRequests = [Request]()
    @Published var requests = [Request]()
    
    private var db = Firestore.firestore()
    
    init() {
        
        //TODO: Move these queries out of the init function to reduce redundant calls to Firebase
        
        // load all posts
        db.collection("groups")
            .order(by: "createdTime")
            .addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.groups = documents.compactMap { (QueryDocumentSnapshot) -> Group? in
                return try? QueryDocumentSnapshot.data(as: Group.self)
            }
 
        }
        
        // load posts for current user
        let userId = Auth.auth().currentUser?.uid
        db.collection("groups")
            .order(by: "createdTime")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No groups for user")
                return
            }
            
            self.userGroups = documents.compactMap { (QueryDocumentSnapshot) -> Group? in
                return try? QueryDocumentSnapshot.data(as: Group.self)
            }
        }
        
        // load requests made by current user
        db.collection("requests")
            .order(by: "createdTime")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No requests for user")
                return
            }
            
            self.userRequests = documents.compactMap { (QueryDocumentSnapshot) -> Request? in
                return try? QueryDocumentSnapshot.data(as: Request.self)
            }
         }
 
    
        // load requests
        db.collection("requests")
            .order(by: "createdTime")
            .addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No requests")
                return
            }
            
            self.requests = documents.compactMap { (QueryDocumentSnapshot) -> Request? in
                return try? QueryDocumentSnapshot.data(as: Request.self)
            }
         }
 
 
    }
    
    // Function for adding post to Firestore collection
    func makePost(group: Group) {
        var addedGroup = group 
        addedGroup.userId = Auth.auth().currentUser?.uid
        do {
            let _ = try db.collection("groups").addDocument(from: addedGroup)
        }
        catch {
            fatalError("Unable to post group: \(error.localizedDescription)")
        }
    }
    
    func makeRequest(request: Request) {
        
        var addedRequest = request
        addedRequest.userId = Auth.auth().currentUser?.uid
        do {
            let _ = try db.collection("requests").addDocument(from: addedRequest)
        }
        catch {
            fatalError("Unable to make request: \(error.localizedDescription)")
        }
    }
    
    func hasRequests(groupName: String) -> Bool {
        for request in requests {
            if (groupName == request.groupName) {
                return true
            }
        }
        return false
    }
    
    func updateRequest(request: Request) {
        print("Updating request!!!")
        print(request)
        if let test = request.id {
            do {
                try db.collection("requests").document(test).setData(from: request)
            }
            catch {
                fatalError("Unable to update request: \(error.localizedDescription).")
            }
        }
    }
    
    func updateGroup(group: Group) {
        print("Updating group!")
        if let test = group.id {
            do {
                try db.collection("groups").document(test).setData(from: group)
            }
            catch {
                fatalError("Unable to update group: \(error.localizedDescription).")
            }
        }
    }
    
    func isFull(group: Group) -> Bool {
        let current = Int(group.currentMembers)
        let needed = Int(group.membersNeeded)
        if(current! >= needed!) {
            return true
        }
        return false
    }
    
    func ownGroup(group: Group) -> Bool{
        let id = Auth.auth().currentUser?.uid
        if (id == group.userId){
            return true
        }
        return false}


}
