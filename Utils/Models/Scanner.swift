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
