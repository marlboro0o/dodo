//
//  CategoryContainerCell.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 06.02.2026.
//

import UIKit
import SnapKit

class CategoryContainerCell: UITableViewHeaderFooterView {
    
    static let reuseId = "CategoryContainerCell"
    var onCategoryTap: ((Category) -> Void)? = nil
    private var categories: [Category] = [] {
        didSet {
            collection.reloadData()
        }
    }
    private var cells: [CategoryCollectionCell] = []
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        //layout.itemSize = CGSize(width: 100, height: 50)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.heightAnchor.constraint(equalToConstant: 50).isActive = true
        collection.dataSource = self
        collection.delegate = self
        collection.register(CategoryCollectionCell.self, forCellWithReuseIdentifier: CategoryCollectionCell.reuseId)
        
        return collection
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(collection)
    }
    
    private func setupConstraints() {
        collection.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(6)
        }
    }
    
    func update(_ categories: [Category]) {
        self.categories = categories
        collection.reloadData()
    }
}

extension CategoryContainerCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard 
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionCell.reuseId, for: indexPath) as? CategoryCollectionCell
        else {
            return UICollectionViewCell()
        }
        
        cell.update(categories[indexPath.item])
        return cell
    }
    
}

extension CategoryContainerCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onCategoryTap?(categories[indexPath.item])
        
        //DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            collection.scrollToItem(at: indexPath, at: .left, animated: true)
        //}
    }
}
