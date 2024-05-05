//
//  TrendingStocksCollectionViewCell.swift
//  StockWave
//
//  Created by rauan on 4/24/24.
//

import UIKit

class TrendingStocksCollectionViewCell: UICollectionViewCell {
    static let identifier = "TrendingStocksCollectionViewCell"
    
    private lazy var logo: UIImageView = {
        let logo = UIImageView()
        logo.contentMode = .scaleAspectFit
        return logo
    }()
    
    private lazy var tickerNameStack: UIStackView = {
        let tickerNameStack = UIStackView()
        tickerNameStack.axis = .vertical
        tickerNameStack.distribution = .fill
        tickerNameStack.spacing = 4
        return tickerNameStack
    }()
    
    private lazy var ticker: UILabel = {
        let ticker = UILabel()
        ticker.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return ticker
    }()
    
    private lazy var companyName: UILabel = {
        let companyName = UILabel()
        companyName.font = UIFont.systemFont(ofSize: 12)
        companyName.textColor = .gray
        return companyName
    }()
    
    private lazy var priceChangeStack: UIStackView = {
        let priceChangeStack = UIStackView()
        priceChangeStack.axis = .vertical
        priceChangeStack.distribution = .fill
        priceChangeStack.spacing = 4
        return priceChangeStack
    }()
    
    private lazy var price: UILabel = {
        let price = UILabel()
        price.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return price
    }()
    
    private lazy var change: UILabel = {
        let change = UILabel()
        change.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        change.textAlignment = .right
        change.textColor = .gray
        return change
    }()
    
    private lazy var numbersAndNamesStack: UIStackView = {
        let numbersAndNamesStack = UIStackView()
        numbersAndNamesStack.axis = .horizontal
        numbersAndNamesStack.distribution = .equalSpacing
        return numbersAndNamesStack
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        change.text = nil
        price.text = nil
        ticker.text = nil
        companyName.text = nil
        logo.image = nil
    }
    
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
        contentView.addSubview(numbersAndNamesStack)
        contentView.addSubview(logo)
        [tickerNameStack, priceChangeStack].forEach {
            numbersAndNamesStack.addArrangedSubview($0)
        }
        
        [ticker, companyName].forEach {
            tickerNameStack.addArrangedSubview($0)
        }
        
        [price, change].forEach {
            priceChangeStack.addArrangedSubview($0)
        }
        
        tickerNameStack.snp.makeConstraints { make in
            make.width.equalTo(150)
        }
        
        logo.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.size.equalTo(34)
            make.centerY.equalToSuperview()
        }
        
        numbersAndNamesStack.snp.makeConstraints { make in
            make.left.equalTo(logo.snp.right).offset(12)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    func configure(data: HomeStocksDataModel) {
    
        let imageURL = URL(string: "https://financialmodelingprep.com/image-stock/\( data.symbol ?? "").png")
        logo.kf.setImage(with: imageURL)
        ticker.text = data.symbol
        companyName.text = data.name
        price.text = "$\(String(format: "%.2f", data.price ?? 0.0))"
        
        if data.change ?? 0.0 > 0.0 {
            change.textColor = .green
            change.text = "+\(String(format: "%.2f", data.changesPercentage ?? 0.0))%"
        } else {
            change.textColor = .red
            change.text = "\(String(format: "%.2f", data.changesPercentage ?? 0.0))%"
        }
        
    }
    
}
