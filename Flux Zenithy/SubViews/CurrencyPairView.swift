//
//  CurrencyPair.swift
//  Flux Zenithy
//
//  Created by Den on 01/04/24.
//

import SwiftUI

struct CurrencyPairView: View {
    @Binding var choosedPair: CurrencyPairModel
    @ObservedObject var model: PersonalBudgetViewModel
    @Binding var dismiss: Bool
    var body: some View {
        VStack {
            Text("Currency pair")
                .padding(.vertical, 10)
            
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(model.currencyPairs, id: \.id) { data in
                        CurrencyPairCell(data: data, choosedPair: $choosedPair, dismiss: $dismiss)
                    }
                }
            }
            
        }
        .padding(.horizontal, 16)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    CurrencyPairView(choosedPair: .constant(.init(id: 0, firstPair: "EUR", secondPair: "USD", percend: 2.3, cost: 1.08, icon: "$")), model: PersonalBudgetViewModel(), dismiss: .constant(false))
}
