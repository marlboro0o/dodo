//
//  ArrayHelper.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 01.04.2026.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
