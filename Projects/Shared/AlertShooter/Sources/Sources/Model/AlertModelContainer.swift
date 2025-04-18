//
//  AlertModelContainer.swift
//  AlertShooter
//
//  Created by choijunios on 4/18/25.
//

actor AlertModelContainer {
    private var models: [AlertModel] = []
    
    func add(model: AlertModel) {
        models.append(model)
    }
    
    func getFirst() -> AlertModel? {
        guard let firstElement = models.first else { return nil }
        models.removeFirst()
        return firstElement
    }
}
