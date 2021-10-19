//
//  DetailsViewModel.swift
//  githubsearch
//
//  Created by Rachit Vyas on 10/16/21.
//  Copyright © 2021 Globalsys. All rights reserved.
//

import Foundation
import UIKit

final class DetailsViewModel {

    var reloadView: (() -> Void)?

    private let dataManager = DataManager()

    var avatarImage: UIImage?
    var likeDislikeSelectorHandler: ((LikeDislikeView.SelectionState) -> Void)?

    private let dataItem: Item

    init(item: Item) {
        self.dataItem = item
        self.commonInit()
    }

    private func commonInit() {
        guard let owner = dataItem.owner else { return }
        guard let url = URL(string: owner.avatar_url ?? "") else { return }
        self.dataManager.fetchImage(url: url) { image in
            self.avatarImage = image
            self.reloadView?()
        }

        self.setLikeDislikeSelectorListener()
    }

    var numberOfRows: Int {
        return 5
    }

    func titleAt(index: Int) -> String? {
        switch index {
        case 0:
            return "Repo Name:"
        case 1:
            return "Language:"
        case 2:
            return "Stars:"
        case 3:
            return "User:"
        case 4:
            return "Creation Date:"
        default:
            return nil
        }
    }

    func valueAt(index: Int) -> String? {
        switch index {
        case 0:
            return self.dataItem.name
        case 1:
            return self.dataItem.language
        case 2 :
            return String.init(describing: "\(self.dataItem.stargazers_count)")
        case 3:
            return self.dataItem.owner?.login
        case 4:
            return AppHelper.formatDate(dateString: self.dataItem.created_at?.replacingOccurrences(of: "Z", with: ""), formatString: "dd-MMM-yyyy")
//            return AppHelper.formatDate(dateString: self.dataItem.created_at?.replacingOccurrences(of: "Z", with: ""), formatString: "dd-MMM-yyyy hh:mm:ss")
        default:
            return nil
        }
    }

    private func setLikeDislikeSelectorListener() {
        self.likeDislikeSelectorHandler = { selectionState in
            self.dataManager.setSelectedState(selectionState: selectionState, id: self.dataItem.id)
        }
    }

    func getLikeDislikeSelectionState() -> LikeDislikeView.SelectionState {
        self.dataManager.getSelectedState(id: self.dataItem.id)
    }
}
