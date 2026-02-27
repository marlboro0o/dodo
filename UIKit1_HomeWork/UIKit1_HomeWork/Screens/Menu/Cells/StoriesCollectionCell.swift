//
//  StoriesCollectionCell.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 09.02.2026.
//

import UIKit
import SnapKit

class StoriesCollectionCell: UICollectionViewCell {
    static let reuseId = "StoriesCollectionCell"
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ story: Story) {
        imageView.image = UIImage(named: story.image)
    }
    
    private func setupViews() {
        contentView.addSubview(imageView)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(5)
            make.width.equalTo(120)
            make.height.equalTo(160)
        }
    }
}
