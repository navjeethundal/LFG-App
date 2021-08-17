//
//  PostHelper.swift
//  LFG
//
//  Created by victor lieu on 2020-11-11.
//  Copyright © 2020 LFG-APP. All rights reserved.
//

// File containing helper methods for functionality related to groups/posts

import Foundation

class PostHelper {
    
    // function used to determine if the selected game has any posts/groups available
    func checkPosts(game: String, platform: String, groups: [Group]) -> Bool {
        for group in groups {
            if (game == group.game && platform == group.platform) {
                return true
            }
        }
        return false
    }
}
