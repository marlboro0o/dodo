//
//  BasketConfigurator.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 27.03.2026.
//

import Foundation

class BasketConfigurator {
    func configure(di: DependencyContainer) -> BasketVC {
        let router = BasketRouter()
        let presenter = BasketPresenter(productRepository: di.productRepository,
                                        suplementService: di.suplementService,
                                        router: router)
        let view = BasketVC(presenter: presenter)
        
        presenter.view = view
        router.view = view
        
        return view
    }
}
