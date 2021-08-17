//
//  Group.swift
//  LFG
//
//  Created by Ajit Pawa  on 2020-10-27.
//  Copyright © 2020 LFG-APP. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Group: Codable, Identifiable {
    //var id: String
    @DocumentID var id: String? = UUID().uuidString
    @ServerTimestamp var createdTime: Timestamp?
    var game: String
    var leader: String
    var name: String
    var membersNeeded: String
    var currentMembers: String
    var description: String
    var userId: String?
    var acceptedUsers: Array<String>
    var platform: String
    
}
