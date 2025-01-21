//
//  CubeMap.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 13/7/23.
//

import Foundation

class CubeMap {
    
    let faces: [CubeMapFace]
    
    init(_ faces: [CubeMapFace]) {
        self.faces = faces
    }
    
    convenience init(_ input: String) {
        let plainMap = input.components(separatedBy: .newlines).map { Array($0).map { String($0) } }
        let itemsByRow = plainMap.map { $0.filter { $0 == "." || $0 == "#" }.count }
        let totalItems = itemsByRow.reduce(0, +)
        let sideLength = Int(sqrt(Double(totalItems / 6)))
        
        var row = 0
        var cubeMapFaces: [CubeMapFace] = []
        var currentId = 0
        while row < itemsByRow.count {
            var col = plainMap[row].enumerated().first {$0.element == "." || $0.element == "#" }!.offset
            while col < plainMap[row].count {
                let newSide = CubeMap.getSubmatrix(plainMap, i0: row, i1: row+sideLength-1, j0: col, j1: col+sideLength-1)
                let cubeMapFace = CubeMapFace(id: currentId, faceMap: newSide, position: (row, col))
                cubeMapFaces.append(cubeMapFace)
                col += sideLength
                currentId += 1
            }
            row += sideLength
        }
        
        for cubeMapFace in cubeMapFaces {
            if let faceRight = cubeMapFaces.first(where: { $0.relativePosition.0 == cubeMapFace.relativePosition.0 && $0.relativePosition.1 == cubeMapFace.relativePosition.1 + sideLength }) {
                cubeMapFace.collindants[.east] = (faceRight, .west)
                faceRight.collindants[.west] = (cubeMapFace, .east)
            }
            if let faceDown = cubeMapFaces.first(where: { $0.relativePosition.1 == cubeMapFace.relativePosition.1 && $0.relativePosition.0 == cubeMapFace.relativePosition.0 + sideLength }) {
                cubeMapFace.collindants[.south] = (faceDown, .north)
                faceDown.collindants[.north] = (cubeMapFace, .south)
            }
        }
        
        var missedFaces = cubeMapFaces.filter { $0.collindants.count < 4 }
        
        while !missedFaces.isEmpty {
            for cube in cubeMapFaces {
                if let upSide = cube.collindants[.north]?.0, let leftSide = cube.collindants[.west]?.0 {
                    upSide.setSide(leftSide, cube, .west, leftSide.directionRespectMe(cube)!)
                    leftSide.setSide(upSide, cube, .north, upSide.directionRespectMe(cube)!)
                }
                if let upSide = cube.collindants[.north]?.0, let rightSide = cube.collindants[.east]?.0 {
                    upSide.setSide(rightSide, cube, .east, rightSide.directionRespectMe(cube)!)
                    rightSide.setSide(upSide, cube, .north, upSide.directionRespectMe(cube)!)
                }
                if let downSide = cube.collindants[.south]?.0, let leftSide = cube.collindants[.west]?.0 {
                    downSide.setSide(leftSide, cube, .west, leftSide.directionRespectMe(cube)!)
                    leftSide.setSide(downSide, cube, .south, downSide.directionRespectMe(cube)!)
                }
                if let downSide = cube.collindants[.south]?.0, let rightSide = cube.collindants[.east]?.0 {
                    downSide.setSide(rightSide, cube, .east, rightSide.directionRespectMe(cube)!)
                    rightSide.setSide(downSide, cube, .south, downSide.directionRespectMe(cube)!)
                }
            }
            missedFaces = cubeMapFaces.filter { $0.collindants.count < 4 }
        }
        
        self.init(cubeMapFaces)
    }
    
    func game(_ path: String) -> Int {
        let movements = getMovements(path)
        var currentFace = faces.first { $0.id == 0 }!
        var currentPosition = (0, 0)
        var currentDirection: Direction = .east
        
        for movement in movements {
            switch movement {
            case .rotate(let left):
                currentDirection = left ? currentDirection.turnLeft() : currentDirection.turnRight()
            case .advance(let steps):
                (currentFace, currentDirection, currentPosition) = currentFace.move(steps, currentDirection, currentPosition)
            }
        }
        return (currentFace.relativePosition.0 + currentPosition.0 + 1) * 1000 + (currentFace.relativePosition.1 + currentPosition.1 + 1) * 4 + (currentDirection == .east ? 0 : currentDirection == .south ? 1 : currentDirection == .west ? 2 : 3)
    }
    
