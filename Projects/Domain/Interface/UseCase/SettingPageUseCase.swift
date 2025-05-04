//
//  SettingPageUseCase.swift
//  Domain
//
//  Created by choijunios on 5/4/25.
//

public protocol SettingPageUseCase {
    func getGridType() -> GridType
    func setGridType(type: GridType)
}
