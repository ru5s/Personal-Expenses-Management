//
//  CalculatorViewModel.swift
//  Flux Zenithy
//
//  Created by Den on 02/04/24.
//

import Foundation
import Combine

class CalculatorViewModel: ObservableObject {
    @Published var allFields: CalculatorFields = .init()
    @Published var eraseText: Bool = false
    @Published var settingsSignal: Bool = false
    var cancellable = Set<AnyCancellable>()
    let userDefault = UserDefaults()
    func clearAllBoards() {
        CombineManager.shared.calculate.sink { bool in
            if bool {
                print("clear all data in calculator")
                self.settingsSignal.toggle()
                CombineManager.shared.calculate.send(false)
            }
        }
        .store(in: &cancellable)
        
    }
}

struct CheckingField: Equatable {
    let id = UUID()
    var state: Bool = false
}

class CalculatorFields: ObservableObject  {
    let userDefault = UserDefaults()
    
    @Published var budget: CalculatorField = .init(name: "Budget", number: 0)
    @Published var housing: CalculatorField = .init(name: "Housing", number: 0)
    @Published var food: CalculatorField = .init(name: "Food", number: 0)
    @Published var clothes: CalculatorField = .init(name: "Clothes", number: 0)
    @Published var transport: CalculatorField = .init(name: "Transport", number: 0)
    @Published var entertainments: CalculatorField = .init(name: "Entertainments", number: 0)
    @Published var otherExpenses: CalculatorField = .init(name: "Other expenses", number: 0)
    
    init() {
        checkUserDefaults(field: &budget)
        checkUserDefaults(field: &housing)
        checkUserDefaults(field: &food)
        checkUserDefaults(field: &clothes)
        checkUserDefaults(field: &transport)
        checkUserDefaults(field: &entertainments)
        checkUserDefaults(field: &otherExpenses)
    }
    
    private func checkUserDefaults(field: inout CalculatorField) {
        field.number = userDefault.integer(forKey: field.name + "-")
    }
}

struct CalculatorField: Equatable {
    let id = UUID()
    let name: String
    var number: Int
}
