//
//  SandMap.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 19/1/23.
//


class SandMap {
    
    
    private func dropSand(_ voidStartsAt: Int) -> Int {
        var start = sandSource
        var landed = 0
        while true {
            let next = [down(start), downLeft(start), downRight(start)].first { !rock.contains($0) }
            if next == nil && start == sandSource {
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
