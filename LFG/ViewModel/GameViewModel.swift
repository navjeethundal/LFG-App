//
//  GameViewModel.swift
//  LFG
//
//  Created by victor lieu on 2020-11-03.
//  Copyright © 2020 LFG-APP. All rights reserved.
//

import Foundation
import FirebaseFirestore

class GameViewModel: ObservableObject {
    @Published var games = [Game]()
    
    private var db = Firestore.firestore()

    init() {
        db.collection("games").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
            print("No documents")
            return
            }
            
            self.games = documents.compactMap { (QueryDocumentSnapshot) -> Game? in
                return try? QueryDocumentSnapshot.data(as: Game.self)
            }
/*
            self.games = documents.map { queryDocumentSnapshot -> Game in
            let data = queryDocumentSnapshot.data()
            let title = data["title"] as? String ?? ""
            let platforms = data["platforms"] as? Array<String> ?? [""]
            let imagepath = data["imagepath"] as? String ?? ""
            return Game(title: title, platforms: platforms, imagepath: imagepath)
                
          }
 */
        }
    }

}
