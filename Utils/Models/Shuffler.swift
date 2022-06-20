//
//  Shuffler.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 16/6/22.
//

import Foundation
import BigInt

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
    
    func modularArithmeticVersion(_ numberCards: Int, _ numberShuffles: Int, _ find: Int) -> Int {
        let numberCardsBI = BigInt(numberCards)
        let findBI = BigInt(find)
        var memory = [BigInt(1), BigInt(0)]
        instructions.reversed().forEach { instruction in
            switch instruction.type {
            case .cut:
                memory[1] = memory[1] + BigInt(instruction.value)
            case .increment:
                let exponent = Int(numberCardsBI - BigInt(2))
                let potencia = BigInt(instruction.value).power(exponent)
                let val = potencia.modulus(numberCardsBI)
                memory[0] *= val
                memory[1] *= val
            case .newStack:
                memory[0] = -memory[0]
                memory[1] = -memory[1] - 1
            }
            memory[0] = memory[0].modulus(numberCardsBI)
            memory[1] = memory[1].modulus(numberCardsBI)
        }
        let power = memory[0].power(numberShuffles).modulus(numberCardsBI)
        let item1 = power * findBI
        let item2 = memory[1] * (power + numberCardsBI)
        let item3 = memory[0].power(numberCards - 2).modulus(numberCardsBI)
        return Int((item1 + item2 * item3).modulus(numberCardsBI))

    }
    
}
