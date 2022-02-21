//
//  Year2017InteractorImpl.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 17/2/22.
//

import Foundation

class Year2017InteractorImpl: NSObject {
    
}

extension Year2017InteractorImpl: YearInteractor {
    
    @objc
    func day1question1() -> String {
        let input = readCSV("InputYear2017Day1")
        var result = 0
        for index in 0..<input.count {
            let fi = input.index(input.startIndex, offsetBy: index)
            let si = input.index(input.startIndex, offsetBy: (index+1)%input.count)
            if input[fi] == input[si] {
                result += Int(String(input[fi]))!
            }
        }
        return String(result)
    }
    
    @objc
    func day1question2() -> String {
        let input = readCSV("InputYear2017Day1")
        var result = 0
        let size = input.count/2
        for index in 0..<input.count {
            let fi = input.index(input.startIndex, offsetBy: index)
            let si = input.index(input.startIndex, offsetBy: (index+size)%input.count)
            if input[fi] == input[si] {
                result += Int(String(input[fi]))!
            }
        }
        return String(result)
    }
    
    @objc
    func day2question1() -> String {
        let input = readCSV("InputYear2017Day2")
            .components(separatedBy: "\n")
            .map { $0.components(separatedBy: .whitespaces).map { Int($0)! } }
        var result = 0
        for item in input {
            let maximum = item.max()!
            let minimum = item.min()!
            result += maximum - minimum
        }
        return String(result)
    }
    
    @objc
    func day2question2() -> String {
        let input = readCSV("InputYear2017Day2")
            .components(separatedBy: "\n")
            .map { $0.components(separatedBy: .whitespaces).map { Int($0)! } }
        var result = 0
        for item in input {
            for value in item {
                if let divisor = item.first(where: { $0 != value && value % $0 == 0}) {
                    result += value/divisor
                    break
                }
            }
        }
        return String(result)
    }
    
    @objc
    func day3question1() -> String {
        return String(positionInSquare(277678))
    }
    
    @objc
    func day3question2() -> String {
        let target = 277678
        let size = 101
        var matrix: [[Int]] = [[Int]](repeating: [Int](repeating: 0, count: size), count: size)
        let center = size/2
        matrix[center][center] = 1
        matrix[center][center+1] = 1
        var row = center - 1
        var col = center + 1
        var direction = 0
        var step = 3
        while row > 0 && row < size-1 && col > 0 && col < size-1 {
            let numSteps = direction == 0 ? step-2 : direction == 3 ? step : step - 1
            for _ in 0..<numSteps {
                let val = sumNeighbors(matrix: matrix, row: row, col: col)
                if val > target {
                    return String(val)
                }
                matrix[row][col] = val
                row += direction == 0 ? -1 : direction == 2 ? 1 : 0
                col += direction == 1 ? -1 : direction == 3 ? 1 : 0
            }
            row += direction == 0 || direction == 1 ? 1 : -1
            col += direction == 1 || direction == 2 ? 1 : -1
            direction = (direction+1)%4
            if direction == 0 { step += 2 }
        }
        return ""
    }
    
    private func positionInSquare(_ input: Int) -> Int {
        let row = (Int(sqrt(Double(input-1))) + 3) / 2
        let firstCenter = (row*2-3) * (row*2-3) + row - 1
        let diff = 2*row - 2
        let minDistance = [abs(input-firstCenter),
                           abs(input-firstCenter-diff),
                           abs(input-firstCenter-2*diff),
                           abs(input-firstCenter-3*diff)].min()!
        return row - 1 + minDistance
    }
    
    private func sumNeighbors(matrix: [[Int]], row: Int, col: Int) -> Int {
        matrix[row][col-1]
        + matrix[row][col+1]
        + matrix[row-1][col]
        + matrix[row-1][col-1]
        + matrix[row-1][col+1]
        + matrix[row+1][col]
        + matrix[row+1][col-1]
        + matrix[row+1][col+1]
    }
    
}
