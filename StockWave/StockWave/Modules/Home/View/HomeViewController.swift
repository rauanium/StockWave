//
//  ViewController.swift
//  StockWave
//
//  Created by rauan on 4/21/24.
//

import UIKit
import SnapKit
import Kingfisher
import CoreData

fileprivate typealias stockDataSource = UICollectionViewDiffableDataSource<HomeSections, HomeStocksDataModel>
fileprivate typealias dataSourceSnapshot = NSDiffableDataSourceSnapshot<HomeSections, HomeStocksDataModel>

class HomeViewController: UIViewController {
    
    
    var general: [HomeStocksDataModel] = []
    var watchlist: [HomeStocksDataModel] = []
    var actives: [HomeStocksDataModel] = []
    var gainers: [HomeStocksDataModel] = []
    var losers: [HomeStocksDataModel] = []
    var favouriteStocks: [NSManagedObject] = []
    var test: Bool = false
    
    
    private var viewModel: HomeViewModel?
//    private var results = [HomeStocksDataModel]()
    private var dataSource: stockDataSource!
    static let sectionHeaderElementKind = "section-header-element-kind"
    
    
    private lazy var compositionalLayout: UICollectionView = {
        let compositionalView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        compositionalView.backgroundColor = .clear
        compositionalView.showsVerticalScrollIndicator = false
        compositionalView.register(TrendingStocksCollectionViewCell.self, forCellWithReuseIdentifier: TrendingStocksCollectionViewCell.identifier)
        compositionalView.register(GeneralCollectionViewCell.self, forCellWithReuseIdentifier: GeneralCollectionViewCell.identifier)
        compositionalView.register(WatchlistCollectionViewCell.self, forCellWithReuseIdentifier: WatchlistCollectionViewCell.identifier)
        compositionalView.register(EmptyStateCollectionViewCell.self, forCellWithReuseIdentifier: EmptyStateCollectionViewCell.identifier)
        
        compositionalView.register(
          HeaderView.self,
          forSupplementaryViewOfKind: HomeViewController.sectionHeaderElementKind,
          withReuseIdentifier: HeaderView.identifier)
        compositionalView.delegate = self
        
        return compositionalView
    }()
    
    private lazy var emptyStateView: EmptyStateView = {
        let emptyStateView = EmptyStateView()
        emptyStateView.configure(image: UIImage(named: "noFavourites")!, title: "No Favourites", subtitle: "You can add an item to your favourites by clicking “Star Icon” in Details")
        emptyStateView.isHidden = true
        return emptyStateView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupViewModel()
        configureDataSource()
        setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStocksFromWatchList()
        hundleEmptyStateView()
        applySnapshot()
        
    }
    
    //MARK: - setupviews
    func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = "Home"
        view.addSubview(compositionalLayout)
        
        compositionalLayout.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    
    private func setupNavigation() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        
        navigationBarAppearance.backgroundColor = .clear
        navigationBarAppearance.shadowColor = .clear
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    //MARK: - setup ViewModel
    func setupViewModel() {
        viewModel = HomeViewModel()
        viewModel?.getMostActiveStocks(completion: { activeStocks in
            for i in 0...4 {
                self.actives.append(.init(
                    symbol: activeStocks[i].symbol ?? "",
                    name: activeStocks[i].name ?? "",
                    price: activeStocks[i].price ?? 0.0,
                    changesPercentage: activeStocks[i].changesPercentage ?? 0.0,
                    change: activeStocks[i].change ?? 0.0
                    
                )
                                    
                )
            }
            self.applySnapshot()
            
        })
        
        viewModel?.getMostGainersStocks(completion: { gainerStocks in
            for i in 0...4 {
                self.gainers.append(.init(
                    symbol: gainerStocks[i].symbol ?? "",
                    name: gainerStocks[i].name ?? "",
                    price: gainerStocks[i].price ?? 0.0,
                    changesPercentage: gainerStocks[i].changesPercentage ?? 0.0,
                    change: gainerStocks[i].change ?? 0.0
                    )
                )
            }
            
            self.applySnapshot()
        })
        
        viewModel?.getMostLosersStocks(completion: { loserStocks in
            for i in 0...4 {
                self.losers.append(.init(
                    symbol: loserStocks[i].symbol ?? "",
                    name: loserStocks[i].name ?? "",
                    price: loserStocks[i].price ?? 0.0,
                    changesPercentage: loserStocks[i].changesPercentage ?? 0.0,
                    change: loserStocks[i].change ?? 0.0
                    
                    )
                )
            }
            self.applySnapshot()
        })
        
        viewModel?.getCommodities(completion: { commodities in
            print("HVCcommodities: \(commodities)")
            commodities.forEach { item in
                self.general.append(.init(
                    symbol: item.symbol ?? "",
                    name: item.name ?? "",
                    price: item.price ?? 0.0,
                    changesPercentage: item.changesPercentage ?? 0.0, 
                    change: item.change ?? 0.0)
                )
            }
            
            self.applySnapshot()
        })
    }
    
