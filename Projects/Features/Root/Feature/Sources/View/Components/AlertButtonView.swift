//
//  AlertButtonView.swift
//  RootModule
//
//  Created by choijunios on 1/31/25.
//

import SwiftUI

struct AlertButtonView: View {
    
    // Content
    private let titleText: String
    private let titleTextColor: Color
    
    
    // State
    @State private var opacity = 0.1
    
    
    init(titleText: String, titleTextColor: Color) {
        self.titleText = titleText
        self.titleTextColor = titleTextColor
    }
    
    var body: some View {
        
        HStack {
            Spacer()
            Text(titleText)
                .font(.title3)
                .foregroundStyle(titleTextColor)
                .padding(.vertical, 10)
            Spacer()
        }
        .background(content: {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.gray)
                .opacity(opacity)
        })
        .simultaneousGesture(
            
            TapGesture()
                .onEnded({ _ in
                    opacity = 0.3
                    withAnimation(.easeInOut(duration: 0.2)) {
                        opacity = 0.1
                    }
                })
        )
    }
}
