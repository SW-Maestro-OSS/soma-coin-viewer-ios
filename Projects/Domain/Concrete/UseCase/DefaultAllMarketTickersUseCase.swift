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
    func getTickerListStream(tickerCount: Int) -> AnyPublisher<TickerList, Never> {
        // #1. SUFFIX가 USDT인 심볼만 추출
        let only_usdt_tickers = allMarketTickersRepository
            .getTickers()
            .unretained(self)
            .map { uc, tickers in
                tickers.filter { ticker in
                    let tickerSymbol = ticker.pairSymbol.uppercased()
                    return tickerSymbol.hasSuffix("USDT")
                }
            }
            
        // #2. totalTradedQuoteAssetVolume을 기반으로 정렬후 상위 tickerCount개만 추출
        let sliced_to_tickerCount_tickers = only_usdt_tickers
            .map { tickers in
                // 내림차순 정렬
                let sorted_tickers = tickers.sorted { ticker1, ticker2 in
                    ticker1.totalTradedQuoteAssetVolume > ticker2.totalTradedQuoteAssetVolume
                }
                
                if sorted_tickers.count < tickerCount {
                    // 원하는 티거 개수보다 작은 경우 그대로 반환
                    return sorted_tickers
                } else {
                    // 원하는 티커 개수보다 많은 경우 상위 추출
                    return Array(sorted_tickers.prefix(tickerCount))
                }
            }
        
        // #3. 가격 정보 적용
        let final_ticker_list = sliced_to_tickerCount_tickers
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
