//
//  MenuScreenPresenter.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 20.03.2026.
//

import Foundation

protocol IMenuPresenter: AnyObject {
    func viewDidLoad()
    func didSelectProduct(index: Int)
    func showBasket()
    func didTapCategory(category: Category)
}

class MenuPresenter: IMenuPresenter {
    
    enum MenuState {
        case initial
        case loading
        case loaded
        case error
    }
    
    weak var view: IMenuScreenVC?
    var router: IMenuRouter?
    
    private let productService: IProductService
    private let productRepository: IProductRepository
    private let categoryService: ICategoryService
    private let storyService: IStoryService
    private let dispatchGroup = DispatchGroup()
    private var fetchErrors: [Error] = []
    private var basket: [Product] = []
    private var products: [Product] = [] {
        didSet {
            view?.showProducts(products: products)
        }
    }
    private var categories: [Category] = [] {
        didSet {
            view?.showCategories(categories: categories)
        }
    }
    private var stories: [Story] = [] {
        didSet {
            view?.showStories(stories: stories)
        }
    }
    
    private var state: MenuState = .initial {
        didSet {
            view?.render(state)
        }
    }
    
    init(productService: IProductService,
         categoryService: ICategoryService,
         storyService: IStoryService,
         productRepository: IProductRepository,
         router: IMenuRouter) {
        self.productService = productService
        self.categoryService = categoryService
        self.storyService = storyService
        self.productRepository = productRepository
        self.router = router
    }
    
}

//MARK: - Business Logic
extension MenuPresenter {
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
        let sum = basket.reduce(into: 0) { result, product in
            result += product.getSum()
        }
        view?.updateBasket(sum: sum)
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(totalBasketPrice),
                                               name: .totalPriceNotification,
                                               object: nil)
    }
    
    @objc
    private func totalBasketPrice(_ notification: Notification) {
        if let value = notification.userInfo?["value"] as? Int {
            view?.updateBasket(sum: value)
        }
    }
}

//MARK: - Event handler
extension MenuPresenter {
    func viewDidLoad() {
        fetchAllData()
    }
    
    func didSelectProduct(index: Int) {
        router?.showProductScreen(product: products[index])
    }
    
    func showBasket() {
        router?.showBasket()
    }
    
    func didTapCategory(category: Category) {
        for (index, item) in categories.enumerated() {
            if item == category {
                categories[index] = item.didSelect()
            } else if item.isSelected {
                categories[index] = item.didSelect()
            }
        }
        view?.selectRow(category: category)
    }
}
