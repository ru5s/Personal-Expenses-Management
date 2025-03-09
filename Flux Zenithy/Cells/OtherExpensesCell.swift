//
//  OtherExpensesCell.swift
//  Flux Zenithy
//
//  Created by Den on 01/04/24.
//

import SwiftUI

struct OtherExpensesCell: View {
    @State var name: String = ""
    @State var cost: String = ""
    @State var item: Item?
    @Binding var updateCell: Bool
    @State var updateData: () -> Void
    @State var changeData: Bool = false
    @Binding var allAmountBudget: Int
    var body: some View {
        VStack {
            NavigationLink(
                destination: OtherExpenses(item: item, dismiss: $changeData, updateData: {
                    updateData()
                    updateCell.toggle()
                }, buttonTitle: "Save", navigationTitle: "Edit other expenses"),
                isActive: $changeData,
                label: {EmptyView()})
            HStack {
                Text(name)
                    .font(Font.system(size: 17, weight: .regular))
                    .foregroundColor(Color.fzWhite)
                Spacer()
                
                Text("$\(Int(cost) ?? 0)")
                    .font(Font.system(size: 17, weight: .regular))
                    .foregroundColor(Color.fzGray)
            }
            .padding(.vertical, 10)
            Divider()
        }
        .background(Color.fzBlack)
        .onTapGesture {
            changeData.toggle()
        }
        .onAppear(){
            name = item?.name ?? ""
            cost = item?.cost ?? ""
        }
        .onChange(of: updateCell, perform: { _ in
            let lastNumber = Double(cost) ?? 0.0
            name = item?.name ?? ""
            cost = item?.cost ?? ""
            
            allAmountBudget -= Int(lastNumber)
            allAmountBudget += Int(cost) ?? 0
        })
    }
}

#Preview {
    PersonalBudget(model: PersonalBudgetViewModel(), tab: .constant(0))
}
