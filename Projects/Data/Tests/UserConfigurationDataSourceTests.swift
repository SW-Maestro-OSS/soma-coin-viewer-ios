//
//  UserConfigurationDataSourceTests.swift
//  Data
//
//  Created by choijunios on 5/4/25.
//

import Testing

import DataSource

struct UserConfigurationDataSourceTests {
    
    @Test("유저 설정 값 저장 확인")
    func checkConfiguratonSaving() {
        // Given
        let dataSource = DefaultUserConfigurationDataSource(
            service: FakeKeyValueStoreService()
        )
        
        
        // When
        let testCurrency = "WON"
        let testLan = "KOR"
        let testGT = "List"
        dataSource.setCurrency(type: testCurrency)
        dataSource.setLanguageType(type: testLan)
        dataSource.setGridType(type: testGT)
        
        
        // Then
        #expect(dataSource.getCurrency() == testCurrency)
        #expect(dataSource.getLanguageType() == testLan)
        #expect(dataSource.getGridType() == testGT)
    }
}
