//
//  Tetris.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 17/3/23.
//

import Foundation

class Tetris {
    
    
    private func fall(_ piece: [(Int, Int)]) -> ([(Int, Int)], Bool) {
    }
    
    private func move(_ piece: [(Int, Int)], _ left: Bool) -> [(Int, Int)] {
    }
    
    private func insertPiece(_ index: Int, _ directionsIndex: Int) -> Int {
        var directionsIndex = directionsIndex
        insertLines(3)
        let linesToInsert = [1, 3, 3, 4, 2]
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
    
    func startFall(_ input: Int) -> Int {
        var directionsIndex = 0
        var states: [TetrisState: (Int, Int)] = [:]
        
        for index in 0..<input {
            directionsIndex = insertPiece(index, directionsIndex)
            let newState = TetrisState(peaks: getPeaks(),
                                       currentBlock: index%5,
                                       currentIndex: directionsIndex%directions.count)
            if let previousState = states[newState] {
                let stepsDiff = index - previousState.0
                let heightDiff = tetrisMap.count - previousState.1
                let numberTimes = (input - previousState.0) / stepsDiff
                let currentHeight = numberTimes * heightDiff + previousState.1
                let finalSteps = input - (numberTimes * stepsDiff + previousState.0)
                let tetrisHeight = tetrisMap.count
                let minIndex = (index + 1) % 5
                for i in minIndex..<finalSteps+minIndex-1 {
                    directionsIndex = insertPiece(i, directionsIndex)
                }
                return currentHeight + (tetrisMap.count - tetrisHeight)
            }
            states[newState] = (index, tetrisMap.count)
        }
        
        return tetrisMap.count
    }
    
}
