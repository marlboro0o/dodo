//
//  ProductRepository.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 27.02.2026.
//

import Foundation

protocol IProductRepository {
    func add(product: Product)
    func change(product: Product)
    func update(product: Product, count: Int, completion: ([Product]) -> ())
    func get() -> [Product]
}

class ProductRepository: IProductRepository {
    
    let storage: ProductStorage
    
    init(storage: ProductStorage) {
        self.storage = storage
    }
    
    func add(product: Product) {
        var basket = storage.loadProducts(forKey: "basket") ?? []
        
        if let index = basket.firstIndex(of: product) {
            let newProduct = basket[index].updateCount((basket[index].countInBasket ?? 0) + 1)
            basket[index] = newProduct
        } else {
            basket.append(product)
        }
         
        do {
            try storage.save(products: basket, forKey: "basket")
        } catch {
            print(error)
        }
    }
    
    func change(product: Product) {
        var basket = storage.loadProducts(forKey: "basket") ?? []
        
        if let index = basket.firstIndex(of: product) {
            basket[index] = product
        }
         
        do {
            try storage.save(products: basket, forKey: "basket")
        } catch {
            print(error)
        }
    }
    
    func update(product: Product, count: Int, completion: ([Product]) -> ()) {
        
        var basket = get()
        
        guard let index = basket.firstIndex(of: product) else { return }
        
        if count == 0 {
            basket.remove(at: index)
        } else {
            basket[index] = basket[index].updateCount(count)
        }
        
        do {
            try storage.save(products: basket, forKey: "basket")
        } catch {
            print(error)
        }
        
        completion(basket)
    }
    
    func get() -> [Product] {
        return storage.loadProducts(forKey: "basket") ?? []
    }
    
}
