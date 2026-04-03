//
//  BasketRouter.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 27.03.2026.
//

import Foundation
import UIKit

protocol IBasketRouter {
    func showProductScreen(product: Product)
    func showPlaceOrder()
    func closeBasketScreen()
}

final class BasketRouter: IBasketRouter {
    
    weak var view: UIViewController?
    
    func showProductScreen(product: Product) {
        let vc = di.screenFactory.makeDetailProduct(product: product, operation: .change)
        view?.present(vc, animated: true)
    }
    
    func closeBasketScreen() {
        view?.dismiss(animated: true)
    }
    
    func showPlaceOrder() {
        view?.present(di.screenFactory.makeMapVC(), animated: true)
    }
}
