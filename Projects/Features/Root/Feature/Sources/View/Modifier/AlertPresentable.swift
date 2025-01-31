//
//  AlertPresentable.swift
//  RootModule
//
//  Created by choijunios on 1/31/25.
//

import SwiftUI

struct AlertPresentableView: ViewModifier {
    
    @Binding var presented: Bool
    let renderObject: AlertRO
    
    func body(content: Content) -> some View {
        ZStack {
            content
            Group {
                if presented {
                    AlertView(presented: $presented, renderObject: renderObject)
                        .transition(.opacity)
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: presented)
    }
}


extension View {
    func alertable(presented: Binding<Bool>, renderObject: AlertRO?) -> some View {
        return self.modifier(
            AlertPresentableView(
                presented: presented,
                renderObject: renderObject ?? .init(
                    titleText: "",
                    messageText: nil,
                    actions: []
                )
            )
        )
    }
}
