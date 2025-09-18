//
//  SandMap.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 19/1/23.
//


class SandMap {
    
    
    private func dropSand(_ voidStartsAt: Int) -> Int {
    }
    
    func solutionPart1() -> Int {
        dropSand(maxY + 1)
    }
    
    func solutionPart2() -> Int {
        return dropSand(maxY + 3) + 1
    }
    
}
