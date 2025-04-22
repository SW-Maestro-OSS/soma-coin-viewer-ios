//
//  LocalizedStringProvider.swift
//  I18N
//
//  Created by choijunios on 1/14/25.
//

import Foundation

/// 해당 객체는 단일체 패턴으로 접근가능합니다.
public class LocalizedStringProvider {
    private let localizableTextData: [String: [String: String]]
    
    private static var _instance: LocalizedStringProvider?
    public static func instance() -> LocalizedStringProvider {
        if let _instance { return _instance }
        let instance = LocalizedStringProvider()
        Self._instance = instance
        return instance
    }
    
    private init() {
        guard let url = I18NResources.bundle.url(forResource: "Localizable", withExtension: "json") else { fatalError() }
        do {
            let jsonData = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([String: [String: String]].self, from: jsonData)
            self.localizableTextData = decoded
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func getString(key: String, lanCode: String) -> String {
        localizableTextData[key]![lanCode]!
    }
}
