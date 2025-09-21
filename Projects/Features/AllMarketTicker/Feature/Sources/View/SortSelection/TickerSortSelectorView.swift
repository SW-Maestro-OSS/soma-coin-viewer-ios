//
//  TickerSortSelectorView.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/6/24.
//

import SwiftUI
import Combine

import CommonUI

struct TickerSortSelectorView: View {
    // State
    private let model: SortSelectionCellRO
    @State private var backgroundOpacity: CGFloat = 0.0
    
    var onTap: (() -> Void)?
    
    private var store: Set<AnyCancellable> = []
    
    init(model: SortSelectionCellRO, onTap: (() -> Void)?) {
        self.model = model
        self.onTap = onTap
    }
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .foregroundStyle(.gray.opacity(0.5))
                .opacity(backgroundOpacity)
            
            HStack(spacing: 10) {
                
                Image(systemName: model.displayImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10)
                
                Text(model.displayText)
                    .font(.caption)
                    .lineLimit(1)
            }
            .foregroundStyle(.black)
        }
        .background {
            Rectangle()
                .foregroundStyle(.gray.opacity(0.3))
                .background { Rectangle().foregroundStyle(.white) }
                .padding(.vertical, 1)
                .background { Rectangle().foregroundStyle(.black) }
        }
        .simultaneousGesture(
            TapGesture()
                .onEnded {
                    // Anim
                    backgroundOpacity = 1.0
                    withAnimation { backgroundOpacity = 0.0 }
                    
                    onTap?()
                }
        )
    }
}
