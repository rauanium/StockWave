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
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension HeaderView {
    func configure() {
        backgroundColor = .yellow
        
        addSubview(label)
        
        
        label.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
    }
}
