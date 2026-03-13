//
//  PromoCell.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 02.02.2026.
//

import UIKit
import SnapKit

class PromoCell: UITableViewCell {
    
    static let reuseId = "PromoCell"
    
    lazy var containerView: UIView = {
        let view = UIView()
       // view.layer.addSublayer(CAGradientLayer(layer: ))
        return view
    }()
    
    lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage.init(named: "pepperoni")
        let width = UIScreen.main.bounds.width
        imageView.widthAnchor.constraint(equalToConstant: width * 0.8).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: width * 0.8).isActive = true
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Масала"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.text = "Тесто, Цыпленок, моцарелла, томатный соус"
        label.textColor = .darkGray
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var priceButton: CapsuleButton = {
        let button = CapsuleButton()
        button.setTitle("от 369 руб", for: .normal)
        button.tintColor = .white
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    // MARK: - Layers
    private let backgroundLayer = CALayer()
    private let haloLayer = CAGradientLayer()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
           super.layoutSubviews()
           
           backgroundLayer.frame = bounds
           haloLayer.frame = bounds
    }
    
    private func setupViews() {
        // Основные настройки карточки
        containerView.layer.cornerRadius = 25
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = .systemGray6
        
        // Создаем градиентный фон
        setupBackground()
        
        contentView.addSubview(containerView)
        [productImageView,nameLabel,detailLabel,priceButton].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(5)
        }
        productImageView.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(20)
            make.centerX.equalTo(containerView)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(10)
            make.left.equalTo(containerView).offset(20)
        }
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(containerView).offset(20)
        }
        priceButton.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(10)
            make.right.bottom.equalTo(contentView).inset(10)
            
        }
    }
    
    private func setupBackground() {
        // Основной светло-серый фон
        backgroundLayer.backgroundColor = UIColor.systemGray6.cgColor
        backgroundLayer.cornerRadius = 25
        containerView.layer.insertSublayer(backgroundLayer, at: 0)
        
        // Оранжевый нимб сверху
        haloLayer.type = .radial
        haloLayer.colors = [
            UIColor.orange.withAlphaComponent(0.3).cgColor,
            UIColor.orange.withAlphaComponent(0.1).cgColor,
            UIColor.clear.cgColor
        ]
        haloLayer.locations = [0, 0.3, 1]
        haloLayer.startPoint = CGPoint(x: 0.5, y: 0.2)
        haloLayer.endPoint = CGPoint(x: 1.5, y: 1.0)
        containerView.layer.insertSublayer(haloLayer, at: 1)
    }
}
