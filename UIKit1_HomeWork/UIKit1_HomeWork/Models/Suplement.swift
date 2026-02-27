//
//  Suplement.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 15.02.2026.
//

import Foundation

struct Suplement: Codable, Equatable {
    let name: String
    let image: String
    let price: Int
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name
    }
}
