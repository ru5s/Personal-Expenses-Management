//
//  Settings.swift
//  Flux Zenithy
//
//  Created by Den on 29/03/24.
//

import SwiftUI

struct FluxSettings: View {
    @ObservedObject var calculatemModel: CalculatorViewModel
    @ObservedObject var model = SettingsViewModel()
    @Binding var tab: Int?
    @State var policyUrl: String = "https://docs.google.com"
    @State var openLink: Bool = false
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    board(image: "star.fill", title: "Rate app", type: .rateApp)
                    board(image: "square.and.arrow.up.fill", title: "Share app", type: .shareApp)
                }
                HStack(spacing: 16) {
                    board(image: "menucard.fill", title: "Usage Policy", type: .policy)
                    board(image: "arrow.counterclockwise", title: "Reset progress", type: .resetData)
                }
                
                Spacer()
//                linkToPolicy
            }
            .padding(.top, 20)
            .padding(.horizontal, 16)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            tab = 2
        }
        .sheet(isPresented: $openLink, content: {
            FluxWebView(stringUrl: policyUrl)
            .navigationBarTitleDisplayMode(.inline)
        })
    }
    
    private var linkToPolicy: some View {
        NavigationLink(
            destination: 
                FluxWebView(stringUrl: policyUrl)
                .navigationBarTitleDisplayMode(.inline)
            ,
            isActive: $openLink,
            label: {
                EmptyView()
            })
    }
    
    private func board(image: String, title: String, type: settingsButtonType) -> some View {
        Button(action: {
            switch type {
            case .policy:
                openLink.toggle()
            case .shareApp:
                model.sharedApp()
            case .rateApp:
                model.rateApp()
            case .resetData:
                model.eraseData(model: calculatemModel)
            }
        }, label: {
            VStack(spacing: 10) {
                Image(systemName: image)
                    .foregroundColor(Color.fzWhite)
                Text(title)
                    .font(Font.system(size: 15, weight: .medium))
                    .foregroundColor(Color.fzWhite)
            }
            .padding(.vertical, 25)
            .frame(maxWidth: .infinity)
            .background(Color.fzBlackBoard)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        })
    }
}

#Preview {
    FluxSettings(calculatemModel: CalculatorViewModel(), tab: .constant(2))
}
