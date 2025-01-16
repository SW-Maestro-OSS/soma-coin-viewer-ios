//
//  ExchangeRateService.swift
//  Data
//
//  Created by 최재혁 on 12/13/24.
//

import Foundation
import Combine

public protocol ExchangeRateService {
    func getLatestExchangeRate(baseCurrencyCode: String, toCurrencyCodes: [String]) -> AnyPublisher<ExchangeRateDTO, Error>
}

public class DefaultExchangeRateService: ExchangeRateService {
    
    private let baseURL = "https://openexchangerates.org/api/latest.json"
    
    public init() { }
    
    public func getLatestExchangeRate(baseCurrencyCode: String, toCurrencyCodes: [String]) -> AnyPublisher<ExchangeRateDTO, Error> {
        
        let apiKey = Bundle.main.infoDictionary!["OPENEX_API_KEY"] as! String
        let symbolList: String = toCurrencyCodes.joined(separator: ",")
        
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "app_id", value: apiKey),
            URLQueryItem(name: "base", value: baseCurrencyCode),
            URLQueryItem(name: "symbols", value: symbolList),
        ]
        let url = components.url!

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ExchangeRateDTO.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
