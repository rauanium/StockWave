//
//  GeneralCollectionViewCell.swift
//  StockWave
//
//  Created by rauan on 4/24/24.
//

import UIKit

class GeneralCollectionViewCell: UICollectionViewCell {
    static let identifier = "GeneralCollectionViewCell"
    
    private lazy var ticker: UILabel = {
        let ticker = UILabel()
        return ticker
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(ticker)
        
        ticker.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(10)
        }
    }
    
    func configure(data: String) {
        ticker.text = data
    }
}
