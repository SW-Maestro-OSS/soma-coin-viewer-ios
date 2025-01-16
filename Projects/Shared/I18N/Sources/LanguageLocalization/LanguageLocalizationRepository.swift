//
//  LanguageLocalizationRepository.swift
//  I18N
//
//  Created by choijunios on 1/14/25.
//

import Foundation

public protocol LanguageLocalizationRepository {
    
    func getString(key: String, lanCode: String) -> String
}


public class DefaultLanguageLocalizationRepository: LanguageLocalizationRepository {
    
    private let localizableTextData: [String: [String: String]]
    
    public init() {
        
        guard let url = I18NResources.bundle.url(forResource: "Localizable", withExtension: "json") else {
            fatalError()
        }
        
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
