//
//  SkeletonUI.swift
//  CommonUI
//
//  Created by choijunios on 12/7/24.
//

import SwiftUI

public struct SkeletonUI: View {
    
    @State private var isAnimating = false
    
    public var body: some View {
        
        KeyframeAnimator(
            initialValue: (0, 0),
            repeating: true) { v1, v2 in
            
            LinearGradient(
                gradient: .init(
                    stops: [
                        .init(color: .black.opacity(0.4), location: 0),
                        .init(color: .gray.opacity(0.1), location: v1),
                    ]
                ),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .opacity(v2)
            
        } keyframes: { v1, v2 in
            
            KeyframeTrack(\.0) {
                LinearKeyframe(1, duration: 1.0)
                LinearKeyframe(1, duration: 0.3)
            }
            
            KeyframeTrack(\.1) {
                LinearKeyframe(1, duration: 0.3)
                LinearKeyframe(1, duration: 1.0)
                LinearKeyframe(0, duration: 0.5)
                LinearKeyframe(0, duration: 0.25)
            }
            
        }
        .onAppear(perform: {
            isAnimating = true
        })
        .background(.white)
    }
}

#Preview(traits: .fixedLayout(width: 150, height: 150)) {
    
    GeometryReader { geo in
        VStack(spacing: 5) {
            
            ForEach(0..<10) { index in
                
                SkeletonUI()
                
            }
        }
        .frame(width: geo.size.width, height: geo.size.height)
    }
}
