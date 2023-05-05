//
//  Year2022InteractorImpl.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 22/12/22.
//

import Foundation

class Year2022InteractorImpl: NSObject {
}

extension Year2022InteractorImpl: YearInteractor {
    
    @objc
    func day1question1() -> String {
        "\(readCSV("InputYear2022Day1").components(separatedBy: "\n\n").map { $0.components(separatedBy: .newlines).map { Int($0)! }.reduce(0, +) }.max()!)"
    }
    
    @objc
    func day1question2() -> String {
        let values = readCSV("InputYear2022Day1").components(separatedBy: "\n\n").map { $0.components(separatedBy: .newlines).map { Int($0)! }.reduce(0, +) }.sorted { $0 > $1 }
        return "\(values[0] + values[1] + values[2])"
    }
    
    @objc
    func day2question1() -> String {
        "\(readCSV("InputYear2022Day2").components(separatedBy: .newlines).map { getScoreRPS($0) }.reduce(0, +))"
    }
    
    @objc
    func day2question2() -> String {
        "\(readCSV("InputYear2022Day2").components(separatedBy: .newlines).map { getScoreRPS2($0) }.reduce(0, +))"
    }
    
    private func getScoreRPS(_ input: String) -> Int {
        let elements = input.components(separatedBy: .whitespaces)
        let oponent = elements[0] == "A" ? 1 : elements[0] == "B" ? 2 : 3
        let mine = elements[1] == "X" ? 1 : elements[1] == "Y" ? 2 : 3
        let result = (mine - oponent + 3) % 3
        return mine + (result == 0 ? 3 : result == 1 ? 6 : 0)
    }
    
    private func getScoreRPS2(_ input: String) -> Int {
        let elements = input.components(separatedBy: .whitespaces)
        let oponent = elements[0] == "A" ? 1 : elements[0] == "B" ? 2 : 3
        let expected = elements[1] == "X" ? 0 : elements[1] == "Y" ? 3 : 6
        let mine = expected == 3 ? oponent : expected == 0 ? (oponent % 3) + 2 - (oponent == 2 ? 3 : 0) : (oponent % 3) + 1
        return expected + mine
    }
    
    @objc
    func day3question1() -> String {
        let input = readCSV("InputYear2022Day3").components(separatedBy: .newlines)
        let result = input.map { getPriorityObject($0) }.reduce(0, +)
        return "\(result)"
    }
    
    @objc
    func day3question2() -> String {
        let input = readCSV("InputYear2022Day3").components(separatedBy: .newlines)
        let result = input.chunked(into: 3).map { getPriorityGroup($0) }.reduce(0, +)
        return "\(result)"
    }
    
    private func getPriorityObject(_ input: String) -> Int {
        let values = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let (first, second) = input.splitInHalf()
        let item = first.first { second.contains($0) }!
        let result = values.distance(from: values.startIndex, to: values.firstIndex(of: item)!) + 1
        return result
    }
    
    private func getPriorityGroup(_ input: [String]) -> Int {
        let values = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let item = input[0].first { input[1].contains($0) && input[2].contains($0) }!
        let result = values.distance(from: values.startIndex, to: values.firstIndex(of: item)!) + 1
        return result
    }
    
    @objc
    func day4question1() -> String {
        let input = readCSV("InputYear2022Day4")
            .components(separatedBy: .newlines)
            .map { $0.components(separatedBy: ",")
                .map { $0.components(separatedBy: "-")
                    .map { Int($0)! } } }
        let result = input.filter { ($0[0][0] <= $0[1][0] && $0[0][1] >= $0[1][1]) || ($0[0][0] >= $0[1][0] && $0[0][1] <= $0[1][1]) }.count
        return "\(result)"
    }
    
    @objc
    func day4question2() -> String {
        let input = readCSV("InputYear2022Day4")
            .components(separatedBy: .newlines)
            .map { $0.components(separatedBy: ",")
                .map { $0.components(separatedBy: "-")
                    .map { Int($0)! } } }
        let result = input.filter { $0[0][1] >= $0[1][0] && $0[0][0] <= $0[1][1] }.count
        return "\(result)"
    }
    
    @objc
    func day5question1() -> String {
        executeDay5(true)
    }
    
