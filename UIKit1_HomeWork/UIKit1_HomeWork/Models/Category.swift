//
//  Category.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 06.02.2026.
//

import Foundation

struct Category: Codable, Equatable {
    let name: String
    let isSelected: Bool
    
    func didSelect() -> Category {
        Category(name: name, isSelected: !isSelected)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name
    }
}


