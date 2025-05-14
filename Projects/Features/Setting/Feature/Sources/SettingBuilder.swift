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
    
    public init() { }
    
    public func build(listener: SettingPageListener) -> SettingRoutable {
        let viewModel = SettingViewModel(
            useCase: DependencyInjector.shared.resolve(),
            i18NManager: DependencyInjector.shared.resolve(),
            localizedStrProvider: DependencyInjector.shared.resolve()
        )
        viewModel.listener = listener
        let view = SettingView(viewModel: viewModel)
        let router = SettingRouter(view: view, viewModel: viewModel)
        return router
    }
}
