//
//  RebootStep.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 6/10/22.
//

import Foundation

class RebootStep {
    
    let on: Bool
    let minX: Int
    let maxX: Int
    let minY: Int
    let maxY: Int
    let minZ: Int
    let maxZ: Int
    
    init(_ on: Bool, _ minX: Int, _ maxX: Int, _ minY: Int, _ maxY: Int, _ minZ: Int, _ maxZ: Int) {
        self.on = on
        self.minX = minX
        self.maxX = maxX
        self.minY = minY
        self.maxY = maxY
        self.minZ = minZ
        self.maxZ = maxZ
    }
    
}
