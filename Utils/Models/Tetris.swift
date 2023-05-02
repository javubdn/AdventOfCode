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
    
    private func fall(_ piece: [(Int, Int)]) -> ([(Int, Int)], Bool) {
        guard piece.first(where: { $0.0 == tetrisMap.count - 1 }) == nil else { return (piece, true) }
        guard piece.first(where: { tetrisMap[$0.0+1][$0.1] }) == nil else { return (piece, true) }
        let newPiece = piece.map { ($0.0 + 1, $0.1) }
        return (newPiece, false)
    }
    
    private func move(_ piece: [(Int, Int)], _ left: Bool) -> [(Int, Int)] {
        let valid = left ? (piece.min { $0.1 < $1.1 }!.1 > 0) : (piece.max { $0.1 < $1.1 }!.1 < 6)
        guard valid else { return piece }
        guard piece.first(where: { tetrisMap[$0.0][$0.1 + (left ? -1 : 1)] }) == nil else { return piece }
        return piece.map { ($0.0, $0.1 + (left ? -1 : 1)) }
    }
    
    private func insertPiece(_ index: Int, _ directionsIndex: Int) -> Int {
        var directionsIndex = directionsIndex
        insertLines(3)
        let linesToInsert = [1, 3, 3, 4, 2]
        let pieces = [[(0, 2), (0, 3), (0, 4), (0, 5)],
                      [(0, 3), (1, 2), (1, 3), (1, 4), (2, 3)],
                      [(0, 4), (1, 4), (2, 2), (2, 3), (2, 4)],
                      [(0, 2), (1, 2), (2, 2), (3, 2)],
                      [(0, 2), (0, 3), (1, 2), (1, 3)]
        ]
        let item = index % 5
        insertLines(linesToInsert[item])
        var piece = pieces[item]
        while true {
            piece = move(piece, directions[directionsIndex%directions.count])
            directionsIndex += 1
            let (pieceFall, finish) = fall(piece)
            if finish { break }
            piece = pieceFall
        }
        piece.forEach { tetrisMap[$0.0][$0.1] = true }
        let filesToRemove = tetrisMap.enumerated().first { $0.element.filter { $0 }.count > 0 }!.offset
        tetrisMap.removeFirst(filesToRemove)
        return directionsIndex
    }
    
    private func insertLines(_ n: Int) {
        for _ in 0..<n {
            tetrisMap.insert([Bool](repeating: false, count: 7), at: 0)
        }
    }
    
    private func getPeaks() -> [Int] {
        var peaks: [Int] = []
        for item in 0..<7 {
            peaks.append(tetrisMap.enumerated().first { $0.element[item] }?.offset ?? tetrisMap.count)
        }
        let minValue = peaks.min()!
        peaks = peaks.map { $0 - minValue }
        return peaks
    }
    
        var directionsIndex = 0
        var states: [TetrisState: (Int, Int)] = [:]
        
            directionsIndex = insertPiece(index, directionsIndex)
            let newState = TetrisState(peaks: getPeaks(),
                                       currentBlock: index%5,
                                       currentIndex: directionsIndex%directions.count)
                let stepsDiff = index - previousState.0
                let heightDiff = tetrisMap.count - previousState.1
    
}
