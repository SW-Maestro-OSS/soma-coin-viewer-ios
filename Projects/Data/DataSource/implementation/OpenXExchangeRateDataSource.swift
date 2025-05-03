//
//  OpenXExchangeRateDataSource.swift
//  Data
//
//  Created by choijunios on 4/22/25.
//

import Foundation

import CoreUtil

public final class OpenXExchangeRateDataSource: ExchangeRateDataSource {
    // Service
    @Injected private var httpService: HTTPService
    
    // State
    private let container: ExchangeRateContainer = .init()
    
    public init() { }
    
    public func prepareRates(base: String, to: [String]) async throws {
        let baseURL = URL(string: "https://openexchangerates.org/api/latest.json")!
        let apiKey = Bundle.main.infoDictionary!["OPENEX_API_KEY"] as! String
        let symbolList = to.joined(separator: ",")
        let urlRequestBuilder = URLRequestBuilder(base: baseURL, httpMethod: .get)
            .add(queryParam: [
                "app_id": apiKey,
                "base": base,
                "symbols": symbolList
            ])
        if let dto = try await httpService.request(urlRequestBuilder, dtoType: ExchangeRateDTO.self, retry: 1).body {
            await container.insert(base: base, dto: dto)
        }
    }
    
    public func getExchangeRate(base: String) async -> ExchangeRateDTO? {
        return await container.get(base: base)
    }
}
