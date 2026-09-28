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
        
    }
    
    
    func countAll() -> Int {
        still.union(flowing).filter { $0.y >= minY && $0.y <= maxY }.count
    }
    
    
}
