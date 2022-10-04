//
//  Year2021InteractorImpl.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 20/12/21.
//

import Foundation
import CoreXLSX

class Year2021InteractorImpl: NSObject {
    var descendants8 = [Int](repeating: -1, count: 256)
    var numberCharacters14: [String: [Int: [String: Int]]] = [:]
    var minorRiskBestPath: [String: Int] = [:]
}

extension Year2021InteractorImpl: YearInteractor {
    
}

private extension Year2021InteractorImpl {
    
    //MARK: - Helper methods
    enum movement {
        case forward
        case up
        case down
        case unknown
        static func movementFromValue(_ value: String) -> movement {
            switch value {
            case "forward": return .forward
            case "down": return .down
            case "up": return .up
            default: return .unknown
            }
        }
    }
    
    func valuesFromExcel(_ name: String) -> [String] {
        guard let path = Bundle.main.path(forResource: name, ofType: "xlsx"),
              let file = XLSXFile(filepath: path) else {
                  return []
              }
        do {
            let input = try file.parseWorksheetPaths()
                .compactMap { try file.parseWorksheet(at: $0) }
                .flatMap { $0.data?.rows ?? [] }
                .flatMap { $0.cells }
                .map { $0.value! }
            
            return input
        } catch {
            return []
        }
    }
    
    func readCSV(_ name: String) -> String {
        guard let filepath = Bundle.main.path(forResource: name, ofType: "csv") else { return "" }
        do {
            let contents = try String(contentsOfFile: filepath, encoding: .utf8)
            return contents
        }
        catch {
            return ""
        }
    }
    
    //MARK: - Main methods
    
    @objc
    func day1question1() -> String {
        let input = valuesFromExcel("InputDay1").map { Int($0)! }
        var answer = 0
        input.enumerated().forEach { item in
            if item.0 > 0 {
                if item.1 > input[item.0-1] {
                    answer += 1
                }
            }
        }
        return String(answer)
    }
    
    @objc
    func day1question2() -> String {
        let input = valuesFromExcel("InputDay1").map { Int($0)! }
        var answer = 0
        input.enumerated().forEach { item in
            if item.0 > 2 {
                if item.1 > input[item.0-3] {
                    answer += 1
                }
            }
        }
        return String(answer)
    }
    
    @objc
    func day2question1() -> String {
        let input = readCSV("InputDay2")
            .components(separatedBy: "\r\n")
            .map{ $0.components(separatedBy: ",")[0] }
        
        var answer = (0, 0)
        input.forEach { action in
            let values = action.components(separatedBy: .whitespaces)
            switch movement.movementFromValue(values[0]) {
            case .forward: answer.0 += Int(values[1])!
            case .up: answer.1 -= Int(values[1])!
            case .down: answer.1 += Int(values[1])!
            default: break
            }
        }
        
        return String(answer.0 * answer.1)
    }
    
    @objc
    func day2question2() -> String {
        let input = readCSV("InputDay2")
            .components(separatedBy: "\r\n")
            .map{ $0.components(separatedBy: ",")[0] }
        
        var answer = (0, 0)
        var aim = 0
        input.forEach { action in
            let values = action.components(separatedBy: .whitespaces)
            let increment = Int(values[1])!
            switch movement.movementFromValue(values[0]) {
            case .forward:
                answer.0 += increment
                answer.1 += aim * increment
            case .up: aim -= increment
            case .down: aim += increment
            default: break
            }
        }
        
        return String(answer.0 * answer.1)
    }
    
    @objc
    func day3question1() -> String {
        let input = readCSV("InputDay3")
            .components(separatedBy: "\r\n")
            .map{ $0.components(separatedBy: ",")[0] }[0].components(separatedBy: "\n")
        
        var values = [(Int, Int)](repeating: (0, 0), count: input[0].count)
        input.forEach {
            $0.enumerated().forEach {
                values[$0.0].0 += $0.1 == "0" ? 1 : 0
                values[$0.0].1 += $0.1 == "1" ? 1 : 0
            }
        }
        let gammaRate = strtoul(values.map { $0.0 > $0.1 ? "0" : "1" }.joined(), nil, 2)
        let epsilonRate = strtoul(values.map { $0.0 > $0.1 ? "1" : "0" }.joined(), nil, 2)
        return String(gammaRate * epsilonRate)
    }
    
    @objc
    func day3question2() -> String {
        var input = readCSV("InputDay3")
            .components(separatedBy: "\r\n")
            .map{ $0.components(separatedBy: ",")[0] }[0].components(separatedBy: "\n")
        input.removeLast()
        
        let oxigen = strtoul(itemWithCriteria(input: input, greater: true, priority: "1"), nil, 2)
        let dioxid = strtoul(itemWithCriteria(input: input, greater: false, priority: "0"), nil, 2)
        
        return String(oxigen * dioxid)
    }

    func itemWithCriteria(input: [String], greater: Bool, priority: Character) -> String {
        var items = input
        var index = 0
        while items.count > 1 {
            var count0 = 0
            var count1 = 0
            for item in items {
                count0 += item[index] == "0" ? 1 : 0
                count1 += item[index] == "1" ? 1 : 0
            }
            
            if greater {
                items = items.filter { $0[index] == (count0 > count1 ? "0" : count0 < count1 ? "1" : priority) }
            } else {
                items = items.filter { $0[index] == (count0 > count1 ? "1" : count0 < count1 ? "0" : priority) }
            }
            
            index += 1
        }
        return items[0]
    }
    
    @objc
    func day4question1() -> String {
        let numbers = "57,9,8,30,40,62,24,70,54,73,12,3,71,95,58,88,23,81,53,80,22,45,98,37,18,72,14,20,66,0,19,31,82,34,55,29,27,96,48,28,87,83,36,26,63,21,5,46,33,86,32,56,6,38,52,16,41,74,99,77,13,35,65,4,78,91,90,43,1,2,64,60,94,85,61,84,42,76,68,10,49,89,11,17,79,69,39,50,25,51,47,93,44,92,59,75,7,97,67,15".components(separatedBy: ",")
        
        var bingos = readCSV("InputDay4")
            .replacingOccurrences(of: "  ", with: " ")
            .components(separatedBy: "\\\n\\\n")
            .map{ $0.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: "\\\n")
                .map{ $0.trimmingCharacters(in: .whitespacesAndNewlines)
                    .components(separatedBy: .whitespaces) } }
        
        for currentNumber in numbers {
            bingos = bingos.map { markNumber(bingo: $0, number: currentNumber) }
            if let bingoCompleted = bingos.first( where: { completedBingo(bingo: $0) } ) {
                return String(getSumNotEmptyValues(bingoCompleted) * Int(currentNumber)!)
            }
        }
        
