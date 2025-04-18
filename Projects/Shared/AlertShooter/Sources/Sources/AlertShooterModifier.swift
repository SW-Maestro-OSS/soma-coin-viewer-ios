//
//  AlertShooterModifier.swift
//  AlertShooter
//
//  Created by choijunios on 4/18/25.
//

import SwiftUI

public extension View {
    func alertShootable() -> some View {
        self.modifier(AlertShooterModifier())
    }
}

public struct AlertShooterModifier: ViewModifier {
    @EnvironmentObject private var alertShooter: AlertShooter
    public func body(content: Content) -> some View {
        content
            .alert(
                alertShooter.alertModel?.titleText ?? "",
                isPresented: $alertShooter.present,
                presenting: alertShooter.alertModel) { (model: AlertRO) in
                    VStack {
                        ForEach(model.actions) { actionModel in
                            Button {
                                actionModel.action?()
                            } label: {
                                Text(actionModel.titleText)
                                    .foregroundStyle(actionModel.titleTextColor)
                            }
                        }
                    }
                } message: { model in
                    if let message = model.messageText {
                        Text(message)
                    }
                }
    }
}
