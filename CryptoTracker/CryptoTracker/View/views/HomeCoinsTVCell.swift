//
//  CoinsTVCell.swift
//  CryptoTracker
//
//  Created by AziK's  MAC 
//

import Foundation
import UIKit
import SnapKit

class HomeCoinsTVCell:UITableViewCell {
        
    lazy var name: UILabel = {
        let text = UILabel()
        text.textColor = .white
        text.numberOfLines = 0
        text.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return text
    }()
    lazy var symbol: UILabel = {
        let text = UILabel()
        text.textColor = .white
        text.numberOfLines = 0
        text.font = UIFont.systemFont(ofSize: 16, weight: .thin)
        return text
    }()
    lazy var price: UILabel = {
        let text = UILabel()
        text.textColor = .white
        text.numberOfLines = 0
        text.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return text
    }()
    lazy var urlToImage: UIImageView = {
        let icon = UIImageView()
        icon.layer.masksToBounds = true
        icon.layer.cornerRadius = 6
        return icon
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI(){
        contentView.addSubview(name)
        contentView.addSubview(price)
        contentView.addSubview(urlToImage)
        contentView.addSubview(symbol)
        contentView.backgroundColor = .black
        urlToImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        name.snp.makeConstraints { make in
            make.top.equalTo(urlToImage.snp.top)
            make.left.equalTo(urlToImage.snp.right).offset(5)
        }
        symbol.snp.makeConstraints { make in
            make.bottom.equalTo(urlToImage.snp.bottom)
            make.left.equalTo(urlToImage.snp.right).offset(5)
        }
        price.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
    }
}
