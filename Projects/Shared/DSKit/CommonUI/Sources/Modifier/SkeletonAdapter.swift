//
//  SkeletonAdapter.swift
//  CommonUI
//
//  Created by choijunios on 4/18/25.
//

import SwiftUI

public struct SkeletonWrapper: ViewModifier {
    var presentOrigin: Bool
    public func body(content: Content) -> some View {
        content
            .opacity(presentOrigin ? 1 : 0)
            .background {
                SkeletonUI()
                    .opacity(presentOrigin ? 0 : 1)
            }
    }
}

public extension View {
    func skeleton(presentOrigin: Bool) -> some View {
        self
            .modifier(SkeletonWrapper(presentOrigin: presentOrigin))
    }
}
