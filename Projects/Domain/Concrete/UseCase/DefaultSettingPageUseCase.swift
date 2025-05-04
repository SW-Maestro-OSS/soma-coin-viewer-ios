//
//  DefaultSettingPageUseCase.swift
//  Domain
//
//  Created by choijunios on 5/4/25.
//

import DomainInterface

final public class DefaultSettingPageUseCase: SettingPageUseCase {
    // Dependency
    private let repository: UserConfigurationRepository
    
    public init(repository: UserConfigurationRepository) {
        self.repository = repository
    }
    
    public func getGridType() -> GridType {
        repository.getGridType() ?? .defaultValue
    }
    
    public func setGridType(type: GridType) {
        repository.setGridType(type: type)
    }
}
