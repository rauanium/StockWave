//
//  FavouritesViewController.swift
//  StockWave
//
//  Created by Mariya Aliyeva on 5/03/24.
//

import UIKit
import CoreData

final class FavouritesViewController: UIViewController {
	
	// MARK: - Private properties
	
	private var favouriteStocks: [NSManagedObject] = [] {
		didSet {
			self.tableView.reloadData()
		}
	}
	
	// MARK: - UI
	
	private var titleLabel: UILabel = {
		let label = UILabel()
		label.text = "Watch List"
		label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
		return label
	}()
	
	private lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(StockTableViewCell.self, forCellReuseIdentifier: "StockTableViewCell")
		return tableView
	}()
	
	private lazy var emptyStateView: EmptyStateViewFavourite = {
		let view = EmptyStateViewFavourite()
		view.isHidden = true
		view.configure(image: UIImage(named: "No_Favorite_illustration")!,
									 title: "No Favourites",
									 subtitle: "You can add an item to your favourites by clicking “Star Icon")
		return view
	}()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setupConstraints()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		loadStocksFromWatchList()
		self.tabBarController?.tabBar.isHidden = false
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		hundleEmptyStateView()
	}
	
	// MARK: - Core
	
	private func loadStocksFromWatchList() {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
		let managedContext = appDelegate.persistentContainer.viewContext
		
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Stocks")
		do {
			favouriteStocks = try managedContext.fetch(fetchRequest)
			tableView.reloadData()
//			UserDefaults.standard.setValue(favouriteStocks.last?.value(forKeyPath: "symbol") as? String, forKey: "StockWave")
		} catch let error as NSError {
			print("Could not fetch. Error: \(error)")
		}
	}
	
	// MARK: - Private

	private func hundleEmptyStateView() {
		if favouriteStocks.count <= 0 {
			emptyStateView.isHidden = false
		} else {
			emptyStateView.isHidden = true
		}
	}
	
	// MARK: - Setup Views
	private func setupViews() {
		view.backgroundColor = .white
		
		[titleLabel, tableView, emptyStateView].forEach {
			view.addSubview($0)
		}
	}
	
	// MARK: - Setup Constraints
	private func setupConstraints() {
		
		titleLabel.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.centerX.equalToSuperview()
		}
		
		tableView.snp.makeConstraints { make in
			make.top.equalTo(titleLabel.snp.bottom).offset(16)
			make.leading.trailing.bottom.equalToSuperview()
		}
		
		emptyStateView.snp.makeConstraints { make in
			make.edges.equalTo(view)
		}
	}
}

extension FavouritesViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return favouriteStocks.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: StockTableViewCell.reuseId, for: indexPath) as? StockTableViewCell else { return UITableViewCell() }
		let stock = favouriteStocks[indexPath.row]
		let title = stock.value(forKeyPath: "name") as? String
		let symbol = stock.value(forKeyPath: "symbol") as? String
		cell.configureWatchList(name: title ?? "", symbol: symbol ?? "")
		return cell
	}
}

extension FavouritesViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("Did")
	}
}
