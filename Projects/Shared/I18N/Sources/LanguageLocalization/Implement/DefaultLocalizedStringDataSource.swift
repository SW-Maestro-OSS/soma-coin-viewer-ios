//
//  DefaultLocalizedStringDataSource.swift
//  I18N
//
//  Created by choijunios on 5/14/25.
//

import Foundation

public final class DefaultLocalizedStringDataSource: LocalizedStringDataSource {
    // State
    private var stringCache: [String: [String: String]] = [:]
    
    
    public init() {
        load()
    }
    
    
    private func load() {
        guard let url = I18NResources.bundle.url(forResource: "Localizable", withExtension: "json") else { fatalError() }
        do {
            let jsonData = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([String: [String: String]].self, from: jsonData)
            self.stringCache = decoded
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}


// MARK: LocalizedStringDataSource
public extension DefaultLocalizedStringDataSource {
    func getString(key: String, lanCode: String) -> String? {
        stringCache[key]?[lanCode]
    }
}
