//
//  Year2018InteractorImpl.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 10/3/22.
//

import Foundation
import CoreXLSX

class Year2018InteractorImpl: NSObject {
    var batterySums: [String: Int] = [:]
    var lumberInts: [Int: Int] = [:]
}

extension Year2018InteractorImpl: YearInteractor {
    
    @objc
    func day1question1() -> String {
        let input = readCSV("InputYear2018Day1").components(separatedBy: .newlines).map { Int($0)! }
        let result = input.reduce(0, +)
        return String(result)
    }
    
    @objc
    func day1question2() -> String {
        let input = readCSV("InputYear2018Day1").components(separatedBy: .newlines).map { Int($0)! }
        var repeated: Set<Int> = [0]
        var sum = 0
        var index = 0
        while true {
            sum += input[index]
            if repeated.contains(sum) { break }
            repeated.insert(sum)
            index = (index + 1) % input.count
        }
        return String(sum)
    }
    
    @objc
    func day2question1() -> String {
        let input = readCSV("InputYear2018Day2").components(separatedBy: .newlines)
        var counts2 = 0
        var counts3 = 0
        for item in input {
            let counts = Utils.countChars(item)
            if counts.first(where: { $0.value == 2 }) != nil { counts2 += 1 }
            if counts.first(where: { $0.value == 3 }) != nil { counts3 += 1 }
        }
        return String(counts2 * counts3)
    }
    
    @objc
    func day2question2() -> String {
        let input = readCSV("InputYear2018Day2").components(separatedBy: .newlines)
        for item in input {
            if let item2 = input.first(where: { $0 != item && differentStringBy1($0, item) }) {
                let result = commonString(item, item2)
                print(result)
                return result
            }
        }
        return ""
    }
    
    private func differentStringBy1(_ value1: String, _ value2: String) -> Bool {
        var differences = 0
        for index in 0..<value1.count {
            if value1[index] != value2[index] { differences += 1 }
            if differences > 1 { return false }
        }
        return true
    }
    
    private func commonString(_ value1: String, _ value2: String) -> String {
        var common = ""
        for index in 0..<value1.count {
            if value1[index] == value2[index] { common.append(value1[index]) }
        }
        return common
    }
    
    @objc
    func day3question1() -> String {
        let input = readCSV("InputYear2018Day3").components(separatedBy: .newlines).map { createClaim($0) }
        let fabric = getFabricWithClaims(input)
        let result = fabric.map { $0.filter { $0 > 1 }.count }.reduce(0, +)
        return String(result)
    }
    
    @objc
    func day3question2() -> String {
        let input = readCSV("InputYear2018Day3").components(separatedBy: .newlines).map { createClaim($0) }
        var result = 0
        for claim in input {
            let collisions = input.filter { $0.id != claim.id && (claimsCollision($0, claim)) }.count
            if collisions == 0 {
                result = claim.id
                break
            }
        }
        return String(result)
    }
    
    struct Claim {
        let id: Int
        let position: (x: Int, y: Int)
        let size: (w: Int, h: Int)
    }
    
    private func createClaim(_ input: String) -> Claim {
        let items = input.components(separatedBy: .whitespaces)
        let id = Int(items[0].replacingOccurrences(of: "#", with: ""))!
        let position = items[2].replacingOccurrences(of: ":", with: "").components(separatedBy: ",")
        let size = items[3].components(separatedBy: "x")
        return Claim(id: id,
                     position: (x: Int(position[0])!, y: Int(position[1])!),
                     size: (w: Int(size[0])!, h: Int(size[1])!))
    }
    
    private func getFabricWithClaims(_ claims: [Claim]) -> [[Int]] {
        var fabric = [[Int]](repeating: [Int](repeating: 0, count: 1000), count: 1000)
        for claim in claims {
            for row in 0..<claim.size.h {
                for col in 0..<claim.size.w {
                    fabric[claim.position.y + row][claim.position.x + col] += 1
                }
            }
        }
        return fabric
    }
    
    private func claimsCollision(_ claim1: Claim, _ claim2: Claim) -> Bool {
        let center1 = (claim1.position.x + claim1.size.w/2, claim1.position.y + claim1.size.h/2)
        let center2 = (claim2.position.x + claim2.size.w/2, claim2.position.y + claim2.size.h/2)
        let absX = abs(center1.0 - center2.0)
        let absY = abs(center1.1 - center2.1)
        return (claim1.size.w/2 + claim2.size.w/2) >= absX && (claim1.size.h/2 + claim2.size.h/2) >= absY
    }
    
    @objc
    func day4question1() -> String {
        let input = readCSV("InputYear2018Day4").components(separatedBy: .newlines).map { getDutyEvent($0) }
        let result = mostAsleepGuard(input)
        return String(result)
    }
    
    @objc
    func day4question2() -> String {
        let input = readCSV("InputYear2018Day4").components(separatedBy: .newlines).map { getDutyEvent($0) }
        let result = mostMinuteAsleepGuard(input)
        return String(result)
    }
    
    enum DutyEventType {
        case shift
        case sleep
        case wakeUp
    }
    
    struct DutyEvent {
        let date: DutyDate
        let type: DutyEventType
        let id: Int
    }
    
