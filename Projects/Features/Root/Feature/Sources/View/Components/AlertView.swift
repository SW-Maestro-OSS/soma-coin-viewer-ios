//
//  AlertView.swift
//  RootModule
//
//  Created by choijunios on 1/31/25.
//

import SwiftUI

struct AlertView: View {
    
    // State
    @Binding private var presented: Bool
    
    
    // Content
    private let renderObject: AlertRO
    
    
    // Action
    var onDismiss: (() -> Void)?
    
    init(presented: Binding<Bool>, renderObject: AlertRO, onDismiss: (() -> Void)?) {
        self._presented = presented
        self.renderObject = renderObject
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        
        VStack {
            Spacer()
            HStack {
                Spacer(minLength: 0)
                
                VStack(spacing: 0) {
                    
                    Text(renderObject.titleText)
                        .font(.title)
                    
                    if let messageText = renderObject.messageText {
                        Text(messageText)
                            .font(.body)
                    }
                    
                    Rectangle()
                        .opacity(0)
                        .frame(height: 10)
                    
                    Group {
                        if renderObject.actions.count == 2 {
                            HStack(spacing: 3) {
                                ForEach(renderObject.actions) { actionRO in
                                    AlertButtonView(
                                        titleText: actionRO.titleText,
                                        titleTextColor: actionRO.titleTextColor
                                    )
                                    .onTapGesture {
                                        actionRO.action?()
                                        onDismiss?()
                                        presented = false
                                    }
                                }
                            }
                        } else {
                            VStack(spacing: 3) {
                                ForEach(renderObject.actions) { actionRO in
                                    AlertButtonView(
                                        titleText: actionRO.titleText,
                                        titleTextColor: actionRO.titleTextColor
                                    )
                                    .onTapGesture {
                                        actionRO.action?()
                                        presented = false
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 5)
                }
                .padding(.vertical, 20)
                Spacer(minLength: 0)
            }
            .background(.white)
            .clipShape(
                RoundedRectangle(cornerRadius: 24)
            )
            .padding(.horizontal, 20)
            Spacer()
        }
        .background(.gray.opacity(0.5))
    }
}
