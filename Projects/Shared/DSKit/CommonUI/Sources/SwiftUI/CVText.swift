//
//  CVText.swift
//  CommonUI
//
//  Created by choijunios on 12/6/24.
//

import SwiftUI

public struct CVText: View {
    
    @Binding private var text: String
    
    public init(text: Binding<String>) {
        
        self._text = text
    }
    
    public var body: some View {
        
        Text(text)
    }
}
