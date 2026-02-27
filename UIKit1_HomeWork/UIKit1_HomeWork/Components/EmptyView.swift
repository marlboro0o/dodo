//
//  EmptyView.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 06.02.2026.
//

import UIKit
import SnapKit

class EmptyView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstaints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstaints() {
//        translatesAutoresizingMaskIntoConstraints = false
//        widthAnchor.constraint(equalToConstant: 1).isActive = true
//        heightAnchor.constraint(equalToConstant: 1).isActive = true
        snp.makeConstraints { make in
            make.height.width.equalTo(1)
        }
    }
}
