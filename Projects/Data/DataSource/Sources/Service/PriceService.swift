//
//  PriceService.swift
//  Data
//
//  Created by 최재혁 on 12/13/24.
//

import Foundation
import Combine

public protocol PriceService {
    func getDollarPrice(date: String) -> AnyPublisher<PriceDTO, Never>
}

public class DefaultPriceService: PriceService {
    
    private let baseURL = "https://www.koreaexim.go.kr/site/program/financial/exchangeJSON"
    private let authKey = "mZvUswvFyQQf94DliSNjzH6FXk5PzAls"
       
    public init() { }
    
    public func getDollarPrice(date: String) -> AnyPublisher<PriceDTO, Never> {
        guard var components = URLComponents(string: baseURL) else {
            return Just(PriceDTO(
                result: .dataCodeError,
                currencyCode: "",
                currencyName: "",
                remittanceReceiveRate: "",
                remittanceSendRate: "",
                baseExchangeRate: "",
                bookPrice: "",
                annualExchangeFeeRate: "",
                tenDayExchangeFeeRate: "",
                kftcBaseExchangeRate: "",
                kftcBookPrice: ""
            ))
            .eraseToAnyPublisher()
        }
        
        components.queryItems = [
            URLQueryItem(name: "authkey", value: authKey),
            URLQueryItem(name: "searchdate", value: date),
            URLQueryItem(name: "data", value: "AP01")
        ]
        
        guard let url = components.url else {
            return Just(PriceDTO(
                result: .dataCodeError,
                currencyCode: "",
                currencyName: "",
                remittanceReceiveRate: "",
                remittanceSendRate: "",
                baseExchangeRate: "",
                bookPrice: "",
                annualExchangeFeeRate: "",
                tenDayExchangeFeeRate: "",
                kftcBaseExchangeRate: "",
                kftcBookPrice: ""
            ))
            .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [PriceDTO].self, decoder: JSONDecoder())
            .compactMap { $0.first { $0.currencyCode == "USD" } }
            .catch { _ in
                Just(PriceDTO(
                    result: .dataCodeError,
                    currencyCode: "",
                    currencyName: "",
                    remittanceReceiveRate: "",
                    remittanceSendRate: "",
                    baseExchangeRate: "",
                    bookPrice: "",
                    annualExchangeFeeRate: "",
                    tenDayExchangeFeeRate: "",
                    kftcBaseExchangeRate: "",
                    kftcBookPrice: ""
                ))
            }
            .eraseToAnyPublisher()
    }
}
