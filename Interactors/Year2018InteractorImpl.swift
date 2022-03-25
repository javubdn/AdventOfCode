//
//  Year2018InteractorImpl.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 10/3/22.
//

import Foundation

class Year2018InteractorImpl: NSObject {
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
        var items = input
        for count in 0..<15000 {
            let minX = items.min { $0.position.x < $1.position.x }!.position.x
            let minY = items.min { $0.position.y < $1.position.y }!.position.y
            let maxX = items.min { $0.position.x > $1.position.x }!.position.x
            let maxY = items.min { $0.position.y > $1.position.y }!.position.y
            if (maxX-minX) <= 65 && (maxY-minY) <= 11 {
                var screen = [[String]](repeating: [String](repeating: ".", count: 65), count: 11)
                items.forEach { screen[$0.position.y - minY][$0.position.x - minX] = "#" }
                let screenShot = screen.map { $0.joined() }
                print("NUMBER SECONDS -> \(count)")
                screenShot.forEach { print($0) }
                break
            }
            items = items.map { LightPoint(position: (x: $0.position.x+$0.speed.x, y: $0.position.y+$0.speed.y), speed: $0.speed) }
        }
        return "ZAEKAJGC"
    }
    
    @objc
    func day10question2() -> String {
        let input = readCSV("InputYear2018Day10").components(separatedBy: .newlines).map { getLightPoint($0) }
        var items = input
        var result = 0
        for count in 0..<15000 {
            let minX = items.min { $0.position.x < $1.position.x }!.position.x
            let minY = items.min { $0.position.y < $1.position.y }!.position.y
            let maxX = items.min { $0.position.x > $1.position.x }!.position.x
            let maxY = items.min { $0.position.y > $1.position.y }!.position.y
            if (maxX-minX) <= 65 && (maxY-minY) <= 11 {
                result = count
                break
            }
            items = items.map { LightPoint(position: (x: $0.position.x+$0.speed.x, y: $0.position.y+$0.speed.y), speed: $0.speed) }
        }
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
    
}
