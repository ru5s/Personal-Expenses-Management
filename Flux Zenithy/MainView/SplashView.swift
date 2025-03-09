//
//  SplashView.swift
//  Flux Zenithy
//
//  Created by Den on 29/03/24.
//

import SwiftUI

struct SplashView: View {
    @State var event: Bool
    @ObservedObject var model: SplashViewModel = SplashViewModel()
    var body: some View {
        NavigationView(content: {
            VStack {
                NavigationLink(destination: OnboardingView(event: event).navigationBarHidden(true), isActive: $model.onboarding) {EmptyView()}
                NavigationLink(destination: CustomTabView().navigationBarHidden(true), isActive: $model.tabView) {EmptyView()}
                Spacer()
                Image(BigValues.logo.logo.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 320)
                Spacer()
                HStack(spacing: 0) {
                    ProgressView(value: model.timer)
                        .progressViewStyle(CircularProgressViewStyle())
                                .padding()
                                .preferredColorScheme(.dark)
                                .scaleEffect(x: 1.5, y: 1.5)
                    Text("\(Int(model.progress.rawValue * 100))%")
                                .font(.headline)
                                .foregroundColor(Color.fzWhite)
                        }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.fzBlack)
            .ignoresSafeArea()
        })
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            model.event = event
            model.starTtimer()
        }
    }
}

#Preview {
    SplashView(event: true)
}
