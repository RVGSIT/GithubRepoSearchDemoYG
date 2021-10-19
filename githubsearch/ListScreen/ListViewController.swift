//
//  ViewController.swift
//  githubsearch
//
//  Created by Rachit Vyas on 16/10/21.
//  Copyright © 2021 Globalsys. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController {

    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.searchBarStyle = .default
        bar.placeholder = "Search Repo"
        bar.delegate = self
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    private let viewModel = ListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInit()
        self.setupViewModelListener()

        self.title = "Repositories"
    }

    private func commonInit() {
        self.view.addSubview(self.searchBar)
        self.view.bringSubviewToFront(self.searchBar)

         NSLayoutConstraint.activate([
            self.searchBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.searchBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
         ])

        self.view.addSubview(self.tableView)

        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupViewModelListener() {
        self.viewModel.reloadView = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let string = searchBar.text else { return }
        self.viewModel.searchRepository(searchString: string)
    }
}

extension ListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "ListCell")

        cell.textLabel?.text = self.viewModel.titleForRowAt(index: indexPath.row)
        cell.detailTextLabel?.text = self.viewModel.descForRowAt(index: indexPath.row)

        cell.accessoryType = .disclosureIndicator

        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let item = self.viewModel.getItemAt(index: indexPath.row) else { return }
        let viewModel = DetailsViewModel(item: item)
        let viewController = DetailsViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
