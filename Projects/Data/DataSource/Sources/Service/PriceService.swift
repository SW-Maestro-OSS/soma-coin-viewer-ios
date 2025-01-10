//
//  PriceService.swift
//  Data
//
//  Created by 최재혁 on 12/13/24.
//

import Foundation
import Combine

public protocol PriceService {
    func getPrice(date : String) -> AnyPublisher<[PriceDTO], Never>
}

public class DefaultPriceService: PriceService {
    
    private let baseURL = "https://www.koreaexim.go.kr/site/program/financial/exchangeJSON"
    private let authKey = "mZvUswvFyQQf94DliSNjzH6FXk5PzAls"
       
    public init() { }
    
    public func getPrice(date : String) -> AnyPublisher<[PriceDTO], Never> {
        guard var components = URLComponents(string: baseURL) else {
            return Just([PriceDTO(
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
            )])
            .eraseToAnyPublisher()
        }
        
        components.queryItems = [
            URLQueryItem(name: "authkey", value: authKey),
            URLQueryItem(name: "searchdate", value: date),
            URLQueryItem(name: "data", value: "AP01")
        ]
        
        guard let url = components.url else {
            return Just([PriceDTO(
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
            )])
            .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [PriceDTO].self, decoder: JSONDecoder())
            .flatMap { priceList -> AnyPublisher<[PriceDTO], Never> in
                if priceList.first != nil {
                    return Just(priceList).eraseToAnyPublisher()
                } else {
                    let previousDate = self.getPreviousData(date: date)
                    return self.getPrice(date: previousDate)
                }
            }
            .catch { _ in
                return Just([PriceDTO(
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
                )])
            }
            .eraseToAnyPublisher()
    }
    
    private func getPreviousData(date : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        guard let currentDate = dateFormatter.date(from: date) else { return date }
        let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
        return dateFormatter.string(from: previousDate)
    }
}
