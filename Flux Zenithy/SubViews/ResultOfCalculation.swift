//
//  ResultOfCalculation.swift
//  Flux Zenithy
//
//  Created by Den on 02/04/24.
//

import SwiftUI

struct ResultOfCalculation: View {
    @Binding var data: CalculatorFields
    @State var budget = 0
    @State var amountOfCost = 0
    @Binding var dismiss: Bool
    var body: some View {
        VStack {
            header
            
            Rectangle()
                .frame(height: 0.85)
                .foregroundColor(Color.fzGray)
                .padding(.bottom, 10)
            
            bodyView
            Spacer()
        }
        .padding(.horizontal, 16)
        .navigationTitle("Calculation result")
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear() {
            budget = data.budget.number
            amountOfCost = data.clothes.number + data.entertainments.number + data.food.number + data.housing.number + data.otherExpenses.number + data.transport.number
        }
    }
    
    private var header: some View {
        VStack(spacing: 26) {
            VStack {
                RoundedRectangle(cornerRadius: 50)
                    .frame(width: 36, height: 5, alignment: .center)
                    .foregroundColor(Color.fzGray.opacity(0.5))
                    .padding(.top, 10)
                ZStack {
                    Text("Calculation result")
                        .font(Font.system(size: 17, weight: .semibold))
                        .foregroundColor(Color.fzWhite)
                    HStack {
                        //back button
                        Button(action: {
                            dismiss.toggle()
                        }, label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color.fzWhite)
                            Text("Back")
                                .font(Font.system(size: 17, weight: .semibold))
                                .foregroundColor(Color.fzWhite)
                        })
                    }
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, -10)
                }
            }
            
            HStack {
                //all board that show data from calculator and divide by ipad and iphone
                board(title: "Budget", sum: "\(budget)")
                board(title: "Amount of costs", sum: "\(amountOfCost)")
                if UIDevice.current.userInterfaceIdiom == .pad {
                    board(title: "Remains", sum: "\(budget - amountOfCost)")
                }
            }
            if UIDevice.current.userInterfaceIdiom == .phone {
                board(title: "Remains", sum: "\(budget - amountOfCost)")
            }
        }
    }
    
    private var bodyView: some View {
        VStack {
            Text("Expenses")
                .font(Font.system(size: UIDevice.current.userInterfaceIdiom == .phone ? 20 : 28, weight: .semibold))
                .foregroundColor(Color.fzWhite)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                //all expenses board below show how percentage in total budget get every type waste of money
                HStack {
                    expensesBoard(title: data.housing.name, percent: Double(data.housing.number))
                    expensesBoard(title: data.food.name, percent: Double(data.food.number))
                }
                HStack {
                    expensesBoard(title: data.clothes.name, percent: Double(data.clothes.number))
                    expensesBoard(title: data.transport.name, percent: Double(data.transport.number))
                }
                HStack {
                    expensesBoard(title: data.entertainments.name, percent: Double(data.entertainments.number))
                    expensesBoard(title: data.otherExpenses.name, percent: Double(data.otherExpenses.number))
                }
            }
        }
    }
    
    private func board(title: String, sum: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(Font.system(size: UIDevice.current.userInterfaceIdiom == .phone ? 13 : 18, weight: .bold))
                .foregroundColor(Color.fzGray)
            Text("$\(sum)")
                .font(Font.system(size: UIDevice.current.userInterfaceIdiom == .phone ? 26 : 36, weight: .bold))
                .foregroundColor(Color.fzWhite)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func expensesBoard(title: String, percent: Double) -> some View {
        VStack {
            // result is calculated how much percentage is spent from the total budget with a percentage of up to hundredths
            let result = ((percent / (Double(budget) / 100)) * 100).rounded() / 100
            Text(title)
                .font(Font.system(size: UIDevice.current.userInterfaceIdiom == .phone ? 12 : 16, weight: .regular))
                .foregroundColor(Color.fzGray)
                .frame(maxWidth: .infinity, alignment: .trailing)
            Text("\(result.description)%")
                .font(Font.system(size: UIDevice.current.userInterfaceIdiom == .phone ? 20 : 27, weight: .bold))
                .foregroundColor(Color.fzWhite)
                .padding(.vertical, 25)
                .lineLimit(1)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(Color.fzGray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
    }
}

#Preview {
    ResultOfCalculation(data: .constant(.init()), dismiss: .constant(false))
}
