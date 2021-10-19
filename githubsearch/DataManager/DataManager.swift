//
//  DataManager.swift
//  githubsearch
//
//  Created by Rachit Vyas on 10/16/21.
//  Copyright © 2021 Globalsys. All rights reserved.
//

import Foundation
import UIKit

final class DataManager {
    func searchReopsitory(searchString: String, _ callback: @escaping ((ItemDataModel?, Error?) -> ())) {
        APIRequest<ItemDataModel>.init(configurator: SearchRepoRequestConfigurator(searchString: searchString)).makeRequest { (model, error) in
            callback(model, error)
        }
    }

    func fetchImage(url: URL, callback: @escaping (UIImage?) -> Void) {
        let fileManager = FileManager.default

        guard var filePath = fileManager.urls(for: .cachesDirectory, in: .allDomainsMask).first else { return }
        filePath.appendPathComponent(url.pathComponents.last ?? "")

        if fileManager.fileExists(atPath: filePath.absoluteString) {
            callback(UIImage(contentsOfFile: filePath.absoluteString))
        } else {
            APIClient.downloadTaskExecute(request: URLRequest(url: url)) { (location) in
                do {
                    let data = try Data(contentsOf: location)
                    try data.write(to: filePath)
                    try fileManager.removeItem(at: location)
                    callback(UIImage(data: data))
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }

    func setSelectedState(selectionState: LikeDislikeView.SelectionState, id: Int) {
        var data = LikeDislikeData()

        if let encodedData = UserDefaults.standard.object(forKey: "LikeDislikeData") as? Data {
            data = try! PropertyListDecoder().decode(LikeDislikeData.self, from: encodedData)
        }

        switch selectionState {
        case .like:
            if !(data.likedIds?.contains(id) ?? false) {
                data.likedIds?.append(id)
                data.dislikedIds?.removeAll(where: { $0 == id })
            }
        case .dislike:
            if data.dislikedIds?.contains(id) == false {
                data.dislikedIds?.append(id)
                data.likedIds?.removeAll(where: { $0 == id })
            }
        case .undefined:
            data.likedIds?.removeAll(where: { $0 == id })
            data.dislikedIds?.removeAll(where: { $0 == id })
        }

        try! UserDefaults.standard.set(PropertyListEncoder().encode(data), forKey: "LikeDislikeData")
    }

    func getSelectedState(id: Int) -> LikeDislikeView.SelectionState {
        var data = LikeDislikeData()

        if let encodedData = UserDefaults.standard.object(forKey: "LikeDislikeData") as? Data {
            data = try! PropertyListDecoder().decode(LikeDislikeData.self, from: encodedData)
        }

        if data.likedIds?.contains(id) ?? false {
            return .like
        } else if data.dislikedIds?.contains(id) ?? false {
            return .dislike
        } else {
            return .undefined
        }
    }
}
