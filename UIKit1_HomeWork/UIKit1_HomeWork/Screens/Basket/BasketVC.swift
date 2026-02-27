//
//  BasketVC.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 20.02.2026.
//

import UIKit
import SnapKit

class BasketVC: UIViewController {
    enum SectionBasket: Int {
        case total
        case products
        case suplements
    }
    
    private var basket: [Product] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var productRepository: ProductRepository
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Закрыть", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.addTarget(self, action: #selector(didTapClosed), for: .touchUpInside)
        return button
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Корзина"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.registerCell(TotalCell.self)
        tableView.registerCell(BasketProductCell.self)
        
        return tableView
    }()
    
    init(productRepository: ProductRepository) {
        //self.basket = basket
        self.productRepository = productRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        fetchBasket()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
       
        [closeButton, headerLabel, tableView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        closeButton.snp.makeConstraints { make in
            make.top.left.equalTo(view).inset(15)
        }
        
        headerLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(closeButton)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(50)
            make.left.right.bottom.equalTo(view).inset(15)
        }
    }
    
    private func fetchBasket() {
//        if let basket = productStorage.loadProducts(forKey: "basket") {
//            self.basket = basket
//        }
        basket = productRepository.get()
    }
    
    @objc
    private func didTapClosed() {
        dismiss(animated: true)
    }
}

extension BasketVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionBasket = SectionBasket.init(rawValue: section) else { return 0 }
        
        switch sectionBasket {
        case .total:
            return 1
        case .products:
            return basket.count
        case .suplements:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionBasket = SectionBasket.init(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch sectionBasket {
        case .total:
            let cell = tableView.dequeuCell(indexPath) as TotalCell
            
            let sum = basket.reduce(into: 0) { result, product in
                result += product.getSum()
            }
            cell.configure(text: "\(basket.count) товар(а) на \(sum) P")
            return cell
        
        case .products:
            let cell = tableView.dequeuCell(indexPath) as BasketProductCell
            cell.configure(product: basket[indexPath.row])
            
            cell.onTapChangeProduct = {
                self.didTapClosed()
            }
            cell.onTapChangeCountProduct = { value in
                self.productRepository.update(product: self.basket[indexPath.row], count: value) { basket in
                    self.basket = basket
                }
            }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
}
