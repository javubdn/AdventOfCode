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
        let item3 = memory[0].power(numberCards - 2).modulus(numberCardsBI)
        return Int((item1 + item2 * item3).modulus(numberCardsBI))
    }
    
}
