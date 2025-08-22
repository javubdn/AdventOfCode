//
//  SandMap.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 19/1/23.
//

private struct ActionQueue: Hashable {
}

class SandMap {
    
    fileprivate var sand: Set<Position> = []
    private var maxY: Int
    private var queue: Set<ActionQueue> = []
    private var isFloor = false
    
    init(_ lines: [String], _ newFloor: Bool? = false) {
        if let newFloor = newFloor { isFloor = newFloor }
        for line in lines {
            var points = line.components(separatedBy: " -> ").map { $0.components(separatedBy: ",").map { Int($0)! } }
            var previousPoint = points.removeFirst()
            for point in points {
                if point[0] == previousPoint[0] {
                    for i in min(point[1], previousPoint[1])...max(point[1], previousPoint[1]) {
                        rock.insert(Position(x: point[0], y: i))
                    }
                } else {
                    for i in min(point[0], previousPoint[0])...max(point[0], previousPoint[0]) {
                        rock.insert(Position(x: i, y: point[1]))
                    }
                }
                previousPoint = point
            }
        }
        
        minX = rock.min { $0.x < $1.x }!.x
        minY = rock.min { $0.y < $1.y }!.y
        maxX = rock.max { $0.x < $1.x }!.x
        maxY = rock.max { $0.y < $1.y }!.y
        
        if isFloor {
            var pointsFloor = [[0, maxY + 2], [maxX*2, maxY + 2]]
            var previousPoint = pointsFloor.removeFirst()
            for point in pointsFloor {
                if point[0] == previousPoint[0] {
                    for i in min(point[1], previousPoint[1])...max(point[1], previousPoint[1]) {
                        rock.insert(Position(x: point[0], y: i))
                    }
                } else {
                    for i in min(point[0], previousPoint[0])...max(point[0], previousPoint[0]) {
                        rock.insert(Position(x: i, y: point[1]))
                    }
                }
                previousPoint = point
            }
            minY = rock.min { $0.y < $1.y }!.y
            maxY = rock.max { $0.y < $1.y }!.y
        }
        
    }
    
    func run(_ x: Int, _ y: Int) {
    externalLoop:
        while true {
            var y = 0
            var x = 500
            while y <= maxY {
                if pile(x, y+1) {
                    if pile(x-1, y+1) {
                        if pile(x+1, y+1) {
                            sand.insert(Position(x: x, y: y))
                            if isFloor {
                                minX = min(minX, x)
                                maxX = max(maxX, x)
                            }
                            if y <= 0 {
                                break externalLoop
                            }
                            break
                        } else {
                            x += 1
                        }
                    } else {
                        x -= 1
                    }
                }
                y += 1
            }
            if y > maxY {
                break
                
            }
        }
    }
    
    func countSand() -> Int {
        sand.filter { $0.y <= maxY }.count
    }
    
    func printS() {
        var sandMap: [[String]] = [[String]](repeating: [String](repeating: ".", count: maxX-minX+3), count: maxY+1)
        for rc in rock {
            sandMap[rc.y][rc.x-minX+1] = "#"
        }
        
        for sn in sand {
            sandMap[sn.y][sn.x-minX+1] = "o"
        }
        let valu = sandMap.map { $0.joined() }
        valu.forEach { print($0) }
    }
    
    private func pile(_ x: Int, _ y: Int) -> Bool {
        rock.contains(Position(x: x, y: y)) || sand.contains(Position(x: x, y: y))
    }
    
    private func fall(_ x: Int, _ y: Int) {
        var y = y
        var x = x
        while y <= maxY {
            if pile(x, y+1) {
                if pile(x-1, y+1) {
                    if pile(x+1, y+1) {
                        sand.insert(Position(x: x, y: y))
                        if y > 0 {
                            queue.insert(ActionQueue(x: 500, y: 0))
                        }
                        return
                    } else {
                        x += 1
                    }
                } else {
                    x -= 1
                }
            }
            y += 1
        }
    }
    
    private let sandSource = Position(x: 500, y: 0)
    private func down(_ position: Position) -> Position { Position(x: position.x, y: position.y+1)  }
    private func downLeft(_ position: Position) -> Position { Position(x: position.x-1, y: position.y+1)  }
    private func downRight(_ position: Position) -> Position { Position(x: position.x+1, y: position.y+1)  }
    
    private func dropSand(_ voidStartsAt: Int) -> Int {
        var start = sandSource
        var landed = 0
        while true {
            let next = [down(start), downLeft(start), downRight(start)].first { !rock.contains($0) }
            if next == nil && start == sandSource {
                return landed
            } else if next == nil {
                rock.insert(start)
                landed += 1
                start = sandSource
            } else if next!.y == voidStartsAt {
                return landed
            } else {
                start = next!
            }
        }
    }
    
    func solutionPart1() -> Int {
        dropSand(maxY + 1)
    }
    
    func solutionPart2() -> Int {
        let minX: Int = rock.min { $0.x < $1.x }!.x
        let maxX: Int = rock.max { $0.x > $1.x }!.x
        for newX in minX-maxY...maxX+maxY {
            rock.insert(Position(x: newX, y: maxY + 2))
        }
        return dropSand(maxY + 3) + 1
    }
    
}
