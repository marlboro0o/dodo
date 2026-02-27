//
//  ProductService.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 23.01.2026.
//

import Foundation

protocol IProductService {
    func loadProducts(completion: @escaping (Result<[Product], Error>) -> ())
}

class ProductService: IProductService {
    let session: URLSession
    let decoder: JSONDecoder
    
    init(session: URLSession, decoder: JSONDecoder) {
        self.session = session
        self.decoder = decoder
    }
    
    func loadProducts(completion: @escaping (Result<[Product], Error>) -> ()) {
        guard let url = URL(string: "http:localhost:3001/products") else { return }
        
        session.dataTask(with: URLRequest(url: url)) { data, response, error in
            
            if let error {
                print(error)
            }
            
            guard let data else { return }
            
            do {
                let products = try self.decoder.decode([Product].self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(products))
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
        
    }
}
