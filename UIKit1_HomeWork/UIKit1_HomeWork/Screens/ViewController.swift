//
//  ViewController.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 26.01.2026.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let itemCount: CGFloat = 3
        let padding: CGFloat = 20
        let paddingCount: CGFloat = itemCount + 1
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        
        let paddingSize = padding * paddingCount
        let cellSize = (UIScreen.main.bounds.width - paddingSize) / itemCount
        
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        layout.itemSize = CGSize.init(width: cellSize, height: cellSize * 2)
        
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .orange
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCollectionCell.self, forCellWithReuseIdentifier: PhotoCollectionCell.reuseID)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionCell.reuseID, for: indexPath) as? PhotoCollectionCell else { return UICollectionViewCell() }
        cell.backgroundColor = .yellow
        return cell
    }
    
    
}

extension ViewController: UICollectionViewDelegate {
    
}
