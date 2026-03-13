//
//  CapsuleButton.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 04.03.2026.
//

import UIKit

final class CapsuleButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConfiguration() {
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        self.configuration = configuration
    }
}
