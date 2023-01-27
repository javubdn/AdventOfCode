//
//  SandMap.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 19/1/23.
//

private struct ActionQueue: Hashable {
    let x: Int
    let y: Int
}

class SandMap {
    
    fileprivate var rock: Set<Position> = []
    fileprivate var sand: Set<Position> = []
    private var minX: Int
    private var minY: Int
    private var maxX: Int
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
    }
    
}
