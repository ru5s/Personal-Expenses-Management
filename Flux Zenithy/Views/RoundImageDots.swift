//
//  RoundImageDots.swift
//  Flux Zenithy
//
//  Created by Den on 29/03/24.
//

import SwiftUI

struct RoundImageDots: View {
    @Binding var count: Int
    @Binding var activeIndex: Int
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<count, id: \.self) { index in
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(index != activeIndex ? Color.fzDarkRed.opacity(0.3) : Color.fzDarkRed)
                    .frame(width: 8, height: 8)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 40)
    }
}

#Preview {
    RoundImageDots(count: .constant(3), activeIndex: .constant(1))
}
