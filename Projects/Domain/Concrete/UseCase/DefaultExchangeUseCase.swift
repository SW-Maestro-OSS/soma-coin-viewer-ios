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
    
    public func getExchangeRate(type: CurrencyType) -> AnyPublisher<ExchangeRateVO, Error> {
        
        fetchSuccessFlag
            .filter({ $0 })
            .unretained(self)
            .flatMap { useCase, _ in
                
                useCase.exchangeRateRepository
                    .getExchangeRateInKRW(currencyCode: type.currencyCode)
            }
            .eraseToAnyPublisher()
    }
    
    public func prepare() {
        
        exchangeRateRepository.prepare()
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
