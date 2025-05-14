//
//  LocalizedStringDataSource.swift
//  I18N
//
//  Created by choijunios on 5/14/25.
//

import DomainInterface

public protocol LocalizedStringDataSource {
    func getString(key: String, lanCode: String) -> String?
}
