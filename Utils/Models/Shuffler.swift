//
//  Shuffler.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 16/6/22.
//

import Foundation

class Shuffler {
    
    enum ShuffleType {
        case newStack
        case cut
        case increment
    }
    
    struct ShuffleInstruction {
        let type: ShuffleType
        let value: Int
    }
    
    let instructions: [ShuffleInstruction]
    
    
    init(instructions: [ShuffleInstruction]) {
        self.instructions = instructions
    }
    
    convenience init(from input: [String]) {
        var instructions: [ShuffleInstruction] = []
        input.forEach { line in
            let items = line.components(separatedBy: .whitespaces)
            if items[0] == "cut" {
                instructions.append(ShuffleInstruction(type: .cut, value: Int(items[1])!))
            } else if items[1] == "into" {
                instructions.append(ShuffleInstruction(type: .newStack, value: 0))
            } else {
                instructions.append(ShuffleInstruction(type: .increment, value: Int(items[3])!))
            }
        }
        self.init(instructions: instructions)
    }
    
    func shuffle(_ numberCards: Int) -> [Int] {
        var cards = Array(0..<numberCards)
        for instruction in instructions {
            switch instruction.type {
            case .newStack: cards = cards.reversed()
            case .cut:
                if instruction.value > 0 {
                    cards = Array(cards[instruction.value...]) + Array(cards[0..<instruction.value])
                } else {
                    cards = Array(cards[(cards.count+instruction.value)...]) + Array(cards[0..<(cards.count+instruction.value)])
                }
            case .increment:
                var cards2 = cards
                var position = 0
                cards.forEach { card in
                    cards2[position] = card
                    position = (position + instruction.value) % cards2.count
                }
                cards = cards2
            }
        }
        return cards
    }
    
}
