//
//  Scanner.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 13/9/22.
//

import Foundation

class Scanner {
    
    let id: Int
    var beacons: [(Int, Int, Int)]
    
    init(id: Int, beacons: [(Int, Int, Int)]) {
        self.id = id
        self.beacons = beacons
    }
    
}
