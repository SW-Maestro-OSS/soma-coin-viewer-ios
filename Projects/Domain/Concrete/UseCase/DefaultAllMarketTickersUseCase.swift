//
//  DefaultAllMarketTickersUseCase.swift
//  Domain
//
//  Created by choijunios on 11/2/24.
//

import Foundation
import Combine

import DomainInterface
import CoreUtil

public final class DefaultAllMarketTickersUseCase: AllMarketTickersUseCase {
    // Dependency
    private var allMarketTickersRepository: AllMarketTickersRepository
    private var exchangeRateRepository: ExchangeRateRepository
    private var userConfigurationRepository: UserConfigurationRepository
    
    public init(
        allMarketTickersRepository: AllMarketTickersRepository,
        exchangeRateRepository: ExchangeRateRepository,
        userConfigurationRepository: UserConfigurationRepository
    ) {
        self.allMarketTickersRepository = allMarketTickersRepository
        self.exchangeRateRepository = exchangeRateRepository
        self.userConfigurationRepository = userConfigurationRepository
    }
}


// MARK: AllMarketTickersUseCase
public extension DefaultAllMarketTickersUseCase {
    func getTickerListStream() -> AnyPublisher<TickerList, Never> {
        // #1. SUFFIX가 USDT인 심볼만 추출
        let only_usdt_tickers = allMarketTickersRepository
            .getStream(baseSymbol: "USDT")
        
        // #2. 가격 정보 적용
        let final_ticker_list = only_usdt_tickers
            .unretained(self)
            .asyncTransform { uc, tickers in
                // Repository dependencies
                let user_config_repo = uc.userConfigurationRepository
                let exchange_rate_repo = uc.exchangeRateRepository
                
                if let current_currency_type = user_config_repo.getCurrencyType(),
                   let exchange_rate = await exchange_rate_repo.getRate(
                       base: .dollar,
                       to: current_currency_type
                   ) {
                    // 설정된 화폐정보가 존재하고 환율을 획득할 수 있는 경우
                    let fitted_to_exchange_rate_tickers = tickers.map { ticker in
                        var new_ticker = ticker
                        new_ticker.price *= Decimal(exchange_rate)
                        return new_ticker
                    }
                    return TickerList(
                        currencyType: current_currency_type,
                        tickers: fitted_to_exchange_rate_tickers
                    )
                } else {
                    // 설정된 화폐정보가 없거나, 환율정보가 없는 경우
                    return TickerList(
                        currencyType: .dollar,
                        tickers: tickers
                    )
                }
            }
            
        return final_ticker_list
            .eraseToAnyPublisher()
    }
    
    
    func getGridType() -> GridType {
        userConfigurationRepository.getGridType() ?? .defaultValue
    }
}