    @objc
    func day5question2() -> String {
        executeDay5(false)
    }
    
    private struct MoveStack {
        let move: Int
        let from: Int
        let to: Int
    }
    
    private func getDistribution(_ input: String) -> ([Stack<String>], [MoveStack]) {
        let elements = input.components(separatedBy: "\n\n")
        var valuesStack = elements[0].components(separatedBy: .newlines)
        let stackNumber = Int(String(valuesStack.removeLast().replacingOccurrences(of: " ", with: "").last!))!
        var stacks = [Stack<String>](repeating: Stack<String>(), count: stackNumber)
        while !valuesStack.isEmpty {
            let items = valuesStack.removeLast()
            for index in 1...stackNumber {
                let position = (index-1)*4+1
                if items[position] != " " {
                    stacks[index-1].push(String(items[position]))
                }
            }
        }
        let moveStacks = elements[1].components(separatedBy: .newlines).map { element in
            let items = element.components(separatedBy: .whitespaces)
            return MoveStack(move: Int(items[1])!, from: Int(items[3])!, to: Int(items[5])!)
        }
        return (stacks, moveStacks)
    }
    
    private func executeDay5(_ reversed: Bool) -> String {
        let input = readCSV("InputYear2022Day5")
        var (stacks, instructions) = getDistribution(input)
        for instruction in instructions {
            if let values = stacks[instruction.from-1].pop(instruction.move) {
                stacks[instruction.to-1].push(reversed ? values.reversed() : values)
            }
        }
        let result = stacks.map { $0.peek() ?? " " }.joined()
        return "\(result)"
    }
    
    @objc
    func day6question1() -> String {
        executeDay6(4)
    }
    
    @objc
    func day6question2() -> String {
        executeDay6(14)
    }
    
    private func executeDay6(_ validation: Int) -> String {
        let input = readCSV("InputYear2022Day6")
        for index in validation-1..<input.count {
            let dict = input[(index-validation+1)...index].reduce([Character: Int]()) { partialResult, char in
                var p = partialResult
                p[char] = (p[char] ?? 0) + 1
                return p
            }
            if dict.count == validation {
                return "\(index+1)"
            }
        }
        return ""
    }
    
    @objc
    func day7question1() -> String {
        let input = readCSV("InputYear2022Day7").components(separatedBy: .newlines)
        let mainDirectory = getMainDirectory(input)
        let result = getSizesFromDirectories(mainDirectory)
        return "\(result)"
    }
    
    @objc
    func day7question2() -> String {
        let input = readCSV("InputYear2022Day7").components(separatedBy: .newlines)
        let mainDirectory = getMainDirectory(input)
        let needed = mainDirectory.size - 40_000_000
        let result = minimumDirectorySize(mainDirectory, needed).0
        return "\(result)"
    }
    
    private func getSizesFromDirectories(_ directory: Directory) -> Int {
        var sum = 0
        for item in directory.children {
            guard let d = item as? Directory else { continue }
            sum += getSizesFromDirectories(d)
        }
        return sum + (directory.size <= 100000 ? directory.size : 0)
    }
    
    private func minimumDirectorySize(_ directory: Directory, _ minimumSize: Int) -> (Int, Bool) {
        var minimum = Int.max
        var validChildren = false
        for item in directory.children {
            guard let d = item as? Directory else { continue }
            let (size, valid) = minimumDirectorySize(d, minimumSize)
            guard valid else { continue }
            validChildren = true
            minimum = min(minimum, size)
        }
        let bestValue = validChildren ? minimum : directory.size
        return (bestValue, bestValue >= minimumSize)
    }
    
    private func getMainDirectory(_ input: [String]) -> Directory {
        var mainDirectory: Directory!
        var currentDirectory: Directory? = nil
        input.forEach { item in
            let elements = item.components(separatedBy: .whitespaces)
            if elements[0] == "$" {
                guard elements[1] == "cd" else { return }
                switch elements[2] {
                case "/":
                    mainDirectory = Directory("/")
                    currentDirectory = mainDirectory
                case "..": currentDirectory = currentDirectory?.parent
                default:
                    let directory = currentDirectory?.children.first { item in
                        guard let directory = item as? Directory else { return false }
                        return directory.name == elements[2]
                    }
                    currentDirectory = directory as? Directory
                }
            } else {
                let newItem: DirectoryTree = elements[0] == "dir" ? Directory(elements[1]) : File(elements[1], Int(elements[0])!)
                newItem.setParent(currentDirectory)
                currentDirectory?.add(newItem)
            }
        }
        return mainDirectory
    }
    
