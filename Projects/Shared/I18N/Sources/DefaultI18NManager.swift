//
//  DefaultI18NManager.swift
//  I18N
//
//  Created by 최재혁 on 12/23/24.
//

import Foundation
import Combine

import DomainInterface

import CoreUtil

public class DefaultI18NManager : I18NManager {
    
    @Injected private var repository : UserConfigurationRepository
    @Injected private var usecase : PriceUseCase
    
    //I18N 상태정보
    private let priceStateSubject  = PassthroughSubject<PriceState, Never>()
    
    public var state : AnyPublisher<PriceState, Never> {
        priceStateSubject.eraseToAnyPublisher()
    }
    
    private var store: Set<AnyCancellable> = .init()
    
    public init() { }
    
    public func getCurrencyType() -> CurrencyType {
        return repository.getCurrencyType()
    }
    
    public func setCurrencyType(type: CurrencyType) {
        repository.setCurrencyType(type: type)
    }
    
    public func getLanguageType() -> LanguageType {
        return repository.getLanguageType()
    }
    
    public func setLanguageType(type: LanguageType) {
        repository.setLanguageType(type: type)
    }
    
    public func getGridType() -> GridType {
        return repository.getGridType()
    }
    
    public func setGridType(type: GridType) {
        repository.setGrideType(type: type)
    }
    
    public func getExchangeRate(type: CurrencyType) -> PriceVO {
        return usecase.getPrice(currency: type.savingValue)
    }
    
    public func setExchangeRate() {
        usecase.setPrice()
            .sink { [weak self] priceState in
                if priceState == .failed {
                    self?.priceStateSubject.send(.failed)
                } else {
                    self?.priceStateSubject.send(.complete)
                }
            }
            .store(in: &store)
    }
}
