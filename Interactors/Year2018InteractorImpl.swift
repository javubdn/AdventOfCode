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
    
}
