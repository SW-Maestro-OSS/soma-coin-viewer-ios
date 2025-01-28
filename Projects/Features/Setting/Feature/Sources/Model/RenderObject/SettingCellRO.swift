//
//  SettingCellRO.swift
//  SettingModule
//
//  Created by 최재혁 on 1/24/25.
//

import SwiftUI

struct SettingCellRO : Identifiable {
    var id : String { self.cellType }
    
    let cellType : String
    
    var titleKey : String
    var optionKey : String
    var isSelected : Bool
}
