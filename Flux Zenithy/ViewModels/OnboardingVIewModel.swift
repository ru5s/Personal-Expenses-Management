//
//  OnboardingVIewModel.swift
//  Flux Zenithy
//
//  Created by Den on 29/03/24.
//

import Foundation

class OnboardingVIewModel: ObservableObject {
    @Published var slides: [OnboardingModel] = []
    
    private var simpleSlides: [OnboardingModel] = [
        .init(picture: BigValues.onboarding.slide_0.rawValue, title: "Control your \n budget", subtitle: "We will help you to stabilize your budget", button: "Next", trigger: .others),
        .init(picture: BigValues.onboarding.slide_1.rawValue, title: "Consider it \n profitable", subtitle: "Build the best options for your budget", button: "Next", trigger: .others),
        .init(picture: BigValues.onboarding.slide_2.rawValue, title: "Instant calculation \n results", subtitle: "Keep track of where and how much you spend \n on various expenses", button: "Next", trigger: .others),
        ]
    
    func event(event: Bool) {
        if event {
            slides = simpleSlides
        }
    }
}
