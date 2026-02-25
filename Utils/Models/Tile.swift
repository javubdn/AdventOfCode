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
        return found
    }
    
}
