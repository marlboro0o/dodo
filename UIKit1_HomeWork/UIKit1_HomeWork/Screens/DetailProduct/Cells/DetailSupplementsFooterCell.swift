//
//  DetailSupplementsFooterCell.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 16.02.2026.
//

import UIKit
import SnapKit

class DetailSupplementsFooterCell: UITableViewHeaderFooterView {
    static let reuseId = "DetailSupplementsFooterCell"
    var onTapBasket: (() -> ())? = nil
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .orange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.setTitle("В корзину", for: .normal)
        button.contentEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(didTapBasket), for: .touchUpInside)
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(sum: Int) {
        button.setTitle("В корзину за \(sum) P", for: .normal)
    }
    
    private func setupViews() {
        contentView.addSubview(button)
    }
    
    private func setupConstraints() {
        button.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView)
            make.left.right.equalTo(contentView).inset(15)
        }
    }
    
    @objc
    private func didTapBasket() {
        onTapBasket?()
    }
}
