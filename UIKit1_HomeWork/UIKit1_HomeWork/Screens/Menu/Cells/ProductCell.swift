//
//  ProductCell.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 23.01.2026.
//

import UIKit
import SnapKit

class ProductCell: UITableViewCell {
    static let reuseId = "ProductCell"
    private var imageViewWidthConstraint: Constraint?
    private var imageViewHeightConstraint: Constraint?
    
    private lazy var containerView: UIView = {
        $0.backgroundColor = .white
        $0.applyShadow(cornerRadius: 10)
        return $0
    }(UIView())

    private lazy var verticalStackView: UIStackView = {
        let stack = UIStackView.init()
        stack.axis = .vertical
        stack.spacing = 15
        stack.alignment = .leading
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 12, bottom: 15, trailing: 0)
        stack.isLayoutMarginsRelativeArrangement = true
        
        return stack
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Гавайская"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.text = "Тесто, Цыпленок, моцарелла, томатный соус"
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 15)
        
        return label
    }()
    
    private lazy var priceButton: CapsuleButton = {
        let button = CapsuleButton()
        button.setTitle("от 469 руб", for: .normal)
        button.tintColor = .orange.withAlphaComponent(0.1)
        button.setTitleColor(.brown, for: .normal)
        return button
    }()
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pizza")
        //imageView.contentMode = .scaleAspectFill
        let width = UIScreen.main.bounds.width
        imageView.widthAnchor.constraint(equalToConstant: 0.4 * width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 0.4 * width).isActive = true
        
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
    
    func update(_ product: Product) {
        nameLabel.text = product.name
        detailLabel.text = product.detail
        priceButton.setTitle("\(product.price) p", for: .normal)
        productImageView.image = UIImage(named: product.image)
    }
}

extension ProductCell {
    struct Layout {
        static let offset = 16
    }
    private func setupViews() {
        [containerView].forEach {
            contentView.addSubview($0)
        }
        [productImageView, verticalStackView].forEach {
            containerView.addSubview($0)
        }
        [nameLabel, detailLabel, priceButton].forEach {
            verticalStackView.addArrangedSubview($0)
        }
    }
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.left.right.equalTo(contentView).inset(16)
            make.top.bottom.equalTo(contentView).inset(8)
        }
        
        productImageView.snp.makeConstraints { make in
            make.left.equalTo(containerView).offset(8)
            make.centerY.equalTo(containerView)
            make.top.bottom.greaterThanOrEqualTo(containerView).inset(8)
        }
        verticalStackView.snp.makeConstraints { make in
            make.top.right.bottom.equalTo(containerView).inset(8)
            make.left.equalTo(productImageView.snp.right).offset(8)
        }
    }
}
