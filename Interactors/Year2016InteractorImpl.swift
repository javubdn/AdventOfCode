//
//  Year2016InteractorImpl.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 20/1/22.
//

import Foundation

class Year2016InteractorImpl: NSObject {
    
}

extension Year2016InteractorImpl: YearInteractor {

    @objc
    func day1question1() -> String {
        let input = readCSV("InputYear2016Day1").replacingOccurrences(of: ",", with: "").components(separatedBy: " ")
        var direction = Direction.north
        var xAxis = 0
        var yAxis = 0
                
        for item in input {
            direction = direction.turn(String(item[0]) == "L" ? .left : .right)
            switch direction {
            case .north: yAxis += Int(String(item[1...item.count-1]))!
            case .south: yAxis -= Int(String(item[1...item.count-1]))!
            case .west: xAxis -= Int(String(item[1...item.count-1]))!
            case .east: xAxis += Int(String(item[1...item.count-1]))!
            }
        }
        let result = abs(xAxis) + abs(yAxis)
        return String(result)
    }
    
    @objc
    func day1question2() -> String {
        let input = readCSV("InputYear2016Day1").replacingOccurrences(of: ",", with: "").components(separatedBy: " ")
        var direction = Direction.north
        var xAxis = 0
        var yAxis = 0
        var horizontalSegments: [((Int, Int), (Int, Int))] = []
        var verticalSegments: [((Int, Int), (Int, Int))] = []
        var intersect: (Int, Int)? = nil
     
        for item in input {
            direction = direction.turn(String(item[0]) == "L" ? .left : .right)
            let horizontal = direction == .west || direction == .east
            let preAxis = horizontal ? xAxis : yAxis
            let segment: ((Int, Int), (Int, Int))
            if horizontal {
                xAxis = xAxis + Int(String(item[1...item.count-1]))! * (direction == .east ? 1 : -1)
                segment = ((direction == .east ? preAxis : xAxis, yAxis), (direction == .east ? xAxis : preAxis, yAxis))
            } else {
                yAxis = yAxis + Int(String(item[1...item.count-1]))! * (direction == .north ? 1 : -1)
                segment = ((xAxis, direction == .north ? preAxis : yAxis), (xAxis, direction == .north ? yAxis : preAxis))
            }
            var segments = horizontal ? verticalSegments : horizontalSegments
            if segments.count > 0 { segments.removeLast() }
            if let value = intersectsSegment(segment, in: segments, horizontal: horizontal) {
                intersect = value
                break
            }
            if horizontal {
                horizontalSegments.append(segment)
            } else {
                verticalSegments.append(segment)
            }
        }
        var result = 0
        if let intersect = intersect {
            result = abs(intersect.0) + abs(intersect.1)
        }
        return String(result)
    }
    
    enum TurnDirection {
        case left
        case right
    }
    
    enum Direction {
        case north
        case south
        case west
        case east
        
        func turnLeft() -> Direction {
            switch self {
            case .north: return .west
            case .south: return .east
            case .west: return .south
            case .east: return .north
            }
        }
        
        func turnRight() -> Direction {
            switch self {
            case .north: return .east
            case .south: return .west
            case .west: return .north
            case .east: return .south
            }
        }
        
        func turn(_ turn: TurnDirection) -> Direction {
            switch self {
            case .north: return turn == .left ? .west : .east
            case .south: return turn == .left ? .east : .west
            case .west: return turn == .left ? .south : .north
            case .east: return turn == .left ? .north : .south
            }
        }
        
    }
    
    private func intersectsSegment(_ segment: ((Int, Int), (Int, Int)), in segments: [((Int, Int), (Int, Int))], horizontal: Bool) -> (Int, Int)? {
        for segmentFromList in segments {
            let horizontalSegment = horizontal ? segment : segmentFromList
            let verticalSegment = horizontal ? segmentFromList : segment
            if verticalSegment.0.0 >= horizontalSegment.0.0
                && verticalSegment.0.0 <= horizontalSegment.1.0
                && horizontalSegment.0.1 >= verticalSegment.0.1
                && horizontalSegment.0.1 <= verticalSegment.1.1 {
                return (verticalSegment.0.0, horizontalSegment.0.1 )
            }
        }
        return nil
    }
    
    @objc
    func day2question1() -> String {
        let input = readCSV("InputYear2016Day2").components(separatedBy: "\n")
        let values = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
        var position = (1, 1)
        var result = ""
        for instruction in input {
            for letter in instruction {
                switch String(letter) {
                case "U": position = (max(position.0 - 1, 0), position.1)
                case "D": position = (min(position.0 + 1, 2), position.1)
                case "L": position = (position.0, max(position.1 - 1, 0))
                default: position = (position.0, min(position.1 + 1, 2))
                }
            }
            result += String(values[position.0][position.1])
        }
        return result
    }
    
    @objc
    func day2question2() -> String {
        let input = readCSV("InputYear2016Day2").components(separatedBy: "\n")
        let values = [["X", "X", "1", "X", "X"],
                      ["X", "2", "3", "4", "X"],
                      ["5", "6", "7", "8", "9"],
                      ["X", "A", "B", "C", "X"],
                      ["X", "X", "D", "X", "X"]]
        var position = (2, 0)
        var result = ""
        for instruction in input {
            for letter in instruction {
                switch String(letter) {
                case "U": position = (position.0 > 0 && values[position.0 - 1][position.1] != "X" ? position.0 - 1 : position.0, position.1)
                case "D": position = (position.0 < 4 && values[position.0 + 1][position.1] != "X" ? position.0 + 1 : position.0, position.1)
                case "L": position = (position.0, position.1 > 0 && values[position.0][position.1 - 1] != "X" ? position.1 - 1 : position.1)
                default: position = (position.0, position.1 < 4 && values[position.0][position.1 + 1] != "X" ? position.1 + 1 : position.1)
                }
            }
            result += String(values[position.0][position.1])
        }
        return result
    }
    
    @objc
    func day3question1() -> String {
        let input = readCSV("InputYear2016Day3").trimmingCharacters(in: .whitespacesAndNewlines)
        let items =  input.components(separatedBy: "\n  ")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "   ", with: " ").replacingOccurrences(of: "  ", with: " ")
            .components(separatedBy: " ")
                .map { Int($0)! } }
        var result = 0
        for item in items {
            if item[0] + item[1] > item[2]
            && item[1] + item[2] > item[0]
            && item[0] + item[2] > item[1] {
              result += 1
            }
        }
        return String(result)
    }
    
    @objc
    func day3question2() -> String {
        return ""
    }
    
}
