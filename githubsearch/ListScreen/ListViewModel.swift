//
//  ListViewModel.swift
//  githubsearch
//
//  Created by Rachit Vyas on 10/16/21.
//  Copyright © 2021 Globalsys. All rights reserved.
//

import Foundation

final class ListViewModel {
    private let dataManager = DataManager()
    private var dataModel: ItemDataModel?

    var reloadView: (() -> Void)?

    var numberOfRows: Int {
        return self.dataModel?.items.count ?? 0
    }

    func titleForRowAt(index: Int) -> String? {
        return self.dataModel?.items[index].name
    }

    func descForRowAt(index: Int) -> String? {
        guard let item = self.dataModel?.items[index] else { return nil }
        let starcount :  String =    "\u{272D} " + (String(describing: item.stargazers_count))
        return String.concatStrings([item.language, starcount], separatedBy: " | ")

    }

    func getItemAt(index: Int) -> Item? {
        return self.dataModel?.items[index]
    }
    func searchRepository(searchString: String) {
        self.dataManager.searchReopsitory(searchString: searchString) { model, error in
            self.dataModel = model
            self.reloadView?()
        }
    }
}
