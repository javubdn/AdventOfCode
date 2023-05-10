//
//  LavaDrop.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 24/3/23.
//

import Foundation

class LavaDrop {
    
    let x: Int
    let y: Int
    let z: Int
    
    init(_ x: Int, _ y: Int, _ z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }
    
        ((x == other.x + 1 || x == other.x - 1) && y == other.y && z == other.z)
        || ((y == other.y + 1 || y == other.y - 1) && x == other.x && z == other.z)
        || ((z == other.z + 1 || z == other.z - 1) && x == other.x && y == other.y)
}

