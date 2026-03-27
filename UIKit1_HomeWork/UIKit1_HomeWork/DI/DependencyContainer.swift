//
//  DependencyContainer.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 08.02.2026.
//

import Foundation

final class DependencyContainer {
    fileprivate let session: URLSession
    fileprivate let decoder: JSONDecoder
    fileprivate let encoder: JSONEncoder
    let productService: ProductService
    let productRepository: ProductRepository
    let categoriesService: CategoryService
    let storyService: StoryService
    let suplementService: SuplementService
    let mapService: MapService
    
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
        
        let locationService = LocationService()
        let geocodeService = GeocodeService()
        mapService = MapService(geocodeService: geocodeService, locationService: locationService)
        
        screenFactory = ScreenFactory()
        screenFactory.di = self
    }
    
    final class ScreenFactory {
        weak var di: DependencyContainer!
        
        func makeMenuScreen() -> MenuScreenVC {
//            MenuScreenVC(productService: di.productService,
//                         categoryService: di.categoriesService,
//                         storyService: di.storyService,
//                         productRepository: di.productRepository)
            let configurator = MenuConfigurator()
            return configurator.configure(di: di)
        }
        
        func makeDetailProduct(product: Product, operation: DetailProductController.OperationProduct) -> DetailProductController {
            DetailProductController(product: product,
                                    suplementService: di.suplementService,
                                    productRepository: di.productRepository,
                                    operation: operation)
        }
        
        func makeBasketVC() -> BasketVC {
            BasketVC(productRepository: di.productRepository,
                     suplementService: di.suplementService)
        }
        
        func makeMapVC() -> MapVC {
            MapVC(locationService: di.mapService.locationService, geocodeService: di.mapService.geocodeService)
        }
    }
    
}
