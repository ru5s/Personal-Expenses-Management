//
//  SwiftUIView.swift
//  Flux Zenithy
//
//  Created by Den on 29/03/24.
//

import SwiftUI

struct CustomButton: View {
    @State var title: String
    @State var color: Color = Color.fzDarkRed
    @State var colorText: Color = Color.fzWhite
    @Binding var state: Bool
    @State var completion: () -> Void = {}
    var body: some View {
        let darkColor = color.brightness(-0.4)
        let clearColor = color.brightness(0.0)
        Button {
            completion()
        } label: {
            HStack {
                if title == "Down" {
                    Image(systemName: "arrowshape.down")
                }
                if title == "Up" {
                    Image(systemName: "arrowshape.up")
                }
                Text(title)
                    .font(Font.system(size: 16, weight: .semibold))
                    .foregroundColor(colorText)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
        }
        .background(state ? clearColor : darkColor)
        .accentColor(Color.fzWhite )
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .disabled(state ? false : true)
    }
}

#Preview {
    CustomButton(title: "Up", state: .constant(true))
}
