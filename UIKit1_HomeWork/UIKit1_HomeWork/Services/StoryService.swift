//
//  StoryService.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 09.02.2026.
//

import Foundation

protocol IStoryService {
    func loadStories(completion: @escaping (Result<[Story], Error>) -> ())
}

class StoryService: IStoryService {
    let session: URLSession
    let decoder: JSONDecoder
    
    init(session: URLSession, decoder: JSONDecoder) {
        self.session = session
        self.decoder = decoder
    }
    
    func loadStories(completion: @escaping (Result<[Story], any Error>) -> ()) {
        guard let url = URL(string: "http:localhost:3001/stories") else { return }
        
        session.dataTask(with: URLRequest(url: url)) { data, response, error in
            
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let data else { return }
            
            do {
                let stories = try self.decoder.decode([Story].self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(stories))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
