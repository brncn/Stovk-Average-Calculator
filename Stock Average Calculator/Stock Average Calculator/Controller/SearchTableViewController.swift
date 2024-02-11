//
//  ViewController.swift
//  Stock Average Calculator
//
//  Created by Apollo on 6.02.2024.
//

import Combine
import UIKit

class SearchTableViewController: UITableViewController {
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Firma adını veya kodunu giriniz."
        sc.searchBar.autocapitalizationType = .allCharacters
        return sc
    }()

    private let apiService = APIService()
    private var subscribes = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        performSearch()
    }

    private func setupNavigationBar() {
        navigationItem.searchController = searchController
    }

    private func performSearch() {
        apiService.fetchSYmbolsPublisher(keywords: "S&P500").sink { completion in
            switch completion {
            case .failure(let error):
                print(error.localizedDescription)
            case .finished: break
            }
        } receiveValue: { searchResults in
            print(searchResults)
        }.store(in: &subscribes)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)
        return cell
    }
}

extension SearchTableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {}
}
