//
//  ViewController.swift
//  StockWave
//
//  Created by rauan on 4/21/24.
//

import UIKit
import SnapKit
import Kingfisher

class HomeViewController: UIViewController {
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "road")
        image.contentMode = .scaleAspectFit
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setupViews()
    }

    func setupViews() {
        view.addSubview(image)
        image.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.center.equalToSuperview()
        }
        setupImage()
    }
    
    func setupImage(){
        let imageUrl = URL(string: "https://financialmodelingprep.com/image-stock/NVDA.png")
        image.kf.setImage(with: imageUrl)
    }

}

