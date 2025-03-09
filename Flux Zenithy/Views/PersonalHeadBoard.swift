//
//  PersonalHeadBoard.swift
//  Flux Zenithy
//
//  Created by Den on 29/03/24.
//

import SwiftUI

struct PersonalHeadBoard: View {
    @Binding var choosedPair: CurrencyPairModel
    @Binding var budget: Int
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Amount of budget")
                    .font(Font.system(size: 15, weight: .semibold))
                    .foregroundColor(Color.fzGray)
                    .padding(.bottom, 10)
                Text("$\(abbreviatedString(for: Double(budget)) )")
                    .font(Font.system(size: 26, weight: .bold))
                    .foregroundColor(Color.fzWhite)
            }
            Spacer()
            Text(choosedPair.firstPair + "/" + choosedPair.secondPair)
                .font(Font.system(size: 18, weight: .semibold))
                .foregroundColor(Color.fzDarkRed)
                .padding(.trailing, 12)
            Image(systemName: "chevron.right")
                .foregroundColor(Color.fzDarkRed)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .frame(height: 102)
        .background(Color.fzBlackBoard)
        .clipShape(RoundedRectangle(cornerRadius: 25))   
    }
    
    private func abbreviatedString(for value: Double) -> String {
        let sign = ((value < 0) ? "-" : "" )
        let absValue = abs(value)
        
        if absValue < 1_000.0 {
            return "\(sign)\(Int(value))"
        }
        
        let abbreviations = [(1_000_000_000.0, "B"), (1_000_000.0, "M"), (1_000.0, "K")]
        
        for (divisor, abbreviation) in abbreviations {
            if absValue >= divisor {
                let roundedNum = round(absValue / divisor * 1000) / 1000
                return "\(sign)\(roundedNum)\(abbreviation)"
            }
        }

        return "\(sign)\(Int(value))"
    }
}

#Preview {
    PersonalHeadBoard(choosedPair: .constant(.init(id: 0, firstPair: "EUR", secondPair: "USD", percend: 2.3, cost: 1.08, icon: "$")), budget: .constant(10034003443))
}
