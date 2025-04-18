//
//  AlertShootable.swift
//  AlertShooter
//
//  Created by choijunios on 1/31/25.
//

public protocol AlertShootable {
    /// Alert를 전송할 것을 요구합니다.
    func shoot(_ model: AlertModel)
}
