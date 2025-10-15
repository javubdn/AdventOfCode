//
//  Scanner.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 13/9/22.
//

import Foundation

class Scanner {
    func commonBeacons(with other: Scanner) -> (Int, Int, Int)? {
        for facing in 0..<6 {
        }
    }
    
    func commonBeaconsNoRotation(with other: Scanner) -> ((Int, Int, Int), Set<Beacon>)? {
        for currentBeacon in beacons {
            for otherBeacon in other.beacons {
            }
        }
        return nil
    }
    
    func face(_ facing: Int) -> Scanner {
        Scanner(id: id, beacons: Set(beacons.map { $0.face(facing) }))
    }
    
    func rotate(_ rotating: Int) -> Scanner {
        Scanner(id: id, beacons: Set(beacons.map { $0.rotate(rotating) }))
    }
    
}
