//
//  DependencyContainer.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 08.02.2026.
//

import Foundation

final class DependencyContainer {
    let session: URLSession
    let decoder: JSONDecoder
    let encoder: JSONEncoder
    let productService: ProductService
    let productRepository: ProductRepository
    let categoriesService: CategoryService
    let storyService: StoryService
    let suplementService: SuplementService
    
    let screenFactory: ScreenFactory
    
    init() {
        session = URLSession.init(configuration: .ephemeral)
        decoder = JSONDecoder()
        encoder = JSONEncoder()
        
        productService = ProductService(session: session, decoder: decoder)
        let storage = ProductStorage(encoder: encoder, decoder: decoder)
        productRepository = ProductRepository(storage: storage)
        categoriesService = CategoryService(session: session, decoder: decoder)
        storyService = StoryService(session: session, decoder: decoder)
        suplementService = SuplementService(session: session, decoder: decoder)
        
        screenFactory = ScreenFactory()
        screenFactory.di = self
    }
    
    final class ScreenFactory {
        weak var di: DependencyContainer!
        
        func makeMenuScreen() -> MenuScreenVC {
            MenuScreenVC(productService: di.productService , categoryService: di.categoriesService, storyService: di.storyService, suplementService: di.suplementService,
                         productRepository: di.productRepository)
        }
    }
    
}
