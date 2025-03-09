//
//  SplashViewModel.swift
//  Flux Zenithy
//
//  Created by Den on 29/03/24.
//

import Foundation

class SplashViewModel: ObservableObject {
    @Published var progress: SplashProgress = .start
    @Published var onboarding: Bool = false
    @Published var tabView: Bool = false
    @Published var event: Bool?
    
    @Published var timer: Double = 0.0
    
    private func seenOnboard() {
        let defaults = UserDefaults.standard
//        defaults.setValue(false, forKey: "saw onboarding") //for test only, remove on prod
        let bool = defaults.bool(forKey: "saw onboarding")
        bool ? tabView.toggle() : onboarding.toggle()
    }
    func starTtimer() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { time in
            if self.timer <= 0.9 {
                self.timer += 0.1
                switch self.timer {
                case 0.2:
                    self.progress = .firstQuarter
                case 0.3:
                    self.progress = .half
                case 0.4:
                    self.progress = .thirdQuarter
                case 0.7:
                    self.progress = .full
                default:
                    break
                }
            } else {
                time.invalidate()
                self.seenOnboard()
            }
        }
    }
}
