//
//  RoundChart.swift
//  Flux Zenithy
//
//  Created by Den on 01/04/24.
//

import SwiftUI

struct RoundChart: View {
    @State var progress: Float = 0.0
    var color: Color = Color.fzDarkRed
    @Binding var item: ChartItem
    var body: some View {
        VStack(spacing: 10) {
            Text(item.name)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(Font.system(size: UIDevice.current.userInterfaceIdiom == .phone ? 12 : 15, weight: .regular))
                .foregroundColor(Color.fzGray)
            ZStack {
                Circle()
                    .stroke(lineWidth: 10)
                    .opacity(0.20)
                    .foregroundColor(Color.fzWhite.opacity(0.75))
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                    .animation(.easeInOut(duration: 1.0))
                    .foregroundColor(progress == 0 ? Color.clear : color)
                    .rotationEffect(Angle(degrees: 270))
                    
                Text("\(abbreviatedString(for: item.hasSpent))$")
                    .font(Font.system(size: UIDevice.current.userInterfaceIdiom == .phone ? 20 : 25, weight: .bold))
                    .foregroundColor(Color.fzWhite)
                    .lineLimit(1)
                    .padding(.horizontal, 8)
            }
            .frame(maxWidth: 150)
            .padding(5)
        }
        .padding(10)
        .background(Color.fzBlackBoard)
        .cornerRadius(25)
        .onAppear() {
            if item.budget == 0 || item.budget < item.hasSpent{
                progress = 0.0
            } else {
                progress = Float(item.hasSpent / item.budget)
            }
        }
        .onChange(of: item, perform: { value in
            if item.budget == 0 || item.budget < item.hasSpent{
                progress = 0.0
            } else {
                progress = Float(item.hasSpent / item.budget)
            }
        })
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
                let roundedNum = round(absValue / divisor * 10) / 10
                return "\(sign)\(roundedNum)\(abbreviation)"
            }
        }

        return "\(sign)\(Int(value))"
    }
}

#Preview {
    RoundChart(item: .constant(.init(name: "Food", budget: 100000000.0, hasSpent: 1000000000.0, chartType: .food)))
}
