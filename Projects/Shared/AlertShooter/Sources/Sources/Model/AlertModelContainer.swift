//
//  AlertModelContainer.swift
//  AlertShooter
//
//  Created by choijunios on 4/18/25.
//

import Foundation

class AlertModelContainer {
    private var models: [AlertModel] = []
    private let lock = NSLock()
    
    func add(model: AlertModel) {
        defer { lock.unlock() }
        lock.lock()
        print(models.count)
        models.append(model)
    }
    
    func getFirst() -> AlertModel? {
        defer { lock.unlock() }
        lock.lock()
        guard let firstElement = models.first else { return nil }
        models.removeFirst()
        return firstElement
    }
}
