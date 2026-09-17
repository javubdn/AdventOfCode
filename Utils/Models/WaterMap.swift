//
//  WaterMap.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 11/4/22.
//

import Foundation

private struct ActionQueue: Hashable {
    let action: Action
    let x: Int
    let y: Int
}

private enum Action {
    case fall
    case scan
}

class WaterMap {
    
    
    init(_ lines: [String]) {
        
        
        minX = clay.min { $0.x < $1.x }!.x
        minY = clay.min { $0.y < $1.y }!.y
        maxX = clay.max { $0.x < $1.x }!.x
        maxY = clay.max { $0.y < $1.y }!.y
        
    }
    
    
    func countAll() -> Int {
        still.union(flowing).filter { $0.y >= minY && $0.y <= maxY }.count
    }
    
    func countStill() -> Int {
        still.filter { $0.y >= minY && $0.y <= maxY }.count
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
    
    private func fall(_ x: Int, _ y: Int) {
        var y = y
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
            queue.insert(ActionQueue(action: .scan, x: x, y: y - 1))
        } else {
            for i in x0..<x1+1 {
            }
            if !stop0 {
                queue.insert(ActionQueue(action: .fall, x: x0, y: y))
            }
            if !stop1 {
                queue.insert(ActionQueue(action: .fall, x: x1, y: y))
            }
        }
    }
    
}
