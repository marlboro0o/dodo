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
    private let suplementService: ISuplementService
    private let productRepository: IProductRepository
    
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
    
    private lazy var footerStack: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .white
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .center
        return stack
    }()
    
    private lazy var footerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Доставим бесплатно"
        return label
    }()
    
    private lazy var footerButton: CapsuleButton = {
        let button = CapsuleButton()
        button.tintColor = .orange
        button.setTitle("Оформить заказ", for: .normal)
        button.addTarget(self, action: #selector(didTapPlaceOrder), for: .touchUpInside)
        return button
    }()
    
    init(productRepository: IProductRepository, suplementService: ISuplementService) {
        self.productRepository = productRepository
        self.suplementService = suplementService
        
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
        setupObservers()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
       
        [closeButton, headerLabel, tableView, footerStack].forEach {
            view.addSubview($0)
        }
        
        [footerLabel, footerButton].forEach {
            footerStack.addArrangedSubview($0)
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
            make.left.right.equalTo(view).inset(15)
        }
        
        footerStack.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(1)
            make.left.equalTo(view).offset(15)
            make.right.bottom.equalTo(view).inset(15)
        }
        
        footerButton.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width).multipliedBy(0.8)
            make.height.equalTo(50)
        }
    }
    
    private func fetchBasket() {
        basket = productRepository.get()
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateBasket), name: .updateBasket, object: nil)
    }
    
    @objc
    private func didTapClosed() {
        dismiss(animated: true)
    }
    
    @objc
    private func updateBasket() {
        fetchBasket()
    }
    
    @objc
    private func didTapPlaceOrder() {
        present(di.screenFactory.makeMapVC(),animated: true)
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
            let userInfo: [AnyHashable: Any] = ["value": sum]
            NotificationCenter.default.post(
                name: .totalPriceNotification,
                object: nil,
                userInfo: userInfo)
            
            cell.configure(text: "\(basket.count) товар(а) на \(sum) P")
            return cell
        
        case .products:
            let cell = tableView.dequeuCell(indexPath) as BasketProductCell
            cell.configure(product: basket[indexPath.row])
            
            cell.onTapChangeProduct = {
                let vc = di.screenFactory.makeDetailProduct(product: self.basket[indexPath.row], operation: .change)
                self.present(vc, animated: true)
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
