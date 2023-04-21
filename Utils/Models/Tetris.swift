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
    
    
}
