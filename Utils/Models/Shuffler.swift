//
//  Shuffler.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 16/6/22.
//

import Foundation
import BigInt

class Shuffler {
    
    
    
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
