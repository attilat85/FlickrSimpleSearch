//
//  ViewController.swift
//  FlickrSearch
//
//  Created by Attila Tamas on 20.06.2022.
//

import UIKit
import RxSwift
import RxCocoa

enum Section: Int, CaseIterable {
    case content, loading
}

class ViewController: UIViewController {

    let viewModel = ViewModel()
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noResultLabel: UILabel!
    @IBOutlet private weak var searchBar: UISearchBar!

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        initBinding()
        
        viewModel.getRecentPhotos()

    }

    private func initUI() {
        tableView.registerWithNib(cellType: LoadingCell.self)
        tableView.registerWithNib(cellType: TableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.showsCancelButton = true
    }

    private func initBinding() {
        viewModel.state.bind { [weak self] state in
            guard let self = self else { return }

            self.loadingIndicator.isHidden = true

            switch state {
            case .loading:
                self.loadingIndicator.isHidden = false
                self.loadingIndicator.startAnimating()
                self.noResultLabel.isHidden = true
                self.tableView.isHidden = true

            case .content:
                if !self.viewModel.photos.isEmpty {
                    self.noResultLabel.isHidden = true
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                } else {
                    self.noResultLabel.text = "No result found for '\(self.viewModel.searchText ?? "")'"
                    self.noResultLabel.isHidden = false
                    self.tableView.isHidden = true
                }

            case .error(let error):
                // error handling should come here
                print(error.localizedDescription)
            }

        }.disposed(by: disposeBag)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Section.loading.rawValue {
            return 1
        }
        return viewModel.photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == Section.loading.rawValue {
            return tableView.dequeueReusableCell(for: indexPath, cellType: LoadingCell.self)
        }
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TableViewCell.self)
        cell.photo = viewModel.photos[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == Section.loading.rawValue {
            viewModel.loadMore()
        }
    }
}

// MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.searchTextField.layer.borderColor = UIColor.black.cgColor
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.search()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.searchTextField.text = nil
        viewModel.searchText = nil
        viewModel.getRecentPhotos()
    }
}
