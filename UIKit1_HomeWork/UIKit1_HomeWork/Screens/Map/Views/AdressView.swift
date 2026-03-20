//
//  AdressView.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 11.03.2026.
//

import Foundation
import UIKit
import SnapKit

class AddressView: UIView {
    
    private var discriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Город, улица и дом"
        label.font = UIFont.systemFont(ofSize: 13, weight: .thin)
        return label
    }()
    
    var addressTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Ваш адрес"
        textField.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return textField
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        //stack.spacing = 4
        
        stack.layer.borderWidth = 2
        stack.layer.borderColor = UIColor.lightGray.cgColor
        stack.layer.cornerRadius = 16
        
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 8)
        stack.isLayoutMarginsRelativeArrangement = true
        
        return stack
    }()
    
//    var addressTextField: CustomTextField = {
//        CustomTextField(header: "Город, улица и дом")
//    }()
    private let entranceTextField: CustomTextField = {
        CustomTextField(header: "Подъезд")
    }()
    
    private let intercomTextField: CustomTextField = {
        CustomTextField(header: "Домофон")
    }()
    
    private let floorTextField: CustomTextField = {
        CustomTextField(header: "Этаж")
    }()
    
    private let apartmentTextField: CustomTextField = {
        CustomTextField(header: "Квартира")
    }()
    private let сommentTextField: CustomTextField = {
        CustomTextField(header: "Комментарий для курьера")
    }()
    private let verticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()
    
    private let horizontStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = .fillEqually
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

}

extension AddressView {
    
    func setupViews() {
        self.addSubview(stackView)
        
        stackView.addArrangedSubview(discriptionLabel)
        stackView.addArrangedSubview(addressTextField)
        
        let hStack = horizontStack
        hStack.addArrangedSubview(entranceTextField)
        hStack.addArrangedSubview(intercomTextField)
        
        verticalStackView.addArrangedSubview(hStack)
        
        let hStack1 = UIStackView()
        hStack1.axis = .horizontal
        hStack1.spacing = 5
        hStack1.distribution = .fillEqually
        hStack1.addArrangedSubview(floorTextField)
        hStack1.addArrangedSubview(apartmentTextField)
        
        verticalStackView.addArrangedSubview(hStack1)
        verticalStackView.addArrangedSubview(сommentTextField)
        
        self.addSubview(verticalStackView)
    }
    
    func setupConstraints() {
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(25)
            make.left.right.equalToSuperview()
           // make.bottom.equalToSuperview().inset(16)
        }
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(addressTextField.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }

    }
}


