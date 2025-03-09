//
//  CustomAlert.swift
//  Flux Zenithy
//
//  Created by Den on 01/04/24.
//

import SwiftUI

struct CustomAlert: View {
    @State var title: String = ""
    @State private var budget: String = ""
    @State private var hasSpent: String = ""
    @State private var disableButton: Bool = true
    @State private var showAttension: Bool = false
    @State var choosedChart: ChartItem?
    @State var completion: (Double, Double, AllCharts) -> Void
    @Binding var dismiss: Bool
    var body: some View {
        ZStack {
            Color.fzBlack.opacity(0.5)
                .ignoresSafeArea()
            VStack{
                titleAlert
                textFields
                buttons
            }
            .opacity(dismiss ? 1.0 : 0.0)
            .frame(maxWidth: 230)
            .padding(16)
            .background(Color.fzBlackBoard)
            .cornerRadius(14)
            attension
                .frame(maxHeight: .infinity, alignment: .bottom)
                .opacity(showAttension ? 1.0 : 0.0)
        }
        .onAppear(){
            
            budget = Int(choosedChart?.budget ?? 0.0).description
            if choosedChart?.budget == 0.0 {
                budget = ""
            }
            hasSpent = Int(choosedChart?.hasSpent ?? 0.0).description
            if choosedChart?.hasSpent == 0.0 {
                hasSpent = ""
            }
            title = choosedChart?.name ?? ""
            checkFields()
        }
        .onChange(of: budget, perform: { value in
            checkFields()
        })
        .onChange(of: hasSpent, perform: { value in
            checkFields()
        })
    }
    
    private func checkFields() {
        if (!budget.isEmpty && Double(budget) != nil) && (!hasSpent.isEmpty && Double(hasSpent) != nil) {
            if Double(budget) ?? 0.0 < Double(hasSpent) ?? 0.0 {
                withAnimation(.bouncy(duration: 1.0)) {
                    showAttension = true
                    disableButton = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    withAnimation {
                        self.showAttension = false
                    }
                })
            } else {
                withAnimation(.easeInOut(duration: 0.3)) {
                    disableButton = false
                }
            }
            
        } else {
            withAnimation(.easeInOut(duration: 0.3)) {
                disableButton = true
            }
        }
    }
    
    private var attension: some View {
        VStack {
            Text("The budget should be more than the planned expenses")
                .multilineTextAlignment(.center)
                .foregroundColor(Color.fzWhite)
                .padding(.bottom, 40)
        }
    }
    
    private var titleAlert: some View {
        VStack {
            Text("Budget expenses for \(title.lowercased())")
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.fzWhite)
                .padding(.bottom, 15)
        }
    }
    
    private var buttons: some View {
        VStack {
            Divider()
                .padding(.horizontal, -16)
            Button(action: {
                completion(Double(budget) ?? 0.0, Double(hasSpent) ?? 0.0, choosedChart?.chartType ?? .food)
                dismiss.toggle()
            }, label: {
                Text("Add")
                    .foregroundColor(disableButton ? Color.fzDarkRed.opacity(0.7) : Color.fzRed)
                    .frame(maxWidth: .infinity)
            })
            .disabled(disableButton)
            Divider()
                .padding(.horizontal, -16)
            Button(action: {
                dismiss.toggle()
            }, label: {
                Text("Close")
                    .foregroundColor(Color.fzWhite)
                    .frame(maxWidth: .infinity)
            })
        }
    }
    
    private var textFields: some View {
        VStack {
            TextField("", text: $budget)
                .keyboardType(.decimalPad)
                .padding(.vertical, 3)
                .padding(.horizontal, 5)
                .placeholder(when: budget.isEmpty) {
                    Text("Enter the budget")
                        .foregroundColor(Color.fzGray)
                        .padding(.leading, 5)
                }
                .background(Color.fzWhite.opacity(0.05))
                .foregroundColor(Color.fzWhite)
                .cornerRadiusWithBorder(radius: 5, borderLineWidth: 0.5, borderColor: Color.gray, antialiased: false)
                .accentColor(Color.fzDarkRed)
                .padding(.bottom, 10)
            TextField("", text: $hasSpent)
                .keyboardType(.decimalPad)
                .padding(.vertical, 3)
                .padding(.horizontal, 5)
                .placeholder(when: hasSpent.isEmpty) {
                    Text("Enter much has spent")
                        .foregroundColor(Color.fzGray)
                        .padding(.leading, 5)
                }
                .background(Color.fzWhite.opacity(0.05))
                .foregroundColor(Color.fzWhite)
                .cornerRadiusWithBorder(radius: 5, borderLineWidth: 0.5, borderColor: Color.gray, antialiased: false)
                .accentColor(Color.fzDarkRed)
                .padding(.bottom, 10)
        }
    }
}

#Preview {
    CustomAlert(completion: {_, _, _ in}, dismiss: .constant(true))
}
