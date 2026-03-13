//
//  BasketButton.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 27.02.2026.
//

import UIKit

final class BasketButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
       // super.setTitle(title, for: state)
        
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 22)
        self.configuration?.attributedTitle = AttributedString(title ?? "", attributes: container)
    }
    
    private func setupConfiguration() {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "100"
        configuration.image = UIImage(systemName: "cart.fill")
        configuration.cornerStyle = .capsule
        
        self.configuration = configuration
        tintColor = .orange
    }
}
