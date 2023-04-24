//
//  Tetris.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 17/3/23.
//

import Foundation

class Tetris {
    
    let directions: [Bool]
    var highest = 0
    var tetrisMap: [[Bool]] = []
    
    private class TetrisState: Hashable {
        
        let peaks: [Int]
        let currentBlock: Int
        let currentIndex: Int
        
        init(peaks: [Int], currentBlock: Int, currentIndex: Int) {
            self.peaks = peaks
            self.currentBlock = currentBlock
            self.currentIndex = currentIndex
        }
        
        func hash(into hasher: inout Hasher) { }
        
        static func == (lhs: Tetris.TetrisState, rhs: Tetris.TetrisState) -> Bool {
            lhs.peaks == rhs.peaks && lhs.currentBlock == rhs.currentBlock && lhs.currentIndex == rhs.currentIndex
        }
        
    }
    
    private init(_ directions: [Bool]) {
        self.directions = directions
    }
    
    convenience init(_ input: String) {
        let directions = input.map { $0 == "<" }
        self.init(directions)
    }
    
        guard piece.first(where: { $0.0 == tetrisMap.count - 1 }) == nil else { return (piece, true) }
        guard piece.first(where: { tetrisMap[$0.0+1][$0.1] }) == nil else { return (piece, true) }
        let newPiece = piece.map { ($0.0 + 1, $0.1) }
        return (newPiece, false)
    
}
