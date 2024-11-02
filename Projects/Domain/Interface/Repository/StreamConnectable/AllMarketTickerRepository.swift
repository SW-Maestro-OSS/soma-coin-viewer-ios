//
//  AllMarketTickerRepository.swift
//  DomainInterface
//
//  Created by choijunios on 11/1/24.
//

import Foundation
import Combine

public protocol AllMarketTickerRepository:
    StreamConnectable where Element == [Symbol24hTickerVO] { }
