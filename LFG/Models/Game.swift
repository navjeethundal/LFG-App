//
//  Game.swift
//  LFG
//
//  Created by victor lieu on 2020-10-25.
//  Copyright © 2020 LFG-APP. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Game: Codable, Identifiable {
    //@DocumentID var id: String?
    @DocumentID var id: String? = UUID().uuidString
    //var id: String = UUID().uuidString // this ID does not match the document ID in firestore
    // TODO: Fix this
    var title: String
    var platforms: Array<String>
    var imagepath: String
}

