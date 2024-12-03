//
//  MainPageLocalizable.swift
//  I18N
//
//  Created by choijunios on 10/14/24.
//

import Foundation
import Localizable

public extension LS {
    
    @I18NRepresentable(table: "LSMainPage", bundleClass: I18NClass.self)
    enum MainPage {
        case Title
        case Description
    }
}


