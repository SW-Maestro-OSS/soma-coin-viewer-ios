//
//  SettingCellRO.swift
//  SettingModule
//
//  Created by 최재혁 on 1/24/25.
//

import SwiftUI

struct SettingCellRO : Identifiable {
    var id : String { self.cellKey }
    
    let cellKey : String
    let cellType : CellType
    
    var title : String
    var option : String
    var isSelected : Bool
}