    private enum MovementPassword {
        case advance(_ steps: Int)
        case rotate(_ left: Bool)
    }
    
    private func getMovements(_ path: String) -> [MovementPassword] {
        var movements: [MovementPassword] = []
        var sum = 0
        for element in path {
            if let value = Int(String(element)) {
                sum = sum * 10 + value
            } else {
                movements.append(.advance(sum))
                sum = 0
                movements.append(.rotate(element == "L"))
            }
        }
        if sum > 0 { movements.append(.advance(sum)) }
        return movements
    }
    
    private static func getSubmatrix(_ matrix: [[String]], i0: Int, i1: Int, j0: Int, j1: Int) -> [[String]] {
        var result = [[String]]()

        for row in Array(matrix[i0...i1]) {
             result.append(Array(row[j0...j1]))
        }
        
        return result
    }
}

class CubeMapFace {
    
    let id: Int
    let faceMap: [[String]]
    var collindants: [Direction: (CubeMapFace, Direction)] = [:]
    let relativePosition: (Int, Int)
    
    init(id: Int, faceMap: [[String]], position: (Int, Int)) {
        self.id = id
        self.faceMap = faceMap
        self.relativePosition = position
    }
    
    func setSide(_ side: CubeMapFace, _ reference: CubeMapFace, _ newRef: Direction, _ refNew: Direction) {
        let refMeV = directionRespectMe(reference)
        guard let refMe = refMeV else { return }
        let (newMe, meNew) = getDirections(refMe, collindants[refMe]!.1, newRef, refNew)
        collindants[newMe] = (side, meNew)
    }
    
    func directionRespectMe(_ face: CubeMapFace) -> Direction? {
        collindants.first { $0.value.0.id == face.id }?.key
    }
    
    private func getDirections(_ refMe: Direction, _ meRef: Direction, _ newRef: Direction, _ refNew: Direction) -> (Direction, Direction) {
        (calcDirection(refMe, meRef, newRef), calcDirection(refNew, newRef, meRef))
    }
    
    private func opositeDirection(_ dir: Direction) -> Direction {
        dir == .north ? .south : dir == .south ? .north : dir == .west ? .east : .west
    }
    
    private func calcDirection(_ refMe: Direction, _ meRef: Direction, _ newRef: Direction) -> Direction {
        refMe == meRef ? opositeDirection(newRef) : refMe == opositeDirection(meRef) ? newRef : refMe == newRef ? meRef : opositeDirection(meRef)
    }
    
    func move(_ steps: Int, _ direction: Direction, _ position: (Int, Int)) -> (CubeMapFace, Direction, (Int, Int)) {
        var steps = steps
        var (row, col) = position
        let sideLength = faceMap.count
        while steps > 0 {
            guard (direction == .north && row > 0)
                    || (direction == .south && row < sideLength - 1)
                    || (direction == .west && col > 0)
                    || (direction == .east && col < sideLength - 1)
            else {
                let nextSide = collindants[direction]!.0
                let directionEntry = collindants[direction]!.1
                let (newRow, newCol) = getFirstItemNextFace(direction, directionEntry, direction == .north || direction == .south ? col : row)
                guard nextSide.faceMap[newRow][newCol] == "." else {
                    break
                }
                return nextSide.move(steps-1, opositeDirection(directionEntry), (newRow, newCol))
            }
            guard (direction == .north && faceMap[row-1][col] == ".")
                    || (direction == .south && faceMap[row+1][col] == ".")
                    || (direction == .west && faceMap[row][col-1] == ".")
                    || (direction == .east && faceMap[row][col+1] == ".")
            else {
                break
            }
            row += direction == .north ? -1 : direction == .south ? 1 : 0
            col += direction == .west ? -1 : direction == .east ? 1 : 0
            steps -= 1
        }
        return (self, direction, (row, col))
    }
    
    private func getFirstItemNextFace(_ first: Direction, _ second: Direction, _ position: Int) -> (Int, Int) {
        let size = faceMap.count
        let invPosition = size - position - 1
        let firstNorthEast = first == .north || first == .east
        let firstSouthWest = first == .south || first == .west
        let row = second == .north ? 0 : second == . south ? size - 1 : second == .west ? (firstNorthEast ? position : invPosition) : (firstSouthWest ? position : invPosition)
        let col = second == . west ? 0 : second == .east ? size - 1 : second == .north ? (firstSouthWest ? position : invPosition) : (firstNorthEast ? position : invPosition)
        return (row, col)
    }
    
}
