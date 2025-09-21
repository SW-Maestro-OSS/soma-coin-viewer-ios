//
//  UDFViewModel.swift
//  BaseModule
//
//  Created by choijunios on 12/5/24.
//

import SwiftUI
import Combine

import CoreUtil

public typealias UDFObservableObject = UDFViewModel & ObservableObject

@MainActor
public protocol UDFViewModel: AnyObject {
    
    associatedtype State
    associatedtype Action
    
    var action: PassthroughSubject<Action, Never> { get }
    var state: State { get set }
    var store: Set<AnyCancellable> { get set }
    
    func mutate(_ action: Action) -> AnyPublisher<Action, Never>
    
    func reduce(_ action: Action, state: State) -> State
}

public extension UDFViewModel {
    
    func createStateStream() {
        
        action
            .unretained(self)
            .flatMap { viewModel, action in
                
                // #1. Mutation for side effect
                
                return viewModel.mutate(action)
            }
            .receive(on: DispatchQueue.main)
            .unretained(self)
            .sink { viewModel, action in
                
                // #2. Update current state
                
                let currentState = viewModel.state
                viewModel.state = viewModel.reduce(action, state: currentState)
            }
            .store(in: &store)
        
    }
    
    func mutate(_ action: Action) -> AnyPublisher<Action, Never> {
        
        return Just(action).eraseToAnyPublisher()
    }
    
    func reduce(_ action: Action, state: State) -> State {
        
        return state
    }
}
