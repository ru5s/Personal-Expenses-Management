//
//  PersonalBudgetViewModel.swift
//  Flux Zenithy
//
//  Created by Den on 01/04/24.
//

import Foundation
import CoreData
import Combine

class PersonalBudgetViewModel: ObservableObject {
    @Published var allChartsNew: ChartItems = .init()
    @Published var allOthersExpenses: [Item] = []
    @Published var choosedPair: CurrencyPairModel = .init(id: 0, firstPair: "EUR", secondPair: "USD", percend: 2.3, cost: 1.08, icon: "$")
    @Published var currencyPairs: [CurrencyPairModel] = [
        .init(id: 0, firstPair: "EUR", secondPair: "USD", percend: 2.3, cost: 1.08, icon: "$"),
        .init(id: 1,firstPair: "USD", secondPair: "JPY", percend: -1.3, cost: 150.3, icon: "¥"),
        .init(id: 2,firstPair: "GBP", secondPair: "USD", percend: 0.8, cost: 1.26, icon: "$"),
        .init(id: 3,firstPair: "AUD", secondPair: "USD", percend: -2.3, cost: 0.65, icon: "$"),
        .init(id: 4,firstPair: "USD", secondPair: "CAD", percend: 1.3, cost: 1.35, icon: "$"),
        .init(id: 5,firstPair: "USD", secondPair: "CHF", percend: -2.9, cost: 0.88, icon: "₣"),
        .init(id: 6,firstPair: "NZD", secondPair: "USD", percend: 2.3, cost: 0.60, icon: "$"),
        .init(id: 7,firstPair: "EUR", secondPair: "JPY", percend: -2.3, cost: 163.1, icon: "¥"),
        .init(id: 8,firstPair: "GBP", secondPair: "JPY", percend: 2.3, cost: 190.8, icon: "¥"),
        .init(id: 9,firstPair: "EUR", secondPair: "GBP", percend: -2.1, cost: 0.85, icon: "£"),
        .init(id: 10,firstPair: "AUD", secondPair: "JPY", percend: 2.3, cost: 97.9, icon: "¥"),
        .init(id: 11,firstPair: "EUR", secondPair: "AUD", percend: -2.3, cost: 1.66, icon: "$"),
        .init(id: 12,firstPair: "EUR", secondPair: "CHF", percend: 0.7, cost: 0.96, icon: "₣"),
        .init(id: 13,firstPair: "AUD", secondPair: "NZD", percend: 3.3, cost: 1.07, icon: "$"),
        .init(id: 14,firstPair: "NZD", secondPair: "JPY", percend: 2.3, cost: 90.9, icon: "¥"),
        .init(id: 15,firstPair: "GBP", secondPair: "AUD", percend: -2.3, cost: 1.94, icon: "$"),
        .init(id: 16,firstPair: "GBP", secondPair: "CAD", percend: 2.3, cost: 1.72, icon: "$"),
        .init(id: 17,firstPair: "EUR", secondPair: "NZD", percend: 0.5, cost: 1.79, icon: "$"),
        .init(id: 18,firstPair: "AUD", secondPair: "CAD", percend: -2.9, cost: 0.88, icon: "$"),
        .init(id: 19,firstPair: "GBP", secondPair: "CHF", percend: 2.3, cost: 1.12, icon: "₣"),
    ]
    var cancellable = Set<AnyCancellable>()
    let userDefaults = UserDefaults()
    
    func change(budget: Double, hasSpent: Double, chart: inout ChartItem) {
        let userDefault = UserDefaults()
        chart.budget = budget
        chart.hasSpent = hasSpent
        userDefault.setValue(budget, forKey: chart.name)
        userDefault.setValue(hasSpent, forKey: chart.name + "HS")
    }
    func choosedCurrencyPair(){
        let id = userDefaults.integer(forKey: "SaveChoosedPair")
        let findPair = currencyPairs.first(where: {$0.id == id})
        choosedPair = findPair ?? .init(id: 0, firstPair: "EUR", secondPair: "USD", percend: 2.3, cost: 1.08, icon: "$")
    }
    func getAllOthersExpenses() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            let items = try CoreDataManager.shared.container.viewContext.fetch(fetchRequest)
            allOthersExpenses = items
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    func clearAllBoards() {
        CombineManager.shared.value.sink { bool in
            if bool {
                //clear all data by defaults values
                self.change(budget: 0.0, hasSpent: 0.0, chart: &self.allChartsNew.food)
                self.change(budget: 0.0, hasSpent: 0.0, chart: &self.allChartsNew.entertainments)
                self.change(budget: 0.0, hasSpent: 0.0, chart: &self.allChartsNew.services)
                self.change(budget: 0.0, hasSpent: 0.0, chart: &self.allChartsNew.transport)
                self.userDefaults.set(0, forKey: "SaveChoosedPair")
                self.choosedPair = .init(id: 0, firstPair: "EUR", secondPair: "USD", percend: 2.3, cost: 1.08, icon: "$")
                CombineManager.shared.value.send(false)
            }
        }
        .store(in: &cancellable)
    }
}

struct ChartItems {
    var food: ChartItem = .init(name: "Food", budget: 0.0, hasSpent: 0.0, chartType: .food)
    var transport: ChartItem = .init(name: "Transport", budget: 0.0, hasSpent: 0.0, chartType: .transport)
    var services: ChartItem = .init(name: "Communal services", budget: 0.0, hasSpent: 0.0, chartType: .services)
    var entertainments: ChartItem = .init(name: "Entertainments", budget: 0.0, hasSpent: 0.0, chartType: .entertainments)
    
    init() {
        let userDefault = UserDefaults()
        
        food.budget = userDefault.double(forKey: food.name)
        food.hasSpent = userDefault.double(forKey: food.name + "HS")
        
        transport.budget = userDefault.double(forKey: transport.name)
        transport.hasSpent = userDefault.double(forKey: transport.name + "HS")
        
        services.budget = userDefault.double(forKey: services.name)
        services.hasSpent = userDefault.double(forKey: services.name + "HS")
        
        entertainments.budget = userDefault.double(forKey: entertainments.name)
        entertainments.hasSpent = userDefault.double(forKey: entertainments.name + "HS")
    }
}