    private func loadStocksFromWatchList() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Stocks")
        do {
            favouriteStocks = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. Error: \(error)")
        }
    }
    
    private func hundleEmptyStateView() {
        print("favstocksCount: \(favouriteStocks.count)")
        print("watchlist.count: \(watchlist.count)")
        
        if favouriteStocks.count > 0 {
//            print("watchlist.count: \(watchlist.count)")
            
            test = true
            for i in 0..<favouriteStocks.count {
                let stock = favouriteStocks[i]
                let symbol = stock.value(forKeyPath: "symbol") as? String
                guard let favStock = symbol else { return }
                viewModel?.getFavourite(favStock: favStock, completion: { favDetails in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.watchlist = favDetails
                        self.applySnapshot()
                    }
                    
                })
                
            }
            self.applySnapshot()
        } else {
            
            test = false
        }
        
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource
        <HomeSections, HomeStocksDataModel>(collectionView: compositionalLayout) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: HomeStocksDataModel) -> UICollectionViewCell? in
            
            let sectionType = HomeSections.allCases[indexPath.section]
            
            switch sectionType {
            case .general:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: GeneralCollectionViewCell.identifier,
                    for: indexPath) as? GeneralCollectionViewCell else { fatalError("Could not create new cell") }
                cell.configure(data: item)
//                cell.backgroundColor = .gray
                return cell
                
            case .watchlist:
                if self.test {
                    self.watchlist = [.init(symbol: "", name: "", price: 0.0,changesPercentage: 0.0, change: 0.0  )]
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: WatchlistCollectionViewCell.identifier,
                        for: indexPath) as? WatchlistCollectionViewCell else { fatalError("Could not create new cell") }
                    cell.configure(data: item)
                    
    //                cell.backgroundColor = .systemPink
                    return cell
                } else {
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: EmptyStateCollectionViewCell.identifier,
                        for: indexPath) as? EmptyStateCollectionViewCell else { fatalError("Could not create new cell") }
//                    cell.configure(data: item)
    //                cell.backgroundColor = .systemPink
                    return cell
                }
                
                
            case .actives:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TrendingStocksCollectionViewCell.identifier,
                    for: indexPath) as? TrendingStocksCollectionViewCell else { fatalError("Could not create new cell") }
                cell.configure(data: item)
                
                return cell
            case .gainers:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TrendingStocksCollectionViewCell.identifier,
                    for: indexPath) as? TrendingStocksCollectionViewCell else { fatalError("Could not create new cell") }
                cell.configure(data: item)
                
                
                return cell
            case .losers:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TrendingStocksCollectionViewCell.identifier,
                    for: indexPath) as? TrendingStocksCollectionViewCell else { fatalError("Could not create new cell") }
                cell.configure(data: item)
                
                return cell
                
            }
        }
        
        dataSource.supplementaryViewProvider = { (
            collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind, withReuseIdentifier: HeaderView.identifier,
                for: indexPath) as? HeaderView else { fatalError("Cannot create header view") }
            
            
            supplementaryView.configure(title: HomeSections.allCases[indexPath.section].rawValue)
            return supplementaryView
        }
    }
    //MARK: - Snapshot
    func applySnapshot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<HomeSections, HomeStocksDataModel>()
        
        snapshot.appendSections([HomeSections.general])
        snapshot.appendItems(general)
        
        snapshot.appendSections([HomeSections.watchlist])
        snapshot.appendItems(watchlist)
        
        snapshot.appendSections([HomeSections.actives])
        snapshot.appendItems(actives)
        
        snapshot.appendSections([HomeSections.gainers])
        snapshot.appendItems(gainers)
        
        snapshot.appendSections([HomeSections.losers])
        snapshot.appendItems(losers)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}

//MARK: -   Creating and generating Sections and Layout
extension HomeViewController {
    
    func generateLayout() -> UICollectionViewLayout {
      let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
        layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
        
        
        let sectionLayoutKind = HomeSections.allCases[sectionIndex]
        switch (sectionLayoutKind) {
        case .general:
            return self.generateGeneralSection()
        case .watchlist:
            return self.generateWatchlistSection()
        case .actives:
            return self.generateTrendingStocksSection()
        case .gainers:
            return self.generateTrendingStocksSection()
        case .losers:
            return self.generateTrendingStocksSection()
        }
      }
      return layout
    }
    
    func generateGeneralSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.7),
            heightDimension: .estimated(48)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, 
                                                       subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 12)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(10)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: HomeViewController.sectionHeaderElementKind,
            alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    func generateWatchlistSection() -> NSCollectionLayoutSection {
        if test {
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.6),
                heightDimension: .estimated(136)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 16)
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(44)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: HomeViewController.sectionHeaderElementKind,
                alignment: .top)
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.boundarySupplementaryItems = [sectionHeader]
            section.orthogonalScrollingBehavior = .continuous
            

            return section
        } else {
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(136)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 16)
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(44)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: HomeViewController.sectionHeaderElementKind,
                alignment: .top)
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.boundarySupplementaryItems = [sectionHeader]
            section.orthogonalScrollingBehavior = .continuous
            

            return section
        }
        
    }
    
    func generateTrendingStocksSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
//        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(62)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
//        group.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 8, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: HomeViewController.sectionHeaderElementKind,
            alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        let stockDetailsViewController = StockDetailsViewController()
        stockDetailsViewController.ticker = item.symbol
//        stockDetailsViewController.companyName = item.companyName
//        stockDetailsViewController.details = item
        
        stockDetailsViewController.hidesBottomBarWhenPushed = true
        
        
        
        navigationController?.pushViewController(stockDetailsViewController, animated: true)
    }
}
