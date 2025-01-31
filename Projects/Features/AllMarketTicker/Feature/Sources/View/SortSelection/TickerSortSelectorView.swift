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
    
    // RenderObject
    private let renderObject: SortSelectionCellRO
    
    
    // View state
    @State private var backgroundOpacity: CGFloat = 0.0
    
    
    // Combine
    private var store: Set<AnyCancellable> = []
    
    init(renderObject: SortSelectionCellRO) {
        
        self.renderObject = renderObject
    }
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .foregroundStyle(.gray.opacity(0.5))
                .opacity(backgroundOpacity)
            
            HStack(spacing: 10) {
                
                Image(systemName: renderObject.displayImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10)
                
                Text(renderObject.displayText)
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
                    // Click animation
                    backgroundOpacity = 1.0
                    withAnimation { backgroundOpacity = 0.0 }
                }
        )
    }
}
