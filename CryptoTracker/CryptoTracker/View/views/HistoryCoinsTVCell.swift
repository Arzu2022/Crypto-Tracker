//
//  HistoryCoinsTVCell.swift
//  CryptoTracker
//
//  Created by AziK's  MAC 
//

import Foundation
import UIKit
import SnapKit

class HistoryCoinsTVCell:UITableViewCell {
        
    lazy var name: UILabel = {
        let text = UILabel()
        text.textColor = .white
        text.numberOfLines = 0
        text.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return text
    }()
    
    lazy var min: UILabel = {
        let text = UILabel()
        text.textColor = .white
        text.numberOfLines = 0
        text.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return text
    }()
    lazy var max: UILabel = {
        let text = UILabel()
        text.textColor = .white
        text.numberOfLines = 0
        text.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return text
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
        contentView.addSubview(min)
        contentView.addSubview(max)
        contentView.backgroundColor = .black
        name.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        max.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        min.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
