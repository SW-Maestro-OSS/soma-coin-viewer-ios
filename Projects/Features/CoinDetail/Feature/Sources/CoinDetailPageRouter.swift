//
//  CoinDetailPageRouter.swift
//  CoinDetailModule
//
//  Created by choijunios on 4/17/25.
//

import SwiftUI

import BaseFeature

public protocol CoinDetailPageViewModelable { }

public typealias CoinDetailPageRoutable = Router<CoinDetailPageViewModelable> & CoinDetailPageRouting

class CoinDetailPageRouter: CoinDetailPageRoutable {
    
    init(view: CoinDetailPageView, viewModel: CoinDetailPageViewModel) {
        super.init(view: AnyView(view), viewModel: viewModel)
    }
}
