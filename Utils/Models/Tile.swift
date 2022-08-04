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
    let piece: [[String]]
    var pieceUp: Int?
    var pieceDown: Int?
    var pieceLeft: Int?
    var pieceRight: Int?
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
    
    func tryAddPiece(_ tile: Tile) {
        
        var numberRotationsFirst = 0
        var numberRotationsSecond = 0
        
        while numberRotationsSecond < 4 {
            var newPiece = piece
            while numberRotationsFirst < 4 {
                if borderRightMatches(newPiece, tile.piece) || borderRightMatches(flip(newPiece), tile.piece) {
                    switch numberRotationsFirst {
                    case 0: pieceDown = tile.id
                    case 1: pieceLeft = tile.id
                    case 2: pieceUp = tile.id
                    default: pieceRight = tile.id
                    }
                    switch numberRotationsSecond {
                    case 0: pieceUp = tile.id
                    case 1: pieceRight = tile.id
                    case 2: pieceDown = tile.id
                    default: pieceLeft = tile.id
                    }
                    return
                }
                newPiece = rotate(newPiece)
                numberRotationsFirst += 1
            }
            numberRotationsFirst = 0
            numberRotationsSecond += 1
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
    
}
