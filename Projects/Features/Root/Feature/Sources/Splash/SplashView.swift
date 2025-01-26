//
//  SplashView.swift
//  RootModule
//
//  Created by choijunios on 1/14/25.
//

import SwiftUI

import I18N

struct SplashView: View {
    
    private let renderObject: SplashRO
    
    init(renderObject: SplashRO) {
        self.renderObject = renderObject
    }
    
    var body: some View {
        
        VStack {
            Spacer()
            Text(renderObject.displayTitleText)
            .font(.largeTitle)
            Spacer()
            Spacer()
        }
    }
}
