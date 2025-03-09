//
//  Onboarding.swift
//  Flux Zenithy
//
//  Created by Den on 29/03/24.
//

import Foundation

struct OnboardingModel: Hashable {
    let id: UUID = UUID()
    let picture: String
    let title: String
    let subtitle: String
    var button: String
    var trigger: Trigger
}
