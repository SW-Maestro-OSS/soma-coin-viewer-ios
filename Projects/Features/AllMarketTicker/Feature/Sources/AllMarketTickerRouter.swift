//
//  AllMarketTickerRouter.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 1/13/25.
//

import SwiftUI

import BaseFeature

protocol AllMarketTickerRouting: AnyObject {
    
}

public class AllMarketTickerRouter: Router<AllMarketTickerViewModelable>, AllMarketTickerRouting {
    
    init(view: AllMarketTickerView, viewModel: AllMarketTickerViewModel) {
        super.init(view: AnyView(view), viewModel: viewModel)
    }
}
