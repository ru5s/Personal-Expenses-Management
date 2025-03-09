//
//  OnboardingCellView.swift
//  Flux Zenithy
//
//  Created by Den on 29/03/24.
//

import SwiftUI

struct OnboardingCellView: View {
    @State var data: OnboardingModel
    @State var countSlides: Int
    @Binding var activeSlide: Int
    @State var completion: () -> Void
    var body: some View {
        ZStack {
            VStack {
                Image(data.picture)
                    .resizable()
                    .scaledToFill()
            }

            VStack(spacing: 10) {
                RoundImageDots(count: $countSlides, activeIndex: $activeSlide)
                Spacer()
                Text(data.title)
                    .foregroundColor(Color.fzWhite)
                    .multilineTextAlignment(.center)
                    .font(Font.system(size: 28, weight: .bold))
                Text(data.subtitle)
                    .foregroundColor(Color.fzGray)
                    .font(Font.system(size: 15, weight: .regular))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 32)
                CustomButton(title: data.button, state: .constant(true), completion: {
                    completion()
                })
                    .padding(.bottom, 60)
            }
            .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 32 : 16)
            .padding(.top, 50)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    OnboardingCellView(data: .init(picture: BigValues.onboarding.slide_2.rawValue, title: "Instant calculation \n results", subtitle: "Keep track of where and how much you spend \n on various expenses", button: "Next", trigger: .others), countSlides: 3, activeSlide: .constant(2), completion: {})
}
