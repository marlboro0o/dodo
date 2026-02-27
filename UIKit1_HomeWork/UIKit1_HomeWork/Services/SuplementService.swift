//
//  SuplementService.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 15.02.2026.
//

import Foundation

protocol ISuplementService {
    func loadSuplements(completion: @escaping (Result<[Suplement], Error>) -> ())
}

class SuplementService: ISuplementService {
    let session: URLSession
    let decoder: JSONDecoder
    
    init(session: URLSession, decoder: JSONDecoder) {
        self.session = session
        self.decoder = decoder
    }
    
    func loadSuplements(completion: @escaping (Result<[Suplement], any Error>) -> ()) {
        
        guard let url = URL(string: "http:localhost:3001/suplements") else { return }
        
        session.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let data else { return }
            
            do {
                let suplements = try self.decoder.decode([Suplement].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(suplements))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
