//
//  StoriesContainerCell.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 09.02.2026.
//

import UIKit
import SnapKit

class StoriesContainerCell: UITableViewCell {
    static let reuseId = "StoriesContainerCell"
    
    private var stories: [Story] = [] {
        didSet {
            collection.reloadData()
        }
    }
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        //layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 4
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
       
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.register(StoriesCollectionCell.self, forCellWithReuseIdentifier: StoriesCollectionCell.reuseId)
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
    
    func update(_ stories: [Story]) {
        self.stories = stories
    }
}

extension StoriesContainerCell {
    private func setupViews() {
        contentView.addSubview(collection)
    }
    
    private func setupConstraints() {
        collection.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
            make.height.equalTo(180)
        }
    }
}

extension StoriesContainerCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        stories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoriesCollectionCell.reuseId, for: indexPath) as? StoriesCollectionCell else { return UICollectionViewCell() }
        
        cell.update(stories[indexPath.row])
        return cell
    }
}
