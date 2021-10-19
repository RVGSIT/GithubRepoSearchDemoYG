//
//  ItemDataModel.swift
//  githubsearch
//
//  Created by Rachit Vyas on 10/16/21.
//  Copyright © 2021 Globalsys. All rights reserved.
//

import Foundation

struct ItemDataModel: Codable {
    var total_count: Int
    var items: [Item]
}

struct Item: Codable {
    var id: Int
    var name: String?
    var language: String?
    var created_at: String?
    var stargazers_count: Int
    var owner: ItemOwner?
    
}

struct ItemOwner: Codable {
    var id: Int
    var login: String?
    var avatar_url: String?
}
