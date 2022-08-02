//
//  Tile.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 2/8/22.
//

import Foundation

class Tile {

    enum ValueTile {
        case black
        case white
    }
    
    let id: Int
    let piece: [[ValueTile]]
    
    init(id: Int, piece: [[ValueTile]]) {
        self.id = id
        self.piece = piece
    }
    
    convenience init(from input: String) {
        var lines = input.components(separatedBy: .newlines)
        let firstLine = lines.removeFirst()
        let id = Int(firstLine.components(separatedBy: .whitespaces)[1])!
        let piece = lines.map { $0.map { $0 == "#" ? ValueTile.black : ValueTile.white } }
        self.init(id: id, piece: piece)
    }
    
    func rotate(_ piece: [[ValueTile]]) -> [[ValueTile]] {
        Array(0..<piece.count).map { row in
            Array(0..<piece.count).map { col in
                piece[col][piece.count - 1 - row]
            }
        }
    }
    
    func flip(_ piece: [[ValueTile]]) -> [[ValueTile]] {
        piece.map { $0.reversed() }
    }
    
    func combinations(_ piece: [[ValueTile]]) -> [[[ValueTile]]] {
        var rotations = [piece]
        for _ in 0..<3 {
            rotations.append(rotate(rotations.last!))
        }
        let flips = rotations.map { flip($0) }
        return rotations + flips
    }
    
    func borderCoincidence(_ other: [[ValueTile]]) -> Bool {
        combinations(piece).first { tile in
            combinations(other).first { borderRightMatches($0, tile) } != nil
        } != nil
    }
    
    func borderRightMatches(_ first: [[ValueTile]], _ second: [[ValueTile]]) -> Bool {
        first.last == second.first
    }
    
}
