//
//  GameRepository.swift
//  LFG
//
//  Created by victor lieu on 2020-11-03.
//  Copyright © 2020 LFG-APP. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class GameRepository: ObservableObject {
    let db = Firestore.firestore()
    @Published var games = [Game]()
    
    func loadGames() {
        db.collection("games").addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.games = querySnapshot.documents.compactMap { document in
                    do {
                        let test = try? document.data(as: Game.self)
                        return test
                    }
                    catch {
                        print(error)
                    }
                    return nil
                }
            }
        }
    }
}



