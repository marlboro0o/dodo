//
//  BaskedProductCell.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 20.02.2026.
//

import UIKit
import SnapKit

class BasketProductCell: UITableViewCell {
    static let reuseId = "BaskedProductCell"
    
    var onTapChangeProduct: (() -> ())?
    var onTapChangeCountProduct: ((Int) -> ())?
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        let width = UIScreen.main.bounds.width
        imageView.widthAnchor.constraint(equalToConstant: 0.3 * width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 0.3 * width).isActive = true
        return imageView
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var suplementsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var changeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Изменить", for: .normal)
        button.setTitleColor(.systemOrange, for: .normal)
        button.addTarget(self, action: #selector(didTapChangeButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var countStepper: CustomStepper = {
        let stepper = CustomStepper()
        stepper.addTarget(self, action: #selector(stepperChangeValue), for: .touchUpInside)
        return stepper
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        return stack
    }()
    
    private lazy var headerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
    }()
    
    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 1
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(product: Product) {
        productImageView.image = UIImage(named: product.image)
        nameLabel.text = product.name
        
        let textSuplements = product.suplements?.reduce(into: []) { result, suplement in
            result.append(suplement.name)
        } .joined(separator: ", ") ?? ""
        suplementsLabel.text = "+ \(textSuplements)"
        priceLabel.text = "\(product.getSum()) P"
        countStepper.currentValue = product.countInBasket ?? 1
    }
    
    private func setupViews() {
        [nameLabel, suplementsLabel].forEach {
            verticalStack.addArrangedSubview($0)
        }
        [productImageView, verticalStack].forEach {
            headerStack.addArrangedSubview($0)
        }
        [changeButton, countStepper].forEach {
            buttonStack.addArrangedSubview($0)
        }
        [headerStack, priceLabel, buttonStack].forEach {
            contentView.addSubview($0)
        }
    }
   
    private func setupConstraints() {
        headerStack.snp.makeConstraints { make in
            make.top.left.equalTo(contentView).offset(15)
            make.right.equalTo(contentView).inset(15)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(headerStack.snp.bottom).offset(15)
            make.left.equalTo(contentView).offset(15)
            make.bottom.equalTo(contentView).inset(15)
        }
        
        buttonStack.snp.makeConstraints { make in
            make.centerY.equalTo(priceLabel)
            make.right.equalTo(contentView).inset(10)
        }
    }
    
    @objc
    private func stepperChangeValue(sender: CustomStepper) {
        onTapChangeCountProduct?(sender.currentValue)
    }
    
    @objc
    private func didTapChangeButton() {
        onTapChangeProduct?()
    }
}
