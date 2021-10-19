//
//  LikeDislikeView.swift
//  githubsearch
//
//  Created by Rachit Vyas on 10/18/21.
//  Copyright © 2021 Globalsys. All rights reserved.
//

import Foundation
import UIKit

final class LikeDislikeView: UIView {

    private let likeButton = UIButton(type: .custom)
    private let dislikeButton = UIButton(type: .custom)

    enum SelectionState {
        case undefined, like, dislike
    }

    var callback: ((LikeDislikeView.SelectionState) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        self.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        self.dislikeButton.addTarget(self, action: #selector(dislikeButtonTapped), for: .touchUpInside)

        self.likeButton.layer.borderWidth = 1
        self.likeButton.layer.borderColor = UIColor.lightGray.cgColor

        self.dislikeButton.layer.borderWidth = 1
        self.dislikeButton.layer.borderColor = UIColor.lightGray.cgColor

        self.likeButton.setImage(UIImage(named: "like_unselected"), for: .normal)
        self.dislikeButton.setImage(UIImage(named: "dislike_unselected"), for: .normal)

        self.likeButton.setImage(UIImage(named: "like_selected"), for: .selected)
        self.dislikeButton.setImage(UIImage(named: "dislike_selected"), for: .selected)

        self.likeButton.translatesAutoresizingMaskIntoConstraints = false
        self.dislikeButton.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(self.likeButton)
        self.addSubview(self.dislikeButton)

        let viewsDictionary = ["likeButton": self.likeButton, "dislikeButton": self.dislikeButton]

        let horizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[likeButton]-<=10-[dislikeButton]-|", options: [], metrics: nil, views: viewsDictionary)

        let verticalConstraintLikeButton = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[likeButton]-|", options: [], metrics: nil, views: viewsDictionary)

        let verticalConstraintDislikeButton = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[dislikeButton]-|", options: [], metrics: nil, views: viewsDictionary)

        self.addConstraints(horizontalConstraint)
        self.addConstraints(verticalConstraintLikeButton)
        self.addConstraints(verticalConstraintDislikeButton)

        NSLayoutConstraint(item: self.likeButton, attribute: .width, relatedBy: .equal, toItem: self.dislikeButton, attribute: .width, multiplier: 1.0, constant: 0.0).isActive = true

        self.layoutIfNeeded()
    }

    func configureSelection(state: SelectionState) {
        switch state {
        case .like:
            self.likeButton.isSelected = true
        case .dislike:
            self.dislikeButton.isSelected = true
        case .undefined:
            self.likeButton.isSelected = false
            self.dislikeButton.isSelected = false
        }
    }

    @objc private func likeButtonTapped() {
        self.likeButton.isSelected = !self.likeButton.isSelected
        self.dislikeButton.isSelected = false

        self.callback?(self.likeButton.isSelected == false ? .undefined : .like)
    }

    @objc private func dislikeButtonTapped() {
        self.dislikeButton.isSelected = !self.dislikeButton.isSelected
        self.likeButton.isSelected = false

        self.callback?(self.dislikeButton.isSelected == false ? .undefined : .dislike)
    }
}
