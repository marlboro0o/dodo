//
//  ProductStorage.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 22.02.2026.
//

import Foundation

final class ProductStorage {
    
    private let defaults = UserDefaults.standard
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    init(encoder: JSONEncoder, decoder: JSONDecoder) {
        self.encoder = encoder
        self.decoder = decoder
    }
    
    // MARK: - Сохранение массива продуктов
    func save(products: [Product], forKey key: String) throws {
        let data = try encoder.encode(products)
        defaults.set(data, forKey: key)
    }
    
    // MARK: - Загрузка массива продуктов
    func loadProducts(forKey key: String) -> [Product]? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? decoder.decode([Product].self, from: data)
    }
    
    // MARK: - Сохранение одного продукта
    func save(product: Product, forKey key: String) throws {
        let data = try encoder.encode(product)
        defaults.set(data, forKey: key)
    }
    
    // MARK: - Загрузка одного продукта
    func loadProduct(forKey key: String) -> Product? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? decoder.decode(Product.self, from: data)
    }
    
    // MARK: - Удаление данных по ключу
    func remove(forKey key: String) {
        defaults.removeObject(forKey: key)
    }
}
