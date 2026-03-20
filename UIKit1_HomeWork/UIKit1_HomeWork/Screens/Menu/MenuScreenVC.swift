//
//  ViewController.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 23.01.2026.
//

import UIKit
import SnapKit

final class MenuScreenVC: UIViewController {

    enum MenuState {
        case initial
        case loading
        case loaded
        case error
    }
    
    enum MenuSection: Int {
        case stories
        case banners
        case promo
        case products
    }
    
    private var basket: [Product] = []
    private let dispatchGroup = DispatchGroup()
    private let productService: IProductService
    private let productRepository: IProductRepository
    private let categoryService: ICategoryService
    private let storyService: IStoryService
    private var fetchErrors: [Error] = []
    
    private var state: MenuState = .initial {
        didSet {
            render(state)
        }
    }
    private var products: [Product] = []
    private var productsFilter: [Product] = [] {
        didSet {
            tableView.reloadSections(IndexSet(integer: MenuSection.products.rawValue), with: .automatic)
            tableView.reloadSections(IndexSet(integer: MenuSection.banners.rawValue), with: .automatic)
        }
    }
    private var categories: [Category] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var stories: [Story] = [] {
        didSet {
            tableView.reloadSections(IndexSet(integer: MenuSection.stories.rawValue), with: .automatic)
        }
    }
    
    private var basketButton: BasketButton = {
        let button = BasketButton()
        button.setTitle("1000", for: .normal)
        button.isHidden = true
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init() //Инициализируем таблицу
        tableView.backgroundColor = .orange //Поставим цвет чтобы увидеть таблицу на вью
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
       
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(ProductCell.self)
        tableView.registerCell(BannerContainerCell.self)
        tableView.registerCell(PromoCell.self)
        tableView.registerCell(StoriesContainerCell.self)
        tableView.register(CategoryContainerCell.self, forHeaderFooterViewReuseIdentifier: CategoryContainerCell.reuseId)
        
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return tableView
    }()
    
    private let errorView: UIView = ErrorStateView()
    
    init(productService: IProductService, 
         categoryService: ICategoryService,
         storyService: IStoryService,
         productRepository: IProductRepository) {
        self.productService = productService
        self.categoryService = categoryService
        self.storyService = storyService
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
        setupTargets()
        fetchAllData()

        setupObservers()
    }
    
    private func fetchAllData() {
        dispatchGroup.enter()
        fetchProducts()
        
        dispatchGroup.enter()
        fetchCategories()
        
        dispatchGroup.enter()
        fetchStories()
        
        // Уведомление о завершении всех задач
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard 
                let self = self,
                self.fetchErrors.isEmpty 
            else {
                self?.state = .error
                return
            }
            
            // Загружаем корзину (синхронная операция)
            self.fetchBasket()
            self.state = .loaded
        }
    }
    
    private func fetchProducts() {
        productService.loadProducts { [weak self] result in
            guard let self else { return }
            defer { self.dispatchGroup.leave() }
            
            switch result {
            case .success(let products):
                self.products = products
                self.productsFilter = products
            case .failure(let error):
                print(error.localizedDescription)
                fetchErrors.append(error)
            }
        }
    }
    
    private func fetchCategories() {
        categoryService.loadCategories { [weak self] result in
            guard let self else { return }
            defer { self.dispatchGroup.leave() }
            
            switch result {
            case .success(let categories):
                self.categories = categories
            case.failure(let error):
                print(error.localizedDescription)
                fetchErrors.append(error)
            }
        }
    }
    
    private func fetchStories() {
        storyService.loadStories { [weak self] result in
            guard let self else { return }
            defer { self.dispatchGroup.leave() }
            
            switch result {
            case .success(let stories):
                self.stories = stories
            case .failure(let error):
                print(error.localizedDescription)
                fetchErrors.append(error)
            }
        }
    }
    
    private func fetchBasket() {
        basket = productRepository.get()
        //basketButton.isHidden = basket.isEmpty
        let sum = basket.reduce(into: 0) { result, product in
            result += product.getSum()
        }
        basketButton.setTitle("\(sum) P", for: .normal)
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(totalBasketPrice),
                                               name: .totalPriceNotification,
                                               object: nil)
    }
    
    private func render(_ state: MenuState) {
        switch state {
        case .initial, .loading, .loaded:
            tableView.isHidden = false
            basketButton.isHidden = basket.isEmpty
            errorView.isHidden = true
        case .error:
            print("error")
            tableView.isHidden = true
            basketButton.isHidden = true
            errorView.isHidden = false
        }
    }
    
    @objc
    private func didTapBasket() {
        present(
            di.screenFactory.makeBasketVC(),
            animated: true)
    }
    
    @objc
    private func totalBasketPrice(_ notification: Notification) {
        if let value = notification.userInfo?["value"] as? Int {
            basketButton.setTitle("\(value) P", for: .normal)
            basketButton.isHidden = value == 0
        }
    }

}

