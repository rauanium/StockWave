//
//  HeaderView.swift
//  StockWave
//
//  Created by rauan on 4/24/24.
//

import UIKit
import SnapKit

class HeaderView: UICollectionReusableView {
    static let identifier = "HeaderView"
    
    private lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return headerLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension HeaderView {
    private func setupView() {
        addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(title: String) {
        headerLabel.text = title
    }
}
