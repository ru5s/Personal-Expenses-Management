//
//  OtherExpens.swift
//  Flux Zenithy
//
//  Created by Den on 01/04/24.
//

import SwiftUI

struct OtherExpenses: View {
    @State var item: Item?
    @State private var name: String = ""
    @State private var cost: String = ""
    @State var disableButton: Bool = false
    @Binding var dismiss: Bool
    @State var updateData: () -> Void
    @State var buttonTitle: String = "Create"
    @State var navigationTitle: String = "Create other expenses"
    var body: some View {
        NavigationView(content: {
            VStack {
                customTextField
                    .padding(.top, 20)
                CustomButton(title: buttonTitle, color: item == nil ? Color.red : Color.fzGreen, state: $disableButton, completion: {
                    if item == nil {
                        CoreDataManager.shared.saveItem(name: name, cost: cost)
                    } else {
                        item?.name = name
                        item?.cost = cost
                        try? CoreDataManager.shared.save()
                        updateData()
                    }
                    dismiss.toggle()
                })
                if item != nil {
                    CustomButton(title: "Delete", state: .constant(true), completion: {
                        CoreDataManager.shared.removeItemFromCoreData(id: item?.id ?? UUID())
                        updateData()
                    })
                    .padding(.top, 10)
                }
                Spacer()
            }
            .padding(.horizontal, 16)
        })
        .navigationTitle(navigationTitle)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear() {
            name = item?.name ?? ""
            cost = item?.cost ?? ""
            checkFields()
        }
        .onChange(of: name, perform: { _ in
            checkFields()
        })
        .onChange(of: cost, perform: { _ in
            checkFields()
        })
    }
    
    private func checkFields() {
        if !name.isEmpty && !cost.isEmpty && Double(cost) != nil {
            disableButton = true
        } else {
            disableButton = false
        }
    }
    
    private var customTextField: some View {
        VStack {
            Text("Name")
                .font(Font.system(size: 15, weight: .medium))
                .foregroundColor(Color.fzWhite)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("", text: $name)
                .keyboardType(.default)
                .padding(.vertical, 13)
                .padding(.horizontal, 16)
                .placeholder(when: name.isEmpty) {
                    Text("Enter")
                        .foregroundColor(Color.fzGray)
                        .padding(.leading, 16)
                }
                .background(Color.fzWhite.opacity(0.15))
                .cornerRadius(8)
                .foregroundColor(Color.fzWhite)
                .accentColor(Color.fzDarkRed)
                .padding(.bottom, 20)
                .font(Font.system(size: 13, weight: .regular))
                .foregroundColor(Color.fzWhite)
            
            Text("Cost")
                .font(Font.system(size: 15, weight: .medium))
                .foregroundColor(Color.fzWhite)
                .frame(maxWidth: .infinity, alignment: .leading)
            ZStack(alignment: .leadingFirstTextBaseline) {
                TextField("", text: $cost)
                    .keyboardType(.decimalPad)
                    .padding(.vertical, 13)
                    .padding(.horizontal, 16)
                    .placeholder(when: cost.isEmpty) {
                        Text("Enter")
                            .foregroundColor(Color.fzGray)
                            .padding(.leading, cost.isEmpty ? 16 : 8)
                    }
                    .padding(.leading, !cost.isEmpty ? 8 : 0)
                    .background(Color.fzWhite.opacity(0.15))
                    .cornerRadius(8)
                    .foregroundColor(Color.fzWhite)
                    .accentColor(Color.fzDarkRed)
                    .padding(.bottom, 20)
                    .font(Font.system(size: 13, weight: .regular))
                    .foregroundColor(Color.fzWhite)
                if !cost.isEmpty {
                    Text("$")
                        .padding(.leading, 15)
                        .font(Font.system(size: 13, weight: .regular))
                        .foregroundColor(Color.fzWhite)
                }
                
            }
        }
    }
}

#Preview {
    OtherExpenses(dismiss: .constant(true), updateData: {})
}
