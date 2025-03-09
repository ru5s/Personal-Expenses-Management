//
//  SettingsViewModel.swift
//  Flux Zenithy
//
//  Created by Den on 02/04/24.
//

import StoreKit
import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    
//    let subject = PassthroughSubject<Int, Never>()
    
    
    let userDefault = UserDefaults()
    var allFields: CalculatorFields = .init()
    func rateApp() {
        DispatchQueue.main.async {
            let scene = UIApplication.shared.connectedScenes.first(where: {$0.activationState == .foregroundActive})
            SKStoreReviewController.requestReview(in: scene as! UIWindowScene)
        }
    }
    
    func sharedApp() {
        DispatchQueue.main.async {
            let appStoreURL = URL(string: "https://apps.apple.com")!
            let activityViewController = UIActivityViewController(activityItems: [appStoreURL], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = UIApplication.shared.windows.first
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY / 2, width: 0, height: 0)
            UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func eraseData(model: CalculatorViewModel) {
        CoreDataManager.shared.removeAll()
        CombineManager.shared.value.send(true)
        CombineManager.shared.calculate.send(true)
        
        clear(field: model.allFields.budget.name)
        clear(field: model.allFields.housing.name)
        clear(field: model.allFields.food.name)
        clear(field: model.allFields.clothes.name)
        clear(field: model.allFields.transport.name)
        clear(field: model.allFields.entertainments.name)
        clear(field: model.allFields.otherExpenses.name)
        
        model.allFields.budget.number = 0
        model.allFields.food.number = 0
        model.allFields.clothes.number = 0
        model.allFields.transport.number = 0
        model.allFields.entertainments.number = 0
        model.allFields.otherExpenses.number = 0
        model.allFields.housing.number = 0
    }
    
    private func clear(field: String) {
        userDefault.setValue(0, forKey: field + "-")
    }
}

enum settingsButtonType {
    case policy
    case shareApp
    case rateApp
    case resetData
}
