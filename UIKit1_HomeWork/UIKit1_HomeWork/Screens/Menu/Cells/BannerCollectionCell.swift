//
//  BannerCollectionCell.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 30.01.2026.
//

import UIKit
import SnapKit

class BannerCollectionCell: UICollectionViewCell {
    static let reuseId = "BannerCollectionCell"
    
    private lazy var containerView: UIView = {
        let view = UIView.init()
        view.backgroundColor = .white
        view.applyShadow(cornerRadius: 10)
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage.init(named: "margarita")
        let width = UIScreen.main.bounds.width
        imageView.widthAnchor.constraint(equalToConstant: width * 0.3).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: width * 0.3).isActive = true
        
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.text = "Маргарита"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "650p"
        label.textColor = .gray
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
    
    func update(_ product: Product) {
        nameLabel.text = product.name
        priceLabel.text = "\(product.price) p"
        imageView.image = UIImage(named: product.image)
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(priceLabel)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.left.equalTo(containerView).offset(10)
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(10)
            make.top.right.equalTo(containerView).inset(10)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.left.equalTo(imageView.snp.right).offset(10)
        }
        
    }
}
