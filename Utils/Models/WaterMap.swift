//
//  WaterMap.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 11/4/22.
//

import Foundation

private class Position: Hashable {
    
    let x: Int
    let y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    func hash(into hasher: inout Hasher) { }
    
    static func == (lhs: Position, rhs: Position) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
    
}

private enum Action {
    case fall
    case scan
}

class WaterMap {
    
    fileprivate var clay: Set<Position> = Set()
    fileprivate var still: Set<Position> = Set()
    fileprivate var flowing: Set<Position> = Set()
    private var minX: Int
    private var minY: Int
    private var maxX: Int
    private var maxY: Int
    private var queue: [(Action, (x: Int, y: Int))] = []
    
    init(_ lines: [String]) {
        
        for line in lines {
            let items = line.components(separatedBy: ", ")
            let left = items[0].components(separatedBy: "=")
            let rigth = items[1].components(separatedBy: "=")[1].components(separatedBy: "..")
            if left[0] == "x" {
                for i in Int(rigth[0])!...Int(rigth[1])! {
                    clay.insert(Position(x: Int(left[1])!, y: i))
                }
            } else {
                for i in Int(rigth[0])!...Int(rigth[1])! {
                    clay.insert(Position(x: i, y: Int(left[1])!))
                }
            }
        }
        
        minX = clay.min { $0.x < $1.x }!.x
        minY = clay.min { $0.y < $1.y }!.y
        maxX = clay.max { $0.x < $1.x }!.x
        maxY = clay.max { $0.y < $1.y }!.y
        
    }
    
    func run(_ x: Int, _ y: Int) {
        queue.append((.fall, (x: x, y: y)))
        while !queue.isEmpty {
            let instruction = queue.removeFirst()
            switch instruction.0 {
            case .fall: fall(instruction.1.x, instruction.1.y)
            case .scan: scan(instruction.1.x, instruction.1.y)
            }
        }
        print("Done")
    }
    
    func countAll() -> Int {
        still.union(flowing).filter { $0.y >= minY && $0.y <= maxY }.count
    }
    
    func printS() {
        var waterMap: [[String]] = [[String]](repeating: [String](repeating: ".", count: maxX-minX+3), count: maxY+1)
        for cl in clay {
            waterMap[cl.y][cl.x-minX+1] = "#"
        }
        
        for st in still {
            waterMap[st.y][st.x-minX+1] = "~"
        }
        
        for fl in flowing {
            waterMap[fl.y][fl.x-minX+1] = "|"
        }
        
        let valu = waterMap.map { $0.joined() }
        valu.forEach { print($0) }
    }
    
    private func pile(_ x: Int, _ y: Int) -> Bool {
        clay.contains(Position(x: x, y: y)) || still.contains(Position(x: x, y: y))
    }
    
    private func stop(_ x: Int, _ y: Int) -> Bool {
        clay.contains(Position(x: x, y: y))
    }
    
    private func fall(_ x: Int, _ y: Int) {
        var y = y
        while y <= maxY && !pile(x, y+1) {
            flowing.insert(Position(x: x, y: y))
            y += 1
        }
        if y <= maxY {
            flowing.insert(Position(x: x, y: y))
            queue.append((.scan, (x: x, y: y)))
        }
    }
    
    private func scan(_ x: Int, _ y: Int) {
        var x0 = x
        while pile(x0, y + 1) && !stop(x0 - 1, y) {
            x0 -= 1
        }
        var x1 = x
        while pile(x1, y + 1) && !stop(x1 + 1, y) {
            x1 += 1
        }
        let stop0 = stop(x0 - 1, y)
        let stop1 = stop(x1 + 1, y)
        if stop0 && stop1 {
            for i in x0..<x1+1 {
                still.insert(Position(x: i, y: y))
            }
            queue.append((.scan, (x: x, y: y - 1)))
        } else {
            for i in x0..<x1+1 {
                flowing.insert(Position(x: i, y: y))
            }
            if !stop0 {
                queue.append((.fall, (x: x0, y: y)))
            }
            if !stop1 {
                queue.append((.fall, (x: x1, y: y)))
            }
        }
    }
    
}
