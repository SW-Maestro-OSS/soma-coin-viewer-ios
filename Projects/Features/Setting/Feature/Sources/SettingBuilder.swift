//
//  SettingBuilder.swift
//  SettingModule
//
//  Created by choijunios on 1/14/25.
//

import I18N
import DomainInterface
import CoreUtil

public class SettingBuilder {
    // Dependency
    @Injected private var i18NManager: I18NManager
    @Injected private var userConfigurationRepository: UserConfigurationRepository
    
    public init() { }
    
    public func build(listener: SettingPageListener) -> SettingRoutable {
        let viewModel = SettingViewModel(
            i18NManager: i18NManager,
            userConfigurationRepository: userConfigurationRepository
        )
        viewModel.listener = listener
        let view = SettingView(viewModel: viewModel)
        let router = SettingRouter(view: view, viewModel: viewModel)
        return router
    }
}
