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
    
    
    @Test("적응형 소수점 표현 확인", arguments: [
        CVNumber(0.1),
        CVNumber(0.01),
        CVNumber(0.001),
        CVNumber(0.0001),
    ])
    func checkAdaptiveFractionFormat(number: CVNumber) {
        // Given
        let target = number
        
        
        // When
        let expression = target.adaptiveFractionFormat(min: 1, max: 4)
        
        
        // Then
        #expect(expression == target.description)
    }
}
