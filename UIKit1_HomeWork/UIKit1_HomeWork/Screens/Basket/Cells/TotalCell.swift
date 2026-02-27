//
//  TotalCell.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 20.02.2026.
//

import UIKit
import SnapKit

class TotalCell: UITableViewCell {
    static let reuseId = "TotalCell"
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 34)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String) {
        totalLabel.text = text
    }
    
    private func setupViews() {
        contentView.addSubview(totalLabel)
    }
    
    private func setupConstraints() {
        totalLabel.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
}
