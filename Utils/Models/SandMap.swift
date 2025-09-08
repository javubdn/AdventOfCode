//
//  SandMap.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 19/1/23.
//


class SandMap {
    
    private var queue: Set<ActionQueue> = []
    private var isFloor = false
    
    func countSand() -> Int {
        sand.filter { $0.y <= maxY }.count
    }
    
    func printS() {
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
