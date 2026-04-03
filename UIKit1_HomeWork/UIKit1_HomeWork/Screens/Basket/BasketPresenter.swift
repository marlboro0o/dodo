//
//  BasketPresenter.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 27.03.2026.
//

import Foundation

protocol IBasketPresenter: AnyObject {
    func viewDidLoad()
    
    func didTapClose()
    func didTapPlaceOrder()
    func didTapEditProduct(product: Product)
    func didTapChangeCount(product: Product, count: Int)
}

final class BasketPresenter: IBasketPresenter {
    
    weak var view: IBasketVC?
    var router: IBasketRouter?
    
    private var basket: [Product] = [] {
        didSet {
            view?.showBasket(basket: basket)
        }
    }
    private let suplementService: ISuplementService
    private let productRepository: IProductRepository
    
    init(productRepository: IProductRepository, suplementService: ISuplementService, router: IBasketRouter) {
        self.productRepository = productRepository
        self.suplementService = suplementService
        self.router = router
    }
}

//MARK: Business logic
extension BasketPresenter {
    private func fetchBasket() {
        basket = productRepository.get()
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateBasket), name: .updateBasket, object: nil)
    }
   
    @objc
    private func updateBasket() {
        fetchBasket()
    }
}

//MARK: Event handler
extension BasketPresenter {
   
    func viewDidLoad() {
        fetchBasket()
        setupObservers()
    }
    
    func didTapClose() {
        router?.closeBasketScreen()
    }
    
    func didTapPlaceOrder() {
        router?.showPlaceOrder()
    }
    
    func didTapEditProduct(product: Product) {
        router?.showProductScreen(product: product)
    }
    
    func didTapChangeCount(product: Product, count: Int) {
        productRepository.update(product: product, count: count) { basket in
            self.basket = basket
        }
    }
}
