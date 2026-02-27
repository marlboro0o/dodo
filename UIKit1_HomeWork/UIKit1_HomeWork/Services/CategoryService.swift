//
//  CategoryService.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 06.02.2026.
//

import Foundation

protocol ICategoryService {
    func loadCategories(completion: @escaping (Result<[Category], Error>) ->())
}

class CategoryService: ICategoryService {
   
    let session: URLSession
    let decoder: JSONDecoder
    
    init(session: URLSession, decoder: JSONDecoder) {
        self.session = session
        self.decoder = decoder
    }
    
    func loadCategories(completion: @escaping (Result<[Category], Error>) ->()) {
        guard let url = URL(string: "http:localhost:3001/categories") else { return }
       
        session.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error {
                completion(.failure(error))
            }
            
            guard let data else { return }
            
            do {
                let categories = try self.decoder.decode([Category].self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(categories))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
