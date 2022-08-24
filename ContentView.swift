//
//  ContentView.swift
//  calculatorTest1
//
//  Created by James  on 05/05/2022.
//

import SwiftUI

struct ContentView: View {
    @State var currentState = appendingNumbers()
    
    var presentedStr: String {
        return String(format: "%.2f", arguments: [currentState.userNumber])
    }
    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 25){
                Spacer()
                VStack(alignment: .leading, spacing: 25) {
                    ZStack {
                Text(presentedStr)
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .font(.largeTitle)
                    .animation(.spring())
                    .frame(maxWidth: 360, alignment: .leading)
                    .padding()
                    }
                }
                HStack{
                    Spacer()
                    buttonOperatorsView(color: .red, action: .clear, operatorViewState: $currentState)
                        .padding(.trailing, 180)
                    buttonOperatorsView(color: .green, action: .equal, operatorViewState: $currentState);
                    Spacer()
                }
                HStack{
                    Spacer()
                    ForEach(7..<10) { i in
                        buttonNumView(num: Double(i), width: 70, buttonViewState: $currentState)
                        Spacer()
                    }
                    buttonOperatorsView(color: .orange, action: .multiply, operatorViewState: $currentState); Spacer()
                }
                HStack{
                    Spacer()
                    ForEach(4..<7) { i in
                        buttonNumView(num: Double(i), width: 70, buttonViewState: $currentState)
                        Spacer()
                    }
                    buttonOperatorsView(color: .orange ,action: .minus, operatorViewState: $currentState); Spacer()
                }
                HStack{
                    Spacer()
                    ForEach(1..<4) { i in
                        buttonNumView(num: Double(i), width: 70, buttonViewState: $currentState)
                        Spacer()
                    }
                    buttonOperatorsView(color: .orange, action: .add, operatorViewState: $currentState); Spacer()
                }
                HStack{
                    Spacer()
                    buttonNumView(num: 0, width: 160, buttonViewState: $currentState); Spacer()
                    buttonNumView(num: .pi, width: 70, buttonViewState: $currentState); Spacer()
                    buttonOperatorsView(color: .orange, action: .divide, operatorViewState: $currentState)
                    Spacer()
                }
            }
            .padding()
            .background(Color("kMainbg"))
        }
    }
}

struct buttonNumView: View {
    let num: Double;  let width: Double
    var numAsString: String {
        if (num == .pi){
            return "π"
        }
        return String(Int(num))
    }
    @Binding var buttonViewState: appendingNumbers
    var body: some View {
        Text(numAsString)
            .font(.title)
            .fontWeight(.heavy)
            .foregroundColor(.black)
            .frame(width: width, height: 70)
            .background(.thinMaterial)
            .background(Color("light"))
            .cornerRadius(20)
            .shadow(radius: 10, x: 0, y: 4)
            .onTapGesture {
                self.buttonViewState.appending(number: self.num)
            }
    }
}
struct appendingNumbers {
    var userNumber: Double = 0
    var filedNum: Double?
    var filedOperator: buttonOperatorsView.Operator?
    
   mutating func appending(number: Double){
        if (number.truncatingRemainder(dividingBy: 1) == 0 && userNumber.truncatingRemainder(dividingBy: 1) == 0) {
            userNumber = userNumber * 10 + number
        } else {
            userNumber = number
        }
    }
}

/*struct buttonOperatorsView: View {
    
    enum Operator {
        case equal, add, minus, divide, multiply, clear
        
        func image() -> Image {
            switch self {
            case .equal:
                return Image(systemName: "equal")
            case .add:
                return Image(systemName: "plus")
            case .minus:
                return Image(systemName: "minus")
            case .divide:
                return Image(systemName: "divide")
            case .multiply:
                return Image(systemName: "multiply")
            case .clear:
                return Image(systemName: "c.circle")
            }
        }*/
        
        func calculation(value1: Double, value2: Double) -> Double? {
            
            switch self {
            case .add:
                return value1 + value2
            case .minus:
                return value1 - value2
            case .divide:
                return value1 / value2
            case .multiply:
                return value1 * value2
            default:
                return nil
            }
        }
    }
    
    let color: Color
    let action: Operator
    @Binding var operatorViewState: appendingNumbers
    
    var body: some View {
        action.image()
            .frame(width: 70, height: 70)
            .foregroundColor(.white)
            .background(color)
            .cornerRadius(20)
            .shadow(radius: 10, x: 0, y: 5)
            .onTapGesture {
                self.operatorUsed()
            }
    }
    
    func operatorUsed() {
        switch action {
        case .equal:
            guard let filedOperator = operatorViewState.filedOperator
            else{
                return
            }
            guard let filedNum = operatorViewState.filedNum
            else{
                return
            }
            guard let calculationResult = filedOperator.calculation(value1: filedNum, value2: operatorViewState.userNumber) else {
                return
            }

            operatorViewState.userNumber = calculationResult
            operatorViewState.filedNum = nil
            operatorViewState.filedOperator = nil
            break
        case .clear:
            operatorViewState.userNumber = 0
            operatorViewState.filedNum = nil
            operatorViewState.filedOperator = nil
            
        default:
            operatorViewState.filedNum = operatorViewState.userNumber
            operatorViewState.userNumber = 0
            operatorViewState.filedOperator = action
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

