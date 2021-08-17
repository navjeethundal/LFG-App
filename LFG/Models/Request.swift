//
//  Request.swift
//  LFG
//
//  Created by victor lieu on 2020-11-22.
//  Copyright © 2020 LFG-APP. All rights reserved.
//
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Request: Codable, Identifiable {
    //var id: String
    @DocumentID var id: String? = UUID().uuidString
    @ServerTimestamp var createdTime: Timestamp?
    var userId: String?
    var groupName: String
    var username: String
    var pending: Bool
    var groupOwner: String
    var platform: String
    var game: String
    var accepted: Bool?
}
