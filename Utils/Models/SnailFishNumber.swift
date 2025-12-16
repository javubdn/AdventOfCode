//
//  SnailFishNumber.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 6/9/22.
//

import Foundation

class SnailFishPair: SnailFishNumber {
    
    
    func explode() {
    }
    
    private func addValue(to side: SnailSide) {
        var current: SnailFishNumber? = self
        if current != nil {
            while current is SnailFishPair {
            }
        }
    }
    
    override func magnitude() -> Int {
        left.magnitude() * 3 + right.magnitude() * 2
    }
    
    override func getValue() -> String {
        let leftString = left.getValue()
        let rightString = right.getValue()
        return "[\(leftString),\(rightString)]"
    }
    
    func copy() -> SnailFishPair {
        SnailFishPair(from: getValue())
    }
    
}
