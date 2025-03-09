//
//  AboutCurrencyPair.swift
//  Flux Zenithy
//
//  Created by Den on 01/04/24.
//

import SwiftUI

struct AboutCurrencyPair: View {
    @State var data: CurrencyPairModel
    @Binding var choosedPair: CurrencyPairModel
    @Binding var dismiss: Bool
    @Binding var backToTabPage: Bool
    let userDefaults = UserDefaults()
    var body: some View {
        let percentage = ((data.percend * 1000).rounded() / 1000)
        VStack {
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
                .padding(.vertical, 20)
                Text(data.firstPair + "/" + data.secondPair)
                    .foregroundColor(Color.fzWhite)
                .padding(.vertical, 10)
            }
            Text("Currency value")
                .font(Font.system(size: 13, weight: .bold))
                .foregroundColor(Color.fzGray)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack(spacing: 8) {
                Text("\(data.icon)\(data.cost.description)")
                    .foregroundColor(Color.fzWhite)
                    .font(Font.system(size: 28, weight: .regular))
                Text("\(percentage >= 0 ? "+" : "")\(percentage.description)%")
                    .foregroundColor(percentage >= 0 ? Color.fzGreen : Color.fzRed)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .font(Font.system(size: 13, weight: .regular))
                Spacer()
            }
            Image(BigValues.images.chart.rawValue)
                .resizable()
                .scaledToFit()
                .padding(.horizontal, -16)
            Spacer()
            HStack {
                CustomButton(title: "Down", color: Color.fzRed, state: .constant(true), completion: {
                    dismiss.toggle()
                })
                CustomButton(title: "Up", color: Color.fzGreen, state: .constant(true), completion: {
                    choosedPair = data
                    userDefaults.set(data.id, forKey: "SaveChoosedPair")
                    backToTabPage.toggle()
                    dismiss.toggle()
                })
            }
            .padding(.bottom, 50)
        }
        .padding(.horizontal, 16)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    AboutCurrencyPair(data: .init(id: 0, firstPair: "EUR", secondPair: "USD", percend: 2.3, cost: 1.08, icon: "$"), choosedPair: .constant(.init(id: 0, firstPair: "EUR", secondPair: "USD", percend: 2.3, cost: 1.08, icon: "$")), dismiss: .constant(true), backToTabPage: .constant(false))
}
