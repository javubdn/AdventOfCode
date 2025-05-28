
class Position: Hashable {
    
        
    
    
    private func lineOnRect(_ insidePoint: Position, _ outsidePoint: Position, _ minX: Int, _ minY: Int, _ maxX: Int, _ maxY: Int) -> (Int, Int) {
        
        
        
        
        return tx <= ty ? (ex, insidePoint.y + ((ex - insidePoint.x) * vy)/vx) : (insidePoint.x + ((ey - insidePoint.y) * vx) / vy, ey)
    }
    
}
