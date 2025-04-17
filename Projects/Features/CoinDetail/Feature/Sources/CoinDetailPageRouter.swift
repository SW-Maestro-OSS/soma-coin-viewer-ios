//
//  CoinDetailPageRouter.swift
//  CoinDetailModule
//
//  Created by choijunios on 4/17/25.
//

import SwiftUI

import BaseFeature

public class CoinDetailPageRouter: Router<CoinDetailPageViewModelable> {
    
    init(view: CoinDetailPageView, viewModel: CoinDetailPageViewModel) {
        super.init(view: AnyView(view), viewModel: viewModel)
    }
}
