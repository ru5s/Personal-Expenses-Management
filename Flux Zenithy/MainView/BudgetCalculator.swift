//
//  BudgetCalculator.swift
//  Flux Zenithy
//
//  Created by Den on 29/03/24.
//

import SwiftUI

struct BudgetCalculator: View {
    @ObservedObject var calculatorModel: CalculatorViewModel
    @ObservedObject var personalBudgetModel: PersonalBudgetViewModel
    @State var openCalculator: Bool = false
    @Binding var activeTab: Int
    @Binding var tab: Int?
    var body: some View {
        VStack {
        }
        .sheet(isPresented: $openCalculator, content: {
            Calculator(model: calculatorModel, dismiss: $openCalculator, activeTab: $activeTab)
        })
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                switch tab {
                case 0:
                    activeTab = 0
                case 2:
                    activeTab = 2
                case .none:
                    break
                case .some(_):
                    break
                }
            })
            openCalculator.toggle()
        }
    }
}

#Preview {
    BudgetCalculator(calculatorModel: CalculatorViewModel(), personalBudgetModel: PersonalBudgetViewModel(), activeTab: .constant(0), tab: .constant(1))
}
