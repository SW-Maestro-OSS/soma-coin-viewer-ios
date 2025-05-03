//
//  BinanceResponseDTO.swift
//  Data
//
//  Created by choijunios on 1/30/25.
//

import Foundation

// MARK: Response
struct BinanceResponseDTO: Decodable {
    let id: String
    let status: Int
    let error: BinanceErrorDTO?
}


// MARK: Error DTO
struct BinanceErrorDTO: Decodable {
    let code: Int
    let msg: String
}
