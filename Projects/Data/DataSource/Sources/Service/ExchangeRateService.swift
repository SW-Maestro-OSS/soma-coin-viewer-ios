//
//  PriceService.swift
//  Data
//
//  Created by 최재혁 on 12/13/24.
//

import Foundation
import Combine

public protocol ExchangeRateService {
    func getExchanges(date: Date) -> AnyPublisher<[PriceDTO], Error>
}

public class DefaultPriceService: ExchangeRateService {
    
    private let baseURL = "https://www.koreaexim.go.kr/site/program/financial/exchangeJSON"
    
    public init() { }
    
    public func getExchanges(date: Date) -> AnyPublisher<[PriceDTO], Error> {
        
        let formattedDate = getDateFormat(date)
        let apiKey = Bundle.main.infoDictionary!["KOREAEXIM_API_KEY"] as! String
        
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "authkey", value: apiKey),
            URLQueryItem(name: "searchdate", value: formattedDate),
            URLQueryItem(name: "data", value: "AP01")
        ]
        let url = components.url!

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [PriceDTO].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    private func getDateFormat(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: date)
    }
}
