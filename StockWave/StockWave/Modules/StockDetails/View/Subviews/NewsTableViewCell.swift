//
//  NewsTableViewCell.swift
//  StockWave
//
//  Created by rauan on 5/5/24.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    static let identifier = "NewsTableViewCell"
    
    private lazy var title: UILabel = {
        let title = UILabel()
        title.numberOfLines = 2
        title.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return title
    }()
    private lazy var summary: UILabel = {
        let summary = UILabel()
        summary.numberOfLines = 0
        summary.font = UIFont.systemFont(ofSize: 12)
        return summary
    }()
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "movieCell")
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        title.text = nil
        summary.text = nil
    }
    
    private func setupViews() {
        contentView.addSubview(title)
        contentView.addSubview(summary)
        
        
        title.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        summary.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
        
    }
    
    func configure(data: Feed){
        title.text = data.title
        summary.text = data.summary
    }

}
