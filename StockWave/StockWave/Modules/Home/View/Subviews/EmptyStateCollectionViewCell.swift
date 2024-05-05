//
//  EmptyStateCollectionViewCell.swift
//  StockWave
//
//  Created by rauan on 4/29/24.
//

import UIKit

class EmptyStateCollectionViewCell: UICollectionViewCell {
    static let identifier = "EmptyStateCollectionViewCell"
    
    private lazy var logo: UIImageView = {
        let logo = UIImageView()
        logo.contentMode = .scaleAspectFit
        logo.image = UIImage(named: "noFavourites")
        return logo
    }()
    
    private lazy var decsriptionAndTitleStack: UIStackView = {
        let decsriptionAndTitleStack = UIStackView()
        decsriptionAndTitleStack.axis = .vertical
        decsriptionAndTitleStack.distribution = .fill
        decsriptionAndTitleStack.spacing = 4
        return decsriptionAndTitleStack
    }()
    
    private lazy var stateTitle: UILabel = {
        let stateTitle = UILabel()
        stateTitle.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        stateTitle.text = "No Favourites"
        return stateTitle
    }()
    
    private lazy var stateDescription: UILabel = {
        let stateDescription = UILabel()
        stateDescription.font = UIFont.systemFont(ofSize: 12)
        stateDescription.text = "No favourite stocks yet"
        stateDescription.textColor = .gray
        return stateDescription
    }()
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - setupViews
    private func setupViews() {
        contentView.addSubview(decsriptionAndTitleStack)
        contentView.addSubview(logo)
        [stateTitle, stateDescription].forEach {
            decsriptionAndTitleStack.addArrangedSubview($0)
        }
        
        logo.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.size.equalTo(60)
            make.centerY.equalToSuperview()
        }
        
        decsriptionAndTitleStack.snp.makeConstraints { make in
            make.left.equalTo(logo.snp.right).offset(12)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    
    
}
