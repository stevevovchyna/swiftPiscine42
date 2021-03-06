//
//  CalcModel.swift
//  Calculator
//
//  Created by Steve Vovchyna on 20.01.2020.
//  Copyright © 2020 Stepan VOVCHYNA. All rights reserved.
//

import Foundation

enum Operation {
    case clear(Int)
    case operation((Int, Int) -> (Int, Bool))
    case equals
}

enum Action {
    case add
    case substract
    case multiply
    case divide
    case clear
    case equal
}

class Calculator {
    
    private var sum: Int = 0
    private var currOperation: operationNow?
    
    var result: Int {
        get {
            return sum
        }
    }
    
    private struct operationNow {
        var with: (Int, Int) -> (Int, Bool)
        var operand1: Int
    }
    
    private var Actions: Dictionary<Action, Operation> = [
        .add : Operation.operation({ $0.addingReportingOverflow($1) }),
        .substract : Operation.operation({ $0.subtractingReportingOverflow($1) }),
        .multiply : Operation.operation({ $0.multipliedReportingOverflow(by: $1) }),
        .divide : Operation.operation({ if ($1 != 0) { return $0.dividedReportingOverflow(by: $1) } else { return (0, false) } }),
        .clear : Operation.clear(0),
        .equal : Operation.equals
    ]
    
    func setSum(number: Int) {
        sum = number
    }
    
    func performCalculations() {
        if currOperation != nil {
            sum = currOperation!.with(currOperation!.operand1, sum).0
            currOperation = nil
        }
    }
    
    func calculate(action: Action) {
        if let operation = Actions[action] {
            switch operation {
            case .clear(let number):
                sum = number
                performCalculations()
            case .operation(let action):
                performCalculations()
                currOperation = operationNow(with: action, operand1: sum)
            case .equals:
                performCalculations()
            }
        }
    }
}
