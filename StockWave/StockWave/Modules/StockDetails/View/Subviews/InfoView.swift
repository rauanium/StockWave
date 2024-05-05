//
//  InfoView.swift
//  StockWave
//
//  Created by rauan on 5/5/24.
//

import UIKit

class InfoView: UIView {
    
    let price: UILabel = {
        let price = UILabel()
        price.font = UIFont.systemFont(ofSize: 12)
        price.textColor = .white
        return price
    }()
    
    let date: UILabel = {
        let date = UILabel()
        date.font = UIFont.systemFont(ofSize: 8)
        date.textColor = UIColor(red: 186/255.0, green: 186/255.0, blue: 186/255.0, alpha: 1.0)
        return date
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        backgroundColor = .black
        layer.cornerRadius = 15
        
        addSubview(price)
        addSubview(date)
        
        price.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.right.equalToSuperview().inset(20)
        }
        
        date.snp.makeConstraints { make in
            make.top.equalTo(price.snp.bottom).offset(1)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    func configure(price: String, date: String){
        self.price.text = price
        self.date.text = date
    }
}
