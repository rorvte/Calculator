//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by yolanda yuan on 12/6/2017.
//  Copyright © 2017 yolanda yuan. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    mutating func addUnaryOperation (named symbol: String, _ operation: @escaping (Double) -> Double) {
        operations[symbol] = Operation.unaryOperation(operation)
    }
    
    private var accumulator: Double?
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
        case clear
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "cos": Operation.unaryOperation(cos),
        "sin": Operation.unaryOperation(sin),                                   
        "tan": Operation.unaryOperation(tan),
        "log": Operation.unaryOperation(log),
        "√": Operation.unaryOperation(sqrt),
        "±": Operation.unaryOperation({-$0}),
        "×": Operation.binaryOperation({$0 * $1}),
        "+": Operation.binaryOperation({$0 + $1}),
        "−": Operation.binaryOperation({$0 - $1}),
        "÷": Operation.binaryOperation({$0 / $1}),
        "=": Operation.equals,
        "c": Operation.clear
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            case .clear:
                accumulator = nil
                pendingBinaryOperation = nil
            }
            
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ Operand: Double) {
        accumulator = Operand
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
}