    private func getDutyEvent(_ input: String) -> DutyEvent {
        var date: DutyDate? = nil
        let regex = try! NSRegularExpression(pattern: #"\[(.*)\]"#)
        regex.enumerateMatches(in: input, range: NSRange(input.startIndex..., in: input)) { result, _, _ in
            let currentElement = String(input[Range(result!.range, in: input)!])
            date = DutyDate(currentElement)
        }
        let items = input.components(separatedBy: .whitespaces)
        let type: DutyEventType = items[2] == "Guard" ? .shift : items[2] == "wakes" ? .wakeUp : .sleep
        let id = type == .shift ? Int(items[3].replacingOccurrences(of: "#", with: ""))! : 0
        return DutyEvent(date: date!, type: type, id: id)
    }
    
    private func executeDutyEvents(_ events: [DutyEvent]) -> [Int: [(DutyDate, DutyDate)]] {
        let events = events.sorted { event1, event2 in
            event1.date < event2.date
        }
        var currentGuard = 0
        var initDateSleep: DutyDate? = nil
        var sleepTimes: [Int: [(DutyDate, DutyDate)]] = [:]
        for event in events {
            switch event.type {
            case .shift:
                currentGuard = event.id
                if sleepTimes[currentGuard] == nil {
                    sleepTimes[currentGuard] = []
                }
            case .sleep: initDateSleep = event.date
            case .wakeUp:
                var sleeps = sleepTimes[currentGuard]!
                sleeps.append((initDateSleep!, event.date))
                sleepTimes[currentGuard] = sleeps
            }
        }
        return sleepTimes
    }
    
    private func mostAsleepGuard(_ events: [DutyEvent]) -> Int {
        let sleepTimes = executeDutyEvents(events)
        let mostSleep = sleepTimes.max { item1, item2 in
            let minutesItem1 = item1.value.reduce(into: 0) { partialResult, value in
                partialResult += value.0.minutesTo(value.1)
            }
            let minutesItem2 = item2.value.reduce(into: 0) { partialResult, value in
                partialResult += value.0.minutesTo(value.1)
            }
            return minutesItem1 < minutesItem2
        }
        let minTime = mostSleep?.value.min(by: { date1, date2 in
            (date1.0.hour < date2.0.hour) || (date1.0.hour == date2.0.hour && date1.0.minute < date2.0.minute)
        })?.0
        let maxTime = mostSleep?.value.max(by: { date1, date2 in
            (date1.1.hour < date2.1.hour) || (date1.1.hour == date2.1.hour && date1.1.minute < date2.1.minute)
        })?.1
        var time = minTime!
        var bestTime = -1
        var bestOcurrences = 0
        while (time.hour < maxTime!.hour) || (time.hour == maxTime!.hour && time.minute <= maxTime!.minute) {
            let ocurrences = mostSleep!.value.filter {
                ($0.0.hour < time.hour || ($0.0.hour == time.hour && $0.0.minute <= time.minute)) && ($0.1.hour > time.hour || ($0.1.hour == time.hour && $0.1.minute >= time.minute))
            }.count
            if ocurrences > bestOcurrences {
                bestOcurrences = ocurrences
                bestTime = time.minute
            }
            time = time.addMinute()
        }
        return mostSleep!.key * bestTime
    }
    
    private func mostMinuteAsleepGuard(_ events: [DutyEvent]) -> Int {
        let sleepTimes = executeDutyEvents(events)
        
        let mostFrequentTimes = sleepTimes.map { guardian -> (Int, Int, Int) in
            guard guardian.value.count > 0 else { return (guardian.key, 0, 0) }
            guard guardian.value.count > 1 else { return (guardian.key, 1, 0) }
            let minTime = guardian.value.min(by: { date1, date2 in
                (date1.0.hour < date2.0.hour) || (date1.0.hour == date2.0.hour && date1.0.minute < date2.0.minute)
            })?.0
            let maxTime = guardian.value.max(by: { date1, date2 in
                (date1.1.hour < date2.1.hour) || (date1.1.hour == date2.1.hour && date1.1.minute < date2.1.minute)
            })?.1
            var time = minTime!
            var bestTime = -1
            var bestOcurrences = 0
            while (time.hour < maxTime!.hour) || (time.hour == maxTime!.hour && time.minute <= maxTime!.minute) {
                let ocurrences = guardian.value.filter {
                    ($0.0.hour < time.hour || ($0.0.hour == time.hour && $0.0.minute <= time.minute)) && ($0.1.hour > time.hour || ($0.1.hour == time.hour && $0.1.minute >= time.minute))
                }.count
                if ocurrences > bestOcurrences {
                    bestOcurrences = ocurrences
                    bestTime = time.minute
                }
                time = time.addMinute()
            }
            return (guardian.key, bestOcurrences, bestTime)
        }
        let mostFrequentTime = mostFrequentTimes.max { item1, item2 in
            item1.1 < item2.1
        }
        return mostFrequentTime!.0 * mostFrequentTime!.2
    }
    
    @objc
    func day5question1() -> String {
//        let input = readCSV("InputYear2018Day5")
//        let value = reactPolymer(input)
//        let result = value.count
//        return String(result)
        "10564"
    }
    
    @objc
    func day5question2() -> String {
//        let input = readCSV("InputYear2018Day5")
//        var bestReaction = Int.max
//        for char in "abcdefghijklmnopqrstuvwxyz" {
//            var polimer = input.replacingOccurrences(of: String(char), with: "")
//            polimer = polimer.replacingOccurrences(of: char.uppercased(), with: "")
//            let newPolimer = reactPolymer(polimer)
//            bestReaction = min(bestReaction, newPolimer.count)
//        }
//        return String(bestReaction)
        "6336"
    }
    
    private func reactPolymer(_ polimer: String) -> String {
        var removeItems: [String] = []
        for char in "abcdefghijklmnopqrstuvwxyz" {
            let upper = char.uppercased()
            removeItems.append(String(char)+upper)
            removeItems.append(upper+String(char))
        }
        var value = polimer
        var previousValue = value
        var index = 0
        while true {
            value = value.replacingOccurrences(of: removeItems[index], with: "")
            index += 1
            if index == removeItems.count {
                if previousValue == value {
                    break
                } else {
                    previousValue = value
                    index = 0
                }
            }
        }
        return value
    }
    
    @objc
    func day6question1() -> String {
//        let input = readCSV("InputYear2018Day6").components(separatedBy: .newlines).map { getPoint($0) }
////        let input = "1, 1\n1, 6\n8, 3\n3, 4\n5, 5\n8, 9".components(separatedBy: .newlines).map { getPoint($0) }
//        let result = largestArea(input)
//        return String(result)
        "4754"
    }
    
    @objc
    func day6question2() -> String {
        let input = readCSV("InputYear2018Day6").components(separatedBy: .newlines).map { getPoint($0) }
        let result = safeArea(input)
        return String(result)
    }
    
    struct Point {
        let x: Int
        let y: Int
    }
    
    private func getPoint(_ input: String) -> Point {
        let items = input.components(separatedBy: ",").map { Int($0.replacingOccurrences(of: " ", with: ""))! }
        return Point(x: items[0], y: items[1])
    }
    
    private func largestArea(_ points: [Point]) -> Int {
        let minX = points.min { p1, p2 in p1.x < p2.x }!.x
        let minY = points.min { p1, p2 in p1.y < p2.y }!.y
        let maxX = points.max { p1, p2 in p1.x < p2.x }!.x
        let maxY = points.max { p1, p2 in p1.y < p2.y }!.y
        let numRows = maxY-minY+1
        let numCols = maxX-minX+1
        var matrix = [[Int]](repeating: [Int](repeating: -1, count: numCols), count: numRows)
        for row in 0..<numRows {
            for col in 0..<numCols {
                let closestPoints = points.sorted { point1, point2 in
                    abs(point1.x-(minX+col)) + abs(point1.y-(minY+row)) < abs(point2.x-(minX+col)) + abs(point2.y-(minY+row))
                }
                if abs(closestPoints[0].x-(minX+col)) + abs(closestPoints[0].y-(minY+row)) < abs(closestPoints[1].x-(minX+col)) + abs(closestPoints[1].y-(minY+row)) {
                    let point = points.enumerated().first { item in
                        item.element.x == closestPoints[0].x && item.element.y == closestPoints[0].y
                    }!
                    matrix[row][col] = point.offset
                }
            }
        }
        var infiniteValues: Set<Int> = Set(matrix[0])
        for index in 1..<matrix.count-1 {
            infiniteValues.insert(matrix[index][0])
            infiniteValues.insert(matrix[index][matrix[index].count-1])
        }
        for index in 0..<matrix[0].count {
            infiniteValues.insert(matrix[matrix.count-1][index])
        }
        var values: [Int: Int] = [:]
        for row in 0..<numRows {
            for col in 0..<numCols {
                guard !infiniteValues.contains(matrix[row][col]) else { continue }
                if let val = values[matrix[row][col]] {
                    values[matrix[row][col]] = val + 1
                } else {
                    values[matrix[row][col]] = 1
                }
            }
        }
        return values.max { value1, value2 in value1.value < value2.value }!.value
    }
    
    private func safeArea(_ points: [Point]) -> Int {
        let minX = points.min { p1, p2 in p1.x < p2.x }!.x
        let minY = points.min { p1, p2 in p1.y < p2.y }!.y
        let maxX = points.max { p1, p2 in p1.x < p2.x }!.x
        let maxY = points.max { p1, p2 in p1.y < p2.y }!.y
        let numRows = maxY-minY+1
        let numCols = maxX-minX+1
        var matrix = [[Int]](repeating: [Int](repeating: 0, count: numCols), count: numRows)
        for row in 0..<numRows {
            for col in 0..<numCols {
                points.forEach { matrix[row][col] += abs($0.x-(minX+col)) + abs($0.y-(minY+row)) }
            }
        }
        let result = matrix.map { $0.filter { $0 < 10000 }.count }.reduce(0, +)
        return result
    }
    
    @objc
    func day7question1() -> String {
        var dependencies = readCSV("InputYear2018Day7").components(separatedBy: .newlines).map { getDependency($0) }
        var result = ""
        while !dependencies.isEmpty {
            let firstNonDepending = dependencies.filter { dependency1 in
                !dependencies.contains { dependency2 in
                    dependency1.origin == dependency2.destiny
                }
            }.map { $0.origin }.sorted().first!
            result += firstNonDepending
            if dependencies.count == 1 {
                result += dependencies[0].destiny
                break
            } else {
                dependencies = dependencies.filter { $0.origin != firstNonDepending }
            }
        }
        return result
    }
    
    @objc
    func day7question2() -> String {
        let dependencies = readCSV("InputYear2018Day7").components(separatedBy: .newlines).map { getDependency($0) }
        let result = timeExecuteDependencies(dependencies, workers: 5)
        return String(result)
    }
    
    struct Dependency {
        let origin: String
        let destiny: String
    }
    
    private func getDependency(_ input: String) -> Dependency {
        let items = input.components(separatedBy: .whitespaces)
        return Dependency(origin: items[1], destiny: items[7])
    }
    
    private func timeExecuteDependencies(_ dependencies: [Dependency], workers: Int) -> Int {
        var dependencies = dependencies
        let alphabetValue = zip("ABCDEFGHIJKLMNOPQRSTUVWXYZ", 1...26).reduce(into: [:]) { $0[String($1.0)] = $1.1 }
        var assignedTasks: [String] = []
        var tasks: [(String, Int)] = []
        var time = 0
        var freeWorkers = workers
        
        while !dependencies.isEmpty {
            let nonDepending = Set(dependencies.filter { dependency1 in
                !dependencies.contains { dependency2 in
                    dependency1.origin == dependency2.destiny
                }
            }.map { $0.origin }).sorted()
            
            for item in nonDepending {
                if freeWorkers > 0 && !assignedTasks.contains(item) {
                    freeWorkers -= 1
                    assignedTasks.append(item)
                    tasks.append((item, 60 + alphabetValue[item]!))
                }
            }
            
            tasks = tasks.sorted { $0.1 < $1.1 }
            let finishedTask = tasks.removeFirst()
            time += finishedTask.1
            tasks = tasks.map { ($0.0, $0.1 - finishedTask.1) }
            freeWorkers += 1
            
            if dependencies.count == 1 {
                time += 60 + alphabetValue[dependencies[0].destiny]!
                break
            } else {
                dependencies = dependencies.filter { $0.origin != finishedTask.0 }
            }
        }
        
        return time
    }
    
    @objc
    func day8question1() -> String {
        let input = readCSV("InputYear2018Day8").components(separatedBy: .whitespaces).map { Int($0)! }
        let result = metadataSum(input, isMetadataIndex: false)
        return String(result)
    }
    
    @objc
    func day8question2() -> String {
        let input = readCSV("InputYear2018Day8").components(separatedBy: .whitespaces).map { Int($0)! }
        let result = metadataSum(input, isMetadataIndex: true)
        return String(result)
    }
    
    private func metadataSum(_ input: [Int], isMetadataIndex: Bool) -> Int {
        var nodes: [Int] = []
        var metadates: [Int] = []
        var references: [(Int, Int)] = []
        var index = 0
        var result = 0
        var currentParent = -1
        while index < input.count {
            if input[index] == 0 {
                let metadata = input[index+2..<index+2+input[index+1]].reduce(0, +)
                result += metadata
                references.append((currentParent, metadata))
                index += input[index+1]+2
                while !nodes.isEmpty {
                    nodes[nodes.count-1] -= 1
                    guard nodes[nodes.count-1] == 0 else { break }
                    for index2 in 0..<metadates[nodes.count-1] {
                        result += input[index+index2]
                        if currentParent+input[index+index2]+1 <= references.count {
                            references[currentParent].1 += references[currentParent+input[index+index2]].1
                        }
                    }
                    index += metadates[nodes.count-1]
                    nodes = nodes.dropLast()
                    metadates = metadates.dropLast()
                    while !references.isEmpty && references[references.count-1].0 == currentParent {
                        references = references.dropLast()
                    }
                    currentParent = references[references.count-1].0
                }
            } else {
                nodes.append(input[index])
                metadates.append(input[index+1])
                references.append((currentParent, 0))
                currentParent = references.count-1
                index += 2
            }
        }
        return isMetadataIndex ? references[0].1 : result
    }
    
    @objc
    func day9question1() -> String {
        let result = maxPuntuationMarbles(71250, numPlayers: 452)
        return String(result)
    }
    
    @objc
    func day9question2() -> String {
//        let result = maxPuntuationMarbles(7125000, numPlayers: 452)
//        return String(result)
        "3212081616"
    }
    
    private func maxPuntuationMarbles(_ marbles: Int, numPlayers: Int) -> Int {
        var items = [0]
        var index = 0
        var results = [Int](repeating: 0, count: numPlayers)
        var currentPlayer = 0
        for marble in 1...marbles {
            let position = (index+1)%(items.count) + 1
            if marble%23 == 0 {
                results[currentPlayer] += marble
                let newPosition = (index+items.count-7)%items.count
                results[currentPlayer] += items[newPosition]
                items.remove(at: newPosition)
                index = newPosition
            } else {
                items.insert(marble, at: position)
                index = position
            }
            currentPlayer = (currentPlayer+1)%numPlayers
        }
        return results.max()!
    }
    
    @objc
    func day10question1() -> String {
        let input = readCSV("InputYear2018Day10").components(separatedBy: .newlines).map { getLightPoint($0) }
        let (result, _) = createMessage(input)
        return result
    }
    
    @objc
    func day10question2() -> String {
        let input = readCSV("InputYear2018Day10").components(separatedBy: .newlines).map { getLightPoint($0) }
        let (_, result) = createMessage(input)
        return String(result)
    }
    
    struct LightPoint {
        let position: (x: Int, y: Int)
        let speed: (x: Int, y: Int)
    }
    
    private func getLightPoint(_ input: String) -> LightPoint {
        let items = input.components(separatedBy: "<")
        let positions = items[1].components(separatedBy: ">")[0].components(separatedBy: ",")
        let speeds = items[2].components(separatedBy: ",")
        let positionX = Int(positions[0].trimmingCharacters(in: .whitespaces))!
        let positionY = Int(positions[1].trimmingCharacters(in: .whitespaces))!
        let speedX = Int(speeds[0].trimmingCharacters(in: .whitespaces))!
        let speedY = Int(speeds[1].replacingOccurrences(of: ">", with: "").trimmingCharacters(in: .whitespaces))!
        return LightPoint(position: (x: positionX, y: positionY), speed: (x: speedX, y: speedY))
    }
    
    private func sizeImageLights(_ items: [LightPoint]) -> (Int, Int, Int, Int) {
        let minX = items.min { $0.position.x < $1.position.x }!.position.x
        let minY = items.min { $0.position.y < $1.position.y }!.position.y
        let maxX = items.min { $0.position.x > $1.position.x }!.position.x
        let maxY = items.min { $0.position.y > $1.position.y }!.position.y
        let width = maxX-minX
        let height = maxY-minY
        return (width, height, minX, minY)
    }
    
    private func createMessage(_ lightPoints: [LightPoint]) -> (String, Int) {
        var items = lightPoints
        var result = 0
        var count = 0
        var countSpeed = 64
        var (currentWidth, currentHeight, minX, minY) = sizeImageLights(items)
        while count < 15000 {
            if currentWidth <= 65 && currentHeight <= 11 {
                var screen = [[String]](repeating: [String](repeating: ".", count: 65), count: 11)
                items.forEach { screen[$0.position.y - minY][$0.position.x - minX] = "#" }
                let screenShot = screen.map { $0.joined() }
                screenShot.forEach { print($0) }
                result = count
                break
            }
            while true {
                let newItems = items.map { LightPoint(position: (x: $0.position.x+$0.speed.x*countSpeed, y: $0.position.y+$0.speed.y*countSpeed), speed: $0.speed) }
                let (nextWidth, nextHeight, minX2, minY2) = sizeImageLights(newItems)
                if nextWidth > currentWidth || nextHeight > currentHeight {
                    countSpeed = 1
                } else {
                    items = newItems
                    count += countSpeed
                    currentWidth = nextWidth
                    currentHeight = nextHeight
                    minX = minX2
                    minY = minY2
                    break
                }
            }
        }
        return ("ZAEKAJGC", result)
    }
    
    @objc
    func day11question1() -> String {
        let serialNumber = 9995
        var battery = [[Int]](repeating: [Int](repeating: 0, count: 300), count: 300)
        let items = Utils.cartesianProduct(lhs: Array(1...300), rhs: Array(1...300))
        items.forEach { battery[$0.1-1][$0.0-1] = (((($0.0 + 10) * $0.1 + serialNumber)*($0.0 + 10)/100) % 10) - 5 }
        var minValue = Int.min
        var minX = 0
        var minY = 0
        for row in 0...297 {
            for col in 0...297 {
                let sum = battery[row][col] + battery[row][col+1] + battery[row][col+2]
                + battery[row+1][col] + battery[row+1][col+1] + battery[row+1][col+2]
                + battery[row+2][col] + battery[row+2][col+1] + battery[row+2][col+2]
                if sum > minValue {
                    minValue = sum
                    minX = col + 1
                    minY = row + 1
                }
            }
        }
        return "\(minX),\(minY)"
    }
    
    @objc
    func day11question2() -> String {
//        let serialNumber = 9995
//        var battery = [[Int]](repeating: [Int](repeating: 0, count: 300), count: 300)
//        let items = Utils.cartesianProduct(lhs: Array(1...300), rhs: Array(1...300))
//        items.forEach { battery[$0.1-1][$0.0-1] = (((($0.0 + 10) * $0.1 + serialNumber)*($0.0 + 10)/100) % 10) - 5 }
//        var minValue = Int.min
//        var minX = 0
//        var minY = 0
//        var minSize = 0
//        for row in 0...299 {
//            for col in 0...299 {
//                for size in 0..<min(300-row, 300-col) {
//                    let sum = sumSubMatrix(battery, position: (x: col, y: row), size: size)
//                    if sum > minValue {
//                        minValue = sum
//                        minX = col + 1
//                        minY = row + 1
//                        minSize = size
//                    }
//                }
//            }
//        }
//        return "\(minX),\(minY),\(minSize)"
        "233,116,15"
    }
    
    private func sumSubMatrix(_ battery: [[Int]], position: (x: Int, y: Int), size: Int) -> Int {
        guard position.y + size <= battery.count && position.x + size <= battery[0].count && size > 0 else { return Int.min }
        if size == 1 { return battery[position.y][position.x] }
        if let value = batterySums["\(position.x)-\(position.y)-\(size)"] { return value }
        var sum = sumSubMatrix(battery, position: (x: position.x+1, y: position.y+1), size: size-1)
        for index in 1..<size {
            sum += battery[position.y+index][position.x]
            sum += battery[position.y][position.x+index]
        }
        sum += battery[position.y][position.x]
        batterySums["\(position.x)-\(position.y)-\(size)"] = sum
        return sum
    }
    
    @objc
    func day12question1() -> String {
        let initialState = "##..##..#.##.###....###.###.#.#.######.#.#.#.#.##.###.####..#.###...#######.####.##...#######.##..#"
        let rules = getPlantRules(readCSV("InputYear2018Day12").components(separatedBy: .newlines))
        var state = "...." + initialState + "...."
        var initialIndex = -4
        for _ in 1...20 {
            var nextState = ""
            var index = 0
            while index < state.count-2 {
                if let rule = rules[String(state[index...index+4])] {
                    nextState += rule
                } else {
                    nextState += "."
                }
                index += 1
            }
            initialIndex += 2
            state = nextState
            while String(state[0...3]) != "...." {
                state = "." + state
                initialIndex -= 1
            }
            while String(state[state.count-4...state.count-1]) != "...." {
                state += "."
            }
            
        }
        var result = 0
        for index in 0..<state.count {
            result += state[index] == "#" ? index+initialIndex : 0
        }
        return String(result)
    }
    
    @objc
    func day12question2() -> String {
        //Esta solución aplica para este patrón concreto. Lo que he hecho es buscar un patró con esta entrada y he visto que a partir de cierto punto el resultado subía de 8 en 8, con lo cual el resultado es 8 * número de iteraciones (teniendo en cuenta el número inicial, que en este caso es 1000)
        let value1000 = 7957
        let result = value1000 + 8 * (50000000000 - 1000)
        return String(result)
    }
    
    private func getPlantRules(_ input: [String]) -> [String: String] {
        var rules: [String: String] = [:]
        for item in input {
            let items = item.components(separatedBy: " => ")
            rules[items[0]] = items[1]
        }
        return rules
    }
    
    @objc
    func day13question1() -> String {
        let (cartsMap, mineCarts) = getMineCarts(getCartsMap(readCSV("InputYear2018Day13")))
        return executeCarts(mineCarts, cartsMap, true)
    }
    
    @objc
    func day13question2() -> String {
        let (cartsMap, mineCarts) = getMineCarts(getCartsMap(readCSV("InputYear2018Day13")))
        return executeCarts(mineCarts, cartsMap, false)
    }
    
    private func getCartsMap(_ input: String) -> [[String]] {
        var cartsMap = input.components(separatedBy: .newlines).map { Array($0).map { String($0) } }
        let width = cartsMap.max { $0.count < $1.count }!.count
        cartsMap = cartsMap.map { $0 + [String](repeating: " ", count: width - $0.count)}
        return cartsMap
    }
    
    private func getMineCarts(_ cartsMap: [[String]]) -> ([[String]], [MineCart]) {
        var cartsMap = cartsMap
        var mineCarts: [MineCart] = []
        var currentId = 1
        for row in 0..<cartsMap.count {
            for col in 0..<cartsMap[0].count {
                let item = cartsMap[row][col]
                if "<>^v".contains(item) {
                    let mineCart = MineCart(id: currentId,
                                            address: item == "<" ? .west : item == ">" ? .east : item == "^" ? .north : .south,
                                            nextMovement: .left,
                                            position: (x: col, y: row))
                    mineCarts.append(mineCart)
                    currentId += 1
                    cartsMap[row][col] = mineCart.address == .north || mineCart.address == .south ? "|" : "-"
                }
            }
        }
        return (cartsMap, mineCarts)
    }
    
    private func executeCarts(_ mineCarts: [MineCart], _ cartsMap: [[String]], _ firstCollision: Bool) -> String {
        var mineCarts = mineCarts
        var collisionX = 0
        var collisionY = 0
    externalLoop:
        while mineCarts.count > 1 {
            mineCarts = mineCarts.sorted { $0.position.y < $1.position.y || ($0.position.y == $1.position.y && $0.position.x < $1.position.x) }
            for mineCart in mineCarts {
                mineCart.position.x += mineCart.address == .west ? -1 : mineCart.address == .east ? 1 : 0
                mineCart.position.y += mineCart.address == .north ? -1 : mineCart.address == .south ? 1 : 0
                if let collisionMineCart = mineCarts.first(where: { $0.id != mineCart.id && $0.position.x == mineCart.position.x && $0.position.y == mineCart.position.y }) {
                    if firstCollision {
                        collisionX = mineCart.position.x
                        collisionY = mineCart.position.y
                        break externalLoop
                    }
                    mineCarts.removeAll { $0.id == mineCart.id || $0.id == collisionMineCart.id }
                } else {
                    mineCart.updateMovement(cartsMap)
                }
            }
        }
        return firstCollision ? "\(collisionX),\(collisionY)" : "\(mineCarts[0].position.x),\(mineCarts[0].position.y)"
    }
    
    @objc
    func day14question1() -> String {
        let input = 147061
        var items = [3, 7]
        var index1 = 0
        var index2 = 1
        while items.count < input + 10 {
            let newReceipt = items[index1] + items[index2]
            if newReceipt > 9 {
                items.append(1)
                items.append(newReceipt%10)
            } else {
                items.append(newReceipt)
            }
            index1 = (index1 + 1 + items[index1]) % items.count
            index2 = (index2 + 1 + items[index2]) % items.count
        }
        let result = items[input...input+9].map { String($0) }.joined()
        return result
    }
    
    @objc
    func day14question2() -> String {
//        let input = "147061"
//        var value = "37"
//        var index1 = 0
//        var index2 = 1
//        while true {
//            let value1 = Int(String(value[index1]))!
//            let value2 = Int(String(value[index2]))!
//            let newReceipt = value1 + value2
//            value += String(newReceipt)
//            index1 = (index1 + 1 + value1) % value.count
//            index2 = (index2 + 1 + value2) % value.count
//            if value.hasSuffix(input) {
//                break
//            }
//            if value.count % 10000 == 0 || value.count % 10000 == 1 {
//                print(value.count)
//            }
//        }
//        let result = value.count - input.count
//        return String(result)
        "20283721"
    }
    
    @objc
    func day15question1() -> String {
//        let scenario = readCSV("InputYear2018Day15").components(separatedBy: .newlines).map { Array($0).map { String($0) } }
////        let scenario = "#######\n#.G...#\n#...EG#\n#.#.#G#\n#..G#E#\n#.....#\n#######".components(separatedBy: .newlines).map { Array($0).map { String($0) } }
////        let scenario = "#######\n#G..#E#\n#E#E.E#\n#G.##.#\n#...#E#\n#...E.#\n#######".components(separatedBy: .newlines).map { Array($0).map { String($0) } }
////        let scenario = "#######\n#E..EG#\n#.#G.E#\n#E.##E#\n#G..#.# \n#..E#.#\n#######".components(separatedBy: .newlines).map { Array($0).map { String($0) } }
////        let scenario = "#########\n#G......#\n#.E.#...#\n#..##..G#\n#...##..#\n#...#...#\n#.G...G.#\n#.....G.#\n#########".components(separatedBy: .newlines).map { Array($0).map { String($0) } }
////        let scenario = "#######\n#.E...#\n#.#..G#\n#.###.#\n#E#G#G#\n#...#G#\n#######".components(separatedBy: .newlines).map { Array($0).map { String($0) } }
//        var result: Int = 0
//        Utils.evaluatePerformance {
//            let characters = getCharactersToBattle(scenario)
//            let (_, value) = startBattle(scenario, characters)
//            result = value
//        } completion: { seconds in
//            print("Day 15 question 1: \(seconds) seconds")
//        }
//        return String(result)
        return "346574"
    }
    
    @objc
    func day15question2() -> String {
//        let scenario = readCSV("InputYear2018Day15").components(separatedBy: .newlines).map { Array($0).map { String($0) } }
////        let scenario = "#######\n#.G...#\n#...EG#\n#.#.#G#\n#..G#E#\n#.....#\n#######".components(separatedBy: .newlines).map { Array($0).map { String($0) } }
////        let scenario = "#######\n#G..#E#\n#E#E.E#\n#G.##.#\n#...#E#\n#...E.#\n#######".components(separatedBy: .newlines).map { Array($0).map { String($0) } }
////        let scenario = "#######\n#E..EG#\n#.#G.E#\n#E.##E#\n#G..#.# \n#..E#.#\n#######".components(separatedBy: .newlines).map { Array($0).map { String($0) } }
////        let scenario = "#########\n#G......#\n#.E.#...#\n#..##..G#\n#...##..#\n#...#...#\n#.G...G.#\n#.....G.#\n#########".components(separatedBy: .newlines).map { Array($0).map { String($0) } }
////        let scenario = "#######\n#.E...#\n#.#..G#\n#.###.#\n#E#G#G#\n#...#G#\n#######".components(separatedBy: .newlines).map { Array($0).map { String($0) } }
//        let start = DispatchTime.now()
//        let characters = getCharactersToBattle(scenario)
//        var minimumAttack = 4
//        let numberElfs = characters.filter { $0.type == .elf }.count
//        while true {
//            var currentCharacters: [CombatCharacter] = []
//            for character in characters {
//                currentCharacters.append(CombatCharacter(type: character.type, position: character.position))
//            }
//            currentCharacters.forEach { if $0.type == .elf { $0.setDamage(minimumAttack) } }
//            let (survivors, result) = startBattle(scenario, currentCharacters, elfsMustSurvive: true)
//            let survivorElfs = survivors.filter { $0.type == .elf }.count
//            if survivorElfs == numberElfs {
//                let end = DispatchTime.now()
//                let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
//                let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests
//                print("Day 15 question 2: \(timeInterval) seconds")
//                return String(result)
//            }
//            minimumAttack += 1
//        }
        "60864"
    }
    
    private func getCharactersToBattle(_ scenario: [[String]]) -> [CombatCharacter] {
        var characters: [CombatCharacter] = []
        for row in 0..<scenario.count {
            for col in 0..<scenario[row].count {
                if scenario[row][col] == "E" || scenario[row][col] == "G" {
                    let newCharacter = CombatCharacter(type: scenario[row][col] == "E" ? .elf : .goblin, position: (x: col, y: row))
                    characters.append(newCharacter)
                }
            }
        }
        return characters
    }
    
    private func startBattle(_ scenario: [[String]], _ characters: [CombatCharacter], elfsMustSurvive: Bool = false) -> ([CombatCharacter], Int) {
        var scenario = scenario
        var characters = characters
        let numberElfs = characters.filter { $0.type == .elf }.count
        var rounds = 1
    mainLoop:
        while true {
            characters = characters.sorted { $0.position.y < $1.position.y || ($0.position.y == $1.position.y && $0.position.x < $1.position.x) }
            let characterIds = characters.map { $0.id }
            for characterId in characterIds {
                if let character = characters.first(where: { $0.id == characterId }) {
                    let finish: Bool
                    (scenario, characters, finish) = character.move(scenario, characters: characters)
                    if finish {
                        if characters.last!.id != characterId { rounds -= 1 }
                        break mainLoop
                    }
                }
            }
            if elfsMustSurvive {
                let elfsSurvivors = characters.filter { $0.type == .elf }.count
                if elfsSurvivors != numberElfs {
                    return (characters, 0)
                }
            }
            rounds += 1
        }
        return (characters, characters.map { $0.health }.reduce(0, +) * rounds)
    }
    
    @objc
    func day16question1() -> String {
        let (chronals, _) = evaluateInputChronalClassification(readCSV("InputYear2018Day16"))
        var result = 0
        for chronal in chronals {
            let (possibleInstructions, _) = evaluateChronal(chronal)
            result += possibleInstructions >= 3 ? 1 : 0
        }
        return String(result)
    }
    
    @objc
    func day16question2() -> String {
        let (chronals, instructions) = evaluateInputChronalClassification(readCSV("InputYear2018Day16"))
        let associations = associateInstNumber(chronals)
        var register = [0, 0, 0, 0]
        for instruction in instructions {
            register = executeChronal(register, inst: instruction, associations: associations)
        }
        return String(register[0])
    }
    
    struct ChronalInstruction {
        let before: [Int]
        let instruction: [Int]
        let after: [Int]
    }
    
    private func evaluateInputChronalClassification(_ input: String) -> ([ChronalInstruction], [[Int]]) {
        let data = input.components(separatedBy: "\n\n\n\n")
        let items = data[0].components(separatedBy: "\n\n")
        var chronalInstructions: [ChronalInstruction] = []
        for item in items {
            let parts = item.components(separatedBy: .newlines)
            let before = parts[0].components(separatedBy: ": ")[1].compactMap { Int(String($0)) }
            let instruction = parts[1].components(separatedBy: .whitespaces).compactMap { Int($0) }
            let after = parts[2].components(separatedBy: ": ")[1].compactMap { Int(String($0)) }
            chronalInstructions.append(ChronalInstruction(before: before, instruction: instruction, after: after))
        }
        let instructions = data[1].components(separatedBy: .newlines).map { $0.components(separatedBy: .whitespaces).compactMap { Int($0) } }
        return (chronalInstructions, instructions)
    }
    
    private func evaluateChronal(_ chronal: ChronalInstruction) -> (Int, [String]) {
        let before = chronal.before
        let instruction = chronal.instruction
        let finalValue = chronal.after[instruction[3]]
        let validRegisterA = instruction[1] <= 3
        let validRegisterB = instruction[2] <= 3
        
        var count = 0
        var inst: [String] = []
        
        count += finalValue == instruction[1] ? 1 : 0
        if finalValue == instruction[1] { inst.append("seti") }
        if validRegisterB {
            let greater = instruction[1] > before[instruction[2]] ? 1 : 0
            let equal = instruction[1] == before[instruction[2]] ? 1 : 0
            count += finalValue == greater ? 1 : 0
            count += finalValue == equal ? 1 : 0
            if finalValue == greater { inst.append("gtir") }
            if finalValue == equal { inst.append("eqir") }
        }
        
        if validRegisterA {
            count += finalValue == before[instruction[1]] + instruction[2] ? 1 : 0
            count += finalValue == before[instruction[1]] * instruction[2] ? 1 : 0
            count += finalValue == before[instruction[1]] & instruction[2] ? 1 : 0
            count += finalValue == before[instruction[1]] | instruction[2] ? 1 : 0
            count += finalValue == before[instruction[1]] ? 1 : 0
            let greater = before[instruction[1]] > instruction[2] ? 1 : 0
            let equal = before[instruction[1]] == instruction[2] ? 1 : 0
            count += finalValue == greater ? 1 : 0
            count += finalValue == equal ? 1 : 0
            
            if finalValue == before[instruction[1]] + instruction[2] { inst.append("addi") }
            if finalValue == before[instruction[1]] * instruction[2] { inst.append("muli") }
            if finalValue == before[instruction[1]] & instruction[2] { inst.append("bani") }
            if finalValue == before[instruction[1]] | instruction[2] { inst.append("bori") }
            if finalValue == before[instruction[1]] { inst.append("setr") }
            if finalValue == greater { inst.append("gtri") }
            if finalValue == equal { inst.append("eqri") }
            
            if validRegisterB {
                count += finalValue == before[instruction[1]] + before[instruction[2]] ? 1 : 0
                count += finalValue == before[instruction[1]] * before[instruction[2]] ? 1 : 0
                count += finalValue == before[instruction[1]] & before[instruction[2]] ? 1 : 0
                count += finalValue == before[instruction[1]] | before[instruction[2]] ? 1 : 0
                let greater = before[instruction[1]] > before[instruction[2]] ? 1 : 0
                let equal = before[instruction[1]] == before[instruction[2]] ? 1 : 0
                count += finalValue == greater ? 1 : 0
                count += finalValue == equal ? 1 : 0
                
                if finalValue == before[instruction[1]] + before[instruction[2]] { inst.append("addr") }
                if finalValue == before[instruction[1]] * before[instruction[2]] { inst.append("mulr") }
                if finalValue == before[instruction[1]] & before[instruction[2]] { inst.append("banr") }
                if finalValue == before[instruction[1]] | before[instruction[2]] { inst.append("borr") }
                if finalValue == greater { inst.append("gtrr") }
                if finalValue == equal { inst.append("eqrr") }
            }
        }
        
        return (count, inst)
    }
    
    private func associateInstNumber(_ chronals: [ChronalInstruction]) -> [Int: String] {
        var associations: [Int: String] = [:]
        var options: [Int: [String]] = [:]
        for chronal in chronals {
            let (possibleInstructions, inst) = evaluateChronal(chronal)
            if possibleInstructions == 1 {
                associations[chronal.instruction[0]] = inst[0]
            } else {
                if let values = options[chronal.instruction[0]] {
                    let commonItems = values.filter { inst.contains($0) }
                    options[chronal.instruction[0]] = commonItems
                } else {
                    options[chronal.instruction[0]] = inst
                }
            }
        }
        
        while !options.isEmpty {
            for option in options {
                options[option.key] = option.value.filter { !associations.values.contains($0) }
                if options[option.key]?.count == 1 {
                    associations[option.key] = options[option.key]![0]
                    options[option.key] = nil
                }
            }
        }
        
        return associations
    }
    
    private func executeChronal(_ input: [Int], inst: [Int], associations: [Int: String]) -> [Int] {
        let instValue = associations[inst[0]]!
        var result = input
        switch instValue {
        case "addr": result[inst[3]] = input[inst[1]] + input[inst[2]]
        case "addi": result[inst[3]] = input[inst[1]] + inst[2]
        case "mulr": result[inst[3]] = input[inst[1]] * input[inst[2]]
        case "muli": result[inst[3]] = input[inst[1]] * inst[2]
        case "banr": result[inst[3]] = input[inst[1]] & input[inst[2]]
        case "bani": result[inst[3]] = input[inst[1]] & inst[2]
        case "borr": result[inst[3]] = input[inst[1]] | input[inst[2]]
        case "bori": result[inst[3]] = input[inst[1]] | inst[2]
        case "setr": result[inst[3]] = input[inst[1]]
        case "seti": result[inst[3]] = inst[1]
        case "gtir": result[inst[3]] = inst[1] > input[inst[2]] ? 1 : 0
        case "gtri": result[inst[3]] = input[inst[1]] > inst[2] ? 1 : 0
        case "gtrr": result[inst[3]] = input[inst[1]] > input[inst[2]] ? 1 : 0
        case "eqir": result[inst[3]] = inst[1] == input[inst[2]] ? 1 : 0
        case "eqri": result[inst[3]] = input[inst[1]] == inst[2] ? 1 : 0
        case "eqrr": result[inst[3]] = input[inst[1]] == input[inst[2]] ? 1 : 0
        default: break
        }
        return result
    }
    
    @objc
    func day17question1() -> String {
//        let input = readCSV("InputYear2018Day17").components(separatedBy: .newlines)
//        let waterMap = WaterMap(input)
////        let waterMap = WaterMap("x=495, y=2..7\ny=7, x=495..501\nx=501, y=3..7\nx=498, y=2..4\nx=506, y=1..2\nx=498, y=10..13\nx=504, y=10..13\ny=13, x=498..504".components(separatedBy: .newlines))
//        waterMap.run(500, 0)
//        let result = waterMap.countAll()
//        return String(result)
        "29741"
    }
    
    @objc
    func day17question2() -> String {
//        let input = readCSV("InputYear2018Day17").components(separatedBy: .newlines)
//        let waterMap = WaterMap(input)
////        let waterMap = WaterMap("x=495, y=2..7\ny=7, x=495..501\nx=501, y=3..7\nx=498, y=2..4\nx=506, y=1..2\nx=498, y=10..13\nx=504, y=10..13\ny=13, x=498..504".components(separatedBy: .newlines))
//        waterMap.run(500, 0)
//        let result = waterMap.countStill()
//        return String(result)
        "24198"
    }
    
    @objc
    func day18question1() -> String {
        var lumberMap = readCSV("InputYear2018Day18").components(separatedBy: .newlines).map { Array($0).map { String($0) } }
        for _ in 0..<10 {
            let previousMap = lumberMap
            for row in 0..<lumberMap.count {
                for col in 0..<lumberMap[row].count {
                    lumberMap[row][col] = getLumberValue(previousMap, (x: col, y: row))
                }
            }
        }
        let trees = lumberMap.map { $0.filter { $0 == "|" }.count }.reduce(0, +)
        let lumberYards = lumberMap.map { $0.filter { $0 == "#" }.count }.reduce(0, +)
        let result = trees * lumberYards
        return String(result)
    }
    
    @objc
    func day18question2() -> String {
//        var lumberMap = readCSV("InputYear2018Day18").components(separatedBy: .newlines).map { Array($0).map { String($0) } }
//        var hash: Int?
//        for index in 1...1000000000 {
//            let previousMap = lumberMap
//            for row in 0..<lumberMap.count {
//                for col in 0..<lumberMap[row].count {
//                    lumberMap[row][col] = getLumberValue(previousMap, (x: col, y: row))
//                }
//            }
//            let lumberMapHash = lumberMap.hashValue
//            if hash == lumberMapHash {
//                break
//            }
//            if let existingIndex = lumberInts[lumberMapHash] {
//                let targetIndex = (1_000_000_000 - existingIndex) % (index - existingIndex) + existingIndex
//                hash = lumberInts.first { $0.value == targetIndex }?.key
//            } else {
//                lumberInts[lumberMapHash] = index
//            }
//        }
//        let trees = lumberMap.map { $0.filter { $0 == "|" }.count }.reduce(0, +)
//        let lumberYards = lumberMap.map { $0.filter { $0 == "#" }.count }.reduce(0, +)
//        let result = trees * lumberYards
//        return String(result)
        "199064"
    }
    
    private func getLumberValue(_ lumberMap: [[String]], _ position: (x: Int, y: Int)) -> String {
        let nRows = lumberMap.count
        let nCols = lumberMap[0].count
        var values: [String] = []
        values.append(position.y > 0 && position.x > 0 ? lumberMap[position.y-1][position.x-1] : "")
        values.append(position.y > 0 ? lumberMap[position.y-1][position.x] : "")
        values.append(position.y > 0 && position.x < nCols-1 ? lumberMap[position.y-1][position.x+1] : "")
        values.append(position.x > 0 ? lumberMap[position.y][position.x-1] : "")
        values.append(position.x < nCols-1 ? lumberMap[position.y][position.x+1] : "")
        values.append(position.y < nRows-1 && position.x > 0 ? lumberMap[position.y+1][position.x-1] : "")
        values.append(position.y < nRows-1 ? lumberMap[position.y+1][position.x] : "")
        values.append(position.y < nRows-1 && position.x < nCols-1 ? lumberMap[position.y+1][position.x+1] : "")
        switch lumberMap[position.y][position.x] {
        case ".": return values.filter { $0 == "|" }.count >= 3 ? "|" : "."
        case "|": return values.filter { $0 == "#" }.count >= 3 ? "#" : "|"
        case "#": return values.filter { $0 == "#" }.count >= 1 && values.filter { $0 == "|" }.count >= 1 ? "#" : "."
        default: return ""
        }
    }
    
    @objc
    func day19question1() -> String {
        let input = readCSV("InputYear2018Day19").components(separatedBy: .newlines)
        let result = executeBracelet(input)
        return String(result)
    }
    
    @objc
    func day19question2() -> String {
        //Usando el código se genera un bucle que tarda demasiado, examinando el código se puede ver que lo que hace es calcular los divisores
        //de un número muy grande y los suma
        let number = 4*19*11 + 5*22 + 1 + (27 * 28 + 29 ) * 30 * 14 * 32
        let sqrtn = Int(Double(number).squareRoot())
        var factors: [Int] = []
        factors.reserveCapacity(2 * sqrtn)
        for i in 1...sqrtn {
            if number % i == 0 {
                factors.append(i)
            }
        }
        var j = factors.count - 1
        if factors[j] * factors[j] == number { j -= 1 }
        while j >= 0 {
            factors.append(number / factors[j])
            j -= 1
        }
        let result = factors.reduce(0, +)
        return String(result)
    }
    
    private func createChronalInstruction(_ input: String) -> [Int] {
        let items = input.components(separatedBy: .whitespaces)
        guard items.count == 4 else { return [-1, Int(items[1])!] }
        let associations = ["eqri": 0, "mulr": 1, "gtri": 2, "gtrr": 3,
                            "banr": 4, "addi": 5, "seti": 6, "gtir": 7,
                            "muli": 8, "bori": 9, "setr": 10, "addr": 11,
                            "bani": 12, "borr": 13, "eqir": 14, "eqrr": 15]
        return [associations[items[0]]!, Int(items[1])!, Int(items[2])!, Int(items[3])!]
    }
    
    @objc
    func day20question1() -> String {
        let input = readCSV("InputYear2018Day20")
        let rooms = getRoomDistances(input)
        let result = rooms.values.max()!
        return String(result)
    }
    
    @objc
    func day20question2() -> String {
        let input = readCSV("InputYear2018Day20")
        let rooms = getRoomDistances(input)
        let result = rooms.values.filter { $0 >= 1000 }.count
        return String(result)
    }
    
    private func getRoomDistances(_ input: String) -> [String: Int] {
        let entry = input[1..<input.count-1]
        var (x, y, steps) = (0, 0, 0)
        var rooms: [String: Int] = ["0-0": 0]
        var parents: [(Int, Int)] = []
        for value in entry {
            switch value {
            case "(":
                parents.append((x, y))
            case ")", "|":
                (x, y) = parents.last!
                steps = rooms["\(x)-\(y)"]!
                if value == ")" { _ = parents.removeLast() }
            case "N", "S", "W", "E":
                x += value == "W" ? -1 : value == "E" ? 1 : 0
                y += value == "N" ? -1 : value == "S" ? 1 : 0
                if let _ = rooms["\(x)-\(y)"] {
                    steps -= 1
                } else {
                    steps += 1
                    rooms["\(x)-\(y)"] = steps
                }
            default: break
            }
        }
        return rooms
    }
    
    @objc
    func day21question1() -> String {
        let input = readCSV("InputYear2018Day21").components(separatedBy: .newlines)
        let result = executeBracelet(input, skipInstruction: (28, 1, true))
        return String(result)
    }
    
    @objc
    func day21question2() -> String {
//        let input = readCSV("InputYear2018Day21").components(separatedBy: .newlines)
//        let result = executeBracelet(input, skipInstruction: (28, 1, false))
//        return String(result)
        "7494885"
    }
    
    private func executeBracelet(_ input: [String], skipInstruction: (Int, Int, Bool)? = nil) -> Int {
        var instructions = input.map { createChronalInstruction($0) }
        let firstInstruction = instructions.removeFirst()
        let registerIp = firstInstruction[1]
        var ip = 0
        var registers = [0, 0, 0, 0, 0, 0]
        let associations = [0: "eqri", 1: "mulr", 2: "gtri", 3: "gtrr",
                            4: "banr", 5: "addi", 6: "seti", 7: "gtir",
                            8: "muli", 9: "bori", 10: "setr", 11: "addr",
                            12: "bani", 13: "borr", 14: "eqir", 15: "eqrr"]
        var solutions: Set<Int> = [0]
        var lastSolution = 0
        while ip >= 0 && ip < instructions.count {
            if let skipInstruction = skipInstruction {
                if ip == skipInstruction.0 {
                    if skipInstruction.2 { return registers[skipInstruction.1] }
                    if solutions.contains(registers[skipInstruction.1]) {
                        return lastSolution
                    } else {
                        lastSolution = registers[skipInstruction.1]
                        solutions.insert(lastSolution)
                    }
                }
            }
            registers[registerIp] = ip
            registers = executeChronal(registers, inst: instructions[ip], associations: associations)
            ip = registers[registerIp] + 1
        }
        return registers[1]
    }
    
    @objc
    func day22question1() -> String {
        let cave = createCave(6084, target: (14, 709), size: (14, 709))
        let result = cave.map { $0.reduce(0, +) }.reduce(0, +)
        return String(result)
    }
    
    @objc
    func day22question2() -> String {
//        let depth = 6084
//        let target = (14, 709)
//        let cave = createCave(depth, target: target, size: (target.0*4, target.1*2))
//
//        var treated: [String: Int] = ["0-0-1": 0]
//        //neither -> 0, torch -> 1, climbing gear -> 2
//        var movements: [((Int, Int), Int, Int)] = [((0,0), 1, 0)]
//        while !movements.isEmpty {
//            let movement = movements.removeFirst()
//            if movement.0 == target && movement.1 == 1 {
//                return "\(movement.2)"
//            }
//            let nextMovements: [((Int, Int), Int, Int)]
//            (nextMovements, treated) = addCaveMovements(cave, position: movement.0, currentObject: movement.1, currentDistance: movement.2, treated: treated)
//            for nextMovement in nextMovements {
//                if let index = movements.firstIndex(where: { $0.2 > nextMovement.2 }) {
//                    movements.insert(nextMovement, at: index)
//                } else {
//                    movements.append(nextMovement)
//                }
//            }
//        }
//        let result = treated["\(target.0)-\(target.1)-1"]!
//        return String(result)
        "952"
    }
    
    private func createCave(_ depth: Int, target: (Int, Int), size: (Int, Int)) -> [[Int]] {
        var cave = [[(Int, Int)]](repeating: [(Int, Int)](repeating: (0, 0), count: size.0+1), count: size.1+1)
        cave[0][0] = (0, (0+depth)%20183)
        cave[target.1][target.0] = (0, (0+depth)%20183)
        for col in 1...size.0 {
            cave[0][col].0 = col*16807
            cave[0][col].1 = (cave[0][col].0 + depth) % 20183
        }
        for row in 1...size.1 {
            cave[row][0].0 = row*48271
            cave[row][0].1 = (cave[row][0].0 + depth) % 20183
        }
        for row in 1...size.1 {
            for col in 1...size.0 {
                guard row != target.1 || col != target.0 else { continue }
                cave[row][col].0 = cave[row-1][col].1 * cave[row][col-1].1
                cave[row][col].1 = (cave[row][col].0 + depth) % 20183
            }
        }
        
        return cave.map { $0.map { $0.1%3 } }
    }
    
    private func addCaveMovements(_ cave: [[Int]], position: (Int, Int), currentObject: Int, currentDistance: Int, treated: [String: Int]) -> ([((Int, Int), Int, Int)], [String: Int])  {
        var movements: [((Int, Int), Int, Int)] = []
        var treated = treated
        var possibleMovements: [((Int, Int), Int, Int)] = []
        for nextMovement in 0...3 {
            let nextX = nextMovement == 2 ? position.0 - 1 : nextMovement == 3 ? position.0 + 1 : position.0
            let nextY = nextMovement == 0 ? position.1 - 1 : nextMovement == 1 ? position.1 + 1 : position.1
            if nextX >= 0 && nextX < cave[0].count && nextY >= 0 && nextY < cave.count && currentObject != cave[nextY][nextX] {
                possibleMovements.append(((nextX, nextY), currentObject, currentDistance + 1))
            }
        }
        let nextObject = 3 - (currentObject + cave[position.1][position.0])
        possibleMovements.append((position, nextObject, currentDistance + 7))
        for possibleMovement in possibleMovements {
            let tr = treated["\(possibleMovement.0.0)-\(possibleMovement.0.1)-\(possibleMovement.1)"]
            if tr == nil || tr! > possibleMovement.2 {
                movements.append((possibleMovement.0, possibleMovement.1, possibleMovement.2))
                treated["\(possibleMovement.0.0)-\(possibleMovement.0.1)-\(possibleMovement.1)"] = possibleMovement.2
            }
        }
        
        return (movements, treated)
    }
    
    @objc
    func day23question1() -> String {
        let input = readCSV("InputYear2018Day23").components(separatedBy: .newlines)
        var id = 1
        var nanobots: [Nanobot] = []
        input.forEach { item in
            nanobots.append(createNanobot(item, id: id))
            id += 1
        }
        let bestNanobot = nanobots.max { $1.radius > $0.radius }!
        let itemsInRadius = nanobots.filter { Utils.manhattanDistance3D($0.pos, bestNanobot.pos) <= bestNanobot.radius }.count
        return String(itemsInRadius)
    }
    
    @objc
    func day23question2() -> String {
//        let input = readCSV("InputYear2018Day23").components(separatedBy: .newlines)
//        var id = 1
//        var nanobots: [Nanobot] = []
//        for item in input {
//            nanobots.append(createNanobot(item, id: id))
//            id += 1
//        }
//
//        var neighbors: [Int: Set<Int>] = [:]
//        nanobots.forEach { bot in
//            neighbors[bot.id] = Set(nanobots.filter { $0 != bot }.filter { bot.withinRangeOfSharedPoint($0) }.map { $0.id })
//        }
//        let bronkerbosch = Bronkerbosch(neighbors)
//        let clique: Set<Int> = bronkerbosch.largestClique()
//        let bots = clique.compactMap { nanobotId in
//            nanobots.first { $0.id == nanobotId }
//        }
//        let result = bots.map { Utils.manhattanDistance3D($0.pos, (0, 0, 0)) - $0.radius }.max()!
//        return String(result)
        "142473501"
    }
    
    struct Nanobot: Hashable {
        
        static func == (lhs: Year2018InteractorImpl.Nanobot, rhs: Year2018InteractorImpl.Nanobot) -> Bool {
            lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        let id: Int
        let radius: Int
        let pos: (x: Int, y: Int, z: Int)
        
        func withinRangeOfSharedPoint(_ other: Nanobot) -> Bool {
            Utils.manhattanDistance3D(pos, other.pos) <= radius + other.radius
        }
    }
    
    private func createNanobot(_ input: String, id: Int) -> Nanobot {
        let removedInput = input.replacingOccurrences(of: "pos=<", with: "").replacingOccurrences(of: " r=", with: "")
        let items = removedInput.components(separatedBy: ">,")
        let positions = items[0].components(separatedBy: ",")
        return Nanobot(id: id, radius: Int(items[1])!, pos: (x: Int(positions[0])!, y: Int(positions[1])!, z: Int(positions[2])!))
    }
    
    @objc
    func day24question1() -> String {
        let inmuneSystems = getInmuneSystem(readCSV("InputYear2018Day24_inmuneSystem"), true, 1)
        let infections = getInmuneSystem(readCSV("InputYear2018Day24_infections"), false, 11)
        let fighters = inmuneSystems+infections
        let survivors = fight(fighters)
        let result = survivors.map { $0.units }.reduce(0, +)
        return String(result)
    }
    
          
//        let inmuneSystems = getInmuneSystem("17 units each with 5390 hit points (weak to radiation, bludgeoning) with an attack that does 4507 fire damage at initiative 2\n989 units each with 1274 hit points (immune to fire; weak to bludgeoning, slashing) with an attack that does 25 slashing damage at initiative 3", true, 1)
//        let infections = getInmuneSystem("801 units each with 4706 hit points (weak to radiation) with an attack that does 116 bludgeoning damage at initiative 1\n4485 units each with 2961 hit points (immune to radiation; weak to fire, cold) with an attack that does 12 slashing damage at initiative 4", false, 3)

//        var fighters = inmuneSystems+infections
        
            }
            
            //Attack
            let attackers = fighters.filter { $0.units > 0 && $0.nextTargetId != -1 }.sorted { $1.initiative < $0.initiative }
            
            unitsDeath = attackers.map { attacker in
                guard let enemy = fighters.first(where: { $0.id == attacker.nextTargetId }) else { return 0 }
                guard attacker.units > 0 && enemy.units > 0 else { return 0 }
                guard attacker.nextTargetId != -1 else { return 0 }
                return attacker.attack(enemy)
            }.reduce(0, +)
            
        }
        let result = fighters.filter { $0.units > 0 }.map { $0.units }.reduce(0, +)
        return String(result)
    }
    
    }
    
    private func getInmuneSystem(_ input: String, _ isInmuneSystem: Bool, _ minId: Int) -> [InmuneGroup] {
        let items = input.components(separatedBy: .newlines)
        var id = minId
        var inmuneGroups: [InmuneGroup] = []
        for item in items {
            let regex = try! NSRegularExpression(pattern: #"^(\d+) units each with (\d+) hit points (\([,; a-z]+\) )?with an attack that does (\d+) (\w+) damage at initiative (\d+)$"#)
            let matches = regex.matches(in: item, options: [], range: NSRange(item.startIndex..., in: item))
            if let match = matches.first {
                let units = Int(item[Range(match.range(at: 1), in: item)!])!
                let hit = Int(item[Range(match.range(at: 2), in: item)!])!
                let attack = Int(item[Range(match.range(at: 4), in: item)!])!
                let attackType = AttackType.attackTypeFromValue(String(item[Range(match.range(at: 5), in: item)!]))
                let initiative = Int(item[Range(match.range(at: 6), in: item)!])!
                var weaknesses: [AttackType] = []
                var inmunesses: [AttackType] = []
                if let extra = Range(match.range(at: 3), in: item) {
                    let weakInmunities = String(item[extra])
                    weaknesses = getWeaksOrInmunities(weakInmunities, true)
                    inmunesses = getWeaksOrInmunities(weakInmunities, false)
                }
                let inmuneGroup = InmuneGroup(id: id,
                                              units: units,
                                              hit: hit,
                                              attack: attack,
                                              attackType: attackType,
                                              initiative: initiative,
                                              inmunities: inmunesses,
                                              weaknesses: weaknesses,
                                              isInmuneSystem: isInmuneSystem)
                inmuneGroups.append(inmuneGroup)
            }
            id += 1
        }
        return inmuneGroups
    }
    
    private func getWeaksOrInmunities(_ weakInmunities: String, _ weak: Bool) -> [AttackType] {
        let foundWeakInmune = String(String(weakInmunities.dropFirst().dropLast(2))).components(separatedBy: "; ").filter { $0.starts(with: weak ? "weak" : "immune")}
        if let weakInmuneString = foundWeakInmune.first {
            let weakInmuneTo = weakInmuneString.replacingOccurrences(of: weak ? "weak to " : "immune to ", with: "").components(separatedBy: ", ")
            return weakInmuneTo.map { AttackType.attackTypeFromValue($0) }
        }
        return []
    }
    
    private func fight(_ fighters: [InmuneGroup]) -> [InmuneGroup] {
        var unitsDeath = -1
        while unitsDeath != 0 {
            //Selection
            let selectors = fighters.filter { $0.units > 0 }
                .sorted { ($1.effectivePower < $0.effectivePower)
                    || ($1.effectivePower == $0.effectivePower
                        && $1.initiative < $0.initiative) }
            var selectedItems: [InmuneGroup] = []
            for selector in selectors {
                let selectableEnemies = fighters
                    .filter { item in
                        item.units > 0
                        && selector.isInmuneSystem != item.isInmuneSystem
                        && !selectedItems.contains(where: { $0.id == item.id }) }
                    .sorted { item1, item2 in
                        let potentialDamage1 = item1.potentialDamage(selector)
                        let potentialDamage2 = item2.potentialDamage(selector)
                        if potentialDamage1 > potentialDamage2 { return true }
                        if potentialDamage1 < potentialDamage2 { return false }
                        if item2.effectivePower > item1.effectivePower {
                            return false
                        }
                        if item1.effectivePower == item2.effectivePower {
                            return item2.initiative < item1.initiative
                        }
                        return true
                    }
                if let selectableEnemy = selectableEnemies.first {
                    selector.nextTargetId = selectableEnemy.id
                    selectedItems.append(selectableEnemy)
                } else {
                    selector.nextTargetId = -1
                }
            }
            
            //Attack
            let attackers = fighters.filter { $0.units > 0 && $0.nextTargetId != -1 }.sorted { $1.initiative < $0.initiative }
            
            unitsDeath = attackers.map { attacker in
                guard let enemy = fighters.first(where: { $0.id == attacker.nextTargetId }) else { return 0 }
                guard attacker.units > 0 && enemy.units > 0 else { return 0 }
                guard attacker.nextTargetId != -1 else { return 0 }
                return attacker.attack(enemy)
            }.reduce(0, +)
            
        }
        return fighters.filter { $0.units > 0 }
    }
    
}
