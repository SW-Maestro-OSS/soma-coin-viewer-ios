//
//  Price.swift
//  Data
//
//  Created by 최재혁 on 12/22/24.
//

import Foundation

import DataSource
import DomainInterface

extension PriceDTO {
    func toEntity() -> ExchangeRateVO {
        return .init(
            currencyCode: currencyCode ?? "Error",
            ttb: Double(remittanceReceiveRate ?? "-1.0") ?? 0.0,
            tts: Double(remittanceSendRate ?? "-1.0") ?? 0.0
        )
    }
}
