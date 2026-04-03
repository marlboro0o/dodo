//
//  ArrayTests.swift
//  UIKit1_HomeWorkTests
//
//  Created by Андрей on 01.04.2026.
//

import XCTest
@testable import UIKit1_HomeWork

final class ArrayTests: XCTestCase {

    func testArrayValueInRange() throws {
        
        //Given
        let array = [10, 20, 30]
        
        //When
        let value = array[safe: 2]
        
        //Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 30)
    }
    
    func testArrayValueOutOfRange() throws {
        //Given
        let array = [10, 20, 30]
        
        //When
        let value = array[safe: 3]
        
        //Then
        XCTAssertNil(value)
        XCTAssertEqual(value, nil)
    }
    
    func testArrayEmpty() throws {
        
        //Given
        let array: [Int] = []
        
        //When
        let value = array.isEmpty
        
        //Then
        XCTAssertEqual(value, true)
    }
}
