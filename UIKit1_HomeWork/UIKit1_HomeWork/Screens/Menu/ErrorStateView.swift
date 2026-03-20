//
//  ViewErrorState.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 13.03.2026.
//

import UIKit
import SnapKit

class ErrorStateView: UIView {
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.text = "Что-то пошло не так \nПовторите попытку позже"
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "menuErrorState")
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        return imageView
    }()
    
    private lazy var repeatButton: CapsuleButton = {
        let button = CapsuleButton()
        button.tintColor = .orange
        button.setTitle("Повторить", for: .normal)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .center
        return stack
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
        addSubview(stackView)
        [headerLabel, imageView, repeatButton].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.center.equalToSuperview()
        }
        repeatButton.snp.makeConstraints { make in
                make.width.equalTo(stackView.snp.width).multipliedBy(0.6) // 60% от ширины стека
                make.height.equalTo(50)
            }
    }
    
}
