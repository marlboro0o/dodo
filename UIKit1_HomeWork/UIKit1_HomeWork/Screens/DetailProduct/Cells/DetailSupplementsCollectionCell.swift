//
//  DetailSupplementsCollectionCell.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 15.02.2026.
//

import UIKit
import SnapKit

class DetailSupplementsCollectionCell: UICollectionViewCell {
    static let reuseId = "DetailSupplementsCollectionCell"
    private lazy var containerView: UIView = {
        let view = UIView.init()
        view.backgroundColor = .white
        view.applyShadow(cornerRadius: 10)
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 22)
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
    
    func configure(suplement: Suplement) {
        imageView.image = UIImage.init(named: suplement.image)
        nameLabel.text = suplement.name
        priceLabel.text = "\(suplement.price) P"
        
        var borderColor = UIColor.white
        var borderWidth = 0.0
        if isSelected {
            borderColor = .orange
            borderWidth = 3.0
        }
        containerView.layer.borderColor = borderColor.cgColor
        containerView.layer.borderWidth = borderWidth
    }
    
    private func setupViews() {
        contentView.backgroundColor = .white
        contentView.addSubview(containerView)
        
        [imageView, nameLabel, priceLabel].forEach {
            containerView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        imageView.snp.makeConstraints { make in
            make.top.left.right.equalTo(containerView).inset(15)
            make.height.equalTo(100)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.left.right.equalTo(containerView).inset(15)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.right.bottom.equalTo(containerView).inset(15)
        }
    }
}
