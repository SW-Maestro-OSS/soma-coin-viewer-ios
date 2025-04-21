//
//  Publisher+Ex.swift
//  CoreUtil
//
//  Created by choijunios on 11/11/24.
//

import Combine

public extension Publisher {
    
    func unretained<T: AnyObject>(_ object: T) -> AnyPublisher<(T, Output), Failure> {
        
        self
            .compactMap { [weak object] output -> (T, Output)? in
            
                guard let object else { return nil }
            
                return (object, output)
            }
            .eraseToAnyPublisher()
    }
    
    func unretainedOnly<T: AnyObject>(_ object: T) -> AnyPublisher<T, Failure> {
        
        self
            .compactMap { [weak object] output -> T? in
            
                guard let object else { return nil }
            
                return object
            }
            .eraseToAnyPublisher()
    }
    
    func asyncTransform<T>(transform: @escaping (Output) async -> T) -> AnyPublisher<T, Failure> {
        
        self
            .flatMap { output in
                Future<T, Failure> { promise in
                    Task {
                        let element = await transform(output)
                        promise(.success(element))
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
    func mapToVoid() -> AnyPublisher<Void, Failure> {
        self.map { _ in }.eraseToAnyPublisher()
    }
}
