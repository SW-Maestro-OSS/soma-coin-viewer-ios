//
//  AlertShooter 2.swift
//  AlertShooter
//
//  Created by choijunios on 4/18/25.
//

import SwiftUI

public class AlertShooter: ObservableObject, AlertShootable {
    // State
    @Published var alertModel: AlertModel?
    @Published var present: Bool = false {
        didSet {
            if oldValue == true && present == false {
                // Alert가 닫힌 경우
                alertModel = nil
                checkAndShoot()
            }
        }
    }
    private let container = AlertModelContainer()
    
    public func shoot(_ model: AlertModel) {
        Task { [weak self] in
            guard let self else { return }
            await container.add(model: model)
            if alertModel == nil {
                checkAndShoot()
            }
        }
    }
    
    private func checkAndShoot() {
        Task { [weak self] in
            guard let self else { return }
            if let model = await container.getFirst() {
                alertModel = model
                
                // 지연 후 Alert표츌
                try? await Task.sleep(for: .seconds(0.5))
                present = true
            }
        }
    }
}
