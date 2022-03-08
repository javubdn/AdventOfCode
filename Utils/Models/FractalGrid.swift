//
//  FractalGrid.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 4/3/22.
//

import Foundation

class FractalGrid {
    private var grid: [String]
    lazy var size: Int = { grid.count }()
    
    init(value: String) {
        self.grid = value.components(separatedBy: "/")
    }
    
    func stringValue() -> String {
        grid.joined(separator: "/")
    }
    
    func rotate() -> FractalGrid {
        FractalGrid(value: Array(0..<grid.count).map { row in
            Array(0..<grid.count).map { col in
                String(grid[col][(grid.count) - 1 - row])
            }.joined()
        }.joined(separator: "/"))
    }
    
    func flip() -> FractalGrid {
        FractalGrid(value: grid.map { String($0.reversed()) }.joined(separator: "/"))
    }
    
    func combinations() -> [FractalGrid] {
        var rotations = [self]
        for _ in 0..<3 {
            rotations.append(rotations.last!.rotate())
        }
        let flips = rotations.map { $0.flip() }
        return rotations + flips
    }
    
    private func fractalsOfSize(_ n: Int) -> [FractalGrid] {
        grid.chunked(into: n).flatMap { chunk -> [String] in
            let chunked = chunk.map { $0.chunked(into: n) }
            return Array(0...chunk[0].count/n-1).map { x in
                Array(0...n-1).map { y in
                    chunked[y][x]
                }
            }.map { $0.joined(separator: "/") }
        }.map { FractalGrid(value: $0) }
    }
    
    func split() -> [FractalGrid] {
        let splitSize = size % 2 == 0 ? 2 : 3
        if size == splitSize { return [self] }
        return fractalsOfSize(splitSize)
    }
    
    func joinByNext(_ next: FractalGrid) -> FractalGrid {
        FractalGrid(value: grid.enumerated().map { $0.element + next.grid[$0.offset] }.joined(separator: "/"))
    }
    
    func joinByOver(_ next: FractalGrid) -> FractalGrid {
        FractalGrid(value: stringValue() + "/" + next.stringValue())
    }
    
    static func join(_ fractals: [FractalGrid]) -> FractalGrid {
        if fractals.count == 1 { return fractals[0] }
        let rows = Int(Double(fractals.count).squareRoot())
        let chunks = fractals.chunked(into: rows)
        let joinedItems = chunks.map { items -> FractalGrid in
            var total = items[0]
            for index in 1..<items.count {
                total = total.joinByNext(items[index])
            }
            return total
        }
        var total = joinedItems[0]
        for index in 1..<joinedItems.count {
            total = total.joinByOver(joinedItems[index])
        }
        return total
    }
}

extension FractalGrid: Hashable {
    
    func hash(into hasher: inout Hasher) { }
    
    static func == (lhs: FractalGrid, rhs: FractalGrid) -> Bool {
        !lhs.combinations().filter { $0.stringValue() == rhs.stringValue() }.isEmpty
    }
    
}
