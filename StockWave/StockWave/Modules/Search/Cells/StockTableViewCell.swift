//
//  StockTableViewCell.swift
//  StockWave
//
//  Created by Mariya Aliyeva on 04.05.2024.
//

import UIKit

final class StockTableViewCell: UITableViewCell {
	
	static var reuseId = "StockTableViewCell"
	
	// MARK: - Consraints
	private enum Consraints {
		static let musicImageSize: CGFloat = 40
		static let musicImageCornerRadius: CGFloat = 20
		static let textsStackViewSpacing: CGFloat = 2
	}
	
	// MARK: - UIView
	
	lazy var companyImage: UIImageView = {
		let image = UIImageView()
		image.layer.cornerRadius = Consraints.musicImageCornerRadius
		image.contentMode = .scaleAspectFill
		image.backgroundColor = #colorLiteral(red: 0.9707725644, green: 0.9807204604, blue: 0.9848499894, alpha: 1)
		return image
	}()
	
	private lazy var textsStackView: UIStackView = {
		let stack = UIStackView()
		stack.spacing = Consraints.textsStackViewSpacing
		stack.distribution = .fillEqually
		stack.alignment = .fill
		stack.axis = .vertical
		return stack
	}()
	
	lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = .boldSystemFont(ofSize: 14)
		label.textColor = #colorLiteral(red: 0.05098039216, green: 0.05098039216, blue: 0.07058823529, alpha: 1)
		label.textAlignment = .left
		return label
	}()
	
	lazy var subtitleLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 12)
		label.textAlignment = .left
		label.textColor = #colorLiteral(red: 0.5058823529, green: 0.5333333333, blue: 0.5960784314, alpha: 1)
		return label
	}()
	
	private lazy var numberStackView: UIStackView = {
		let stack = UIStackView()
		stack.spacing = Consraints.textsStackViewSpacing
		stack.distribution = .fillEqually
		stack.alignment = .fill
		stack.axis = .vertical
		return stack
	}()
	
	lazy var currencyLabel: UILabel = {
		let label = UILabel()
		label.font = .boldSystemFont(ofSize: 14)
		label.textColor = #colorLiteral(red: 0.05098039216, green: 0.05098039216, blue: 0.07058823529, alpha: 1)
		label.textAlignment = .right
		return label
	}()
	
	lazy var percentLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 12)
		label.textAlignment = .right
		label.textColor = #colorLiteral(red: 0.0862745098, green: 0.6392156863, blue: 0.2901960784, alpha: 1)
		return label
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Public
	
	func configure(data: ActiveGainersLosersResponse?) {
		
		titleLabel.text = data?.symbol
		subtitleLabel.text = data?.name
		let currency = Double(String(format: "%.2f", data?.price ?? 0))
		currencyLabel.text = "$\(currency ?? 0)"
		let percent = Double(String(format: "%.2f", data?.changesPercentage ?? 0))
		percentLabel.text = "\(percent ?? 0)%"
		let imageUrl = URL(string: "https://financialmodelingprep.com/image-stock/\(data?.symbol ?? "").png")
		companyImage.kf.setImage(with: imageUrl)
	}
	
	func configure(data: SearchResponseElement?) {
		
		titleLabel.text = data?.symbol
		subtitleLabel.text = data?.name
		let imageUrl = URL(string: "https://financialmodelingprep.com/image-stock/\(data?.symbol ?? "").png")
		companyImage.kf.setImage(with: imageUrl)
	}
	
	func configureWatchList(name: String, symbol: String) {
		titleLabel.text = symbol
		subtitleLabel.text = name
		let imageUrl = URL(string: "https://financialmodelingprep.com/image-stock/\(symbol).png")
		companyImage.kf.setImage(with: imageUrl)
	}
	// MARK: - SetupViews
	
	private func setupViews() {
		
		selectionStyle = .none
		
		[titleLabel, subtitleLabel].forEach {
			textsStackView.addArrangedSubview($0)
		}
		
		[currencyLabel, percentLabel].forEach {
			numberStackView.addArrangedSubview($0)
		}
		
		[companyImage, textsStackView, numberStackView].forEach {
			contentView.addSubview($0)
		}
		
		companyImage.snp.makeConstraints { make in
			make.left.equalToSuperview().inset(12)
			make.top.bottom.equalToSuperview().inset(8)
			make.size.equalTo(Consraints.musicImageSize)
		}
		
		textsStackView.snp.makeConstraints { make in
			make.left.equalTo(companyImage.snp.right).offset(12)
			make.top.bottom.equalTo(companyImage)
		}
		
		numberStackView.snp.makeConstraints { make in
			make.trailing.equalToSuperview().inset(12)
			make.top.bottom.equalTo(companyImage)
		}
	}
}

