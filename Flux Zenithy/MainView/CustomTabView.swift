//
//  TabView.swift
//  Flux Zenithy
//
//  Created by Den on 29/03/24.
//

import SwiftUI

struct CustomTabView: View {
    @ObservedObject var calculatorModel = CalculatorViewModel()
    @ObservedObject var personalBudgetModel = PersonalBudgetViewModel()
    @State var activeTab: Int = 0
    @State var previewsTab: Int?
    var body: some View {
        TabView(selection: $activeTab, content: {
            PersonalBudget(model: personalBudgetModel, tab: $previewsTab)
                .tabItem {
                    VStack {
                        Image(systemName: "creditcard.fill")
                        Text("Personal budget")
                    }
                }
                .tag(0)
            BudgetCalculator(calculatorModel: calculatorModel, personalBudgetModel: personalBudgetModel, activeTab: $activeTab, tab: $previewsTab)
                .tabItem {
                    VStack {
                        Image(systemName: "123.rectangle.fill")
                        Text("Budget calculator")
                    }
                }
                .tag(1)
            FluxSettings(calculatemModel: calculatorModel, tab: $previewsTab)
                .tabItem {
                    VStack {
                        Image(systemName: "gearshape.fill")
                        Text("Settings")
                    }
                }
                .tag(2)
        })
        .accentColor(Color.fzDarkRed)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    CustomTabView()
}
