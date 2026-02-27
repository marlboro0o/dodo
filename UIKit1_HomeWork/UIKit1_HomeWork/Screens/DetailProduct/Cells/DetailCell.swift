//
//  DetailCell.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 13.02.2026.
//

import UIKit
import SnapKit

class DetailCell: UITableViewCell {
    static let reuseId = "DetailCell"
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ product: Product) {
        nameLabel.text = product.name
        detailLabel.text = product.detail
    }
    
    private func setupViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(detailLabel)
    }
    
    private func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(5)
            make.left.equalTo(contentView).inset(15)
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(contentView).inset(15)
            make.width.bottom.equalToSuperview()
        }
    }
}
