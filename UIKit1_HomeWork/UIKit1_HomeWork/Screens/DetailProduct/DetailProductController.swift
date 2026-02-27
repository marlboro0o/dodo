//
//  DetailProductController.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 13.02.2026.
//

import UIKit
import SnapKit

class DetailProductController: UIViewController {
    
    enum DetailSections: Int {
        case promo
        case detail
        case segments
        case supplements
    }
    private var suplements: [Suplement] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var product: Product
    private var productRepository: ProductRepository
    private let suplementService: ISuplementService
    private var basketSuplements: [Suplement] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var basketProducts: [Product] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.registerCell(DetailPromoCell.self)
        tableView.registerCell(DetailCell.self)
        tableView.registerCell(DetailSegmentsCell.self)
        tableView.registerCell(DetailSupplementsContainerCell.self)
        tableView.register(DetailSupplementsFooterCell.self, forHeaderFooterViewReuseIdentifier: DetailSupplementsFooterCell.reuseId)
        
        return tableView
    }()
    
    init(product: Product, suplementService: ISuplementService, productRepository: ProductRepository) {
        self.product = product
        self.suplementService = suplementService
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
        loadSuplements()
    }
    
    private func loadSuplements() {
        suplementService.loadSuplements { result in
            switch result {
            case .success(let suplements):
                self.suplements = suplements
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
}

extension DetailProductController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let section = DetailSections.init(rawValue: indexPath.section)
        else {
            return UITableViewCell()
        }
        
        switch section {
        case .promo:
            let cell = tableView.dequeuCell(indexPath) as DetailPromoCell
            cell.configure(product)
            return cell
        case .detail:
            let cell = tableView.dequeuCell(indexPath) as DetailCell
            cell.configure(product)
            return cell
        case .segments:
            let cell = tableView.dequeuCell(indexPath) as DetailSegmentsCell
            return cell
        case .supplements:
            let cell = tableView.dequeuCell(indexPath) as DetailSupplementsContainerCell
            cell.configure(suplements, basket: basketSuplements)
            cell.onSelectSuplement = { suplement in
                if self.basketSuplements.contains(suplement) {
                    self.basketSuplements.removeAll(where: { $0 == suplement } )
                } else {
                    self.basketSuplements.append(suplement)
                }
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard
            let detailSection = DetailSections.init(rawValue: section)
        else {
            return nil
        }
        
        switch detailSection {
        case .supplements:
            guard
                let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: DetailSupplementsFooterCell.reuseId) as? DetailSupplementsFooterCell
            else {
                return nil
            }
            
            let sum = basketSuplements.reduce(into: product.price) { result, suplement in
                result += suplement.price
            }
            
            cell.configure(sum: sum)
            cell.onTapBasket = {
                //сохраняем в корзину
                self.productRepository.add(product: self.product.productForBasket(suplements: self.basketSuplements))
//                var basket = self.productRepository.loadProducts(forKey: "basket") ?? []
//                basket.append(self.product.productForBasket(suplements: self.suplements))
//                 
//                do {
//                    try self.productStorage.save(products: basket, forKey: "basket")
//                } catch {
//                    print(error)
//                }
                
                let vc = BasketVC(productRepository: self.productRepository)
                self.present(vc, animated: true)
            }
            
            return cell
        default:
            return nil
        }
    }
    
}

