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

class Scanner {
    
    let id: Int
    var beacons: [Beacon]
    var position: (x: Int, y: Int, z: Int)?
    var reference: Scanner?
    
    init(id: Int, beacons: [Beacon]) {
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
        let beacons = lines.map { item -> (Int, Int, Int) in
            let values = item.components(separatedBy: ",")
            return (Int(values[0])!, Int(values[1])!, Int(values[2])!)
        }
        self.init(id: id, beacons: beacons)
    }
    
    func rotate() -> Scanner {
        let beacons = beacons.map { ($0.0, -$0.2, $0.1) }
        return Scanner(id: id, beacons: beacons)
    }
    
    func invertAxis() -> Scanner {
        let beacons = beacons.map { ($0.1, $0.2, $0.0) }
        return Scanner(id: id, beacons: beacons)
    }
    
    func flip() -> Scanner {
        let beacons = beacons.map { (-$0.0, -$0.1, $0.2) }
        return Scanner(id: id, beacons: beacons)
    }
    
}
