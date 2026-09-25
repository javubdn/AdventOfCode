//
//  WaterMap.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 11/4/22.
//

import Foundation

private struct ActionQueue: Hashable {
    let action: Action
    let x: Int
    let y: Int
}

private enum Action {
    case fall
    case scan
}

class WaterMap {
    
    
    init(_ lines: [String]) {
        
        
        minY = clay.min { $0.y < $1.y }!.y
        maxX = clay.max { $0.x < $1.x }!.x
        maxY = clay.max { $0.y < $1.y }!.y
        
    }
    
    
    func countAll() -> Int {
        still.union(flowing).filter { $0.y >= minY && $0.y <= maxY }.count
    }
    
    
    
    private func fall(_ x: Int, _ y: Int) {
    }
    
    
}
