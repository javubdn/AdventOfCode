//
//  SnailFishNumber.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 6/9/22.
//

import Foundation

class SnailFishPair: SnailFishNumber {
    
    
    
    
    
    override func getValue() -> String {
        return "[\(leftString),\(rightString)]"
    }
    
    func copy() -> SnailFishPair {
        SnailFishPair(from: getValue())
    }
    
}
