//
//  CalculatorEnterField.swift
//  Flux Zenithy
//
//  Created by Den on 02/04/24.
//

import SwiftUI

struct CalculatorEnterField: View {
    @Binding var data: CalculatorField
    @State var name: String = ""
    @State var number: String = ""
    @Binding var updateData: Bool
    @Binding var removeText: Bool
    @Binding var checkFielsText: Bool
    @Binding var activity: Bool
    let userDefault = UserDefaults()
    var body: some View {
        VStack {
            Text(name)
                .font(Font.system(size: 15, weight: .medium))
                .foregroundColor(Color.fzWhite)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                TextField("", text: $number)
                    .keyboardType(.decimalPad)
                    .padding(.vertical, 13)
                    .padding(.horizontal, 16)
                    .placeholder(when: number.isEmpty) {
                        Text("Enter")
                            .foregroundColor(Color.fzGray)
                            .padding(.leading, 16)
                    }
                    .background(Color.fzWhite.opacity(0.1))
                    .foregroundColor(Color.fzWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
        }
        .onChange(of: updateData, perform: { _ in
            change(number: Int(number) ?? 0, field: &data)
            number = String(data.number)
        })
        .onChange(of: removeText, perform: { _ in
            userDefault.setValue(0, forKey: name + "-")
            number = ""
        })
        .onChange(of: number, perform: { value in
            activity.toggle()
            data.number = Int(value) ?? 0
            if !number.isEmpty && Int(number) != nil {
                checkFielsText = true
            } else {
                checkFielsText = false
            }
        })
        .onAppear(){
            name = data.name
            if data.number == 0 {
                number = ""
            } else {
                number = String(data.number)
                checkFielsText = true
            }
        }
    }
    
    private func change(number: Int, field: inout CalculatorField) {
        field.number = number
        userDefault.setValue(number, forKey: field.name + "-")
    }
}

#Preview {
    CalculatorEnterField(data: .constant(.init(name: "Budget", number: 123)), updateData: .constant(false), removeText: .constant(false), checkFielsText: .constant(false), activity: .constant(true))
}
