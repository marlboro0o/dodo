//
//  AdressPanelView.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 11.03.2026.
//

import UIKit
import SnapKit

class AddressPanelView: UIView {
    
    var onAddressChanged: ((String) -> Void)?
    
    var timer: Timer?
    var delayValue : Double = 2.0
    
    let addressView = AddressView()
    let saveButton = SaveButton()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ addressText: String) {
        addressView.addressTextField.text = addressText
    }
    
    func observe() {
        //addressView.addressTextField.addTarget(nil, action: #selector(addressTextFieldChanged(_:)), for: .editingChanged)
        addressView.addressTextField.addTarget(nil, action: #selector(addressTextFieldChanged(_:)), for: .editingChanged)
    }
}

//MARK: - Event Handler
extension AddressPanelView {
    
    @objc func addressTextFieldChanged(_ sender: UITextField) {
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: delayValue, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
    }
    
    @objc func timerAction() {
        if let addressText = addressView.addressTextField.text {
            onAddressChanged?(addressText)
        }
    }
}

extension AddressPanelView {
    
    func setupViews() {
        //backgroundColor = .lightGray.withAlphaComponent(0.1)
        backgroundColor = .systemBackground
        self.addSubview(stackView)
        stackView.addArrangedSubview(addressView)
        stackView.addArrangedSubview(saveButton)
        
    }
    
    func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
    }
    
}
