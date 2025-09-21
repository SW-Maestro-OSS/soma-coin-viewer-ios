//
//  AllMarketTickerRouter.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 1/13/25.
//

import SwiftUI

import BaseFeature

public protocol AllMarketTickerViewModelable { }

public typealias AllMarketTickerRoutable = Router<AllMarketTickerViewModelable> & AllMarketTickerRouting

@MainActor
public final class AllMarketTickerRouter: AllMarketTickerRoutable {
    
    init(view: AllMarketTickerView, viewModel: AllMarketTickerViewModel) {
        super.init(view: AnyView(view), viewModel: viewModel)
        viewModel.router = self
    }
}