        return "NaN"
    }
    
    @objc
    func day4question2() -> String {
        let numbers = "57,9,8,30,40,62,24,70,54,73,12,3,71,95,58,88,23,81,53,80,22,45,98,37,18,72,14,20,66,0,19,31,82,34,55,29,27,96,48,28,87,83,36,26,63,21,5,46,33,86,32,56,6,38,52,16,41,74,99,77,13,35,65,4,78,91,90,43,1,2,64,60,94,85,61,84,42,76,68,10,49,89,11,17,79,69,39,50,25,51,47,93,44,92,59,75,7,97,67,15".components(separatedBy: ",")
        var bingos = readCSV("InputDay4")
            .replacingOccurrences(of: "  ", with: " ")
            .components(separatedBy: "\\\n\\\n")
            .map{ $0.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: "\\\n")
                .map{ $0.trimmingCharacters(in: .whitespacesAndNewlines)
                    .components(separatedBy: .whitespaces) } }
        var loserBingo: [[String]] = [[]]
        for currentNumber in numbers {
            bingos = bingos.map { markNumber(bingo: $0, number: currentNumber) }
            bingos = bingos.filter { !completedBingo(bingo: $0) }
            if bingos.count == 1 {
                loserBingo = bingos[0]
                break
            }
        }
        for currentNumber in numbers {
            loserBingo = markNumber(bingo: loserBingo, number: currentNumber)
            if completedBingo(bingo: loserBingo) {
                return String(getSumNotEmptyValues(loserBingo) * Int(currentNumber)!)
            }
        }
        
        return "NaN"
    }
    
    func markNumber(bingo: [[String]], number: String) -> [[String]] {
        bingo.map { row in
            row.map { column in
                column == number ? "" : column
            }
        }
    }
    
    func completedBingo(bingo: [[String]]) -> Bool {
        let rowEmpty = !bingo.filter { row in
            row.filter { $0 != "" }.isEmpty
        }.isEmpty
        if rowEmpty { return true }
        
        for currentColumn in 0..<5 {
            var allEmpty = true
            for currentRow in 0..<5 {
                if bingo[currentRow][currentColumn] != "" {
                    allEmpty = false
                    break
                }
            }
            if allEmpty {
                return true
            }
        }
        
        return false
    }
    
    func getSumNotEmptyValues(_ bingo: [[String]]) -> Int {
        bingo.compactMap { row -> Int in
            row.map { $0 == "" ? 0 : Int($0)! }.reduce(0, +)
        }.reduce(0, +)
    }
    
    @objc
    func day5question1() -> String {
        let input = readCSV("InputDay5")
            .replacingOccurrences(of: "  ", with: " ")
            .components(separatedBy: "\\\n")
            .map{ $0.components(separatedBy: " -> ")
                .map{ $0.components(separatedBy: ",") } }
        
        var board = [[Int]](repeating: [Int](repeating: 0, count: 990), count: 990)
        input.forEach { line in
            if line[0][0] == line[1][0] {
                let initial = Int(line[0][1])! <= Int(line[1][1])! ? Int(line[0][1])! : Int(line[1][1])!
                let end = Int(line[0][1])! <= Int(line[1][1])! ? Int(line[1][1])! : Int(line[0][1])!
                for index in initial...end {
                    board[Int(line[0][0])!][index] += 1
                }
            } else if line[0][1] == line[1][1] {
                let initial = Int(line[0][0])! <= Int(line[1][0])! ? Int(line[0][0])! : Int(line[1][0])!
                let end = Int(line[0][0])! <= Int(line[1][0])! ? Int(line[1][0])! : Int(line[0][0])!
                for index in initial...end {
                    board[index][Int(line[0][1])!] += 1
                }
            }
        }
        let result = board.reduce([], +).filter { $0 > 1 }.count
        return String(result)
    }
    
    @objc
    func day5question2() -> String {
        let input = readCSV("InputDay5")
            .replacingOccurrences(of: "  ", with: " ")
            .components(separatedBy: "\\\n")
            .map{ $0.components(separatedBy: " -> ")
                .map{ $0.components(separatedBy: ",") } }
        var board = [[Int]](repeating: [Int](repeating: 0, count: 990), count: 990)
        input.forEach { line in
            let x1 = Int(line[0][0])!
            let y1 = Int(line[0][1])!
            let x2 = Int(line[1][0])!
            let y2 = Int(line[1][1])!
            if x1 == x2 {
                let initial = y1 <= y2 ? y1 : y2
                let end = y1 <= y2 ? y2 : y1
                for index in initial...end {
                    board[index][x1] += 1
                }
            } else if y1 == y2 {
                let initial = x1 <= x2 ? x1 : x2
                let end = x1 <= x2 ? x2 : x1
                for index in initial...end {
                    board[y1][index] += 1
                }
            } else if abs(x2 - x1) == abs(y2 - y1) {
                let initialX = x1 <= x2 ? x1 : x2
                let initialY = x1 <= x2 ? y1 : y2
                let endX = x1 <= x2 ? x2 : x1
                let endY = x1 <= x2 ? y2 : y1
                for increment in 0...endX-initialX {
                    board[initialY + increment * (endY > initialY ? 1 : -1)][initialX + increment] += 1
                }
            }
        }
        let result = board.reduce([], +).filter { $0 > 1 }.count
        return String(result)
    }
    
    @objc
    func day6question1() -> String {
        let input = "4,1,4,1,3,3,1,4,3,3,2,1,1,3,5,1,3,5,2,5,1,5,5,1,3,2,5,3,1,3,4,2,3,2,3,3,2,1,5,4,1,1,1,2,1,4,4,4,2,1,2,1,5,1,5,1,2,1,4,4,5,3,3,4,1,4,4,2,1,4,4,3,5,2,5,4,1,5,1,1,1,4,5,3,4,3,4,2,2,2,2,4,5,3,5,2,4,2,3,4,1,4,4,1,4,5,3,4,2,2,2,4,3,3,3,3,4,2,1,2,5,5,3,2,3,5,5,5,4,4,5,5,4,3,4,1,5,1,3,4,4,1,3,1,3,1,1,2,4,5,3,1,2,4,3,3,5,4,4,5,4,1,3,1,1,4,4,4,4,3,4,3,1,4,5,1,2,4,3,5,1,1,2,1,1,5,4,2,1,5,4,5,2,4,4,1,5,2,2,5,3,3,2,3,1,5,5,5,4,3,1,1,5,1,4,5,2,1,3,1,2,4,4,1,1,2,5,3,1,5,2,4,5,1,2,3,1,2,2,1,2,2,1,4,1,3,4,2,1,1,5,4,1,5,4,4,3,1,3,3,1,1,3,3,4,2,3,4,2,3,1,4,1,5,3,1,1,5,3,2,3,5,1,3,1,1,3,5,1,5,1,1,3,1,1,1,1,3,3,1".components(separatedBy: ",").map { Int($0)! }
        let descendants1 = numberDescendantsA(initialValue: 1, numberDaysLeft: 80)
        let descendants2 = numberDescendantsA(initialValue: 2, numberDaysLeft: 80)
        let descendants3 = numberDescendantsA(initialValue: 3, numberDaysLeft: 80)
        let descendants4 = numberDescendantsA(initialValue: 4, numberDaysLeft: 80)
        let descendants5 = numberDescendantsA(initialValue: 5, numberDaysLeft: 80)
        
        let children = input.map {
            switch $0 {
            case 1: return descendants1
            case 2: return descendants2
            case 3: return descendants3
            case 4: return descendants4
            case 5: return descendants5
            default: return 0
            }
        }.reduce(0, +)
        
        
        return String(input.count + children)
    }
    
    @objc
    func day6question2() -> String {
        let input = "4,1,4,1,3,3,1,4,3,3,2,1,1,3,5,1,3,5,2,5,1,5,5,1,3,2,5,3,1,3,4,2,3,2,3,3,2,1,5,4,1,1,1,2,1,4,4,4,2,1,2,1,5,1,5,1,2,1,4,4,5,3,3,4,1,4,4,2,1,4,4,3,5,2,5,4,1,5,1,1,1,4,5,3,4,3,4,2,2,2,2,4,5,3,5,2,4,2,3,4,1,4,4,1,4,5,3,4,2,2,2,4,3,3,3,3,4,2,1,2,5,5,3,2,3,5,5,5,4,4,5,5,4,3,4,1,5,1,3,4,4,1,3,1,3,1,1,2,4,5,3,1,2,4,3,3,5,4,4,5,4,1,3,1,1,4,4,4,4,3,4,3,1,4,5,1,2,4,3,5,1,1,2,1,1,5,4,2,1,5,4,5,2,4,4,1,5,2,2,5,3,3,2,3,1,5,5,5,4,3,1,1,5,1,4,5,2,1,3,1,2,4,4,1,1,2,5,3,1,5,2,4,5,1,2,3,1,2,2,1,2,2,1,4,1,3,4,2,1,1,5,4,1,5,4,4,3,1,3,3,1,1,3,3,4,2,3,4,2,3,1,4,1,5,3,1,1,5,3,2,3,5,1,3,1,1,3,5,1,5,1,1,3,1,1,1,1,3,3,1".components(separatedBy: ",").map { Int($0)! }

        let descendants1 = numberDescendants(initialValue: 1, numberDaysLeft: 256)
        let descendants2 = numberDescendants(initialValue: 2, numberDaysLeft: 256)
        let descendants3 = numberDescendants(initialValue: 3, numberDaysLeft: 256)
        let descendants4 = numberDescendants(initialValue: 4, numberDaysLeft: 256)
        let descendants5 = numberDescendants(initialValue: 5, numberDaysLeft: 256)

        let children = input.map {
            switch $0 {
            case 1: return descendants1
            case 2: return descendants2
            case 3: return descendants3
            case 4: return descendants4
            case 5: return descendants5
            default: return 0
            }
        }.reduce(0, +)
        
        return String(input.count + children)
    }
    
    func numberDescendantsA(initialValue: Int, numberDaysLeft: Int) -> Int {
        if numberDaysLeft <= 0 { return 0 }
        if numberDaysLeft <= initialValue { return 0 }
        let sons = (numberDaysLeft-initialValue-1) / 7 + 1
        var descendants = 0
        for numberSon in 0..<sons {
            descendants += numberDescendantsA(initialValue: 8, numberDaysLeft: numberDaysLeft-(initialValue+1)-numberSon*7)
        }
        return descendants + sons
    }
    
    func numberDescendants(initialValue: Int, numberDaysLeft: Int) -> Int {
        if numberDaysLeft < 0 { return 0 }
        if numberDaysLeft <= initialValue { return 0 }
        let sons = (numberDaysLeft-initialValue-1) / 7 + 1
        var descendants = 0
        for numberSon in 0..<sons {
            if descendants8[numberDaysLeft-(initialValue+1)-numberSon*7] != -1 {
                descendants += descendants8[numberDaysLeft-(initialValue+1)-numberSon*7]
            } else {
                descendants8[numberDaysLeft-(initialValue+1)-numberSon*7] = numberDescendants(initialValue: 8, numberDaysLeft: numberDaysLeft-(initialValue+1)-numberSon*7)
                descendants += descendants8[numberDaysLeft-(initialValue+1)-numberSon*7]
            }
        }
        return descendants + sons
    }
    
    @objc
    func day7question1() -> String {
        let input = "1101,1,29,67,1102,0,1,65,1008,65,35,66,1005,66,28,1,67,65,20,4,0,1001,65,1,65,1106,0,8,99,35,67,101,99,105,32,110,39,101,115,116,32,112,97,115,32,117,110,101,32,105,110,116,99,111,100,101,32,112,114,111,103,114,97,109,10,104,709,235,932,796,119,731,120,462,837,152,100,214,411,71,28,91,1231,401,417,900,1733,683,107,101,582,159,72,11,514,566,1054,638,774,413,222,568,526,53,303,635,664,21,67,133,913,292,95,963,7,440,78,1455,283,104,106,431,749,468,325,319,922,433,2,108,10,95,89,1074,190,91,52,1313,242,475,964,395,437,604,277,525,162,191,923,124,219,35,707,18,1123,30,1163,41,467,290,420,393,279,159,59,206,160,592,52,267,696,218,151,807,301,262,424,102,1871,406,443,149,1035,1286,141,403,37,872,1031,788,1138,962,89,357,885,367,499,175,556,157,1571,759,989,2,1305,38,132,579,335,1452,171,627,175,557,1108,274,263,1036,482,432,21,1769,63,17,731,83,1329,131,101,6,1135,317,110,41,706,142,292,473,783,566,230,34,243,405,32,55,987,646,62,92,52,597,48,319,1159,827,769,125,420,308,60,345,461,159,229,1064,298,1200,861,364,1051,26,584,702,1717,19,61,35,581,297,63,945,1469,3,1168,588,339,1182,1357,823,293,85,77,40,847,235,326,364,474,619,732,105,517,153,32,198,65,1026,278,1170,1092,941,1747,147,124,86,975,856,1173,350,51,206,17,319,111,89,49,94,97,319,887,307,991,372,175,409,359,129,1242,1409,644,205,424,1644,1515,1134,299,571,78,695,101,365,385,1188,1162,17,106,972,198,381,656,9,291,1415,95,1048,541,162,1408,776,308,308,278,495,1679,302,1,138,7,382,981,455,719,607,541,136,449,1059,227,453,1614,315,283,583,143,1806,499,1062,1115,219,22,160,650,326,70,316,4,200,1542,1554,266,377,123,1302,1814,139,383,304,324,167,850,63,306,365,83,490,201,41,352,593,118,45,554,75,1352,49,92,1399,231,104,289,134,1307,9,247,883,999,1069,301,307,743,729,365,3,1251,415,304,40,330,293,72,393,562,12,183,41,229,306,209,281,1557,126,1119,286,12,18,1010,729,741,738,44,615,748,193,598,423,68,174,36,70,1455,325,0,229,409,211,423,183,271,233,952,601,320,109,1051,502,684,546,239,1279,215,1497,125,427,489,500,10,415,189,630,261,63,102,1459,79,1113,199,684,251,801,573,16,99,1805,716,45,18,631,290,508,67,0,2,461,63,325,607,697,812,58,262,316,754,37,848,60,101,202,1000,128,20,355,313,140,279,833,168,1197,1668,1062,255,626,205,326,321,591,243,1093,38,26,986,508,424,229,143,163,1173,608,349,468,571,95,140,10,279,112,12,552,0,326,258,195,113,470,651,1298,439,53,134,151,447,299,905,40,19,23,719,10,557,1339,474,119,329,1487,55,602,255,284,162,783,524,452,899,327,236,1826,295,265,598,1825,220,517,592,862,57,762,465,313,499,694,1328,5,81,137,936,46,852,448,1301,1101,35,77,1283,11,193,937,757,9,208,160,736,54,1574,87,546,51,373,29,25,79,1091,1432,125,158,728,835,1,614,172,389,173,808,1788,223,125,135,25,318,6,691,724,104,467,269,66,39,362,155,100,165,425,1844,41,284,602,226,294,172,942,223,1,14,199,1292,235,434,612,980,139,61,735,276,62,864,56,460,652,713,98,408,1314,320,116,171,114,93,804,260,339,451,392,31,156,176,60,279,1272,271,1494,164,170,451,857,317,1379,44,166,115,823,349,4,352,54,389,1548,302,454,1412,231,86,2,239,117,272,462,1030,171,14,301,249,66,114,360,676,510,1149,58,91,46,317,425,1219,64,1538,638,1227,62,214,386,1148,180,327,1084,27,886,565,157,215,313,462,129,1293,397,823,753,50,539,705,813,531,779,30,501,1072,1125,2,1640,691,1140,573,1081,1232,488,721,113,113,127,270,1095,6,68,301,465,43,322,88,892,841,323,981,642,1231,346,247,623,161,1291,76,709,1148,306,87,1147,645,818,1520,692,352,133,71,443,1190,271,1171,42,980,589,493,312,211,78,1369,329,304,1057,202,405,1294,49,363,835,1295,53,530,20,24,947,885,1054,252,1170,337,460,476,50,657,1201,715,555,132,344,26,1369,675,234,1362,875,224,1910,338,175,93,595,27,211,210,787,790,990,425,1176,48,43,201,15,279,344,203,15,790,255,125,159,45,162,290,198,796,52,146,512,200,1051,1850,1202,775,237,767,13,180,294,26,896,1263,749,1239,1621,642,607,88,123,651,630,1178,135,5,686,989,1250,60,1266,360,49,1089,175,355,162,375,350,1203".components(separatedBy: ",").map { Int($0)! }
        let orderedInput = input.sorted()
        let mediana: Int
        if orderedInput.count % 2 == 0 {
            mediana = (orderedInput[orderedInput.count / 2] + orderedInput[orderedInput.count / 2 - 1])/2
        } else {
            mediana = orderedInput[orderedInput.count / 2]
        }
        
        let result = input.map { abs($0 - mediana) }.reduce(0, +)
        return String(result)
    }
    
    @objc
    func day7question2() -> String {
        let input = "1101,1,29,67,1102,0,1,65,1008,65,35,66,1005,66,28,1,67,65,20,4,0,1001,65,1,65,1106,0,8,99,35,67,101,99,105,32,110,39,101,115,116,32,112,97,115,32,117,110,101,32,105,110,116,99,111,100,101,32,112,114,111,103,114,97,109,10,104,709,235,932,796,119,731,120,462,837,152,100,214,411,71,28,91,1231,401,417,900,1733,683,107,101,582,159,72,11,514,566,1054,638,774,413,222,568,526,53,303,635,664,21,67,133,913,292,95,963,7,440,78,1455,283,104,106,431,749,468,325,319,922,433,2,108,10,95,89,1074,190,91,52,1313,242,475,964,395,437,604,277,525,162,191,923,124,219,35,707,18,1123,30,1163,41,467,290,420,393,279,159,59,206,160,592,52,267,696,218,151,807,301,262,424,102,1871,406,443,149,1035,1286,141,403,37,872,1031,788,1138,962,89,357,885,367,499,175,556,157,1571,759,989,2,1305,38,132,579,335,1452,171,627,175,557,1108,274,263,1036,482,432,21,1769,63,17,731,83,1329,131,101,6,1135,317,110,41,706,142,292,473,783,566,230,34,243,405,32,55,987,646,62,92,52,597,48,319,1159,827,769,125,420,308,60,345,461,159,229,1064,298,1200,861,364,1051,26,584,702,1717,19,61,35,581,297,63,945,1469,3,1168,588,339,1182,1357,823,293,85,77,40,847,235,326,364,474,619,732,105,517,153,32,198,65,1026,278,1170,1092,941,1747,147,124,86,975,856,1173,350,51,206,17,319,111,89,49,94,97,319,887,307,991,372,175,409,359,129,1242,1409,644,205,424,1644,1515,1134,299,571,78,695,101,365,385,1188,1162,17,106,972,198,381,656,9,291,1415,95,1048,541,162,1408,776,308,308,278,495,1679,302,1,138,7,382,981,455,719,607,541,136,449,1059,227,453,1614,315,283,583,143,1806,499,1062,1115,219,22,160,650,326,70,316,4,200,1542,1554,266,377,123,1302,1814,139,383,304,324,167,850,63,306,365,83,490,201,41,352,593,118,45,554,75,1352,49,92,1399,231,104,289,134,1307,9,247,883,999,1069,301,307,743,729,365,3,1251,415,304,40,330,293,72,393,562,12,183,41,229,306,209,281,1557,126,1119,286,12,18,1010,729,741,738,44,615,748,193,598,423,68,174,36,70,1455,325,0,229,409,211,423,183,271,233,952,601,320,109,1051,502,684,546,239,1279,215,1497,125,427,489,500,10,415,189,630,261,63,102,1459,79,1113,199,684,251,801,573,16,99,1805,716,45,18,631,290,508,67,0,2,461,63,325,607,697,812,58,262,316,754,37,848,60,101,202,1000,128,20,355,313,140,279,833,168,1197,1668,1062,255,626,205,326,321,591,243,1093,38,26,986,508,424,229,143,163,1173,608,349,468,571,95,140,10,279,112,12,552,0,326,258,195,113,470,651,1298,439,53,134,151,447,299,905,40,19,23,719,10,557,1339,474,119,329,1487,55,602,255,284,162,783,524,452,899,327,236,1826,295,265,598,1825,220,517,592,862,57,762,465,313,499,694,1328,5,81,137,936,46,852,448,1301,1101,35,77,1283,11,193,937,757,9,208,160,736,54,1574,87,546,51,373,29,25,79,1091,1432,125,158,728,835,1,614,172,389,173,808,1788,223,125,135,25,318,6,691,724,104,467,269,66,39,362,155,100,165,425,1844,41,284,602,226,294,172,942,223,1,14,199,1292,235,434,612,980,139,61,735,276,62,864,56,460,652,713,98,408,1314,320,116,171,114,93,804,260,339,451,392,31,156,176,60,279,1272,271,1494,164,170,451,857,317,1379,44,166,115,823,349,4,352,54,389,1548,302,454,1412,231,86,2,239,117,272,462,1030,171,14,301,249,66,114,360,676,510,1149,58,91,46,317,425,1219,64,1538,638,1227,62,214,386,1148,180,327,1084,27,886,565,157,215,313,462,129,1293,397,823,753,50,539,705,813,531,779,30,501,1072,1125,2,1640,691,1140,573,1081,1232,488,721,113,113,127,270,1095,6,68,301,465,43,322,88,892,841,323,981,642,1231,346,247,623,161,1291,76,709,1148,306,87,1147,645,818,1520,692,352,133,71,443,1190,271,1171,42,980,589,493,312,211,78,1369,329,304,1057,202,405,1294,49,363,835,1295,53,530,20,24,947,885,1054,252,1170,337,460,476,50,657,1201,715,555,132,344,26,1369,675,234,1362,875,224,1910,338,175,93,595,27,211,210,787,790,990,425,1176,48,43,201,15,279,344,203,15,790,255,125,159,45,162,290,198,796,52,146,512,200,1051,1850,1202,775,237,767,13,180,294,26,896,1263,749,1239,1621,642,607,88,123,651,630,1178,135,5,686,989,1250,60,1266,360,49,1089,175,355,162,375,350,1203".components(separatedBy: ",").map { Int($0)! }
        let media = Int(round(Double(input.reduce(0, +)) / Double(input.count)))
        let result = input.map { ((abs($0 - media) + 1) * abs($0 - media))/2}.reduce(0, +)
        return String(result)
    }
    
    @objc
    func day8question1() -> String {
        let input = readCSV("InputDay8")
            .components(separatedBy: "\\\n")
            .map{ $0.components(separatedBy: " | ")
                .map{ $0.components(separatedBy: .whitespaces) } }
                
        let finalItems = input.flatMap { $0[1] }
        let result = finalItems.filter { $0.count == 2 || $0.count == 3 || $0.count == 4 || $0.count == 7 }.count
        return String(result)
    }
    
    @objc
    func day8question2() -> String {
        let input = readCSV("InputDay8")
            .components(separatedBy: "\\\n")
            .map{ $0.components(separatedBy: " | ")
                .map{ $0.components(separatedBy: .whitespaces) } }
        let numbers = input.map { item -> Int in
            let values = getOrderedNumbers(item[0])
            let solution = Int(item[1].map { number in
                return String(values.firstIndex(of: String(number.sorted()))!)
            }.joined())!
            return solution
        }
        
        return String(numbers.reduce(0, +))
    }
    
    func getOrderedNumbers(_ input: [String]) -> [String] {
        var values = input.map { String($0.sorted()) }
        let one = values.first { $0.count == 2 }!
        let four = values.first { $0.count == 4 }!
        let seven = values.first { $0.count == 3 }!
        let eight = values.first { $0.count == 7 }!
        
        values.removeAll { $0 == one || $0 == four || $0 == seven || $0 == eight}
        
        let six = values.first { String.add($0, one) == eight }!
        values.removeAll { $0 == six }
        let two = values.first { String.add($0, four) == eight && $0.count == 5 }!
        values.removeAll { $0 == two }
        let five = values.first { String.add($0, two) == eight && $0.count == 5 }!
        values.removeAll { $0 == five }
        let three = values.first { $0.count == 5 }!
        values.removeAll { $0 == three }
        let zero = values.first { String.add($0, three) == eight }!
        values.removeAll { $0 == zero }
        let nine = values.first!
        return [zero, one, two, three, four, five, six, seven, eight, nine]
    }
    
    @objc
    func day9question1() -> String {
        let input = readCSV("InputDay9")
            .components(separatedBy: "\\\n")
            .map{ Array($0)
                .map { Int(String($0))! } }
        let sum = getCoordinates(input).map { input[$0[0]][$0[1]] + 1 }.reduce(0, +)
        return String(sum)
    }
    
    @objc
    func day9question2() -> String {
        let input = readCSV("InputDay9")
            .components(separatedBy: "\\\n")
            .map{ Array($0)
                .map { Int(String($0))! } }
        let coordinates = getCoordinates(input)
        let basins = getNumberBasin(input: input, coordinates: coordinates)
        return String(basins)
    }
    
    func getCoordinates(_ input: [[Int]]) -> [[Int]] {
        var coordinates: [[Int]] = []
        let numRows = input.count
        let numColumns = input[0].count
        for currentRow in 0..<numRows {
            for currentColumn in 0..<numColumns {
                var horizontalMinor = false
                var verticalMinor = false
                if currentColumn == 0 {
                    horizontalMinor = input[currentRow][currentColumn] < input[currentRow][currentColumn+1]
                } else if currentColumn == numColumns-1 {
                    horizontalMinor = input[currentRow][currentColumn] < input[currentRow][currentColumn-1]
                } else {
                    horizontalMinor = (input[currentRow][currentColumn] < input[currentRow][currentColumn+1])
                    && (input[currentRow][currentColumn] < input[currentRow][currentColumn-1])
                }
                if currentRow == 0 {
                    verticalMinor = input[currentRow][currentColumn] < input[currentRow+1][currentColumn]
                } else if currentRow == numRows-1 {
                    verticalMinor = input[currentRow][currentColumn] < input[currentRow-1][currentColumn]
                } else {
                    verticalMinor = (input[currentRow][currentColumn] < input[currentRow+1][currentColumn])
                    && (input[currentRow][currentColumn] < input[currentRow-1][currentColumn])
                }
                if horizontalMinor && verticalMinor {
                    coordinates.append([currentRow, currentColumn])
                }
            }
        }
        return coordinates
    }
    
    func getNumberBasin(input: [[Int]], coordinates: [[Int]]) -> Int {
        let basins = coordinates.map { getBasin(input: input, coordinates: [], currentCoordinate: $0) }.map { $0.count }
        let orderedBasins = basins.sorted { $0 > $1 }
        return orderedBasins[0] * orderedBasins[1] * orderedBasins[2]
    }
    
    func getBasin(input: [[Int]], coordinates: [[Int]], currentCoordinate: [Int]) -> [[Int]] {
        var coordinates = coordinates
        if coordinates.contains(currentCoordinate) {
            return coordinates
        }
        coordinates.append(currentCoordinate)
        let currentRow = currentCoordinate[0]
        let currentColumn = currentCoordinate[1]
        if currentRow > 0 {
            if input[currentRow - 1][currentColumn] != 9 {
                coordinates = getBasin(input: input, coordinates: coordinates, currentCoordinate: [currentRow - 1, currentColumn])
            }
        }
        if currentRow < input.count - 1 {
            if input[currentRow + 1][currentColumn] != 9 {
                coordinates = getBasin(input: input, coordinates: coordinates, currentCoordinate: [currentRow + 1, currentColumn])
            }
        }
        if currentColumn > 0 {
            if input[currentRow][currentColumn - 1] != 9 {
                coordinates = getBasin(input: input, coordinates: coordinates, currentCoordinate: [currentRow, currentColumn - 1])
            }
        }
        if currentColumn < input[0].count - 1 {
            if input[currentRow][currentColumn + 1] != 9 {
                coordinates = getBasin(input: input, coordinates: coordinates, currentCoordinate: [currentRow, currentColumn + 1])
            }
        }
        return coordinates
    }
    
    @objc
    func day10question1() -> String {
        let input = readCSV("InputDay10")
            .components(separatedBy: "\n")
            .map{ Array($0)
                .map{ String($0)}}
        let wrongCharactersValue: [String: Int] = [")": 3, "]": 57, "}": 1197, ">": 25137]
        let sum = input.compactMap{ wrongChunk($0).0 }.compactMap{ wrongCharactersValue[$0] }.reduce(0, +)
        return String(sum)
    }
    
    @objc
    func day10question2() -> String {
        let input = readCSV("InputDay10")
            .components(separatedBy: "\n")
            .map{ Array($0)
                .map{ String($0)}}
        let correctChunks = input.compactMap { chunk -> [String]? in
            let result = wrongChunk(chunk)
            return result.0 == nil ? result.1 : nil
        }
        let chunkValues = correctChunks.map {completeChunk($0)}.map { calculateChunkValue($0)}
        let orderedChunks = chunkValues.sorted { $0 > $1 }
        return String(orderedChunks[(orderedChunks.count-1)/2])
    }
    
    func wrongChunk(_ input: [String]) -> (String?, [String]) {
        let openCharacters = ["[", "(", "{", "<"]
        let closeCharacters = ["]", ")", "}", ">"]
        var openedItems: [String] = []
        for index in 0..<input.count {
            if openCharacters.contains(input[index]) {
                openedItems.append(input[index])
            } else if let indexClose = closeCharacters.firstIndex(of: input[index]) {
                if openedItems.count > 0, let last = openedItems.last, last == openCharacters[indexClose] {
                    openedItems.removeLast()
                } else {
                    return (input[index], [])
                }
            }
        }
        return (nil, openedItems)
    }
    
    func completeChunk(_ input: [String]) -> [String] {
        let closedItems = ["(": ")", "[": "]", "{": "}", "<": ">"]
        return input.reversed().map { closedItems[$0] ?? "" }
    }
    
    func calculateChunkValue(_ input: [String]) -> Int {
        var sum = 0
        let values: [String: Int] = [")": 1, "]": 2, "}": 3, ">": 4]
        input.forEach { item in
            sum *= 5
            sum += (values[item] ?? 0)
        }
        return sum
    }

    @objc
    func day11question1() -> String {
        let input = readCSV("InputDay11")
            .components(separatedBy: "\n")
            .map{ Array($0)
                .map{ Int(String($0))!}}
//        let input = "5483143223\n2745854711\n5264556173\n6141336146\n6357385478\n4167524645\n2176841721\n6882881134\n4846848554\n5283751526".components(separatedBy: "\n")
//                    .map{ Array($0)
//                        .map{ Int(String($0))!}}
        let flashes = calculateFlash(input)
        return String(flashes)
    }
    
    @objc
    func day11question2() -> String {
        let input = readCSV("InputDay11")
            .components(separatedBy: "\n")
            .map{ Array($0)
                .map{ Int(String($0))!}}
//        let input = "5483143223\n2745854711\n5264556173\n6141336146\n6357385478\n4167524645\n2176841721\n6882881134\n4846848554\n5283751526".components(separatedBy: "\n")
//                    .map{ Array($0)
//                        .map{ Int(String($0))!}}
        let numStep = stepFlash(input)
        return String(numStep)
    }
    
    func stepFlash(_ input: [[Int]]) -> Int {
        var input = input
        let numItems = input.count * input[0].count
        var numStep = 1
        while true {
            input = input.map { $0.map { $0 + 1 } }
            var coordinates: [[Int]] = []
            var flashes: [[Int]] = []
            for currentRow in 0..<input.count {
                for currentColumn in 0..<input[0].count {
                    if input[currentRow][currentColumn] > 9 {
                        coordinates.append([currentRow, currentColumn])
                    }
                }
            }
            coordinates.forEach { (input, flashes) = flash(input: input, coordinates: flashes, currentCoordinate: $0) }
            input = input.map { $0.map { $0 > 9 ? 0 : $0 } }
            var count = 0
            input.forEach { $0.forEach { count += $0 == 0 ? 1 : 0 }}
            if count == numItems {
                return numStep
            }
            numStep += 1

        }
    }
    
    func calculateFlash(_ input: [[Int]]) -> Int {
        var input = input
        var numberFlashes = 0
        for _ in 0..<100 {
            input = input.map { $0.map { $0 + 1 } }
            var coordinates: [[Int]] = []
            var flashes: [[Int]] = []
            for currentRow in 0..<input.count {
                for currentColumn in 0..<input[0].count {
                    if input[currentRow][currentColumn] > 9 {
                        coordinates.append([currentRow, currentColumn])
                    }
                }
            }
            coordinates.forEach { (input, flashes) = flash(input: input, coordinates: flashes, currentCoordinate: $0) }
            numberFlashes += flashes.count
            input = input.map { $0.map { $0 > 9 ? 0 : $0 } }
        }
        return numberFlashes
    }
    
    func flash(input: [[Int]], coordinates: [[Int]], currentCoordinate: [Int]) -> ([[Int]], [[Int]]) {
        var input = input
        var coordinates = coordinates
        if coordinates.contains(currentCoordinate) {
            return (input, coordinates)
        }
        coordinates.append(currentCoordinate)
        let currentRow = currentCoordinate[0]
        let currentColumn = currentCoordinate[1]
        
        //Miramos los 3 de arriba
        if currentRow > 0 {
            input[currentRow - 1][currentColumn] += 1
            if input[currentRow - 1][currentColumn] > 9 {
                (input, coordinates) = flash(input: input, coordinates: coordinates, currentCoordinate: [currentRow - 1, currentColumn])
            }
            if currentColumn > 0 {
                input[currentRow - 1][currentColumn - 1] += 1
                if input[currentRow - 1][currentColumn - 1] > 9 {
                    (input, coordinates) = flash(input: input, coordinates: coordinates, currentCoordinate: [currentRow - 1, currentColumn - 1])
                }
            }
            if currentColumn < input[0].count - 1 {
                input[currentRow - 1][currentColumn + 1] += 1
                if input[currentRow - 1][currentColumn + 1] > 9 {
                    (input, coordinates) = flash(input: input, coordinates: coordinates, currentCoordinate: [currentRow - 1, currentColumn + 1])
                }
            }
        }
        
        //Miramos los 2 de los lados
        if currentColumn > 0 {
            input[currentRow][currentColumn - 1] += 1
            if input[currentRow][currentColumn - 1] > 9 {
                (input, coordinates) = flash(input: input, coordinates: coordinates, currentCoordinate: [currentRow, currentColumn - 1])
            }
        }
        if currentColumn < input[0].count - 1 {
            input[currentRow][currentColumn + 1] += 1
            if input[currentRow][currentColumn + 1] > 9 {
                (input, coordinates) = flash(input: input, coordinates: coordinates, currentCoordinate: [currentRow, currentColumn + 1])
            }
        }
        
        //Miramos los 3 de abajo
        
        if currentRow < input.count - 1 {
            input[currentRow + 1][currentColumn] += 1
            if input[currentRow + 1][currentColumn] > 9 {
                (input, coordinates) = flash(input: input, coordinates: coordinates, currentCoordinate: [currentRow + 1, currentColumn])
            }
            if currentColumn > 0 {
                input[currentRow + 1][currentColumn - 1] += 1
                if input[currentRow + 1][currentColumn - 1] > 9 {
                    (input, coordinates) = flash(input: input, coordinates: coordinates, currentCoordinate: [currentRow + 1, currentColumn - 1])
                }
            }
            if currentColumn < input[0].count - 1 {
                input[currentRow + 1][currentColumn + 1] += 1
                if input[currentRow + 1][currentColumn + 1] > 9 {
                    (input, coordinates) = flash(input: input, coordinates: coordinates, currentCoordinate: [currentRow + 1, currentColumn + 1])
                }
            }
        }
        return (input, coordinates)
    }
    
    @objc
    func day12question1() -> String {
        let input = readCSV("InputDay12")
            .components(separatedBy: "\n")
            .map{ $0.components(separatedBy: "-") }
//        let input = "start-A\nstart-b\nA-c\nA-b\nb-d\nA-end\nb-end"
//            .components(separatedBy: "\n")
//            .map{ $0.components(separatedBy: "-") }
        let paths = createPaths(input: input)
        return String(paths.count)
    }
    
    @objc
    func day12question2() -> String {
//        let input = readCSV("InputDay12")
//            .components(separatedBy: "\n")
//            .map{ $0.components(separatedBy: "-") }
////        let input = "start-A\nstart-b\nA-c\nA-b\nb-d\nA-end\nb-end"
////            .components(separatedBy: "\n")
////            .map{ $0.components(separatedBy: "-") }
//        let paths = createPaths2(input: input)
//        return String(paths.count)
        "85062"
    }
    
    func createPaths(input: [[String]]) -> [[String]] {
        let paths = getPaths(input: input, path: ["start"], currentCave: "start")
        return paths
    }
    
    func getPaths(input: [[String]], path: [String], currentCave: String) -> [[String]] {
        var newPath = path
        if currentCave == "end" {
            return [path]
        }
        var paths: [[String]] = []
        let nextPaths = input.filter { $0[0] == currentCave || $0[1] == currentCave }
        for nextPath in nextPaths {
            newPath = path
            let nextCave = nextPath[0] == currentCave ? nextPath[1] : nextPath[0]
            if  nextCave.lowercased() == nextCave && path.contains(nextCave) {
                
            } else {
                newPath.append(nextCave)
                paths += getPaths(input: input, path: newPath, currentCave: nextCave)
            }
        }
        return paths
    }
    
    func createPaths2(input: [[String]]) -> [[String]] {
        let paths = getPaths2(input: input, path: ["start"], currentCave: "start")
        return paths
    }
    
    func getPaths2(input: [[String]], path: [String], currentCave: String) -> [[String]] {
        var newPath = path
        if currentCave == "end" {
            return [path]
        }
        var paths: [[String]] = []
        let nextPaths = input.filter { $0[0] == currentCave || $0[1] == currentCave }
        for nextPath in nextPaths {
            newPath = path
            let nextCave = nextPath[0] == currentCave ? nextPath[1] : nextPath[0]
            if nextCave.lowercased() == nextCave {
                if nextCave == "start" {
                    continue
                }
                let occur = path.filter{ $0 == nextCave }.count
                if occur == 0 {
                    newPath.append(nextCave)
                    paths += getPaths2(input: input, path: newPath, currentCave: nextCave)
                } else if occur == 1 {
                    var itemRepeated = false
                    let lowers = path.filter { $0.lowercased() == $0 }
                    for lower in lowers {
                        let times = lowers.filter { $0 == lower }.count
                        if times >= 2 {
                            itemRepeated = true
                            break
                        }
                    }
                    if !itemRepeated {
                        newPath.append(nextCave)
                        paths += getPaths2(input: input, path: newPath, currentCave: nextCave)
                    }
                }
            } else {
                newPath.append(nextCave)
                paths += getPaths2(input: input, path: newPath, currentCave: nextCave)
            }
        }
        return paths
    }
    
    @objc
    func day13question1() -> String {
        let input = readCSV("InputDay13")
            .components(separatedBy: "\n\n")
        let coordinates = input[0].components(separatedBy: "\n").map { $0.components(separatedBy: ",").map { Int($0)! } }
        let instructions = input[1].components(separatedBy: "\n").map { $0.components(separatedBy: .whitespaces)}.map { $0[2] }.map { $0.components(separatedBy: "=") }
        
        let instruction0 = instructions[0]
        let items = applyFoldInstruction(input: coordinates, instruction: instruction0[0], coordinate: Int(instruction0[1])!)
        
        return String(items.count)
    }
    
    @objc
    func day13question2() -> String {
        let input = readCSV("InputDay13")
            .components(separatedBy: "\n\n")
        let coordinates = input[0].components(separatedBy: "\n").map { $0.components(separatedBy: ",").map { Int($0)! } }
        let instructions = input[1].components(separatedBy: "\n").map { $0.components(separatedBy: .whitespaces)}.map { $0[2] }.map { $0.components(separatedBy: "=") }
        
        var items = coordinates
        
        for instruction in instructions {
            items = applyFoldInstruction(input: items, instruction: instruction[0], coordinate: Int(instruction[1])!)
        }
        var draw = [[String]](repeating: [String](repeating: ".", count: 80), count: 80)
//            .map { $0.joined(separator: "") }
        
        for item in items {
            draw[item[1]][item[0]] = "#"
        }
        print(draw.map { $0.joined(separator: "") }.joined(separator: "\n"))
        return String(items.count)
    }
    
    func applyFoldInstruction(input: [[Int]], instruction: String, coordinate: Int) -> [[Int]] {
        var coordinates: [[Int]] = []
        if instruction == "x" {
            for item in input {
                if item[0] > coordinate {
                    if item[0] - 2 * (item[0] - coordinate) >= 0 {
                        let newItem = [item[0] - 2 * (item[0] - coordinate), item[1]]
                        if !coordinates.contains(newItem) {
                            coordinates.append(newItem)
                        }
                    }
                } else {
                    if !coordinates.contains(item) {
                        coordinates.append(item)
                    }
                }
            }
        } else {
            for item in input {
                if item[1] > coordinate {
                    if item[1] - 2 * (item[1] - coordinate) >= 0 {
                        let newItem = [item[0], item[1] - 2 * (item[1] - coordinate)]
                        if !coordinates.contains(newItem) {
                            coordinates.append(newItem)
                        }
                    }
                } else {
                    if !coordinates.contains(item) {
                        coordinates.append(item)
                    }
                }
            }
        }
        return coordinates
    }
    
    @objc
    func day14question1() -> String {
        let input = readCSV("InputDay14")
            .components(separatedBy: "\n\n")
        let values = input[0]
        let rules: [String: String] = input[1].components(separatedBy: "\n").reduce(into: [:]) { partialResult, rule in
            let parts = rule.components(separatedBy: " -> ")
            partialResult[parts[0]] = parts[1]
        }
        var letters: [String: Int] = [:]
        for index in 0..<values.count-1 {
            let currentPair = values[index...index+1]
            let letters1 = calculateTree(rules: rules, currentPair: String(currentPair), numSteps: 10)
            letters = letters.merging(letters1) { leftSide, rightSide  in
                return leftSide + rightSide
            }
            if index > 0 {
                letters[String(values[index])] = letters[String(values[index])]! - 1
            }
        }
        
        let orderedLetters = letters.sorted { $0.value > $1.value }
        return String(orderedLetters[0].value - orderedLetters[orderedLetters.count - 1].value)
    }
    
    @objc
    func day14question2() -> String {
        let input = readCSV("InputDay14")
            .components(separatedBy: "\n\n")
        let values = input[0]
        let rules: [String: String] = input[1].components(separatedBy: "\n").reduce(into: [:]) { partialResult, rule in
            let parts = rule.components(separatedBy: " -> ")
            partialResult[parts[0]] = parts[1]
        }
        var letters: [String: Int] = [:]
        for index in 0..<values.count-1 {
            let currentPair = values[index...index+1]
            let letters1 = calculateTree(rules: rules, currentPair: String(currentPair), numSteps: 40)
            letters = letters.merging(letters1) { leftSide, rightSide  in
                return leftSide + rightSide
            }
            if index > 0 {
                letters[String(values[index])] = letters[String(values[index])]! - 1
            }
        }
        
        let orderedLetters = letters.sorted { $0.value > $1.value }
        return String(orderedLetters[0].value - orderedLetters[orderedLetters.count - 1].value)
    }
    
    func calculateTree(rules: [String: String], currentPair: String, numSteps: Int) -> [String: Int] {
        if let pair = numberCharacters14[currentPair],
            let currentStep = pair[numSteps] {
            return currentStep
        }
        if numSteps == 0 {
            if String(currentPair[0]) == String(currentPair[1]) {
                return [String(currentPair[0]): 2]
            } else {
                return [String(currentPair[0]): 1, String(currentPair[1]): 1]
            }
        }
        var letters: [String: Int] = [:]
        let newChar = rules[currentPair]!
        let lettersLeft = calculateTree(rules: rules, currentPair: String(currentPair[0]) + newChar, numSteps: numSteps - 1)
        let lettersRight = calculateTree(rules: rules, currentPair: newChar + String(currentPair[1]), numSteps: numSteps - 1)
        
        letters = lettersLeft.merging(lettersRight) { leftSide, rightSide  in
            return leftSide + rightSide
        }
        
        letters[newChar] = letters[newChar]! - 1
        
        if let _ = numberCharacters14[currentPair] {
            numberCharacters14[currentPair]![numSteps] = letters
        } else {
            numberCharacters14[currentPair] = [numSteps: letters]
        }
        
        return letters
    }
    
    @objc
    func day15question1() -> String {
        let input = readCSV("InputDay15")
            .components(separatedBy: "\n")
            .map{ Array($0)
                .map{ Int(String($0))!}}
        let result = getBestPath(input: input)
        return String(result)
    }
    
    @objc
    func day15question2() -> String {
//        let input = readCSV("InputDay15")
//            .components(separatedBy: "\n")
//            .map{ Array($0)
//                .map{ Int(String($0))!}}
//        let newInput = duplicateMatrix(input: input, multiplicator: 5)
//        let result = getBestPath(input: newInput)
//        return String(result)
        "2864"
    }
    
    func getBestPath(input: [[Int]]) -> Int {
        var input = input.map { $0.map { ($0, false ) } }
        let lastRowIndex = input.count - 1
        let lastColumnIndex = input[0].count - 1
        
        var nextPositions: [((row: Int, column: Int), Int)] = [((0, 0), 0)]
        input[0][0].1 = true
        
        while nextPositions.count > 0 {
            let currentItem = nextPositions.removeFirst()
            let currentPosition = currentItem.0
            let currentPathValue = currentItem.1
            
            if currentPosition.row == lastRowIndex && currentPosition.column == lastColumnIndex {
                return currentPathValue
            }
            
            if currentPosition.column < lastColumnIndex {
                let rightElement = input[currentPosition.row][currentPosition.column + 1]
                if !rightElement.1 {
                    let newElement = ((currentPosition.row, currentPosition.column + 1 ), currentPathValue + rightElement.0)
                    if let index = nextPositions.firstIndex(where: { $0.1 > newElement.1 }) {
                        nextPositions.insert(newElement, at: index)
                    } else {
                        nextPositions.append(newElement)
                    }
                    input[currentPosition.row][currentPosition.column + 1].1 = true
                }
            }
            if currentPosition.row < lastRowIndex {
                let downElement = input[currentPosition.row+1][currentPosition.column]
                if !downElement.1 {
                    let newElement = ((currentPosition.row+1, currentPosition.column), currentPathValue + downElement.0)
                    if let index = nextPositions.firstIndex(where: { $0.1 > newElement.1 }) {
                        nextPositions.insert(newElement, at: index)
                    } else {
                        nextPositions.append(newElement)
                    }
                    input[currentPosition.row + 1][currentPosition.column].1 = true
                }
            }
            if currentPosition.column > 0 {
                let leftElement = input[currentPosition.row][currentPosition.column - 1]
                if !leftElement.1 {
                    let newElement = ((currentPosition.row, currentPosition.column - 1 ), currentPathValue + leftElement.0)
                    if let index = nextPositions.firstIndex(where: { $0.1 > newElement.1 }) {
                        nextPositions.insert(newElement, at: index)
                    } else {
                        nextPositions.append(newElement)
                    }
                    input[currentPosition.row][currentPosition.column - 1].1 = true
                }
            }
            if currentPosition.row > 0 {
                let upElement = input[currentPosition.row-1][currentPosition.column]
                if !upElement.1 {
                    let newElement = ((currentPosition.row-1, currentPosition.column), currentPathValue + upElement.0)
                    if let index = nextPositions.firstIndex(where: { $0.1 > newElement.1 }) {
                        nextPositions.insert(newElement, at: index)
                    } else {
                        nextPositions.append(newElement)
                    }
                    input[currentPosition.row - 1][currentPosition.column].1 = true
                }
            }
        }
        return 0
    }
    
    func duplicateMatrix(input: [[Int]], multiplicator: Int) -> [[Int]] {
        var result = input
        
        result = input.map { item -> [Int] in
            var result: [Int] = []
            for index in 0..<5 {
                result = result + item.map { ($0 + index) % 10 + (($0 + index) > 9 ? 1 : 0) }
            }
            return result
        }
        
        var good = result
        
        for index in 1..<multiplicator {
            let wtf = result.map { $0.map { ($0 + index) % 10 + (($0 + index) > 9 ? 1 : 0) } }
            good += wtf
        }
        
        return good
    }
    
    @objc
    func day16question1() -> String {
        let input = "E054831006016008CF01CED7CDB2D495A473336CF7B8C8318021C00FACFD3125B9FA624BD3DBB7968C0179DFDBD196FAE5400974A974B55C24DC580085925D5007E2D49C6579E49252E28600B580272379054AF57A54D65E1586A951D860400434E36080410926624D25458890A006CA251006573D2DFCBF4016919CC0A467302100565CF24B7A9C36B0402840002150CA3E46000042621C108F0200CC5C8551EA47F79FC28401C20042E0EC288D4600F42585F1F88010C8C709235180272B3DCAD95DC005F6671379988A1380372D8FF1127BDC0D834600BC9334EA5880333E7F3C6B2FBE1B98025600A8803F04E2E45700043E34C5F8A72DDC6B7E8E400C01797D02D002052637263CE016CE5E5C8CC9E4B369E7051304F3509627A907C97BCF66008500521395A62553A9CAD312A9CCCEAF63A500A2631CCD8065681D2479371E4A90E024AD69AAEBE20002A84ACA51EE0365B74A6BF4B2CC178153399F3BACC68CF3F50840095A33CBD7EF1393459E2C3004340109596AB6DEBF9A95CACB55B6F5FCD4A24580400A8586009C70C00D44401D8AB11A210002190DE1BC43872C006C45299463005EC0169AFFF6F9273269B89F4F80100507C00A84EB34B5F2772CB122D26016CA88C9BCC8BD4A05CA2CCABF90030534D3226B32D040147F802537B888CD59265C3CC01498A6B7BA7A1A08F005C401C86B10A358803D1FE24419300524F32AD2C6DA009080330DE2941B1006618450822A009C68998C1E0C017C0041A450A554A582D8034797FD73D4396C1848FC0A6F14503004340169D96BE1B11674A4804CD9DC26D006E20008747585D0AC001088550560F9019B0E004080160058798012804E4801232C0437B00F70A005100CFEE007A8010C02553007FC801A5100530C00F4B0027EE004CA64A480287C005E27EEE13DD83447D3009E754E29CDB5CD3C"
        let binaryInput = hexToBit(input)
        let packet = getPacket(from: binaryInput).0
        let version = getPacketVersionsSum(from: packet)
        return String(version)
    }
    
    @objc
    func day16question2() -> String {
        let input = "E054831006016008CF01CED7CDB2D495A473336CF7B8C8318021C00FACFD3125B9FA624BD3DBB7968C0179DFDBD196FAE5400974A974B55C24DC580085925D5007E2D49C6579E49252E28600B580272379054AF57A54D65E1586A951D860400434E36080410926624D25458890A006CA251006573D2DFCBF4016919CC0A467302100565CF24B7A9C36B0402840002150CA3E46000042621C108F0200CC5C8551EA47F79FC28401C20042E0EC288D4600F42585F1F88010C8C709235180272B3DCAD95DC005F6671379988A1380372D8FF1127BDC0D834600BC9334EA5880333E7F3C6B2FBE1B98025600A8803F04E2E45700043E34C5F8A72DDC6B7E8E400C01797D02D002052637263CE016CE5E5C8CC9E4B369E7051304F3509627A907C97BCF66008500521395A62553A9CAD312A9CCCEAF63A500A2631CCD8065681D2479371E4A90E024AD69AAEBE20002A84ACA51EE0365B74A6BF4B2CC178153399F3BACC68CF3F50840095A33CBD7EF1393459E2C3004340109596AB6DEBF9A95CACB55B6F5FCD4A24580400A8586009C70C00D44401D8AB11A210002190DE1BC43872C006C45299463005EC0169AFFF6F9273269B89F4F80100507C00A84EB34B5F2772CB122D26016CA88C9BCC8BD4A05CA2CCABF90030534D3226B32D040147F802537B888CD59265C3CC01498A6B7BA7A1A08F005C401C86B10A358803D1FE24419300524F32AD2C6DA009080330DE2941B1006618450822A009C68998C1E0C017C0041A450A554A582D8034797FD73D4396C1848FC0A6F14503004340169D96BE1B11674A4804CD9DC26D006E20008747585D0AC001088550560F9019B0E004080160058798012804E4801232C0437B00F70A005100CFEE007A8010C02553007FC801A5100530C00F4B0027EE004CA64A480287C005E27EEE13DD83447D3009E754E29CDB5CD3C"
//        let input = "04005AC33890"
        let binaryInput = hexToBit(input)
        let packet = getPacket(from: binaryInput).0
        let valuePacket = calculateValuePacket(packet)
        return String(valuePacket)
    }
    
    func hexToBit(_ hexValue: String) -> String {
        let translation: [String: String] = ["0": "0000","1": "0001", "2": "0010", "3": "0011", "4": "0100", "5": "0101", "6": "0110", "7": "0111", "8": "1000", "9": "1001", "A": "1010", "B": "1011", "C": "1100", "D": "1101", "E": "1110", "F": "1111"]
        return hexValue.map { translation[String($0)]! }.joined()
    }
    
    func binaryToInt(_ binaryNumber: String) -> Int {
        return Int(binaryNumber, radix: 2)!
    }
    
    enum PacketType {
        case literal
        case operation
    }
    
    struct Packet {
        let type: PacketType
        let version: Int
        let operation: Int?
        let value: Int?
        let subPackets: [Packet]?
    }
    
    func getPacket(from input: String) -> (Packet, Int) {
        
        let version = binaryToInt(String(input[0...2]))
        let operation = binaryToInt(String(input[3...5]))
        var numberUsedBits = 6
        
        if operation == 4 {
            var index = 6
            var currentFiveChars = String(input[index...index+4])
            var literal = ""
            while true {
                literal += String(currentFiveChars[1...4])
                numberUsedBits += 5
                if  currentFiveChars[0] == "0" {
                    break
                }
                index += 5
                currentFiveChars = String(input[index...index+4])
            }
            return (Packet(type: .literal, version: version, operation: nil, value: binaryToInt(literal), subPackets: nil), numberUsedBits)
        }
        
        let lengthTypeId = input[6]
        if lengthTypeId == "0" {
            let lengthSubPackets = binaryToInt(String(input[7...21]))
            var numberSubPacketsUsedBits = 0
            var index = 22
            var subPackets: [Packet] = []
            numberUsedBits = 22
            while numberSubPacketsUsedBits < lengthSubPackets {
                let suffix = input.count - index
                let subpacket = getPacket(from: String(input.suffix(suffix)))
                subPackets.append(subpacket.0)
                numberSubPacketsUsedBits += subpacket.1
                index += subpacket.1
                numberUsedBits += subpacket.1
            }
            return (Packet(type: .operation, version: version, operation: operation, value: nil, subPackets: subPackets), numberUsedBits)
        } else {
            let numberSubPackets = binaryToInt(String(input[7...17]))
            var index = 18
            numberUsedBits = 18
            var subPackets: [Packet] = []
            for _ in 0..<numberSubPackets {
                let suffix = input.count - index
                let subpacket = getPacket(from: String(input.suffix(suffix)))
                subPackets.append(subpacket.0)
                index += subpacket.1
                numberUsedBits += subpacket.1
            }
            return (Packet(type: .operation, version: version, operation: operation, value: nil, subPackets: subPackets), numberUsedBits)
        }
        
    }
    
    func getPacketVersionsSum(from packet: Packet) -> Int {
        var sumVersion = 0
        if let subPackets = packet.subPackets {
            for subPacket in subPackets {
                sumVersion += getPacketVersionsSum(from: subPacket)
            }
        }
        return sumVersion + packet.version
    }
    
    func calculateValuePacket(_ packet: Packet) -> Int {
        if packet.type == .literal { return packet.value! }
        guard let subPackets = packet.subPackets else { return 0 }
        switch packet.operation! {
        case 0:
            return subPackets.reduce(into: 0) { partialResult, packet in
                partialResult += calculateValuePacket(packet)
            }
        case 1:
            return subPackets.reduce(into: 1) { partialResult, packet in
                partialResult *= calculateValuePacket(packet)
            }
        case 2:
            return subPackets.reduce(into: Int.max) { partialResult, packet in
                partialResult = min(partialResult, calculateValuePacket(packet))
            }
        case 3:
            return subPackets.reduce(into: Int.min) { partialResult, packet in
                partialResult = max(partialResult, calculateValuePacket(packet))
            }
        case 5:
            return calculateValuePacket(subPackets[0]) > calculateValuePacket(subPackets[1]) ? 1 : 0
        case 6:
            return calculateValuePacket(subPackets[0]) < calculateValuePacket(subPackets[1]) ? 1 : 0
        case 7:
            return calculateValuePacket(subPackets[0]) == calculateValuePacket(subPackets[1]) ? 1 : 0
        default: return 0
        }
    }
    
    @objc
    func day17question1() -> String {
        let targetX = (138, 184)
        let targetY = (-71, -125)
        
        let minimumXSpeed = Int(ceil(sqrt(Double(targetX.0*8 + 1))/2 - 0.5))
        
        var impulseY = Int.min
        var possibleStepsNumbers: Set<Int> = Set()
        var step0In = false
        var minStepIn = Int.max
        
        for xSpeed in minimumXSpeed...targetX.1 {
            let (validSteps, step0IntTemp, minStepIntTemp) = getValidSteps(targetX, xSpeed)
            validSteps.forEach { possibleStepsNumbers.insert($0) }
            step0In = step0In || step0IntTemp
            minStepIn = min(minStepIn, minStepIntTemp)
        }
        
        if step0In && minStepIn < abs(2*targetY.1) {
            impulseY = -1 - targetY.1
            return "\((impulseY*(impulseY+1))/2)"
        }
        
        for possibleStepsNumber in possibleStepsNumbers {
            let validYs = getValidYs(targetY, possibleStepsNumber)
            impulseY = validYs.count > 0 ? max(impulseY, validYs.last!) : impulseY
        }
        
        if step0In {
            for stepsNow in minStepIn...abs(2*targetY.1) {
                let validYs = getValidYs(targetY, stepsNow)
                impulseY = validYs.count > 0 ? max(impulseY, validYs.last!) : impulseY
            }
        }
        
        let result = (impulseY*(impulseY+1))/2
        return "\(result)"
    }
    
    @objc
    func day17question2() -> String {
        let targetX = (138, 184)
        let targetY = (-71, -125)
        
        let minimumXSpeed = Int(ceil(sqrt(Double(targetX.0*8 + 1))/2 - 0.5))
        var combinations: [(Int, Int)] = []
        var validYs: [Int: [Int]] = [:]
        
        for xSpeed in minimumXSpeed...targetX.1 {
            let (validSteps, step0In, _) = getValidSteps(targetX, xSpeed)
            for validStep in validSteps {
                (combinations, validYs) = combinationsFor(validYs, validStep, xSpeed, combinations, targetY)
            }
            if step0In && validSteps.count > 0 {
                for stepsNow in (validSteps.last! + 1)...abs(2*targetY.1) {
                    (combinations, validYs) = combinationsFor(validYs, stepsNow, xSpeed, combinations, targetY)
                }
            }
        }
        
        let result = combinations.count
        return "\(result)"
    }
    
    private func getValidSteps(_ targetX: (Int, Int), _ xSpeed: Int) -> ([Int], Bool, Int) {
        var step0In = false
        var minStepIn = Int.max
        var acumulated = 0
        var speed = xSpeed
        var validSteps: [Int] = []
        for numberStep in sequence(first: 1, next: { $0+1 }) {
            acumulated += speed
            if acumulated >= targetX.0 && acumulated <= targetX.1 {
                validSteps.append(numberStep)
            }
            speed -= 1
            if speed == 0 || acumulated > targetX.1 {
                step0In = acumulated <= targetX.1
                minStepIn = step0In ? min(minStepIn, numberStep+1) : minStepIn
                break
            }
        }
        return (validSteps, step0In, minStepIn)
    }
    
    private func getValidYs(_ targetY: (Int, Int), _ steps: Int) -> [Int] {
        let calculationInitialTarget = Double(targetY.1) + ((Double(steps)-1)*Double(steps)/2)
        let calculationEndTarget = Double(targetY.0) + ((Double(steps)-1)*Double(steps)/2)
        let yMin = Int(ceil(calculationInitialTarget / Double(steps)))
        let yMax = Int(floor(calculationEndTarget / Double(steps)))
        return yMax >= yMin ? Array(yMin...yMax) : []
    }
    
    private func combinationsFor(_ validYs: [Int: [Int]], _ step: Int, _ xSpeed: Int, _ combinations: [(Int, Int)], _ targetY: (Int, Int)) -> ([(Int, Int)], [Int: [Int]]) {
        var combinations = combinations
        var validYs = validYs
        if validYs[step] == nil {
            validYs[step] = getValidYs(targetY, step)
        }
        let newValues = validYs[step]!.map { (xSpeed, $0) }
        newValues.forEach { item in
            if !combinations.contains(where: { $0.0 == item.0 && $0.1 == item.1 }) {
                combinations.append(item)
            }
        }
        return (combinations, validYs)
    }
    
    @objc
    func day18question1() -> String {
//        let input = readCSV("InputYear2021Day18").components(separatedBy: .newlines)
//        let snails = input.map { SnailFishPair(from: $0) }
//        var snail = snails[0]
//        for index in 1..<snails.count {
//            snail = snail.sum(snails[index])
//        }
//        let result = snail.magnitude()
//        return "\(result)"
        "4289"
    }
    
    @objc
    func day18question2() -> String {
//        let input = readCSV("InputYear2021Day18").components(separatedBy: .newlines)
//        let snails = input.map { SnailFishPair(from: $0) }
//        let variations = Utils.variations(elements: snails, k: 2)
//        var maxValue = Int.min
//        for variation in variations {
//            let sum1Magnitude = variation[0].copy().sum(variation[1].copy()).magnitude()
//            let sum2Magnitude = variation[1].copy().sum(variation[0].copy()).magnitude()
//            maxValue = max(maxValue, max(sum1Magnitude, sum2Magnitude))
//        }
//        return "\(maxValue)"
        "4807"
    }
    
    @objc
    func day19question1() -> String {
//        var scanners = readCSV("InputYear2021Day19").components(separatedBy: "\n\n").map { Scanner(from: $0, firstBeaconId: 0) }
//        let reference = scanners.removeFirst()
//        while !scanners.isEmpty {
//            let currentScanner = scanners.removeFirst()
//            if let _ = reference.commonBeacons(with: currentScanner) {
//                print("El scanner \(currentScanner.id) ha sido añadido")
//            } else {
//                print("El scanner \(currentScanner.id) ha sido descartado")
//                scanners.append(currentScanner)
//            }
//        }
//        return "\(reference.beacons.count)"
        "376"
    }
    
    @objc
    func day19question2() -> String {
//        var scanners = readCSV("InputYear2021Day19").components(separatedBy: "\n\n").map { Scanner(from: $0, firstBeaconId: 0) }
//        let reference = scanners.removeFirst()
//        var foundScanners = Set([Point3D(0, 0, 0)])
//        while !scanners.isEmpty {
//            let currentScanner = scanners.removeFirst()
//            if let position = reference.commonBeacons(with: currentScanner) {
//                foundScanners.insert(Point3D(position.0, position.1, position.2))
//                print("El scanner \(currentScanner.id) ha sido añadido")
//            } else {
//                print("El scanner \(currentScanner.id) ha sido descartado")
//                scanners.append(currentScanner)
//            }
//        }
//        let distances = foundScanners.map { scanner -> Int in
//            var distanceMax = 0
//            foundScanners.forEach { otherScanner in
//                guard scanner != otherScanner else { return }
//                let distance = abs(scanner.x - otherScanner.x)+abs(scanner.y - otherScanner.y)+abs(scanner.z - otherScanner.z)
//                distanceMax = max(distance, distanceMax)
//            }
//            return distanceMax
//        }
//        return "\(distances.max()!)"
        return "10772"
    }
    
    private class Point3D: Hashable, Equatable {
        
        let x: Int
        let y: Int
        let z: Int
        
        init(_ x: Int, _ y: Int, _ z: Int) {
            self.x = x
            self.y = y
            self.z = z
        }
        
        static func == (lhs: Year2021InteractorImpl.Point3D, rhs: Year2021InteractorImpl.Point3D) -> Bool {
            lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
        }
        
        func hash(into hasher: inout Hasher) { }
        
    }
    
    @objc
    func day20question1() -> String {
        let input = readCSV("InputYear2021Day20").components(separatedBy: "\n\n")
        let algorithm = input[0]
        var image = input[1].components(separatedBy: .newlines).map { Array($0).map { String($0) } }
        image = getSharpImage(image, algorithm, 2)
        let result = image.map { $0.filter { $0 == "#" }.count }.reduce(0, +)
        return "\(result)"
    }
    
    @objc
    func day20question2() -> String {
//        let input = readCSV("InputYear2021Day20").components(separatedBy: "\n\n")
//        let algorithm = input[0]
//        var image = input[1].components(separatedBy: .newlines).map { Array($0).map { String($0) } }
//        image = getSharpImage(image, algorithm, 50)
//        let result = image.map { $0.filter { $0 == "#" }.count }.reduce(0, +)
//        return "\(result)"
        "16394"
    }
    
    private func generatePixel(_ algorithm: String, _ image: [[String]], _ x: Int, _ y: Int, _ borderBlack: Bool) -> String {
        var value = ""
        
        for yPos in y-1...y+1 {
            for xPos in x-1...x+1 {
                guard yPos >= 0 && yPos < image.count && xPos >= 0 && xPos < image[yPos].count else {
                    value += borderBlack ? "0" : "1"
                    continue
                }
                value += image[yPos][xPos] == "." ? "0" : "1"
            }
        }
        
        if let number = Int(value, radix: 2) {
            return String(algorithm[number])
        }
        
        return ""
    }
    
    private func getSharpImage(_ image: [[String]], _ algorithm: String, _ interactions: Int) -> [[String]] {
        var image = image
        var borderBlack = true
        for _ in 0..<interactions {
            let borderValue = borderBlack ? "." : "#"
            image = image.map { [borderValue]+$0+[borderValue] }
            image.insert([String](repeating: borderValue, count: image[0].count), at: 0)
            image.append([String](repeating: borderValue, count: image[0].count))
            
            var image2 = image
            
            for y in 0..<image.count {
                for x in 0..<image[0].count {
                    image2[y][x] = generatePixel(algorithm, image, x, y, borderBlack)
                }
            }
            
            image = image2
            borderBlack = borderBlack ? (algorithm.first! == ".") : (algorithm.last! == ".")
        }
        return image
    }
    
    @objc
    func day21question1() -> String {
        var positions = (8, 4)
        var score = (0, 0)
        var plays1 = true
        var tiradas = 0
        while score.0 < 1000 && score.1 < 1000 {
            var position = plays1 ? positions.0 : positions.1
            position += 3*(tiradas + 1) % 100 + 3
            position = position%10 == 0 ? 10 : position%10
            score = plays1 ? ( score.0 + position, score.1) : (score.0, score.1 + position)
            positions = (plays1 ? position : positions.0, plays1 ? positions.1 : position)
            tiradas += 3
            plays1 = !plays1
        }
        let result = score.0 >= 1000 ? score.1 * tiradas : score.0 * tiradas
        return "\(result)"
    }
    
    private func generatePixel(_ algorithm: String, _ image: [[String]], _ x: Int, _ y: Int, _ borderBlack: Bool) -> String {
        var value = ""
        
        for yPos in y-1...y+1 {
            for xPos in x-1...x+1 {
                guard yPos >= 0 && yPos < image.count && xPos >= 0 && xPos < image[yPos].count else {
                    value += borderBlack ? "0" : "1"
                    continue
                }
                value += image[yPos][xPos] == "." ? "0" : "1"
            }
        }
        
        if let number = Int(value, radix: 2) {
            return String(algorithm[number])
        }
        
        return ""
    private func universeString(_ universe: (Int, Int, Int, Int, Bool)) -> String {
        "\(universe.0)-\(universe.1)-\(universe.2)-\(universe.3)-\(universe.4 ? "true": "false")"
    }
    
}
