//
//  PriceChangePercentView.swift
//  CoinDetailModule
//
//  Created by choijunios on 4/16/25.
//

import SwiftUI

struct PriceChangePercentView: View {
    
    @Binding var renderObject: PriceChagePercentRO?
    
    var body: some View {
        HStack(spacing: 2) {
            if let imageName = renderObject?.changeType.imageName {
                Image(systemName: imageName)
            } else {
                Text("-")
            }
            Text(renderObject?.percentText ?? "-")
                .font(.subheadline.bold())
                .monospacedDigit()
        }
        .foregroundStyle(renderObject?.changeType.color ?? .black)
    }
}

#Preview {
    PriceChangePercentView(renderObject: .constant(nil))
}
#Preview {
    PriceChangePercentView(renderObject: .constant(.init(
        changeType: .minus,
        percentText: "50.0"
    )))
}
#Preview {
    PriceChangePercentView(renderObject: .constant(.init(
        changeType: .plus,
        percentText: "50.0"
    )))
}
#Preview {
    PriceChangePercentView(renderObject: .constant(.init(
        changeType: .neutral,
        percentText: "50.0"
    )))
}
