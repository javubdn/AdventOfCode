
class Position: Hashable {
    func line(_ to: Position, _ rangeX: (Int, Int)? = nil, _ rangeY: (Int, Int)? = nil ) -> [Position] {
        if inRange(rangeX, rangeY) && !to.inRange(rangeX, rangeY) {
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
    
    private func lineOnRect(_ insidePoint: Position, _ outsidePoint: Position, _ minX: Int, _ minY: Int, _ maxX: Int, _ maxY: Int) -> (Int, Int) {
        
        let vx = outsidePoint.x - insidePoint.x
        let vy = outsidePoint.y - insidePoint.y
        let ex = vx > 0 ? maxX : minX
        let ey = vy > 0 ? maxY : minY
        
        if vx == 0 { return (minX, ey) }
        if vy == 0 { return (ex, minY) }
        
        let tx = (ex - insidePoint.x) / vx
        let ty = (ey - insidePoint.y) / vy
        
        return tx <= ty ? (ex, insidePoint.y + ((ex - insidePoint.x) * vy)/vx) : (insidePoint.x + ((ey - insidePoint.y) * vx) / vy, ey)
    }
    
}
