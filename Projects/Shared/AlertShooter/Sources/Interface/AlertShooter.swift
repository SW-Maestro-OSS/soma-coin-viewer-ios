//
//  AlertShooter.swift
//  AlertShooter
//
//  Created by choijunios on 1/31/25.
//

public protocol AlertShooterListener: AnyObject {
    
    func alert(model: AlertModel)
}

public protocol AlertShooter {
    
    /// AlertShooter의 이벤트를 구독할 것을 요청합니다.
    func request(listener: AlertShooterListener)
    
    /// Alert를 전송할 것을 요구합니다.
    func shoot(_ model: AlertModel)
}
