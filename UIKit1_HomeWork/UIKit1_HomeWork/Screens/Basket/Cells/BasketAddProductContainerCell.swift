//
//  BasketAddProductContainerCell.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 25.02.2026.
//

import UIKit
import SnapKit

class BasketAddProductContainerCell: UITableViewCell {
    static let reuseId = "BasketAddProductContainerCell"
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Добавить к заказу?"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        
        return label
    }()
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 5
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.dataSource = self
        return collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [headerLabel, collection].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.top.left.equalTo(contentView).offset(10)
        }
        collection.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(10)
            make.left.right.equalTo(contentView)
            make.height.equalTo(150)
        }
    }
    
    
}

extension BasketAddProductContainerCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
    
    
}