extension MenuScreenVC {
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(errorView)
        view.addSubview(tableView)
        view.addSubview(basketButton)
    }
    
    private func setupConstraints() {
        errorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        basketButton.snp.makeConstraints { make in
            make.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
    }
    
    private func setupTargets() {
        basketButton.addTarget(self, action: #selector(didTapBasket), for: .touchUpInside)
    }
}

extension MenuScreenVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard
            let menuSection = MenuSection.init(rawValue: section)
        else {
            return 0
        }
        switch menuSection {
        case .stories:
            return 1
        case .banners:
            return 1
        case .promo:
            return 1
        case .products:
            return productsFilter.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard 
            let menuSection = MenuSection.init(rawValue: indexPath.section)
        else {
            return UITableViewCell()
        }
        
        switch menuSection {
        case .banners:
            let cell = tableView.dequeuCell(indexPath) as BannerContainerCell
            cell.update(products)
            return cell
        case .promo:
            let cell = tableView.dequeuCell(indexPath) as PromoCell
            return cell
        case .products:
            let cell = tableView.dequeuCell(indexPath) as ProductCell
            cell.update(productsFilter[indexPath.row])
            return cell
        case .stories:
            let cell = tableView.dequeuCell(indexPath) as StoriesContainerCell
            cell.update(stories)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let menuSection = MenuSection.init(rawValue: section) else { return nil }
        
        switch menuSection {
        case .products:
            guard 
                let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CategoryContainerCell.reuseId) as? CategoryContainerCell
            else {
                return UIView()
            }
            header.update(categories)
            header.onCategoryTap = { [weak self] category in
                guard
                    let self,
                    let firstIndex = self.categories.firstIndex(of: category)
                else {
                    return
                }
                
                for (index, item) in self.categories.enumerated() {
                    if index == firstIndex {
                        self.categories[index] = item.didSelect()
                    } else if item.isSelected {
                        categories[index] = item.didSelect()
                    }
                }
                
                let indexProduct = products.firstIndex(where: { $0.category == category } )
                
                let indexPath = IndexPath(row: indexProduct ?? 0, section: MenuSection.products.rawValue)
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
            }
            
            return header
        default: return EmptyView.init()
        }
    }
}

extension MenuScreenVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = MenuSection.init(rawValue: indexPath.section) else { return }
        
        if section == .products {
            let vc = di.screenFactory.makeDetailProduct(product: products[indexPath.row], operation: .add)
            present(vc, animated: true)
        }
    }
}

extension UIView {
    func applyShadow(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        
    }
}

extension UITableView {
    func registerCell<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.reuseId)
    }
    func dequeuCell<Cell: UITableViewCell>(_ indexPath: IndexPath) -> Cell {
        guard
            let cell = dequeueReusableCell(withIdentifier: Cell.reuseId, for: indexPath) as? Cell
        else {
            fatalError("Fatal error for cell at \(indexPath)")
        }
        return cell
    }
}

protocol Reusable {
}

extension UITableViewCell: Reusable {
}

extension Reusable where Self: UITableViewCell {
    static var reuseId: String {
        return String.init(describing: self)
    }
}
