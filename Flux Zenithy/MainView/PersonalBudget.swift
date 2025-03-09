//
//  PersonalBudget.swift
//  Flux Zenithy
//
//  Created by Den on 29/03/24.
//

import SwiftUI

struct PersonalBudget: View {
    @ObservedObject var model: PersonalBudgetViewModel
    @Binding var tab: Int?
    @State var budget = 0
    
    @State var openAlert: Bool = false
    @State var choosedBudgetBoard: ChartItem?
    @State private var createNewOtherExpenses: Bool = false
    @State private var headerHeight: CGFloat?
    @State private var openCurrencyPair: Bool = false
    var body: some View {
        ZStack {
            linkToOtherExpenses
            linkToCurrencyPair
            ZStack(alignment: .top) {
                ScrollView(showsIndicators: false) {
                    Text("Budget expenditures")
                        .padding(.vertical, 15)
                        .font(Font.system(size: 20, weight: .semibold))
                        .foregroundColor(Color.fzWhite)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, (headerHeight ?? 0) + 50)
                    
                    allProgress
                        
                    otherExpenses
                }
                .padding(.top, 70)
                header
                    .padding(.top, 20)
                    .onTapGesture {
                        openCurrencyPair.toggle()
                    }
            }
            .padding(.horizontal, 16)
            
            
            if openAlert {
                CustomAlert(choosedChart: choosedBudgetBoard, completion: {budget, spent, type in
                    switch type {
                    case .food:
                        //subtract the old amount from the total budget
                        self.budget -= Int(model.allChartsNew.food.budget)
                        //saving new data in the graph
                        model.change(budget: budget, hasSpent: spent, chart: &model.allChartsNew.food)
                        //adding new data to the total budget
                        self.budget += Int(budget)
                    case .transport:
                        self.budget -= Int(model.allChartsNew.transport.budget)
                        model.change(budget: budget, hasSpent: spent, chart: &model.allChartsNew.transport)
                        self.budget += Int(budget)
                    case .services:
                        self.budget -= Int(model.allChartsNew.services.budget)
                        model.change(budget: budget, hasSpent: spent, chart: &model.allChartsNew.services)
                        self.budget += Int(budget)
                    case .entertainments:
                        self.budget -= Int(model.allChartsNew.entertainments.budget)
                        model.change(budget: budget, hasSpent: spent, chart: &model.allChartsNew.entertainments)
                        self.budget += Int(budget)
                    }
                }, dismiss: $openAlert)
            }
            
        }
        .onAppear {
            tab = 0
            //find choosed currency pair
            model.choosedCurrencyPair()
            //get data from CoreData
            model.getAllOthersExpenses()
            //put choosed board by default for protect code
            choosedBudgetBoard = model.allChartsNew.food
            //connect to Combine
            model.clearAllBoards()
        }
    }
    
    var linkToOtherExpenses: some View {
        NavigationLink(
            destination: OtherExpenses(dismiss: $createNewOtherExpenses, updateData: {
                model.getAllOthersExpenses()
            }),
            isActive: $createNewOtherExpenses,
            label: {EmptyView()})
    }
    
    var linkToCurrencyPair: some View {
        NavigationLink(
            destination: CurrencyPairView(choosedPair: $model.choosedPair, model: model, dismiss: $openCurrencyPair),
            isActive: $openCurrencyPair,
            label: {EmptyView()})
    }

    var header: some View {
        PersonalHeadBoard(choosedPair: $model.choosedPair, budget: $budget)
            .shadow(color: Color.fzBlack, radius: 10, x: 0.0, y: 0.0)
            .overlay(
                GeometryReader(content: { geometry in
                    EmptyView()
                        .onAppear(){
                            headerHeight = CGFloat(geometry.size.height)
                        }
                })
            )
            .onAppear(){
                budget = Int(model.allChartsNew.food.budget + model.allChartsNew.transport.budget + model.allChartsNew.services.budget + model.allChartsNew.entertainments.budget + calculateAllOthersExpenses())
            }
    }
    
    private func calculateAllOthersExpenses() -> Double {
        var result = 0.0
        
        for i in model.allOthersExpenses {
            result += Double(i.cost ?? "") ?? 0.0
        }
        
        return result
    }
    
    var allProgress: some View {
        VStack(spacing: 10) {
            HStack(spacing: 23) {
                RoundChart(item: $model.allChartsNew.food)
                    .onTapGesture {
                        choosedBudgetBoard = model.allChartsNew.food
                        withAnimation {
                            openAlert.toggle()
                        }
                    }
                RoundChart(item: $model.allChartsNew.transport)
                    .onTapGesture {
                        choosedBudgetBoard = model.allChartsNew.transport
                        withAnimation {
                            openAlert.toggle()
                        }
                    }
            }
            .frame(minHeight: 167)
            HStack(spacing: 23) {
                RoundChart(item: $model.allChartsNew.services)
                    .onTapGesture {
                        choosedBudgetBoard = model.allChartsNew.services
                        withAnimation {
                            openAlert.toggle()
                        }
                    }
                RoundChart(item: $model.allChartsNew.entertainments)
                    .onTapGesture {
                        choosedBudgetBoard = model.allChartsNew.entertainments
                        withAnimation {
                            openAlert.toggle()
                        }
                    }
            }
            .frame(minHeight: 167)
        }
        .onAppear() {
        }
    }
    
    var otherExpenses: some View {
        VStack {
            HStack{
                Text("Other expenses")
                    .font(Font.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.fzWhite)
                Spacer()
                Button(action: {
                    createNewOtherExpenses.toggle()
                }, label: {
                    Image(systemName: "plus")
                        .foregroundColor(Color.fzDarkRed)
                })
            }
            .padding(.top, 15)
            
            LazyVStack {
                ForEach(model.allOthersExpenses, id: \.id) { data in
                    OtherExpensesCell(item: data, updateCell: .constant(false), updateData: {
                        model.getAllOthersExpenses()
                    }, allAmountBudget: $budget)
                }
            }
        }
    }
}

#Preview {
    PersonalBudget(model: PersonalBudgetViewModel(), tab: .constant(0))
}
