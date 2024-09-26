//
//  Injector.swift
//  PresentationUtil
//
//  Created by choijunios on 9/26/24.
//

import Swinject

// MARK: Injected
/// 의존성 주입을 간편하게 해주는 프로퍼티 랩퍼

@propertyWrapper
public class Injected<T> {
    
    public let wrappedValue: T
    
    public init() {
        self.wrappedValue = DependencyInjector.shared.resolve()
    }
}

// MARK: Injector
public protocol DependencyAssemblable {
    func assemble(_ assemblyList: [Assembly])
    func register<T>(_ serviceType: T.Type, _ object: T)
}


public protocol DependencyResolvable {
    func resolve<T>() -> T
    func resolve<T>(_ serviceType: T.Type) -> T
}

public typealias Injector = DependencyAssemblable & DependencyResolvable

public final class DependencyInjector: Injector {
    
    public static let shared: DependencyInjector = .init()
    
    private let container: Container
    
    private init(container: Container = Container()) {
        self.container = container
    }
    
    public func assemble(_ assemblyList: [Assembly]) {
        assemblyList.forEach {
            $0.assemble(container: container)
        }
    }
    
    public func register<T>(_ serviceType: T.Type, _ object: T) {
        container.register(serviceType) { _ in object }
    }
    
    public func resolve<T>() -> T {
        container.resolve(T.self)!
    }
    
    public func resolve<T>(_ serviceType: T.Type) -> T {
        container.resolve(T.self)!
    }
}
