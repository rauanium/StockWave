//
//  SearchViewController.swift
//  StockWave
//
//  Created by Aliyeva Mariya on 3/05/24.
//

import UIKit

final class SearchViewController: UIViewController {
	
	// MARK: - Props
	
	var timer: Timer?

	// MARK: - UI
	
	private lazy var searchViewController: UISearchController = {
		let searchVC = UISearchController(searchResultsController: SearchResultsViewController())
		searchVC.searchBar.placeholder = "What do you want to?"
		searchVC.searchBar.searchBarStyle = .minimal
		searchVC.definesPresentationContext = true
		searchVC.searchBar.searchTextField.backgroundColor = .white
		searchVC.searchResultsUpdater = self
		return searchVC
	}()
    
    private lazy var emptyStateView: EmptyStateViewFavourite = {
        let view = EmptyStateViewFavourite()
        view.configure(image: UIImage(named: "searchNotFound")!,
                                     title: "Not Found",
                                     subtitle: "Try entering something")
        return view
    }()

	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavigationBar()
		setupViews()
	}
	
	// MARK: - SetupNavigationBar
	
	private func setupNavigationBar() {
		title = "Search"
		navigationItem.searchController = searchViewController
		self.navigationItem.backBarButtonItem?.tintColor = .white
	}
	
	// MARK: - SetupViews
	private func setupViews() {
		view.backgroundColor = .white
        view.addSubview(emptyStateView)
        
        emptyStateView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
	}
	
}

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
	
	func updateSearchResults(for searchController: UISearchController) {
		guard
			let resultsViewController = searchViewController.searchResultsController as?
				SearchResultsViewController,
			let text = searchController.searchBar.text,
			!text.trimmingCharacters(in: .whitespaces).isEmpty
		else {
			return
		}
		
		timer?.invalidate()
		timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false, block: { _ in
			SearchManager.shared.getSymbol(symbol: text) { result in
				resultsViewController.update(with: result)
			}
		})
	}
}

