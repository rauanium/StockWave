//
//  SearchResultsViewController.swift
//  StockWave
//
//  Created by Mariya Aliyeva on 04.05.2024.
//

import UIKit

final class SearchResultsViewController: UIViewController {

	// MARK: - Props
	
	var stocks: [SearchResponseElement] = [] {
		didSet {
			self.tableView.reloadData()
		}
	}
	
	// MARK: - UI
	
	private lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(StockTableViewCell.self, forCellReuseIdentifier: "StockTableViewCell")
		return tableView
	}()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .black
		
		view.addSubview(tableView)
		tableView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
	
	func update(with stocks: [SearchResponseElement]) {
		self.stocks = stocks
		tableView.reloadData()
	}
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		stocks.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: StockTableViewCell.reuseId, for: indexPath) as? StockTableViewCell else { return UITableViewCell() }
		let stock = stocks[indexPath.row]
		cell.configure(data: stock)
		return cell
	}
	
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let stock = stocks[indexPath.row]
        let stockDetailsViewController = StockDetailsViewController()
        stockDetailsViewController.ticker = stock.symbol
        print("indexPath: \(indexPath.row)")
        print("symbol: \(String(describing: stock.symbol))")
        stockDetailsViewController.hidesBottomBarWhenPushed = true
        
//        navigationController?.pushViewController(stockDetailsViewController, animated: true)
//        present(stockDetailsViewController, animated: true)
        self.presentingViewController?.navigationController?.pushViewController(stockDetailsViewController, animated: true)
    }
}
