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
        minY = 0
        maxX = clay.max { $0.x < $1.x }!.x
        maxY = clay.max { $0.y < $1.y }!.y
        
    }
}
