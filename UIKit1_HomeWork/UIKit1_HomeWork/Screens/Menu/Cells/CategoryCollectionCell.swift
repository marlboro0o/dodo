//
//  CategoryCollectionCell.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 06.02.2026.
//

import UIKit
import SnapKit

class CategoryCollectionCell: UICollectionViewCell {
    
    static let reuseId = "CategoryCollectionCell"
    
    lazy var nameLabel: LabelInsets = {
        let label = LabelInsets.init()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.layer.cornerRadius = 30
        label.clipsToBounds = true
        label.backgroundColor = .systemGray6
        label.contentInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(nameLabel)
    }
    
    private func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    func update(_ category: Category) {
        nameLabel.text = category.name
        
        if category.isSelected {
            nameLabel.textColor = .black
        } else {
            nameLabel.textColor = .systemGray4
        }
    }
}
