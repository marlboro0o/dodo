//
//  CustomTextField.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 13.03.2026.
//

import UIKit

class CustomTextField: UIStackView {
    
    var label: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: 13, weight: .thin)
        return label
    }()
    
    var textField: UITextField = {
        let textField = UITextField()
        textField.heightAnchor.constraint(equalToConstant: 24).isActive = true
        textField.addTarget(self, action: #selector(didEditing), for: .editingChanged)
        textField.addTarget(self, action: #selector(didEditing), for: .editingDidBegin)
        
        return textField
    }()
    
    init(header: String) {
        super.init(frame: .zero)
        setupUI(header)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(_ header: String) {
        axis = .vertical
        alignment = .leading
        heightAnchor.constraint(equalToConstant: 60).isActive = true
        layer.borderWidth = 2
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 16
        
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 8)
        isLayoutMarginsRelativeArrangement = true
        
        addArrangedSubview(label)
        addArrangedSubview(textField)
        
        label.text = header
        textField.placeholder = header
    }
    
    @objc
    private func didEditing() {
        label.isHidden = textField.text?.isEmpty ?? true
    }
}
