//
//  DetailsViewController.swift
//  githubsearch
//
//  Created by Rachit Vyas on 10/16/21.
//  Copyright © 2021 Globalsys. All rights reserved.
//

import Foundation
import UIKit

final class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    lazy var tableHeaderView: UIImageView = {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()

    lazy var tableFooterView: LikeDislikeView = {
        let view = LikeDislikeView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 75))
        view.callback = self.viewModel?.likeDislikeSelectorHandler
        return view
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableHeaderView = self.tableHeaderView
        tableView.tableFooterView =  self.tableFooterView
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension

        return tableView
    }()

    private var viewModel: DetailsViewModel?
    convenience init(viewModel: DetailsViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Repository Details"
        
        self.tableHeaderView.image = self.viewModel?.avatarImage

        self.view.addSubview(self.tableView)
        self.view.bringSubviewToFront(self.tableView)

        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])

        self.setupViewModelListener()

        self.configureLikeDislikeButtonState()
    }

    private func setupViewModelListener() {
        self.viewModel?.reloadView = {
            DispatchQueue.main.async {
                self.tableHeaderView.image = self.viewModel?.avatarImage
                self.tableView.reloadData()
            }
        }
    }

    private func configureLikeDislikeButtonState() {
        self.tableFooterView.configureSelection(state: self.viewModel?.getLikeDislikeSelectionState() ?? .undefined)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell") ?? UITableViewCell(style: .value1, reuseIdentifier: "detailCell")

        cell.textLabel?.text = self.viewModel?.titleAt(index: indexPath.row)
        cell.detailTextLabel?.text = self.viewModel?.valueAt(index: indexPath.row)

        cell.selectionStyle = .none

        return cell
    }
}
