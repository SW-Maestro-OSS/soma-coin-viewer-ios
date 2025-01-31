//
//  FakeAlertShooter.swift
//  WebSocketManagementHelper
//
//  Created by choijunios on 1/31/25.
//

import AlertShooter

class FakeAlertShooter: AlertShooter {
    
    var shotAlertModels: [AlertModel] = []
    
    func request(listener: AlertShooterListener) {
        fatalError()
    }
    
    func shoot(_ model: AlertModel) {
        shotAlertModels.append(model)
    }
}
