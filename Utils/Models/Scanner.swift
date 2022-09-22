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
    
    func rotate() -> Beacon {
        Beacon(x, -z, y)
    }
    
    func invertAxis() -> Beacon {
        Beacon(y, z, x)
    }
    
    func flip() -> Beacon {
        Beacon(-x, -y, z)
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
        case 1: return Beacon(id: id, x: -y, y: x, z: z)
        case 2: return Beacon(id: id, x: -x, y: -y, z: z)
        case 3: return Beacon(id: id, x: y, y: -x, z: z)
        default: assertionFailure("Invalid rotation")
        }
        return Beacon(id: id, x: 0, y: 0, z: 0)
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
    
    convenience init(from input: String, firstBeaconId: Int) {
        var lines = input.components(separatedBy: .newlines)
        let scannerName = lines.removeFirst()
        let regex = try! NSRegularExpression(pattern: #"--- scanner ([0-9]+) ---"#)
        let matches = regex.matches(in: scannerName, options: [], range: NSRange(scannerName.startIndex..., in: scannerName))
        let match = matches.first!
        let id = Int(String(scannerName[Range(match.range(at: 1), in: scannerName)!]))!
        var beaconId = firstBeaconId
        let beacons = lines.map { item -> Beacon in
            let values = item.components(separatedBy: ",")
            let beacon = Beacon(id: beaconId, x: Int(values[0])!, y: Int(values[1])!, z: Int(values[2])!)
            beaconId += 1
            return beacon
        }.sorted()
        self.init(id: id, beacons: beacons)
    }
    
    func commonBeacons(with other: Scanner) -> [Beacon] {        
        var bestCombination: [Beacon] = []
        for scanner in other.combinations() {
            let commonBeacons = commonBeaconsNoRotation(with: scanner)
            if commonBeacons.count > bestCombination.count {
                bestCombination = commonBeacons
                if bestCombination.count >= 12 {
                    break
                }
            }
        }
        
        return bestCombination
    }
    func rotate() -> Scanner {
        Scanner(id: id, beacons: beacons.map { $0.rotate() })
    }
    
    func invertAxis() -> Scanner {
        Scanner(id: id, beacons: beacons.map { $0.invertAxis() })
    }
    
    func flip() -> Scanner {
        Scanner(id: id, beacons: beacons.map { $0.flip() })
    }
    
    func combinations() -> [Scanner] {
        var axis = [self]
        for _ in 0..<2 {
            axis.append(axis.last!.invertAxis())
        }
        
        axis = axis.flatMap { item -> [Scanner] in
            var rotations: [Scanner] = [item]
            for _ in 0..<3 {
                rotations.append(rotations.last!.rotate())
            }
            return rotations
        }
        
        let flips = axis.map { $0.flip() }
        let scanners = axis + flips
        scanners.forEach { $0.reference = self }
        return scanners
    }
    
}
