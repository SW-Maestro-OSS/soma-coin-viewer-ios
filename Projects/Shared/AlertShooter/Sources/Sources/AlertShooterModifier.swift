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
                alertShooter.alertModel?.titleKey ?? "",
                isPresented: $alertShooter.present,
                presenting: alertShooter.alertModel) { model in
                    VStack {
                        ForEach(model.actions) { actionModel in
                            Button {
                                actionModel.action?()
                            } label: {
                                Text(actionModel.titleKey)
                                    .foregroundStyle({
                                        switch actionModel.role {
                                        case .normal:
                                            return Color.black
                                        case .cancel:
                                            return Color.red
                                        }
                                    }())
                            }
                        }
                    }
                } message: { model in
                    if let message = model.messageKey {
                        Text(message)
                    }
                }
    }
}
