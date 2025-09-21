//
//  SettingRouter.swift
//  SettingModule
//
//  Created by choijunios on 1/14/25.
//

import SwiftUI

import BaseFeature

public protocol SettingViewModelable { }

public typealias SettingRoutable = Router<SettingViewModelable> & SettingPageRouting

@MainActor
class SettingRouter: SettingRoutable {
    
    init(view: SettingView, viewModel: SettingViewModel) {
        super.init(view: AnyView(view), viewModel: viewModel)
        viewModel.router = self
    }
}
