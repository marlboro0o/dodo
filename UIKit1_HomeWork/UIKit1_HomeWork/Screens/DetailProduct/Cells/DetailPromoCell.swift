//
//  DetailPromoCell.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 13.02.2026.
//

import UIKit
import SnapKit

class DetailPromoCell: UITableViewCell {
    
    static let reuseId = "DetailPromoCell"
    
    private lazy var promoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        let width = UIScreen.main.bounds.width
        imageView.widthAnchor.constraint(equalToConstant: width * 0.8).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: width * 0.8).isActive = true
        
        return imageView
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
        promoImageView.image = UIImage.init(named: product.image)
    }
    
    private func setupViews() {
        contentView.addSubview(promoImageView)
    }
    
    private func setupConstraints() {
        promoImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
            make.center.equalTo(contentView)
        }
    }
}
