//
//  DefaultAlertShooter.swift
//  AlertShooter
//
//  Created by choijunios on 1/31/25.
//

import Foundation

public final class DefaultAlertShooter: AlertShooter {
    
    // Listeners
    private var listeners: [WeakListener] = []
    
    public init() { }
    
    public func request(listener: AlertShooterListener) {
        listeners.append(WeakListener(wrappedObject: listener))
    }
    
    public func shoot(_ model: AlertModel) {
        listeners.forEach { listener in
            listener.wrappedObject?.alert(model: model)
        }
    }
}


private extension DefaultAlertShooter {
    
    struct WeakListener {
        weak var wrappedObject: AlertShooterListener?
    }
}

