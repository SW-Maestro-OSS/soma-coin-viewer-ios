//
//  DefaultExchangeUseCase.swift
//  Domain
//
//  Created by choijunios on 1/13/25.
//

import Combine

import DomainInterface

import CoreUtil

public class DefaultExchangeUseCase: ExchangeRateUseCase {
    
    @Injected private var exchangeRateRepository: ExchangeRateRepository
    
    
    // Publisher
    private let fetchSuccessFlag: CurrentValueSubject<Bool, Never> = .init(false)
    private var store: Set<AnyCancellable> = .init()
    
    public init() { }
    
    public func getExchangeRate(base: CurrencyType, to: CurrencyType) -> AnyPublisher<Double, Never> {
        
        fetchSuccessFlag
            .filter({ $0 })
            .unretained(self)
            .map { useCase, _ in
                
                let result = useCase.exchangeRateRepository
                    .getExchangeRate(
                        baseCurrencyCode: base.currencyCode,
                        toCurrencyCode: to.currencyCode
                    )
                
                guard let result else {
                    printIfDebug("DefaultExchangeUseCase, 환율정보가져오기 실패 from: \(base.currencyCode) to: \(to.currencyCode)")
                    return 0.0
                }
                
                return result
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
                fetchSuccessFlag.send(true)
            }
            .store(in: &store)
    }
}
