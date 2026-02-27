//
//  PhotoCollectionCell.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 28.01.2026.
//

import UIKit
import SnapKit

class PhotoCollectionCell: UICollectionViewCell {
    static let reuseID = "PhotoCollectionCell"
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.backgroundColor = .blue
        imageView.image = UIImage.init(named: "cucumber")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Маринованные огурчики"
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "79p"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        
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
    
    func setupViews() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
    }
    
    func setupConstraints() {
        photoImageView.snp.makeConstraints { make in
            make.top.left.right.equalTo(contentView)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom).offset(10)
            make.left.right.equalTo(contentView)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.left.right.equalTo(contentView)
        }
    }
}
