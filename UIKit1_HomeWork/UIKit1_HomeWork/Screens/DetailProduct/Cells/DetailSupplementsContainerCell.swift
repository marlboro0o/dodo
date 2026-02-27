//
//  DetailSupplementsContainer.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 13.02.2026.
//

import UIKit
import SnapKit

class DetailSupplementsContainerCell: UITableViewCell {
    static let reuseId = "DetailSupplementsContainerCell"
    var onSelectSuplement: ((Suplement) -> ())? = nil
    private var heightCell = 0.0
    private var basket: [Suplement] = [] {
        didSet {
            collection.reloadData()
        }
    }
    private var suplements: [Suplement] = [] {
        didSet {
            collection.reloadData()
        }
    }
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Добавить по вкусу"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        //layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        
        let width = UIScreen.main.bounds.width * 0.29
        heightCell = UIScreen.main.bounds.height * 0.26
        layout.itemSize = CGSize(width: width, height: heightCell)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(DetailSupplementsCollectionCell.self, forCellWithReuseIdentifier: DetailSupplementsCollectionCell.reuseId)

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
    func configure(_ suplements: [Suplement], basket: [Suplement]) {
        self.suplements = suplements
        self.basket = basket
        
        //collection.heightAnchor.constraint(equalToConstant: (heightCell + 5) * Double(suplements.count) / 3).isActive = true
    }
    
    private func setupViews() {
        contentView.addSubview(headerLabel)
        contentView.addSubview(collection)
    }
    
    private func setupConstraints() {
        
        headerLabel.snp.makeConstraints {make in
            make.top.equalTo(contentView)
            make.left.right.equalTo(contentView).inset(15)
            make.height.equalTo(50)
        }
        collection.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(10)
            make.left.right.bottom.equalTo(contentView).inset(15)
            make.height.equalTo(1500)
        }
    }
}

extension DetailSupplementsContainerCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        suplements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard 
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailSupplementsCollectionCell.reuseId, for: indexPath) as? DetailSupplementsCollectionCell
        else {
            return UICollectionViewCell()
        }
        let suplement = suplements[indexPath.item]
        cell.isSelected = basket.contains(suplement)
        cell.configure(suplement: suplement)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelectSuplement?(suplements[indexPath.item])
    }
}
