//
//  PriceDTO.swift
//  Data
//
//  Created by 최재혁 on 12/22/24.
//

import Foundation

public struct PriceDTO : Decodable {
    public enum Result: Int, Decodable {
        case success = 1         // 성공
        case dataCodeError = 2   // DATA코드 오류
        case authCodeError = 3   // 인증코드 오류
        case dailyLimitExceeded = 4 // 일일제한횟수 마감
    }
    
    public var result: Result            // 조회 결과
    public var currencyCode: String?     // 통화코드 (CUR_UNIT)
    public var currencyName: String?      // 국가/통화명 (CUR_NM)
    public var remittanceReceiveRate: String? // 전신환(송금) 받으실때 (TTB)
    public var remittanceSendRate: String?    // 전신환(송금) 보내실때 (TTS)
    public var baseExchangeRate: String?     // 매매 기준율 (DEAL_BAS_R)
    public var bookPrice: String?            // 장부가격 (BKPR)
    public var annualExchangeFeeRate: String? // 년환가료율 (YY_EFEE_R)
    public var tenDayExchangeFeeRate: String? // 10일환가료율 (TEN_DD_EFEE_R)
    public var kftcBaseExchangeRate: String?  // 서울외국환중개 매매기준율 (KFTC_DEAL_BAS_R)
    public var kftcBookPrice: String?         // 서울외국환중개 장부가격 (KFTC_BKPR)
    
    
    enum CodingKeys: String, CodingKey {
        case result
        case currencyCode = "cur_unit"
        case remittanceReceiveRate = "ttb"
        case remittanceSendRate = "tts"
        case baseExchangeRate = "deal_bas_r"
        case bookPrice = "bkpr"
        case annualExchangeFeeRate = "yy_efee_r"
        case tenDayExchangeFeeRate = "ten_dd_efee_r"
        case kftcBookPrice = "kftc_bkpr"
        case kftcBaseExchangeRate = "kftc_deal_bas_r"
        case currencyName = "cur_nm"
    }
}
