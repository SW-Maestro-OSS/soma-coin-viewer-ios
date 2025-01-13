//
//  DefaultExchangeRateUseCase.swift
//  Domain
//
//  Created by choijunios on 1/13/25.
//

import Combine
import Foundation

import DomainInterface

import CoreUtil

public class DefaultExchangeRateUseCase: ExchangeRateUseCase {
    
    @Injected private var exchangeRateRepository: ExchangeRateRepository
    
    
    // Publisher
    private let fetchSuccessFlag: CurrentValueSubject<Void?, Never> = .init(nil)
    private var store: Set<AnyCancellable> = .init()
    
    public init() { }
    
    public func getExchangeRate(base: CurrencyType, to: CurrencyType) -> AnyPublisher<Double, Never> {
        
        if base == to { return Just(1.0).eraseToAnyPublisher() }
        
        return Future { [weak self] promise in
            
            guard let self else { return }
            
            fetchSuccessFlag
                .compactMap({ $0 })
                .first()
                .unretained(self)
                .sink { useCase, _ in
                    
                    let result = useCase.exchangeRateRepository
                        .getExchangeRate(
                            baseCurrencyCode: base.currencyCode,
                            toCurrencyCode: to.currencyCode
                        )
                    
                    guard let result else {
                        printIfDebug("DefaultExchangeUseCase, 환율정보가져오기 실패 from: \(base.currencyCode) to: \(to.currencyCode)")
                        promise(.success(0.0))
                        return
                    }
                    
                    promise(.success(result))
                }
                .store(in: &store)
            
        }
        .eraseToAnyPublisher()
    }
    
    public func prepare() {
        
        exchangeRateRepository
            .prepare(baseCurrencyCode: "USD", toCurrencyCodes: CurrencyType.allCases.map({ $0.currencyCode }))
            .sink { error in
                
                // Fetch 도중 에러 발생 -> 유저에게 알리기
                
            } receiveValue: { [weak self] _ in
                
                guard let self else { return }
                
                printIfDebug("DefaultExchangeUseCase, 성공적으로 환율정보 가져옴")
                fetchSuccessFlag.send(())
            }
            .store(in: &store)
    }
}
