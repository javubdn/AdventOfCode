//
//  Position.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 5/1/23.
//

class Position: Hashable {
    
    var x: Int
    var y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    func hash(into hasher: inout Hasher) { }
    
    static func == (lhs: Position, rhs: Position) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    func line(_ to: Position, _ rangeX: (Int, Int)? = nil, _ rangeY: (Int, Int)? = nil ) -> [Position] {
        guard let rangeX = rangeX, let rangeY = rangeY else {
            return lineNoRange(to)
        }
        if inRange(rangeX, rangeY) && to.inRange(rangeX, rangeY) {
            return lineNoRange(to)
        }
        if inRange(rangeX, rangeY) && !to.inRange(rangeX, rangeY) {
            let middlePoint = lineOnRect(self, to, rangeX.0, rangeY.0, rangeX.1, rangeY.1)
            return lineNoRange(Position(x: middlePoint.0, y: middlePoint.1))
        }
        if inRange(rangeX, rangeY) && !to.inRange(rangeX, rangeY) {
            let middlePoint = lineOnRect(self, to, rangeX.0, rangeY.0, rangeX.1, rangeY.1)
            return Position(x: middlePoint.0, y: middlePoint.1).lineNoRange(to)
        }
        return []
    }
    
    private func lineNoRange(_ to: Position) -> [Position] {
        var positions: [Position] = []
        
        var previousPoint = self
        let distanceX = to.x - x
        let distanceY = to.y - y
        let slope = distanceY/distanceX
        while previousPoint.x <= to.x {
            positions.append(previousPoint)
            previousPoint = Position(x: previousPoint.x+1, y: previousPoint.y+slope)
        }
        return positions
    }
    
    private func inRange(_ rangeX: (Int, Int), _ rangeY: (Int, Int)) -> Bool {
        x >= rangeX.0 && x <= rangeX.1 && y >= rangeY.0 && y <= rangeY.1
    }
    
}
