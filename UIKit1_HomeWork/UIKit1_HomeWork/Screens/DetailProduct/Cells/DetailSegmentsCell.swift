//
//  DetailSegmentsCell.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 13.02.2026.
//

import UIKit
import SnapKit

class DetailSegmentsCell: UITableViewCell {
    static let reuseId = "DetailSegmentsCell"
    
    var onChangeSize: ((Int) -> ())? = nil
    var onChangeDough: ((Int) -> ())? = nil
    
    private lazy var sizeSegment: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.insertSegment(withTitle: "20 cm", at: 0, animated: true)
        segment.insertSegment(withTitle: "25 cm", at: 1, animated: true)
        segment.insertSegment(withTitle: "30 cm", at: 2, animated: true)
        segment.insertSegment(withTitle: "35 cm", at: 3, animated: true)
        segment.addTarget(self, action: #selector(didChangeSize), for: .valueChanged)
        return segment
    }()
    
    private lazy var doughSegment: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.insertSegment(withTitle: "Традиционное", at: 0, animated: true)
        segment.insertSegment(withTitle: "Тонкое", at: 1, animated: true)
        segment.addTarget(self, action: #selector(didChangeDough), for: .valueChanged)
        return segment
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(size: Product.Size, dough: Product.Dough) {
        sizeSegment.selectedSegmentIndex = size.rawValue
        doughSegment.selectedSegmentIndex = dough.rawValue
    }
    
    private func setupViews() {
        contentView.addSubview(sizeSegment)
        contentView.addSubview(doughSegment)
    }
    
    private func setupConstraints() {
        sizeSegment.snp.makeConstraints { make in
            make.top.left.right.equalTo(contentView).inset(15)
            make.height.equalTo(40)
        }
        doughSegment.snp.makeConstraints { make in
            make.top.equalTo(sizeSegment.snp.bottom).offset(5)
            make.left.right.bottom.equalTo(contentView).inset(15)
        }
    }
    
    @objc
    private func didChangeSize(_ segment: UISegmentedControl) {
        onChangeSize?(segment.selectedSegmentIndex)
    }
    
    @objc
    private func didChangeDough(_ segment: UISegmentedControl) {
        onChangeDough?(segment.selectedSegmentIndex)
    }
}
