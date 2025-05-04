//
//  GridType.swift
//  Domain
//
//  Created by choijunios on 1/13/25.
//

public enum GridType: String {
    case list="LIST"
    case twoByTwo="2X2"
    
    /// 도메인 기본값
    public static var defaultValue: Self { .list }
}
