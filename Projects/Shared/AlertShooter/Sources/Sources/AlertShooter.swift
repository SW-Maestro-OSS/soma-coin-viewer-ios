//
//  AlertShooter 2.swift
//  AlertShooter
//
//  Created by choijunios on 4/18/25.
//

import SwiftUI

open class AlertShooter: ObservableObject, AlertShootable {
    // State
    @Published var alertModel: AlertRO?
    @Published var present: Bool = false {
        didSet {
            if oldValue == true && present == false {
                // Alert가 닫힌 경우
                alertModel = nil
                checkAndShoot()
            }
        }
    }
    let container = AlertModelContainer()
    
    public init() { }
    
    /// 메세지 스택에서 다음 메세지를 탐색하고 Alert를 표시합니다.
    func checkAndShoot() {
        // 메인쓰레드 sync실행을 방지하기 위해 사용
        if let model = container.getFirst() {
            if Thread.current != Thread.main {
                DispatchQueue.main.sync { [weak self] in
                    guard let self else { return }
                    alertModel = createRO(model: model)
                }
            } else {
                alertModel = createRO(model: model)
            }
            
            // 지연 후 Alert표츌
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { [weak self] in
                guard let self else { return }
                present = true
            }
        }
    }
    open func createRO(model: AlertModel) -> AlertRO { return .mock }
    
    open func shoot(_ model: AlertModel) { }
}
