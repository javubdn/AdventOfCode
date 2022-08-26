//
//  Cup.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 25/8/22.
//

import Foundation

class Cup {
    
    let value: Int
    var next: Cup!
    
    init(value: Int) {
        self.value = value
    }
    
    func nextAsList(_ n: Int) -> [Cup] {
        var nextCup = next!
        var items = [nextCup]
        for _ in 1...n {
            nextCup = nextCup.next
            items.append(nextCup)
        }
        return items
    }
    
    func valueFromMe() -> String {
        var current = next!
        var result = ""
        while current.value != value {
            result += String(current.value)
            current = current.next
        }
        return result
    }
    
}

