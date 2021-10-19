//
//  SearchRepoRequestConfigurator.swift
//  githubsearch
//
//  Created by Rachit Vyas on 10/16/21.
//  Copyright © 2021 Globalsys. All rights reserved.
//

import Foundation

struct SearchRepoRequestConfigurator: RequestConfigurator {

    private var searchString: String
    init(searchString: String) {
        self.searchString = searchString
    }

    var httpMethod: HTTPMethod {
        return .get
    }

    var httpProtocol: HTTPProtocol {
        return .https
    }

    var host: String {
        return "api.github.com"
    }

    var path: String {
        return "/search/repositories"
    }

    var queryItems: [URLQueryItem]? {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "q", value: self.searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))
        return queryItems
    }
}
