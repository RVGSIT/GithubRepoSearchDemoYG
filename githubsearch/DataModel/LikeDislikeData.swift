//
//  LikeDislikeData.swift
//  githubsearch
//
//  Created by Rachit Vyas on 10/18/21.
//  Copyright © 2021 Globalsys. All rights reserved.
//

import Foundation

struct LikeDislikeData: Codable {
    var likedIds: [Int]?
    var dislikedIds: [Int]?

    init() {
        self.likedIds = [Int]()
        self.dislikedIds = [Int]()
    }
}
