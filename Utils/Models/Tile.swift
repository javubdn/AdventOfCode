//
//  Tile.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 2/8/22.
//

import Foundation


class Tile {

    
    
    
    
    
    
    
    func maskIfFound(_ mask: [(Int, Int)]) -> Bool {
        let maxHeight = mask.max { $0.0 < $1.0 }!.0
        Array(0..<(piece.count - maxHeight)).forEach { y in
            Array(0..<(piece.count - maxWidth)).forEach { x in
                let lookingAt = (y, x)
                let actualSpots = mask.map { ($0.0 + lookingAt.0, $0.1 + lookingAt.1) }
                let matches = actualSpots.filter { piece[$0.0][$0.1] == "#" }.count
                if matches == mask.count {
                    found = true
                    actualSpots.forEach { piece[$0.0][$0.1] = "0" }
                }
            }
        }
        return found
    }
    
}
