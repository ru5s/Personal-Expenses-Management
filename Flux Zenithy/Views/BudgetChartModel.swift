//
//  BudgetChartModel.swift
//  Flux Zenithy
//
//  Created by Den on 01/04/24.
//

import Foundation

struct ChartItem: Equatable {
    let name: String
    var budget: Double
    var hasSpent: Double
    let chartType: AllCharts
}

enum AllCharts {
    case food
    case transport
    case services
    case entertainments
}
