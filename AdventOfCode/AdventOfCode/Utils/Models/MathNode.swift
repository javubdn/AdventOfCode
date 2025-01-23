//
//  MathNode.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 14/7/22.
//

import Foundation

class MathNode {
    
    static func create(from entry: String) -> MathNode {
        guard entry.count > 1 else {
            return MathValue(value: Int(String(entry[0]))!)
        }
        let input = entry.replacingOccurrences(of: " ", with: "")
        let operandRight: MathNode
        var index = input.count-2
        if input.last! == ")" {
            var parentesisCount = 1
            while parentesisCount > 0 {
                parentesisCount += input[index] == ")" ? 1 : input[index] == "(" ? -1 : 0
                index -= 1
            }
            if index == -1 {
                return MathNode.create(from: String(input[(index+2)..<input.count-1]))
            }
            operandRight = MathNode.create(from: String(input[(index+2)..<input.count-1]))
        } else {
            operandRight = MathValue(value: Int(String(input.last!))!)
        }
        let operand: MathOp = input[index] == "+" ? .sum : .mul
        let operandLeft = MathNode.create(from: String(input[0..<index]))
        return MathOperation(operation: operand, firstOperand: operandLeft, secondOperand: operandRight)
    }
    
    static func createAdvance(from entry: String) -> MathNode {
        guard entry.count > 1 else {
            return MathValue(value: Int(String(entry[0]))!)
        }
        let input = entry.replacingOccurrences(of: " ", with: "")
        var operandNodes: [MathNode] = []
        var operators: [MathOp] = []
        var index = 0
        
        while index < input.count {
            if input[index] == "(" {
                var parentesisCount = 1
                var index2 = index+1
                while parentesisCount > 0 {
                    parentesisCount += input[index2] == ")" ? -1 : input[index2] == "(" ? 1 : 0
                    index2 += 1
                }
                operandNodes.append(MathNode.createAdvance(from: String(input[index+1..<index2-1])))
                index = index2
                continue
            } else if input[index] == "+" {
                operators.append(.sum)
            } else if input[index] == "*" {
                operators.append(.mul)
            } else {
                operandNodes.append(MathNode.createAdvance(from: String(input[index])))
            }
            index += 1
        }
        
        var indexOperator = 0
        while indexOperator < operators.count {
            if operators[indexOperator] == .sum {
                let operation = MathOperation(operation: .sum, firstOperand: operandNodes[indexOperator], secondOperand: operandNodes[indexOperator+1])
                operandNodes[indexOperator] = operation
                operandNodes.remove(at: indexOperator+1)
                operators.remove(at: indexOperator)
            } else {
                indexOperator += 1
            }
        }
        var finalOperation = operandNodes.removeFirst()
        while !operandNodes.isEmpty {
            finalOperation = MathOperation(operation: .mul, firstOperand: finalOperation, secondOperand: operandNodes.removeFirst())
        }
        return finalOperation
    }
    
    func calculate() -> Int {
        0
    }
    
}

enum MathOp {
    case sum
    case mul
}

class MathOperation: MathNode {
    
    let operation: MathOp
    let firstOperand: MathNode
    let secondOperand: MathNode
    
    init(operation: MathOp, firstOperand: MathNode, secondOperand: MathNode) {
        self.operation = operation
        self.firstOperand = firstOperand
        self.secondOperand = secondOperand
    }
    
    override func calculate() -> Int {
        let firstValue = firstOperand.calculate()
        let secondValue = secondOperand.calculate()
        let result = operation == .sum ? firstValue + secondValue : firstValue * secondValue
        return result
    }
    
}

class MathValue: MathNode {
    
    let value: Int
    
    init(value: Int) {
        self.value = value
    }
    
    override func calculate() -> Int {
        value
    }
    
}
