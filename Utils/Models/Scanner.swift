//
//  Scanner.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 13/9/22.
//

import Foundation

class Scanner {
    }
    
    func commonBeaconsNoRotation(with other: Scanner) -> ((Int, Int, Int), Set<Beacon>)? {
        return nil
    }
    
    func face(_ facing: Int) -> Scanner {
        Scanner(id: id, beacons: Set(beacons.map { $0.face(facing) }))
    }
    
    func rotate(_ rotating: Int) -> Scanner {
        Scanner(id: id, beacons: Set(beacons.map { $0.rotate(rotating) }))
    }
    
}
