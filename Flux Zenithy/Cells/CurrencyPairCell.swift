//
//  CurrencyPairCell.swift
//  Flux Zenithy
//
//  Created by Den on 01/04/24.
//

import SwiftUI

struct CurrencyPairCell: View {
    @State var data: CurrencyPairModel
    @Binding var choosedPair: CurrencyPairModel
    @State var openAboutPair: Bool = false
    @Binding var dismiss: Bool
    var body: some View {
        HStack {
            HStack(spacing: 0) {
                Image(data.firstPair)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 28)
                Image(data.secondPair)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 28)
                    .padding(.leading, -14)
                    .padding(.bottom, -28)
            }
            .padding(.bottom, 19)
            ZStack(alignment: .bottom) {
                HStack {
                    Text(data.firstPair + "/" + data.secondPair)
                        .font(Font.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.fzWhite)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.fzWhite)
                }
                .frame(height: 60)
                Divider()
                    .padding(.trailing, -16)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 60)
        .background(Color.fzWhite.opacity(0.05))
        .cornerRadius(10)
        .onTapGesture {
            openAboutPair.toggle()
        }
        .sheet(isPresented: $openAboutPair, content: {
            AboutCurrencyPair(data: data, choosedPair: $choosedPair, dismiss: $openAboutPair, backToTabPage: $dismiss)
        })
    }
}

#Preview {
    CurrencyPairCell(data: .init(id: 0, firstPair: "EUR", secondPair: "USD", percend: 2.3, cost: 1.08, icon: "$"), choosedPair: .constant(.init(id: 0, firstPair: "EUR", secondPair: "USD", percend: 2.3, cost: 1.08, icon: "$")), dismiss: .constant(false))
}