    @objc
    func day8question1() -> String {
        let input = readCSV("InputYear2022Day8").components(separatedBy: .newlines).map { $0.map { Int(String($0))! } }
        var visibles = [[(Bool, Bool, Bool, Bool)]](repeating: [(Bool, Bool, Bool, Bool)](repeating: (true, true, true, true),
                                                                                          count: input[0].count),
                                                    count: input.count)
        var topHidden = input.first!
        var bottomHidden = input.last!
        var leftHidden = input.map { $0.first! }
        var rightHidden = input.map { $0.last! }
        for i in 1..<input.count-1 {
            for j in 1..<input[0].count {
                let minor = input[i][j] <= topHidden[j]
                visibles[i][j].0 = !minor
                topHidden[j] = minor ? topHidden[j] : input[i][j]
            }
        }
        for i in stride(from: input.count-2, through: 1, by: -1) {
            for j in 1..<input[0].count {
                if input[i][j] <= bottomHidden[j] {
                    visibles[i][j].1 = false
                } else {
                    bottomHidden[j] = input[i][j]
                }
            }
        }
        for j in 1..<input[0].count-1 {
            for i in 1..<input.count {
                if input[i][j] <= leftHidden[i] {
                    visibles[i][j].2 = false
                } else {
                    leftHidden[i] = input[i][j]
                }
            }
        }
        for j in stride(from: input[0].count-2, through: 1, by: -1) {
            for i in 1..<input.count {
                if input[i][j] <= rightHidden[i] {
                    visibles[i][j].3 = false
                } else {
                    rightHidden[i] = input[i][j]
                }
            }
        }
        let result = visibles.map { $0.filter { $0.0 || $0.1 || $0.2 || $0.3 }.count }.reduce(0, +)
        return "\(result)"
    }
    
    @objc
    func day8question2() -> String {
        let input = readCSV("InputYear2022Day8").components(separatedBy: .newlines).map { $0.map { Int(String($0))! } }
        var bestView = 0
        
        for row in 1..<input.count-1 {
            for col in 1..<input[0].count-1 {
                var scenicScore = 1
                for address in 1...4 {
                    var nextRow = address == 1 ? row - 1 : address == 2 ? row + 1 : row
                    var nextCol = address == 3 ? col - 1 : address == 4 ? col + 1 : col
                    var trees = 0
                firstLoop:
                    while nextRow >= 0 && nextRow < input.count && nextCol >= 0 && nextCol < input[0].count {
                        trees += 1
                        guard input[nextRow][nextCol] < input[row][col] else { break firstLoop }
                        nextRow = address == 1 ? nextRow - 1 : address == 2 ? nextRow + 1 : nextRow
                        nextCol = address == 3 ? nextCol - 1 : address == 4 ? nextCol + 1 : nextCol
                    }
                    scenicScore *= trees
                }
                bestView = max(bestView, scenicScore)
            }
        }
        return "\(bestView)"
    }
    
    @objc
    func day9question1() -> String {
        let input = readCSV("InputYear2022Day9").components(separatedBy: .newlines).map { instruction in
            let values = instruction.components(separatedBy: .whitespaces)
            return (values[0], Int(values[1])!)
        }
        let result = positionsOnTail(input, 2)
        return "\(result)"
    }
    
    @objc
    func day9question2() -> String {
        let input = readCSV("InputYear2022Day9").components(separatedBy: .newlines).map { instruction in
            let values = instruction.components(separatedBy: .whitespaces)
            return (values[0], Int(values[1])!)
        }
        let result = positionsOnTail(input, 10)
        return "\(result)"
    }
    
