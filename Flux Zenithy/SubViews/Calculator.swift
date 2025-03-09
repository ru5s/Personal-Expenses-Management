//
//  Calculator.swift
//  Flux Zenithy
//
//  Created by Den on 29/03/24.
//

import SwiftUI
import Combine

struct Calculator: View {
    @ObservedObject var model: CalculatorViewModel
    @Binding var dismiss: Bool
    @Binding var activeTab: Int
    @State var updateData: Bool = false
    @State var unDisbableButton: Bool = false
    @State var checkFielsText: Bool = false
    
    @State var checkFielsTextBudget: Bool = false
    @State var checkFielsTextHousing: Bool = false
    @State var checkFielsTextFood: Bool = false
    @State var checkFielsTextClothes: Bool = false
    @State var checkFielsTextTransport: Bool = false
    @State var checkFielsTextEntertainments: Bool = false
    @State var checkFielsTextOthersExpenses: Bool = false
    
    @State var activity: Bool = false
    
    @State var alertCalculate: Bool = false
    @State private var alertBudget = 0
    @State private var alertAllOthersAmount = 0
    
    @State private var openResult: Bool = false
    
    var body: some View {
        NavigationView{
            ZStack {
                linkToResult
                VStack {
                    header
                    ScrollView(showsIndicators: false) {
                        fields
                            .padding(.bottom, 40)
                    }
                    .padding(.bottom, 50)
                }
                .padding(.horizontal, 16)
                VStack {
                    alertField
                    customButtonToCalculate
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, 20)
                .padding(.horizontal, 16)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .onChange(of: activity, perform: { _ in
                //check that all field was filled by numbers
                if checkFielsTextBudget &&
                    checkFielsTextHousing &&
                    checkFielsTextFood &&
                    checkFielsTextClothes &&
                    checkFielsTextTransport &&
                    checkFielsTextEntertainments &&
                    checkFielsTextOthersExpenses {
                    unDisbableButton = true
                } else {
                    unDisbableButton = false
                }
            })
            .navigationBarBackButtonHidden()
        }
        .onAppear() {
            //Combine method to remove all data
            model.clearAllBoards()
            //check the signal from Combine
            if model.settingsSignal {
                model.eraseText.toggle()
                model.settingsSignal = false
            }
            //swith keyboard if that was opened
            #if canImport(UIKit)
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            #endif
        }
        
    }
    private var linkToResult: some View {
        NavigationLink(destination: 
                        ResultOfCalculation(data: $model.allFields, dismiss: $openResult)
            .navigationBarHidden(true),
                       isActive: $openResult,
                       label: {EmptyView()})
    }
    private var header: some View {
        //title
        VStack {
            RoundedRectangle(cornerRadius: 50)
                .frame(width: 36, height: 5, alignment: .center)
                .foregroundColor(Color.fzGray.opacity(0.5))
                .padding(.top, 10)
            Text("Personal budget calculator")
                .font(Font.system(size: 17, weight: .semibold))
                .foregroundColor(Color.fzWhite)
                .padding(.vertical, 20)
        }
    }
    
    private var customButtonToCalculate: some View {
        //main button that calculate all filled data
        VStack {
            CustomButton(title: "Calculate", state: $unDisbableButton, completion: {
                calculateData()
            })
            .shadow(color: UIDevice.current.userInterfaceIdiom == .pad ? Color.clear : Color.fzBlack, radius: 10, x: 0.0, y: 0.0)
        }
    }
    
    private func calculateData() {
        let budget = model.allFields.budget.number
        let housing = model.allFields.housing.number
        let food = model.allFields.food.number
        let clothes = model.allFields.clothes.number
        let transport = model.allFields.transport.number
        let entertainment = model.allFields.entertainments.number
        let others = model.allFields.otherExpenses.number
        
        //calculate how much user want spend
        let sum = (housing + food + clothes + transport + entertainment + others)
        alertBudget = budget
        alertAllOthersAmount = sum
        //check that budget always will more than want spent
        if budget < sum {
            withAnimation {
                alertCalculate = true
                
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                withAnimation {
                    alertCalculate = false
                }
            })
        } else {
            openResult.toggle()
        }
        updateData.toggle()
    }
    
    private var fields: some View {
        VStack(spacing: 20) {
            //All fields will fill with summ by category
            CalculatorEnterField(
                data: $model.allFields.budget,
                updateData: $updateData, removeText: $model.eraseText, checkFielsText: $checkFielsTextBudget, activity: $activity)
            CalculatorEnterField(
                data: $model.allFields.housing,
                updateData: $updateData, removeText: $model.eraseText, checkFielsText: $checkFielsTextHousing, activity: $activity)
            CalculatorEnterField(
                data: $model.allFields.food,
                updateData: $updateData, removeText: $model.eraseText, checkFielsText: $checkFielsTextFood, activity: $activity)
            CalculatorEnterField(
                data: $model.allFields.clothes,
                updateData: $updateData, removeText: $model.eraseText, checkFielsText: $checkFielsTextClothes, activity: $activity)
            CalculatorEnterField(
                data: $model.allFields.transport,
                updateData: $updateData, removeText: $model.eraseText, checkFielsText: $checkFielsTextTransport, activity: $activity)
            CalculatorEnterField(
                data: $model.allFields.entertainments,
                updateData: $updateData, removeText: $model.eraseText, checkFielsText: $checkFielsTextEntertainments, activity: $activity)
            CalculatorEnterField(
                data: $model.allFields.otherExpenses,
                updateData: $updateData, removeText: $model.eraseText, checkFielsText: $checkFielsTextOthersExpenses, activity: $activity)
            
            //button than clear all fields
            Button(action: {
                model.eraseText.toggle()
            }, label: {
                HStack {
                    Text("Clear all fields")
                        .font(Font.system(size: 17, weight: .regular))
                        .foregroundColor(Color.fzGray)
                    Image(systemName: "trash")
                        .font(Font.system(size: 15, weight: .regular))
                        .foregroundColor(Color.fzGray)
                }
                
            })
        }
    }
    
    private var alertField: some View {
        VStack {
            Text("The budget should be more than the planned expenses.\n Budget: $\(alertBudget)\n Amount of costs: $\(alertAllOthersAmount)")
                .font(Font.system(size: 19, weight: .regular))
                .foregroundColor(Color.fzWhite)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.fzGray)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .offset(y: !alertCalculate ? 50 : 0)
                .opacity(alertCalculate ? 1.0 : 0.0)
                .animation(.bouncy)
        }
    }
}

#Preview {
    Calculator(model: CalculatorViewModel(), dismiss: .constant(true), activeTab: .constant(0))
}
