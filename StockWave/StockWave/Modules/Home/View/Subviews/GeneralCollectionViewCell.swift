//
//  GeneralCollectionViewCell.swift
//  StockWave
//
//  Created by rauan on 4/24/24.
//

import UIKit

class GeneralCollectionViewCell: UICollectionViewCell {
    static let identifier = "GeneralCollectionViewCell"
    
    private lazy var tickerNameStack: UIStackView = {
        let tickerNameStack = UIStackView()
        tickerNameStack.axis = .vertical
        tickerNameStack.distribution = .fill
        tickerNameStack.spacing = 4
        return tickerNameStack
    }()
    
    private lazy var ticker: UILabel = {
        let ticker = UILabel()
        ticker.font = UIFont.systemFont(ofSize: 12)
        ticker.textColor = .gray
        return ticker
    }()
    
    private lazy var companyName: UILabel = {
        let companyName = UILabel()
        companyName.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        companyName.textColor = .black
        return companyName
    }()
    
    private lazy var change: UILabel = {
        let change = UILabel()
        change.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        change.textAlignment = .right
        return change
    }()
    
    private lazy var numbersAndNamesStack: UIStackView = {
        let numbersAndNamesStack = UIStackView()
        numbersAndNamesStack.axis = .horizontal
        numbersAndNamesStack.distribution = .equalSpacing
        numbersAndNamesStack.alignment = .bottom
        return numbersAndNamesStack
    }()
    
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setting up views
    private func setupViews() {

        contentView.addSubview(numbersAndNamesStack)
        contentView.layer.cornerRadius = 6
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.gray.cgColor
        
        [tickerNameStack, change].forEach {
            numbersAndNamesStack.addArrangedSubview($0)
        }
        
        [companyName, ticker].forEach {
            tickerNameStack.addArrangedSubview($0)
        }
        
        numbersAndNamesStack.snp.makeConstraints { make in
            make.left.top.bottom.right.equalToSuperview().inset(8)
        }
    }
    
    //MARK: - Cell configuaration
    func configure(data: HomeStocksDataModel) {
        ticker.text = data.symbol
        companyName.text = data.name
        if data.change ?? 0.0 > 0.0 {
            change.textColor = .green
            change.text = "+\(String(format: "%.2f", data.changesPercentage ?? 0.0))%"
        } else {
            change.textColor = .red
            change.text = "\(String(format: "%.2f", data.changesPercentage ?? 0.0))%"
        }
    }
}
