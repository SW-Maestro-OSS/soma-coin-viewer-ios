//
//  DefaultExchangeRateUseCase.swift
//  Domain
//
//  Created by choijunios on 1/13/25.
//

import Combine
import Foundation

import DomainInterface

import AlertShooter
import I18N
import CoreUtil

public class DefaultExchangeRateUseCase: ExchangeRateUseCase {
    
    // Service locator
    @Injected private var exchangeRateRepository: ExchangeRateRepository
    @Injected private var alertShooter: AlertShooter
    
    // Publisher
    private var store: Set<AnyCancellable> = .init()
    
    public init() { }
    
    public func getExchangeRate(base: CurrencyType, to: CurrencyType) -> AnyPublisher<Double?, Never> {
        
        if base == to { return Just(1.0).eraseToAnyPublisher() }
        
        return Future { [weak self] promise in
            
            guard let self else { return }
            
            let result = exchangeRateRepository
                .getExchangeRate(
                    baseCurrencyCode: base.currencyCode,
                    toCurrencyCode: to.currencyCode
                )
            
            guard let result else {
                printIfDebug("DefaultExchangeUseCase, 환율정보가져오기 실패 from: \(base.currencyCode) to: \(to.currencyCode)")
                promise(.success(nil))
                return
            }
            
            promise(.success(result))
            
        }
        .eraseToAnyPublisher()
    }
    
    public func prepare() {
        exchangeRateRepository
            .prepare(baseCurrencyCode: "USD", toCurrencyCodes: CurrencyType.allCases.map({ $0.currencyCode }))
            .sink { [weak self] completion in
                guard let self else { return }
                if case .failure(let error) = completion {
                    printIfDebug("\(Self.self) 환율정보 가져오기 실패 \(error.localizedDescription)")
                    var alertModel = AlertModel(
                        titleKey: TextKey.Alert.Title.exchangeRateError.rawValue,
                        messageKey: TextKey.Alert.Message.failedToGetExchangerate.rawValue
                    )
                    alertModel.add(action: .init(
                        titleKey: TextKey.Alert.ActionTitle.retry.rawValue
                    ) { [weak self] in
                        guard let self else { return }
                        prepare()
                    })
                    alertModel.add(action: .init(
                        titleKey: TextKey.Alert.ActionTitle.ignore.rawValue,
                        config: .init(textColor: .red)
                    ))
                    alertShooter.shoot(alertModel)
                }
            } receiveValue: { _ in
                printIfDebug("DefaultExchangeUseCase, 성공적으로 환율정보 가져옴")
            }
            .store(in: &store)
    }
}
