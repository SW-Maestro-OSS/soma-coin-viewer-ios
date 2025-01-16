//
//  SplashView.swift
//  RootModule
//
//  Created by choijunios on 1/14/25.
//

import SwiftUI

import DomainInterface

import I18N

import CoreUtil

class SplashViewModel: ObservableObject {
    
    @Injected private var i18NManager: I18NManager
    
    @Published var languageType: LanguageType
    
    init() {
        self.languageType = .english
        self.languageType = i18NManager.getLanguageType()
    }
}

struct SplashView: View {
    
    @StateObject private var splashViewModel: SplashViewModel = .init()
    
    var body: some View {
        
        VStack {
            Spacer()
            LocalizableText(
                key: "LaunchScreen_title",
                languageType: $splashViewModel.languageType
            )
            .font(.largeTitle)
            Spacer()
            Spacer()
        }
    }
}
