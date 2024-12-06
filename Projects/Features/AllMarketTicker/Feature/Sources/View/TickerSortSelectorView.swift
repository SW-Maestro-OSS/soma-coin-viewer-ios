//
//  TickerSortSelectorView.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/6/24.
//

import SwiftUI

import CommonUI

struct TickerSortSelectorView: View {
    
    @StateObject var viewModel: TickerSortSelectorViewModel
    
    init(viewModel: TickerSortSelectorViewModel) {
        
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        HStack {
            
            Image(systemName: "chevron.up.chevron.down")
            
            CVText(text: $viewModel.state.title)
        }
    }
}