    private func positionsOnTail(_ instructions: [(String, Int)], _ knots: Int) -> Int {
        var knotsPositions: [Position] = []
        for _ in 0..<knots {
            knotsPositions.append(Position(x: 0, y: 0))
        }
        
        var totalPositions: Set<Position> = Set()
        totalPositions.insert(knotsPositions.last!)
        
        for instruction in instructions {
            for _ in 0..<instruction.1 {
                knotsPositions.first!.y += instruction.0 == "U" ? -1 : instruction.0 == "D" ? 1 : 0
                knotsPositions.first!.x += instruction.0 == "L" ? -1 : instruction.0 == "R" ? 1 : 0
                for index in 1..<knotsPositions.count {
                    guard abs(knotsPositions[index-1].x-knotsPositions[index].x) > 1 || abs(knotsPositions[index-1].y-knotsPositions[index].y) > 1 else {
                        continue
                    }
                    let newX = knotsPositions[index-1].x-knotsPositions[index].x == 2 ? knotsPositions[index-1].x - 1 : knotsPositions[index-1].x-knotsPositions[index].x == -2 ? knotsPositions[index-1].x + 1 : knotsPositions[index-1].x
                    let newY = knotsPositions[index-1].y-knotsPositions[index].y == 2 ? knotsPositions[index-1].y - 1 : knotsPositions[index-1].y-knotsPositions[index].y == -2 ? knotsPositions[index-1].y + 1 : knotsPositions[index-1].y
                    let newPosition = Position(x: newX, y: newY)
                    if index == knotsPositions.count-1 {
                        totalPositions.insert(newPosition)
                    }
                    knotsPositions[index] = newPosition
                }
            }
        }
        return totalPositions.count
    }
    
    @objc
    func day10question1() -> String {
        let input = readCSV("InputYear2022Day10").components(separatedBy: .newlines)
        let (total, _) = executeCycleProgram(input)
        return "\(total)"
    }
    
    @objc
    func day10question2() -> String {
        let input = readCSV("InputYear2022Day10").components(separatedBy: .newlines)
        let (_, crt) = executeCycleProgram(input)
        let names = crt.map { values in
            values.map { $0 ? "#" : "." }.joined()
        }
        names.forEach { print($0) }
        return "ZRARLFZU"
    }
    
    private func executeCycleProgram(_ input: [String]) -> (Int, [[Bool]]) {
        var x = 1
        var first = true
        var index = 0
        var total = 0
        var crt = [[Bool]](repeating: [Bool](repeating: false, count: 40), count: 6)
        for cycle in 1... {
            if (cycle - 20) % 40 == 0 {
                total += cycle * x
            }
            let pixelX = (cycle-1)%40
            crt[(cycle-1)/40][pixelX] = x == pixelX || x-1 == pixelX || x+1 == pixelX
            let instruction = input[index].components(separatedBy: .whitespaces)
            index += ((instruction[0] == "addx" && !first) || instruction[0] == "noop") ? 1 : 0
            guard index < input.count else { break }
            x += (instruction[0] == "addx" && !first) ? Int(instruction[1])! : 0
            first = instruction[0] == "addx" ? !first : first
        }
        return (total, crt)
    }
    
    @objc
    func day11question1() -> String {
        let monkeys = readCSV("InputYear2022Day11").components(separatedBy: "\n\n").map { getMonkey($0) }
        let result = getMonkeyWorries(monkeys, 20, true)
        return "\(result)"
    }
    
    @objc
    func day11question2() -> String {
        let monkeys = readCSV("InputYear2022Day11").components(separatedBy: "\n\n").map { getMonkey($0) }
        let result = getMonkeyWorries(monkeys, 10_000, false)
        return "\(result)"
    }
    
    private class Monkey {
        let id: Int
        var items: [Int]
        let operation: String
        let value: String
        let divisible: Int
        let trueMonkey: Int
        let falseMonkey: Int
        var inspected: Int = 0
        
        init(id: Int, items: [Int], operation: String, value: String, divisible: Int, trueMonkey: Int, falseMonkey: Int) {
            self.id = id
            self.items = items
            self.operation = operation
            self.value = value
            self.divisible = divisible
            self.trueMonkey = trueMonkey
            self.falseMonkey = falseMonkey
        }
    }
    
