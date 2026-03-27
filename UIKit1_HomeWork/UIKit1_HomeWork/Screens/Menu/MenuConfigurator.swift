//
//  MenuConfigurator.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 20.03.2026.
//

import Foundation

class MenuConfigurator {
    func configure(di: DependencyContainer) -> MenuScreenVC {
        
        let router = MenuRouter()
        let presenter = MenuPresenter(productService: di.productService , categoryService: di.categoriesService, storyService: di.storyService, productRepository: di.productRepository, router: router)
        
        let view = MenuScreenVC(presenter: presenter)
        presenter.view = view
        router.view = view
        
        return view
    }
}
