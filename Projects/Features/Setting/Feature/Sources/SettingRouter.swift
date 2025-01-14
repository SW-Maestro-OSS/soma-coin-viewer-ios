//
//  SettingRouter.swift
//  SettingModule
//
//  Created by choijunios on 1/14/25.
//

import SwiftUI

import BaseFeature

public typealias SettingRoutable = Router<SettingViewModelable>

public class SettingRouter: SettingRoutable {
    
    init(view: SettingView, viewModel: SettingViewModel) {
        super.init(view: AnyView(view), viewModel: viewModel)
    }
}