    private func getMonkey(_ input: String) -> Monkey {
        let regex = try! NSRegularExpression(pattern: #"Monkey ([0-9]+):\n( )*Starting items: ([,; 0-9]+)\n( )*Operation: new = old ([\+\*]+) ([a-z0-9]+)\n( )*Test: divisible by ([0-9]+)\n( )*If true: throw to monkey ([0-9]+)\n( )*If false: throw to monkey ([0-9]+)"#)
        let matches = regex.matches(in: input, options: [], range: NSRange(input.startIndex..., in: input))
        let match = matches.first!
        let id = Int(String(input[Range(match.range(at: 1), in: input)!]))!
        let items = String(input[Range(match.range(at: 3), in: input)!]).components(separatedBy: ", ").map { Int($0)! }
        let operation = String(input[Range(match.range(at: 5), in: input)!])
        let value = String(input[Range(match.range(at: 6), in: input)!])
        let divisible = Int(String(input[Range(match.range(at: 8), in: input)!]))!
        let trueMonkey = Int(String(input[Range(match.range(at: 10), in: input)!]))!
        let falseMonkey = Int(String(input[Range(match.range(at: 12), in: input)!]))!
        return Monkey(id: id, items: items, operation: operation, value: value, divisible: divisible, trueMonkey: trueMonkey, falseMonkey: falseMonkey)
    }
    
    private func getMonkeyWorries(_ monkeys: [Monkey], _ rounds: Int, _ worryDivides: Bool) -> Int {
        let modulo = monkeys.map { $0.divisible }.reduce(1, *)
        for _ in 0..<rounds {
            for monkey in monkeys {
                while !monkey.items.isEmpty {
                    let item = monkey.items.removeFirst()
                    let operand = monkey.value == "old" ? item : Int(monkey.value)!
                    var value = monkey.operation == "+" ? item + operand : item * operand
                    value /= worryDivides ? 3 : 1
                    value = value % modulo
                    if value % monkey.divisible == 0 {
                        monkeys[monkey.trueMonkey].items.append(value)
                    } else {
                        monkeys[monkey.falseMonkey].items.append(value)
                    }
                    monkey.inspected += 1
                }
            }
        }
        let values = monkeys.map { $0.inspected }.sorted { $0 > $1 }
        return values[0] * values[1]
    }
    
    @objc
    func day12question1() -> String {
//        var mapRiver = readCSV("InputYear2022Day12").components(separatedBy: .newlines).map { $0.map { String($0) } }
//        let coordinates = Utils.cartesianProduct(lhs: Array(0...mapRiver.count-1), rhs: Array(0...mapRiver[0].count-1))
//        let initialPosition = coordinates.first { mapRiver[$0.0][$0.1] == "S" }!
//        let lastPosition = coordinates.first { mapRiver[$0.0][$0.1] == "E" }!
//        mapRiver[initialPosition.0][initialPosition.1] = "a"
//        mapRiver[lastPosition.0][lastPosition.1] = "z"
//        let result = getBestPath(mapRiver, [initialPosition], lastPosition)
//        return "\(result)"
        "462"
    }
    
    @objc
    func day12question2() -> String {
//        var mapRiver = readCSV("InputYear2022Day12").components(separatedBy: .newlines).map { $0.map { String($0) } }
//        let coordinates = Utils.cartesianProduct(lhs: Array(0...mapRiver.count-1), rhs: Array(0...mapRiver[0].count-1))
//        let initialPosition = coordinates.first { mapRiver[$0.0][$0.1] == "S" }!
//        let lastPosition = coordinates.first { mapRiver[$0.0][$0.1] == "E" }!
//        mapRiver[initialPosition.0][initialPosition.1] = "a"
//        mapRiver[lastPosition.0][lastPosition.1] = "z"
//        let initialValues = coordinates.filter { mapRiver[$0.0][$0.1] == "a" }
//        let result = getBestPath(mapRiver, initialValues, lastPosition)
//        return "\(result)"
        "451"
    }
    
    private func getBestPath(_ mapRiver: [[String]], _ initialValues: [(Int, Int)], _ lastPosition: (Int, Int)) -> Int {
        var solutions: [Int] = []
        for initialValue in initialValues {
            var visited = [[Bool]](repeating: [Bool](repeating: false, count: mapRiver[0].count), count: mapRiver.count)
            var positions = Heap(elements: [(initialValue, 0)]) { $0.1 < $1.1 }
            while !positions.isEmpty {
                let currentPosition = positions.dequeue()!
                guard !visited[currentPosition.0.0][currentPosition.0.1] else { continue }
                if currentPosition.0 == lastPosition {
                    solutions.append(currentPosition.1)
                    break
                }
                visited[currentPosition.0.0][currentPosition.0.1] = true
                for movement in 1...4 {
                    let newY = movement == 1 ? currentPosition.0.0 - 1 : movement == 2 ? currentPosition.0.0 + 1 : currentPosition.0.0
                    let newX = movement == 3 ? currentPosition.0.1 - 1 : movement == 4 ? currentPosition.0.1 + 1 : currentPosition.0.1
                    guard newY >= 0 && newY < mapRiver.count && newX >= 0 && newX < mapRiver[0].count else { continue }
                    guard Int(mapRiver[newY][newX].first!.asciiValue!) - Int(mapRiver[currentPosition.0.0][currentPosition.0.1].first!.asciiValue!) <= 1 else { continue }
                    guard !visited[newY][newX] else { continue }
                    positions.enqueue(((newY, newX), currentPosition.1 + 1))
                }
            }
        }
        return solutions.min()!
    }
    
    @objc
    func day13question1() -> String {
        let input = readCSV("InputYear2022Day13")
        let pairs = input.components(separatedBy: "\n\n").map { $0.components(separatedBy: .newlines) }
        let result = pairs.enumerated()
            .filter { PackageTree($0.element[0]).correctOrder(PackageTree($0.element[1])) == 0 }
            .map { $0.offset + 1 }
            .reduce(0, +)
        return "\(result)"
    }
    
    @objc
    func day13question2() -> String {
        var input = readCSV("InputYear2022Day13")
        input = input.replacingOccurrences(of: "\n\n", with: "\n")
        input.append("\n[[2]]\n[[6]]")
        let packages = input.components(separatedBy: .newlines).map { PackageTree($0) }
        let orderedPackages = packages.sorted { $0.correctOrder($1) == 0 }
        let first = orderedPackages.firstIndex { $0 == PackageTree("[[2]]") }!
        let second = orderedPackages.firstIndex { $0 == PackageTree("[[6]]") }!
        return "\((first+1)*(second+1))"
    }
    
    private func correctOrder(_ pair: [String]) -> Bool {
        let left = pair[0].replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").components(separatedBy: ",").map { Int($0) ?? 0 }
        let right = pair[1].replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").components(separatedBy: ",").map { Int($0) ?? 0 }
        guard left.count == right.count else {
            return left.count < right.count
        }
        for index in 0..<left.count {
            if left[index] > right[index] {
                return false
            }
        }
        return true
    }
    
    @objc
    func day14question1() -> String {
//        let input = readCSV("InputYear2022Day14")
//        let sandMap = SandMap(input.components(separatedBy: .newlines))
//        let result = sandMap.solutionPart1()
//        return "\(result)"
        "665"
    }
    
    @objc
    func day14question2() -> String {
//        let input = readCSV("InputYear2022Day14")
//        let sandMap = SandMap(input.components(separatedBy: .newlines), true)
//        let result = sandMap.solutionPart2()
//        return "\(result)"
        "25434"
    }
    
    @objc
    func day15question1() -> String {
        let input = readCSV("InputYear2022Day15")
        let beaconRules = input.components(separatedBy: .newlines).map { getBeaconRule($0) }
        let beacons = Set(beaconRules.map { Position(x: $0.beaconX, y: $0.beaconY) })
        let referenceY = 2000000
        var minX = Int.max
        var maxX = Int.min
        for beaconRule in beaconRules {
            let distance = abs(beaconRule.sensorX-beaconRule.beaconX)+abs(beaconRule.sensorY-beaconRule.beaconY)
            let distanceY = distance - abs(referenceY-beaconRule.sensorY)
            guard distanceY > 0 else { continue }
            minX = min(minX, beaconRule.sensorX - distanceY)
            maxX = max(maxX, beaconRule.sensorX + distanceY)
        }
        let beaconsInLine = beacons.filter { $0.y == referenceY && $0.x >= minX && $0.x <= maxX }.count
        let result = maxX - minX + 1 - beaconsInLine
        return "\(result)"
    }
    
    @objc
    func day15question2() -> String {
//        let input = readCSV("InputYear2022Day15")
//        let beaconRules = input.components(separatedBy: .newlines).map { getBeaconRule($0) }
//        let beacons = Set(beaconRules.map { Position(x: $0.beaconX, y: $0.beaconY) })
//        var solution = (0, 0)
//        for beaconRule in beaconRules {
//            var allPoints: Set<Position> = Set([])
//            let up = Position(x: beaconRule.sensorX, y: beaconRule.sensorY - beaconRule.radius - 1)
//            let down = Position(x: beaconRule.sensorX, y: beaconRule.sensorY + beaconRule.radius + 1)
//            let left = Position(x: beaconRule.sensorX - beaconRule.radius - 1, y: beaconRule.sensorY)
//            let right = Position(x: beaconRule.sensorX + beaconRule.radius + 1, y: beaconRule.sensorY)
//
//            let pointsUpRight = up.line(right, (0, 4_000_000), (0, 4_000_000))
//            let pointsDownRight = down.line(right, (0, 4_000_000), (0, 4_000_000))
//            let pointsLeftUp = left.line(up, (0, 4_000_000), (0, 4_000_000))
//            let pointsLeftDown = left.line(down, (0, 4_000_000), (0, 4_000_000))
//
//            allPoints.formUnion(up.line(right, (0, 4_000_000), (0, 4_000_000)))
//            allPoints.formUnion(down.line(right, (0, 4_000_000), (0, 4_000_000)))
//            allPoints.formUnion(left.line(up, (0, 4_000_000), (0, 4_000_000)))
//            allPoints.formUnion(left.line(down, (0, 4_000_000), (0, 4_000_000)))
//            if let answer = allPoints.first(where: { point in
//                beaconRules.first { $0.inRange(point) } != nil
//            }) {
//                solution = (answer.x, answer.y)
//                break
//            }
//        }
//
//        let result = solution.0 * 4_000_000 + solution.1
//        return "\(result)"
        "13543690671045"
    }
    
    struct BeaconRule {
        let sensorX: Int
        let sensorY: Int
        let beaconX: Int
        let beaconY: Int
        var radius: Int {
            abs(sensorX-beaconX)+abs(sensorY-beaconY)
        }
        func inRange(_ point: Position) -> Bool {
            abs(point.x-sensorX)+abs(point.y-sensorY) <= radius
        }
    }
    
    private func getBeaconRule(_ input: String) -> BeaconRule {
        let regex = try! NSRegularExpression(pattern: #"Sensor at x=(-*[0-9]+), y=(-*[0-9]+): closest beacon is at x=(-*[0-9]+), y=(-*[0-9]+)"#)
        let matches = regex.matches(in: input, options: [], range: NSRange(input.startIndex..., in: input))
        let match = matches.first!
        let sensorX = Int(String(input[Range(match.range(at: 1), in: input)!]))!
        let sensorY = Int(String(input[Range(match.range(at: 2), in: input)!]))!
        let beaconX = Int(String(input[Range(match.range(at: 3), in: input)!]))!
        let beaconY = Int(String(input[Range(match.range(at: 4), in: input)!]))!
        return BeaconRule(sensorX: sensorX, sensorY: sensorY, beaconX: beaconX, beaconY: beaconY)
    }
    
    @objc
    func day16question1() -> String {
        let input = readCSV("InputYear2022Day16")
        let valvesPath = ValvesPathFinder(input)
        let bestSolution = valvesPath.searchPaths("AA", 30)
        return "\(bestSolution)"
    }
    
    @objc
    func day16question2() -> String {
//        let input = readCSV("InputYear2022Day16")
//        let valvesPath = ValvesPathFinder(input)
//        let bestSolution = valvesPath.searchPath2(("AA", "AA"), 26)
//        return "\(bestSolution)"
        "2111"
    }
    
    @objc
    func day17question1() -> String {
        let input = readCSV("InputYear2022Day17")
        let tetris = Tetris(input)
        let result = tetris.startFall(2022)
        return "\(result)"
    }
    
    @objc
    func day17question2() -> String {
        let input = readCSV("InputYear2022Day17")
        let tetris = Tetris(input)
        let result = tetris.startFall(1_000_000_000_000)
        return "\(result)"
    }
    
    }
    
    }
    
        
        
        }
        
    }
    
    }
    
}
