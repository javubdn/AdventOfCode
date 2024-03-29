//
//  Tile.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 2/8/22.
//

import Foundation

enum Orientation: CaseIterable {
    case north
    case east
    case south
    case west
}

class Tile {

    enum ValueTile {
        case black
        case white
    }
    
    let id: Int
    var piece: [[String]]
    private var sides: Set<String>
    private var sidesReversed: Set<String>
    
    init(id: Int, piece: [[String]]) {
        self.id = id
        self.piece = piece
        self.sides = Set(Orientation.allCases.map { Tile.sideFacing(piece, $0) })
        self.sidesReversed = Set(Array(sides).map { String($0.reversed()) })
    }
    
    convenience init(from input: String) {
        var lines = input.components(separatedBy: .newlines)
        let firstLine = lines.removeFirst()
        let id = Int(firstLine.components(separatedBy: .whitespaces)[1])!
        let piece = lines.map { $0.map { String($0) } }
        self.init(id: id, piece: piece)
    }
    
    func rotate() -> Tile {
        let newPiece = Array(0..<piece.count).map { row in
            Array(0..<piece.count).map { col in
                piece[col][piece.count - 1 - row]
            }
        }
        return Tile(id: id, piece: newPiece)
    }
    
    func flip() -> Tile {
        Tile(id: id, piece: piece.map { $0.reversed() })
    }
    
    func combinations() -> [Tile] {
        var rotations = [self]
        for _ in 0..<3 {
            rotations.append(rotations.last!.rotate())
        }
        let flips = rotations.map { $0.flip() }
        return rotations + flips
    }
    
    func sharedSideCount(_ tiles: [Tile]) -> Int {
        sides.filter { side in
            tiles.filter { $0.id != id }.filter { $0.hasSide(side) }.count > 0
        }.count
    }
    
    func hasSide(_ side: String) -> Bool {
        sides.contains(side) || sidesReversed.contains(side)
    }
    
    func sideFacing(_ dir: Orientation) -> String {
        Tile.sideFacing(piece, dir)
    }
    
    static func sideFacing(_ piece: [[String]], _ dir: Orientation) -> String {
        switch dir {
        case .north: return piece.first!.joined()
        case .south: return piece.last!.joined()
        case .west: return piece.map { $0.first! }.joined()
        case .east: return piece.map { $0.last! }.joined()
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
