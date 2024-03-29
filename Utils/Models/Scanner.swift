//
//  Scanner.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 13/9/22.
//

import Foundation

class Beacon {
    
    var x: Int
    var y: Int
    var z: Int
    
    init(_ x: Int, _ y: Int, _ z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    func substract(_ other: Beacon) -> (Int, Int, Int) {
        (x-other.x, y-other.y, z-other.z)
    }
    
    func substract(_ diff: (Int, Int, Int)) -> Beacon {
        Beacon(x-diff.0, y-diff.1, z-diff.2)
    }
    
    func face(_ facing: Int) -> Beacon {
        switch facing {
        case 0: return self
        case 1: return Beacon(x, -y, -z)
        case 2: return Beacon(x, -z, y)
        case 3: return Beacon(-y, -z, x)
        case 4: return Beacon(y, -z, -x)
        case 5: return Beacon(-x, -z, -y)
        default: assertionFailure("Invalid facing")
        }
        return Beacon(0, 0, 0)
    }
    
    func rotate(_ rotating: Int) -> Beacon {
        switch rotating {
        case 0: return self
        case 1: return Beacon(-y, x, z)
        case 2: return Beacon(-x, -y, z)
        case 3: return Beacon(y, -x, z)
        default: assertionFailure("Invalid rotation")
        }
        return Beacon(0, 0, 0)
    }
    
}

extension Beacon: Equatable {
    
    static func == (lhs: Beacon, rhs: Beacon) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
    
}

extension Beacon: Comparable {
    
    static func < (lhs: Beacon, rhs: Beacon) -> Bool {
        lhs.x < rhs.x || (lhs.x == rhs.x && lhs.y < rhs.y) || (lhs.x == rhs.x && lhs.y == rhs.y && lhs.z < rhs.z)
    }
    
}

extension Beacon: Hashable {
    func hash(into hasher: inout Hasher) { }
}

class Scanner {
    
    let id: Int
    var beacons: Set<Beacon>
    var position: (x: Int, y: Int, z: Int)?
    var reference: Scanner?
    
    init(id: Int, beacons: Set<Beacon>) {
        self.id = id
        self.beacons = beacons
    }
    
    convenience init(from input: String) {
        var lines = input.components(separatedBy: .newlines)
        let scannerName = lines.removeFirst()
        let regex = try! NSRegularExpression(pattern: #"--- scanner ([0-9]+) ---"#)
        let matches = regex.matches(in: scannerName, options: [], range: NSRange(scannerName.startIndex..., in: scannerName))
        let match = matches.first!
        let id = Int(String(scannerName[Range(match.range(at: 1), in: scannerName)!]))!
        let beacons = lines.map { item -> Beacon in
            let values = item.components(separatedBy: ",")
            let beacon = Beacon(Int(values[0])!, Int(values[1])!, Int(values[2])!)
            return beacon
        }.sorted()
        self.init(id: id, beacons: Set(beacons))
    }
    
    func commonBeacons(with other: Scanner) -> (Int, Int, Int)? {
        for facing in 0..<6 {
            for rotating in 0..<4 {
                let scanner = other.face(facing).rotate(rotating)
                if let (position, newBeacons) = commonBeaconsNoRotation(with: scanner) {
                    beacons.formUnion(newBeacons)
                    return position
                }
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
