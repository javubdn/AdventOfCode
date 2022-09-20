//
//  Scanner.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 13/9/22.
//

import Foundation

class Beacon {
    
    var id: Int
    var x: Int
    var y: Int
    var z: Int
    
    init(id: Int, x: Int, y: Int, z: Int) {
        self.id = id
        self.x = x
        self.y = y
        self.z = z
    }
    
    func rotate() -> Beacon {
        Beacon(id: id, x: x, y: -z, z: y)
    }
    
    func invertAxis() -> Beacon {
        Beacon(id: id, x: y, y: z, z: x)
    }
    
    func flip() -> Beacon {
        Beacon(id: id, x: -x, y: -y, z: z)
    }
    
    func substract(_ other: Beacon) -> (Int, Int, Int) {
        (x-other.x, y-other.y, z-other.z)
    }
    
    func substract(_ diff: (Int, Int, Int)) -> Beacon {
        Beacon(id: id, x: x-diff.0, y: y-diff.1, z: z-diff.2)
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

class Scanner {
    
    let id: Int
    var beacons: [Beacon]
    var position: (x: Int, y: Int, z: Int)?
    var reference: Scanner?
    
    init(id: Int, beacons: [Beacon]) {
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
    
    func rotate() -> Scanner {
        Scanner(id: id, beacons: beacons.map { $0.rotate() })
    }
    
    func invertAxis() -> Scanner {
        Scanner(id: id, beacons: beacons.map { $0.invertAxis() })
    }
    
    func flip() -> Scanner {
        let beacons = beacons.map { (-$0.0, -$0.1, $0.2) }
        return Scanner(id: id, beacons: beacons)
    }
    
}
