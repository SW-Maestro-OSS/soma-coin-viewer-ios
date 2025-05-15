//
//  CVNumberTests.swift
//  CoreUtil
//
//  Created by choijunios on 5/12/25.
//

import Testing
@testable import CoreUtil

@Suite("CVNumber테스트")
struct CVNumberTests {
    @Test("길이 기반 축약표현, 최대 자리수 이하로 만들어지는지 확인", arguments: [1, 2, 3, 4, 5, 6])
    func checkSizeCompaction(size: Int) {
        // Given
        let number = CVNumber(0.123456)
        
        
        // When
        let string = number.adaptiveToSize(size)
        
        
        // Then
        print(size, string)
        #expect(string.count <= size)
    }
    
    @Test("길이 기반 축약표현, K/M/B간소화 표현 테스트", arguments: [
        (CVNumber(1200.0), "1K"),
        (CVNumber(1230.0), "1K"),
        (CVNumber(1234.0), "1K"),
        (CVNumber(1234000.0), "1M"),
        (CVNumber(1234000000.0), "1B"),
    ])
    func checkSizeCompactionKMB(_ input: (CVNumber, String)) {
        // Given
        let number = input.0
        let size = 3
        
        
        // When
        let str = number.adaptiveToSize(size)
        
        
        // Then
        let result = input.1
        #expect(str == result)
    }
    
    
    @Test("K/M/B간소화 표현 테스트")
    func checkCompactExpression() {
        // Given
        let numbers: [CVNumber] = [
            CVNumber(0.0000001),
            CVNumber(0.0001000),
            
            CVNumber(1.0),
            CVNumber(10.0),
            CVNumber(100.0),
            
            CVNumber(1_234.0),
            CVNumber(12_345.0),
            CVNumber(123_456.0),
            
            CVNumber(1_234_567.0),
            CVNumber(12_345_678.0),
            CVNumber(123_456_789.0),
            
            CVNumber(1_234_567_890.0),
            CVNumber(12_345_678_900.0),
            CVNumber(123_456_789_000.0),
        ]
        
        
        // When
        let results = numbers.map({ $0.formatCompactNumberWithSuffix() })
        
        
        // Then
        let expectedResults: [String] = [
            "0.0000",
            "0.0001",
            "1.0000",
            "10.000",
            "100.00",
            
            "1.234K",
            "12.34K",
            "123.4K",
            
            "1.234M",
            "12.34M",
            "123.4M",
            
            "1.234B",
            "12.34B",
            "123.4B",
        ]
        results.enumerated().forEach { index, str in
            print(str, expectedResults[index], terminator: " ")
            print("")
            #expect(str == expectedResults[index])
        }
    }
}
