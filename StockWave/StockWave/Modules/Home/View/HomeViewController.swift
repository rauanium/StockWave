//
//  ViewController.swift
//  StockWave
//
//  Created by rauan on 4/21/24.
//

import UIKit
import SnapKit
import Kingfisher

fileprivate typealias stockDataSource = UICollectionViewDiffableDataSource<HomeSections, HomeStocksDataModel>


class HomeViewController: UIViewController, UICollectionViewDelegate {
    
    var general: [HomeStocksDataModel] = []
    var watchlist: [HomeStocksDataModel] = []
    var actives: [HomeStocksDataModel] = []
    var gainers: [HomeStocksDataModel] = []
    var losers: [HomeStocksDataModel] = []
    
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
        compositionalView.register(
          HeaderView.self,
          forSupplementaryViewOfKind: HomeViewController.sectionHeaderElementKind,
          withReuseIdentifier: HeaderView.identifier)
        compositionalView.delegate = self
        
        return compositionalView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...10 {
            general.append(.init(id: "id \(5 + i)", companyImage: nil, companyTicker: "companyTicker \(i)", companyName: "companyName \(i+1)", companyPrice: 0.5 + Double(i), companyChange: 0.3 + Double(i)))
            watchlist.append(.init(id: "id \(5 + i)", companyImage: nil, companyTicker: "companyTicker \(i)", companyName: "companyName \(i+1)", companyPrice: 0.5 + Double(i), companyChange: 0.3 + Double(i)))
            actives.append(.init(id: "id \(5 + i)", companyImage: nil, companyTicker: "companyTicker \(i)", companyName: "companyName \(i+1)", companyPrice: 0.5 + Double(i), companyChange: 0.3 + Double(i)))
            gainers.append(.init(id: "id \(5 + i)", companyImage: nil, companyTicker: "companyTicker \(i)", companyName: "companyName \(i+1)", companyPrice: 0.5 + Double(i), companyChange: 0.3 + Double(i)))
            losers.append(.init(id: "id \(5 + i)", companyImage: nil, companyTicker: "companyTicker \(i)", companyName: "companyName \(i+1)", companyPrice: 0.5 + Double(i), companyChange: 0.3 + Double(i)))
        }
        setupViews()
        setupViewModel()
        configureDataSource()

    }
    //MARK: - setupviews
    func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(compositionalLayout)
        compositionalLayout.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
    }
    
    //MARK: - setup ViewModel
    func setupViewModel() {
        viewModel = HomeViewModel()
        viewModel?.getTrending(completion: { items in
            
        })
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
                cell.configure(data: item.companyName)
                cell.backgroundColor = .gray
                return cell
                
            case .watchlist:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: GeneralCollectionViewCell.identifier,
                    for: indexPath) as? GeneralCollectionViewCell else { fatalError("Could not create new cell") }
                cell.configure(data: item.companyTicker)
                cell.backgroundColor = .systemPink
                return cell
                
            case .actives:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TrendingStocksCollectionViewCell.identifier,
                    for: indexPath) as? TrendingStocksCollectionViewCell else { fatalError("Could not create new cell") }
                cell.configure(data: item.companyName)
                cell.backgroundColor = .green
                return cell
            case .gainers:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TrendingStocksCollectionViewCell.identifier,
                    for: indexPath) as? TrendingStocksCollectionViewCell else { fatalError("Could not create new cell") }
                cell.configure(data: item.companyTicker)
                cell.backgroundColor = .brown
                return cell
            case .losers:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TrendingStocksCollectionViewCell.identifier,
                    for: indexPath) as? TrendingStocksCollectionViewCell else { fatalError("Could not create new cell") }
                cell.configure(data: item.id)
                cell.backgroundColor = .yellow
                return cell
                
            }
        }
        
        dataSource.supplementaryViewProvider = { (
          collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in

          guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: HeaderView.identifier,
            for: indexPath) as? HeaderView else { fatalError("Cannot create header view") }

          supplementaryView.label.text = HomeSections.allCases[indexPath.section].rawValue
          return supplementaryView
        }

        let snapshot = applySnapshot()
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func applySnapshot() -> NSDiffableDataSourceSnapshot<HomeSections, HomeStocksDataModel> {
        
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
        return snapshot
    }
    
}

extension HomeViewController {
    
    func generateLayout() -> UICollectionViewLayout {
      let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
        layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
        
        let sectionLayoutKind = HomeSections.allCases[sectionIndex]
        switch (sectionLayoutKind) {
        case .general:
            return self.generateGeneralSection()
        case .watchlist:
            return self.generateGeneralSection()
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
            widthDimension: .fractionalWidth(0.8),
            heightDimension: .fractionalWidth(0.20)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, 
                                                       subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
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
    
    func generateTrendingStocksSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.20))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
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

