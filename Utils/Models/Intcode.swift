//
//  Intcode.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 12/5/22.
//

import Foundation

enum Mode {
    case full
    case partial
}

class Intcode {
    
    var instructions: [Int]
    var ip = 0
    var input: [Int] = []
    var output: [Int] = []
    var completed = false
    
    init(instructions: [Int]) {
        self.instructions = instructions
    }
    
    func addInput(_ input: [Int]) {
        self.input.append(contentsOf: input)
    }
    
    func execute(_ mode: Mode) {
        while ip < instructions.count {
            let instruction = instructions[ip]
            let opcode = instruction % 100
            let firstParamReference = instruction/100 % 10 == 0
            let secondParamReference = instruction/1000 % 10 == 0
            switch opcode {
            case 1:
                instructions[instructions[ip+3]] = (firstParamReference ? instructions[instructions[ip+1]] : instructions[ip+1])
                + (secondParamReference ? instructions[instructions[ip+2]] : instructions[ip+2])
                ip += 4
            case 2:
                let firstParam = firstParamReference ? instructions[instructions[ip+1]] : instructions[ip+1]
                let secondParam = secondParamReference ? instructions[instructions[ip+2]] : instructions[ip+2]
                instructions[instructions[ip+3]] = firstParam * secondParam
                ip += 4
            case 3:
                if !input.isEmpty {
                    instructions[instructions[ip+1]] = input.removeFirst()
                }
                ip += 2
            case 4:
                output.append(instructions[instructions[ip+1]])
                ip += 2
                if mode == .partial {
                    return
                }
            case 5:
                if (firstParamReference ? instructions[instructions[ip+1]] : instructions[ip+1]) != 0 {
                    ip = secondParamReference ? instructions[instructions[ip+2]] : instructions[ip+2]
                } else {
                    ip += 3
                }
            case 6:
                if (firstParamReference ? instructions[instructions[ip+1]] : instructions[ip+1]) == 0 {
                    ip = secondParamReference ? instructions[instructions[ip+2]] : instructions[ip+2]
                } else {
                    ip += 3
                }
            case 7:
                let firstValue = firstParamReference ? instructions[instructions[ip+1]] : instructions[ip+1]
                let secondValue = secondParamReference ? instructions[instructions[ip+2]] : instructions[ip+2]
                instructions[instructions[ip+3]] = firstValue < secondValue ? 1 : 0
                ip += 4
            case 8:
                let firstValue = firstParamReference ? instructions[instructions[ip+1]] : instructions[ip+1]
                let secondValue = secondParamReference ? instructions[instructions[ip+2]] : instructions[ip+2]
                instructions[instructions[ip+3]] = firstValue == secondValue ? 1 : 0
                ip += 4
            case 99:
                completed = true
                return
            default: break
            }
        }
    }
    
}
