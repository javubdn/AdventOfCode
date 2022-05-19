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
    var relativeBase = 0
    
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
            switch opcode {
            case 1:
                instructions[getParam(3, read: false)] = getParam(1, read: true) + getParam(2, read: true)
                ip += 4
            case 2:
                instructions[getParam(3, read: false)] = getParam(1, read: true) * getParam(2, read: true)
                ip += 4
            case 3:
                if !input.isEmpty {
                    instructions[getParam(1, read: false)] = input.removeFirst()
                }
                ip += 2
            case 4:
                output.append(getParam(1, read: true))
                ip += 2
                if mode == .partial {
                    return
                }
            case 5:
                if getParam(1, read: true) != 0 {
                    ip = getParam(2, read: true)
                } else {
                    ip += 3
                }
            case 6:
                if getParam(1, read: true) == 0 {
                    ip = getParam(2, read: true)
                } else {
                    ip += 3
                }
            case 7:
                instructions[getParam(3, read: false)] = getParam(1, read: true) < getParam(2, read: true) ? 1 : 0
                ip += 4
            case 8:
                instructions[getParam(3, read: false)] = getParam(1, read: true) == getParam(2, read: true) ? 1 : 0
                ip += 4
            case 9:
                relativeBase += getParam(1, read: true)
                ip += 2
            case 99:
                completed = true
                return
            default: break
            }
        }
    }
    
    private func getParam(_ num: Int, read: Bool) -> Int {
        let instruction = instructions[ip]
        let mode = num == 1 ? instruction/100 % 10 : num == 2 ? instruction/1000 % 10 : instruction/10000 % 10
        return read ? instructions[getInstructionAddress(num, mode)] : getInstructionAddress(num, mode)
    }
    
    private func getInstructionAddress(_ param: Int, _ paramMode: Int) -> Int {
        var position = 0
        switch paramMode {
        case 0: position = instructions[ip+param]
        case 1: position = ip+param
        case 2: position = relativeBase+instructions[ip+param]
        default: break
        }
        if position >= instructions.count {
            instructions += [Int](repeating: 0, count: position-instructions.count+1)
        }
        return position
    }
    
}
