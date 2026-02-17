//
//  Tile.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 2/8/22.
//

import Foundation


class Tile {

    
    
    static func sideFacing(_ piece: [[String]], _ dir: Orientation) -> String {
        switch dir {
        }
    }
    
    func isSideShared(_ dir: Orientation, tiles: [Tile]) -> Bool {
        tiles.filter { $0.id != id }.filter { $0.hasSide(sideFacing(dir)) }.count > 0
    }
    
    func findAndOrientNeighbor(mySide: Orientation, theirSide: Orientation, tiles: [Tile]) -> Tile {
        let mySideValue = sideFacing(mySide)
        let correctTile = tiles.filter { $0.id != id }.first { $0.hasSide(mySideValue) }!
        return correctTile.orientToSide(side: mySideValue, direction: theirSide)
    }
    
    private func orientToSide(side: String, direction: Orientation) -> Tile {
        combinations().first { $0.sideFacing(direction) == side }!
    }
    
    func insetRow(_ row: Int) -> String {
        piece[row].dropFirst().dropLast().joined()
    }
    
    func maskIfFound(_ mask: [(Int, Int)]) -> Bool {
        var found = false
        let maxWidth = mask.max { $0.1 < $1.1 }!.1
        let maxHeight = mask.max { $0.0 < $1.0 }!.0
        Array(0..<(piece.count - maxHeight)).forEach { y in
            Array(0..<(piece.count - maxWidth)).forEach { x in
                let lookingAt = (y, x)
                let actualSpots = mask.map { ($0.0 + lookingAt.0, $0.1 + lookingAt.1) }
                let matches = actualSpots.filter { piece[$0.0][$0.1] == "#" }.count
                if matches == mask.count {
                    found = true
                    actualSpots.forEach { piece[$0.0][$0.1] = "0" }
                }
            }
        }
        return found
    }
    
}
