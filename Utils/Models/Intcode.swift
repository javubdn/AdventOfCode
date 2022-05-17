//
//  Intcode.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 12/5/22.
//

import Foundation

class Intcode {
    
    static func execute(_ instructions: [Int], input: [Int]) -> (Int, [Int]) {
        var instructions = instructions
        var output: [Int] = []
        var index = 0
        var indexInput = 0
        while index < instructions.count {
            let instruction = instructions[index]
            let opcode = instruction % 100
            let firstParamReference = instruction/100 % 10 == 0
            let secondParamReference = instruction/1000 % 10 == 0
            switch opcode {
            case 1:
                instructions[instructions[index+3]] = (firstParamReference ? instructions[instructions[index+1]] : instructions[index+1])
                + (secondParamReference ? instructions[instructions[index+2]] : instructions[index+2])
                index += 4
            case 2:
                let firstParam = firstParamReference ? instructions[instructions[index+1]] : instructions[index+1]
                let secondParam = secondParamReference ? instructions[instructions[index+2]] : instructions[index+2]
                instructions[instructions[index+3]] = firstParam * secondParam
                index += 4
            case 3:
                if indexInput < input.count {
                    instructions[instructions[index+1]] = input[indexInput]
                    indexInput += 1
                }
                index += 2
            case 4:
                output.append(instructions[instructions[index+1]])
                index += 2
            case 5:
                if (firstParamReference ? instructions[instructions[index+1]] : instructions[index+1]) != 0 {
                    index = secondParamReference ? instructions[instructions[index+2]] : instructions[index+2]
                } else {
                    index += 3
                }
            case 6:
                if (firstParamReference ? instructions[instructions[index+1]] : instructions[index+1]) == 0 {
                    index = secondParamReference ? instructions[instructions[index+2]] : instructions[index+2]
                } else {
                    index += 3
                }
            case 7:
                let firstValue = firstParamReference ? instructions[instructions[index+1]] : instructions[index+1]
                let secondValue = secondParamReference ? instructions[instructions[index+2]] : instructions[index+2]
                instructions[instructions[index+3]] = firstValue < secondValue ? 1 : 0
                index += 4
            case 8:
                let firstValue = firstParamReference ? instructions[instructions[index+1]] : instructions[index+1]
                let secondValue = secondParamReference ? instructions[instructions[index+2]] : instructions[index+2]
                instructions[instructions[index+3]] = firstValue == secondValue ? 1 : 0
                index += 4
            case 99: return (instructions[0], output)
            default: break
            }
        }
        return (instructions[0], output)
    }
    
}
