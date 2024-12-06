//
//  ImageView.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/6/24.
//

import SwiftUI

import SimpleImageProvider

struct ImageView: View {
    
    @Binding var imageURL: String
    
    @State private var image: UIImage = .actions
    
    var body: some View {
        
        Image(uiImage: image)
            .frame(width: 32, height: 32)
            .task {
                
                guard let image = await SimpleImageProvider.shared
                    .requestImage(url: imageURL, size: .init(width: 32, height: 32)) else { return }
                
                self.image = image
            }
        
    }
}
