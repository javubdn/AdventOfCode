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
                if input[index] == ")" {
                    parentesisCount += 1
                } else if input[index] == "(" {
                    parentesisCount -= 1
                }
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
    
    func calculate() -> Int {
        0
    }
    
}

