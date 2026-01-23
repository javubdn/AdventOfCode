//
//  Tetris.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 17/3/23.
//

import Foundation

class Tetris {
    
    
    
    
    
    private func insertLines(_ n: Int) {
    }
    
    private func getPeaks() -> [Int] {
    }
    
    func startFall(_ input: Int) -> Int {
        var states: [TetrisState: (Int, Int)] = [:]
        
        for index in 0..<input {
            if let previousState = states[newState] {
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
