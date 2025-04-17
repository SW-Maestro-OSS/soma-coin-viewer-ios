//
//  SettingBuilder.swift
//  SettingModule
//
//  Created by choijunios on 1/14/25.
//

public class SettingBuilder {
    
    public init() { }
    
    public func build(listener: SettingPageListener) -> SettingRoutable {
        let viewModel = SettingViewModel()
        viewModel.listener = listener
        let view = SettingView(viewModel: viewModel)
        let router = SettingRouter(view: view, viewModel: viewModel)
        return router
    }
}
