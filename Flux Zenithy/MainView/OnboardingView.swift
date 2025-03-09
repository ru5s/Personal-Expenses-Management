//
//  OnboardingView.swift
//  Flux Zenithy
//
//  Created by Den on 29/03/24.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var model = OnboardingVIewModel()
    @State var event: Bool
    @State var activeTab: Int = 0
    @State var openTabview: Bool = false
    @State var activeNextButton: Bool = true
    var body: some View {
        NavigationView(content: {
            ZStack {
                NavigationLink(
                    destination: CustomTabView().navigationBarHidden(true),isActive: $openTabview,label: {EmptyView()})
                TabView(selection: $activeTab,
                        content:  {
                    ForEach(Array(model.slides.enumerated()), id: \.element) {index, data in
                        OnboardingCellView(data: data, countSlides: model.slides.count, activeSlide: $activeTab, completion: {
                            if activeTab < model.slides.count - 1 {
                                activeTab += 1
                            } else {
                                let defaults = UserDefaults.standard
                                defaults.set(true, forKey: "saw onboarding")
                                DispatchQueue.main.async {
                                    openTabview.toggle()
                                }
                            }
                        })
                        .tag(index)
                    }
                })
                .onAppear {
                    UIScrollView.appearance().isScrollEnabled = false
                }
                .background(Color.fzBlack)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut)
            }
            .ignoresSafeArea()
        })
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            model.event(event: event)
        }
    }
}

#Preview {
    OnboardingView(event: true)
}
