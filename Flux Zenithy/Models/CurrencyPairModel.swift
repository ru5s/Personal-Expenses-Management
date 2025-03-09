//
//  CurrencyPairModel.swift
//  Flux Zenithy
//
//  Created by Den on 01/04/24.
//

import Foundation

struct CurrencyPairModel: Hashable {
    let id: Int 
    let firstPair: String
    let secondPair: String
    let percend: Double
    let cost: Double
    let icon: String
}
