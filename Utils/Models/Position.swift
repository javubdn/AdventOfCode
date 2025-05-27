
class Position: Hashable {
    
        
    
    
    private func lineOnRect(_ insidePoint: Position, _ outsidePoint: Position, _ minX: Int, _ minY: Int, _ maxX: Int, _ maxY: Int) -> (Int, Int) {
        
        let ey = vy > 0 ? maxY : minY
        
        if vx == 0 { return (minX, ey) }
        if vy == 0 { return (ex, minY) }
        
        let tx = (ex - insidePoint.x) / vx
        let ty = (ey - insidePoint.y) / vy
        
        return tx <= ty ? (ex, insidePoint.y + ((ex - insidePoint.x) * vy)/vx) : (insidePoint.x + ((ey - insidePoint.y) * vx) / vy, ey)
    }
    
}
