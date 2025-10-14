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
            for rotating in 0..<4 {
            }
        }
        return nil
    }
    
    func commonBeaconsNoRotation(with other: Scanner) -> ((Int, Int, Int), Set<Beacon>)? {
        for currentBeacon in beacons {
            for otherBeacon in other.beacons {
                let difference = otherBeacon.substract(currentBeacon)
                let displacedCoordenates = Set(other.beacons.map { $0.substract(difference) })
                if beacons.intersection(displacedCoordenates).count >= 12 {
                    return ((difference.0, difference.1, difference.2), displacedCoordenates)
                }
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
