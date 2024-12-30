//
//  ImageView.swift
//  AllMarketTickerModule
//
//  Created by choijunios on 12/6/24.
//

import SwiftUI

import SimpleImageProvider

struct SymbolImageView: View {
    
    @Binding var imageURL: String
    
    @State private var image: UIImage = .actions
    
    var body: some View {
        
        GeometryReader { geo in
            Circle()
                .background(.white)
                .foregroundStyle(.gray.opacity(0.5))
                .frame(width: geo.size.width, height: geo.size.height)
                .overlay {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }
                .task {
                    
                    guard let image = await SimpleImageProvider.shared
                        .requestImage(
                            url: imageURL,
                            size: .init(width: geo.size.width, height: geo.size.height)
                        ) else { return }
                    
                    self.image = image
                }
        }
        
    }
}


#Preview {
    SymbolImageView(
        imageURL: .constant("plus")
    )
}
