//
//  MenuRouter.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 27.03.2026.
//

import Foundation
import UIKit

protocol IMenuRouter {
    func showProductScreen(product: Product)
    func showBasket()
}

final class MenuRouter {
    weak var view: UIViewController?
}

extension MenuRouter: IMenuRouter {
    func showProductScreen(product: Product) {
        let vc = di.screenFactory.makeDetailProduct(product: product, operation: .add)
        view?.present(vc, animated: true)
    }
    
    func showBasket() {
        view?.present(di.screenFactory.makeBasketVC(), animated: true)
    }
}
