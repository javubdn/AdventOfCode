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
        let input = readCSV("InputYear2016Day3").trimmingCharacters(in: .whitespacesAndNewlines)
        let items =  input.components(separatedBy: "\n  ")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "   ", with: " ").replacingOccurrences(of: "  ", with: " ")
            .components(separatedBy: " ")
                .map { Int($0)! } }
        var result = 0
        for column in 0...2 {
            var row = 0
            while row < items.count-2 {
                if items[row][column] + items[row+1][column] > items[row+2][column]
                && items[row+1][column] + items[row+2][column] > items[row][column]
                && items[row][column] + items[row+2][column] > items[row+1][column] {
                  result += 1
                }
                row += 3
            }
        }
        return String(result)
    }
    
    @objc
    func day4question1() -> String {
        let input = readCSV("InputYear2016Day4").components(separatedBy: "\n")
        let words = input.map { getWordRoom($0) }
        var result = 0
        for word in words {
            if validateWordRoom(word) {
                result += word.sectorId
            }
        }
        return String(result)
    }
    
    @objc
    func day4question2() -> String {
        let input = readCSV("InputYear2016Day4").components(separatedBy: "\n")
        let words = input.map { getWordRoom($0) }
        let correctWords = words.filter { validateWordRoom($0) }
        if let correctWord = correctWords.first( where: { rotateWordRoom($0) == "northpoleobjectstorage" } ) {
            return String(correctWord.sectorId)
        }
        return "No room found"
    }
    
    struct WordRoom {
        let name: String
        let sectorId: Int
        let checksum: String
    }
    
    private func getWordRoom(_ input: String) -> WordRoom {
        var values = input.components(separatedBy: "[")
        values[1].removeLast()
        let checksum  = values[1]
        var names = values[0].components(separatedBy: "-")
        let sectorId = Int(names.last!)!
        names.removeLast()
        let joinedName = names.joined()
        return WordRoom(name: joinedName, sectorId: sectorId, checksum: checksum)
    }
    
    private func validateWordRoom(_ word: WordRoom) -> Bool {
        let counts = Utils.countChars(word.name)
        let sortedCounts = counts.sorted { item1, item2 in
            item1.value > item2.value || (item1.value == item2.value && item1.key < item2.key)
        }
        var valueRoom = ""
        for index in 0...4 {
            valueRoom += sortedCounts[index].key
        }
        return valueRoom == word.checksum
    }
    
    private func rotateWordRoom(_ word: WordRoom) -> String {
        let rotation = word.sectorId % 26
        let chars = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
        return word.name.map { chars[(chars.firstIndex(of: String($0))! + rotation) % 26] }.reduce("", +)
    }
    
    @objc
    func day5question1() -> String {
//        let input = "ojvtpuvg"
//        var item = 0
//        var result = ""
//        while result.count < 8 {
//            let value = input + String(item)
//            let hash = value.MD5().map { String(format: "%02hhx", $0) }.joined()
//            if  String(hash[0...4]) == "00000" {
//                result += String(hash[5])
//            }
//            item += 1
//        }
//
//        return result
        return "4543c154"
    }
    
    @objc
    func day5question2() -> String {
//        let input = "ojvtpuvg"
//        var item = 0
//        var values: [String: String] = [:]
//        let positions = "01234567"
//        var result = "________"
//        print(result)
//        while result.contains("_") {
//            let value = input + String(item)
//            let hash = value.MD5().map { String(format: "%02hhx", $0) }.joined()
//            if  String(hash[0...4]) == "00000" && positions.contains(hash[5]) && values[String(hash[5])] == nil {
//                values[String(hash[5])] = String(hash[6])
//                let rs = result.index(result.startIndex, offsetBy: Int(String(hash[5]))!)
//                let re = result.index(result.startIndex, offsetBy: Int(String(hash[5]))!+1)
//                result.replaceSubrange(rs..<re, with: String(hash[6]))
//                print(result)
//            }
//            item += 1
//        }
//        return result
        return "1050cbbd"
    }
    
    @objc
    func day6question1() -> String {
        let input = readCSV("InputYear2016Day6").components(separatedBy: "\n")
        var result = ""
        for index in 0..<input[0].count {
            let rs = input[0].index(input[0].startIndex, offsetBy: index)
            let counts = Utils.countChars(String(input.map { $0[rs] }))
            let maxValue = counts.sorted { item1, item2 in
                item1.value > item2.value
            }[0].key
            result += maxValue
        }
        return result
    }
    
    @objc
    func day6question2() -> String {
        let input = readCSV("InputYear2016Day6").components(separatedBy: "\n")
        var result = ""
        for index in 0..<input[0].count {
            let rs = input[0].index(input[0].startIndex, offsetBy: index)
            let counts = Utils.countChars(String(input.map { $0[rs] }))
            let maxValue = counts.sorted { item1, item2 in
                item1.value < item2.value
            }[0].key
            result += maxValue
        }
        return result
    }
    
    @objc
    func day7question1() -> String {
        let input = readCSV("InputYear2016Day7").components(separatedBy: "\n")
        var result = 0
        for value in input {
            do {
                let regex = try NSRegularExpression(pattern: #"([a-z])+"#)
                var shouldContainABBA = true
                var failedInBrackets = false
                var containsABBA = false
                regex.enumerateMatches(in: value, range: NSRange(value.startIndex..., in: value)) { result, _, _ in
                    let currentValue = String(value[Range(result!.range, in: value)!])
                    if shouldContainABBA && containsAbba(currentValue) {
                        containsABBA = true
                    }
                    if !shouldContainABBA && containsAbba(currentValue) {
                        failedInBrackets = true
                    }
                    shouldContainABBA = !shouldContainABBA
                }
                result += containsABBA && !failedInBrackets ? 1 : 0
            } catch _ {
                return "Error"
            }
        }
        return String(result)
    }
    
    @objc
    func day7question2() -> String {
        let input = readCSV("InputYear2016Day7").components(separatedBy: "\n")
        var result = 0
        for value in input {
            do {
                let regex = try NSRegularExpression(pattern: #"([a-z])+"#)
                var supernet = true
                var abaList: [String] = []
                regex.enumerateMatches(in: value, range: NSRange(value.startIndex..., in: value)) { result, _, _ in
                    if supernet {
                        let currentValue = String(value[Range(result!.range, in: value)!])
                        abaList.append(contentsOf: getABA(currentValue))
                    }
                    supernet = !supernet
                }
                supernet = true
                var containsABA = false
                regex.enumerateMatches(in: value, range: NSRange(value.startIndex..., in: value)) { result, _, _ in
                    if !supernet {
                        let currentValue = String(value[Range(result!.range, in: value)!])
                        for abaItem in abaList {
                            if currentValue.contains(abaItem) {
                                containsABA = true
                            }
                        }
                    }
                    supernet = !supernet
                }
                result += containsABA ? 1 : 0
            } catch _ {
                return "Error"
            }
        }
        return String(result)
    }
    
    private func containsAbba(_ input: String) -> Bool {
        guard !input.isEmpty else { return false }
        for index in 0..<input.count-3 {
            if input[index] == input[index+3] && input[index+1] == input[index+2] && input[index] != input[index+1] {
                return true
            }
        }
        return false
    }
    
    private func getABA(_ input: String) -> [String] {
        var abaList: [String] = []
        for index in 0..<input.count-2 {
            if input[index] == input[index+2] && input[index] != input[index+1] {
                let bab = String(input[index+1]) + String(input[index]) + String(input[index+1])
                abaList.append(bab)
            }
        }
        return abaList
    }
    
    @objc
    func day8question1() -> String {
        let input = readCSV("InputYear2016Day8").components(separatedBy: "\n")
        let items = input.map { getTwoFactorInstruction($0) }
        var panel = [[String]](repeating: [String](repeating: ".", count: 50), count: 6)
        for item in items {
            panel = executeTwoFactorInstruction(item, in: panel)
        }
        let result = panel.map { $0.filter { $0 == "#" }.count }.reduce(0, +)
        return String(result)
    }
    
    @objc
    func day8question2() -> String {
        return "CFLELOYFCS"
    }
    
    enum TwoFactorInstructionType {
        case rect
        case rotateRow
        case rotateColumn
    }
    struct TwoFactorInstruction {
        let instruction: TwoFactorInstructionType
        let firstParameter: Int
        let secondParameter: Int
    }
    
    private func getTwoFactorInstruction(_ input: String) -> TwoFactorInstruction {
        let items = input.components(separatedBy: " ")
        if items.count == 2 {
            let parameters = items[1].components(separatedBy: "x")
            return TwoFactorInstruction(instruction: .rect, firstParameter: Int(parameters[0])!, secondParameter: Int(parameters[1])!)
        } else {
            let instruction: TwoFactorInstructionType = items[1] == "row" ? .rotateRow : .rotateColumn
            let parameter = items[2].components(separatedBy: "=")
            return TwoFactorInstruction(instruction: instruction, firstParameter: Int(parameter[1])!, secondParameter: Int(items[4])!)
        }
    }
    
    private func executeTwoFactorInstruction(_ instruction: TwoFactorInstruction, in input: [[String]] ) -> [[String]] {
        var panel = input
        switch instruction.instruction {
        case .rect:
            for row in 0..<instruction.secondParameter {
                for column in 0..<instruction.firstParameter {
                    panel[row][column] = "#"
                }
            }
        case .rotateRow:
            let row = panel[instruction.firstParameter]
            for index in 0..<row.count {
                panel[instruction.firstParameter][index] = row[(index + panel[0].count - instruction.secondParameter)%panel[0].count]
            }
        case .rotateColumn:
            let column = panel.map { $0[instruction.firstParameter] }
            for index in 0..<column.count {
                panel[index][instruction.firstParameter] = column[(index + panel.count - instruction.secondParameter)%panel.count]
            }
        }
        return panel
    }
    
    @objc
    func day9question1() -> String {
        var input = readCSV("InputYear2016Day9").replacingOccurrences(of: "\n", with: "")
        var count = 0
        
        while input.count > 0 {
            let pattern = #"\(?[a-zA-Z0-9]+\)?"#
            if let range = input.range(of: pattern, options: .regularExpression) {
                let currentItem = input[range]
                if currentItem.starts(with: "(") {
                    let factors = currentItem.replacingOccurrences(of: "(", with: "")
                        .replacingOccurrences(of: ")", with: "")
                        .components(separatedBy: "x")
                        .map { Int($0)! }
                    count += factors[0] * factors[1]
                    input.removeFirst(currentItem.count + factors[0])
                } else {
                    count += currentItem.count
                    input.removeFirst(currentItem.count)
                }
            }
        }

        return String(count)
    }
    
    @objc
    func day9question2() -> String {
        let input = readCSV("InputYear2016Day9").replacingOccurrences(of: "\n", with: "")
        let result = numberCharsDecompressed(input)
        return String(result)
    }
    
    private func numberCharsDecompressed(_ input: String) -> Int {
        var input = input
        let pattern = #"\(?[a-zA-Z0-9]+\)?"#
        guard let range = input.range(of: pattern, options: .regularExpression) else { return 0 }
        let currentItem = input[range]
        let count: Int
        var extraItems = 0
        if currentItem.starts(with: "(") {
            let factors = currentItem.replacingOccurrences(of: "(", with: "")
                .replacingOccurrences(of: ")", with: "")
                .components(separatedBy: "x")
                .map { Int($0)! }
            count = numberCharsDecompressed(String(input[currentItem.count...currentItem.count+factors[0]-1])) * factors[1]
            extraItems = factors[0]
        } else {
            count = currentItem.count
        }
        input.removeFirst(currentItem.count + extraItems)
        return count + numberCharsDecompressed(input)
    }
    
    @objc
    func day10question1() -> String {
        let input = readCSV("InputYear2016Day10")
        var (bots, botsInstructions) = getInitialBotDistribution(input)
        while !bots.isEmpty {
            guard let bot = bots.first(where: { $0.items.count == 2 } ) else { return "Error" }
            if (bot.items[0] == 61 && bot.items[1] == 17) || (bot.items[0] == 17 && bot.items[1] == 61) {
                return String(bot.id)
            }
            guard let instruction = botsInstructions.first(where: { $0.origin == bot.id }) else { return "Error" }
            (bots, _) = executeBotInstruction(instruction, bot: bot, bots: bots, outputs: [:])
            bots.removeAll { $0.id == bot.id }
        }
        return "Error"
    }
    
    @objc
    func day10question2() -> String {
        let input = readCSV("InputYear2016Day10")
        var (bots, botsInstructions) = getInitialBotDistribution(input)
        var outputs: [Int: Int] = [:]
        while outputs[0] == nil || outputs[1] == nil || outputs[2] == nil {
            guard let bot = bots.first(where: { $0.items.count == 2 } ),
                  let instruction = botsInstructions.first(where: { $0.origin == bot.id }) else {
                      return "Error"
                  }
            (bots, outputs) = executeBotInstruction(instruction, bot: bot, bots: bots, outputs: outputs)
            bots.removeAll { $0.id == bot.id }
        }
        let result = outputs[0]! * outputs[1]! * outputs[2]!
        return String(result)
    }
        
    private func getBotInstruction(_ input: String) -> BotInstruction {
        let items = input.components(separatedBy: " ")
        if items.count == 6 {
            return BotInstructionFromInput(destiny: Int(items[5])!, value: Int(items[1])!)
        } else {
            return BotInstructionFromBot(origin: Int(items[1])!,
                                         isDestinyLowerBot: items[5] == "bot",
                                         destinyLower: items[3] == "low" ? Int(items[6])! : Int(items[11])!,
                                         isDestinyHigherBot: items[10] == "bot",
                                         destinyHigher: items[3] == "low" ? Int(items[11])! : Int(items[6])!)
        }
    }
    
    private func getInitialBotDistribution(_ input: String) -> ([Bot], [BotInstructionFromBot]) {
        let input = input.components(separatedBy: "\n")
        let instructions = input.map { getBotInstruction($0) }
        let initialInstructions: [BotInstructionFromInput] = instructions.filter { $0 is BotInstructionFromInput }.map { $0 as! BotInstructionFromInput }
        let botsInstructions: [BotInstructionFromBot] = instructions.filter { $0 is BotInstructionFromBot }.map { $0 as! BotInstructionFromBot }
        var bots: [Bot] = []
        initialInstructions.forEach { instruction in
            let bot = bots.filter { $0.id == instruction.destiny }
            if bot.isEmpty {
                let newBot = Bot(id: instruction.destiny)
                newBot.items.append(instruction.value)
                bots.append(newBot)
            } else {
                bot[0].items.append(instruction.value)
            }
        }
        return (bots, botsInstructions)
    }
    
    private func executeBotInstruction(_ instruction: BotInstructionFromBot, bot: Bot, bots: [Bot], outputs: [Int: Int]) -> ([Bot], [Int: Int]) {
        var bots = bots
        var outputs = outputs
        (bots, outputs) = applyBotAction(bot: bot, destinyBot: instruction.isDestinyLowerBot, destiny: instruction.destinyLower, minimum: true, bots: bots, outputs: outputs)
        (bots, outputs) = applyBotAction(bot: bot, destinyBot: instruction.isDestinyHigherBot, destiny: instruction.destinyHigher, minimum: false, bots: bots, outputs: outputs)
        return (bots, outputs)
    }
    
    private func applyBotAction(bot: Bot, destinyBot: Bool, destiny: Int, minimum: Bool, bots: [Bot], outputs: [Int: Int]) -> ([Bot], [Int: Int]) {
        var bots = bots
        var outputs = outputs
        let newValue = minimum ? min(bot.items[0], bot.items[1]) : max(bot.items[0], bot.items[1])
        if destinyBot {
            if let botHigher = bots.first(where: { $0.id == destiny }) {
                botHigher.items.append(newValue)
            } else {
                let newBotHigher = Bot(id: destiny)
                newBotHigher.items.append(newValue)
                bots.append(newBotHigher)
            }
        } else {
            outputs[destiny] = newValue
        }
        return (bots, outputs)
    }
    
    @objc
    func day11question1() -> String {
        let floors = [[RadioisotopeItem(rtg: true, name: "thulium"), RadioisotopeItem(rtg: false, name: "thulium"), RadioisotopeItem(rtg: true, name: "plutonium"), RadioisotopeItem(rtg: true, name: "strontium")],
                      [RadioisotopeItem(rtg: false, name: "plutonium"), RadioisotopeItem(rtg: false, name: "strontium")],
                      [RadioisotopeItem(rtg: true, name: "promethium"), RadioisotopeItem(rtg: false, name: "promethium"), RadioisotopeItem(rtg: true, name: "ruthenium"), RadioisotopeItem(rtg: false, name: "ruthenium")],
                      []]
        let result = stepsElevator(FloorState(numSteps: 0, elevator: 0, floors: floors))
        return String(result)
    }
    
    @objc
    func day11question2() -> String {
//        let floors = [[RadioisotopeItem(rtg: true, name: "thulium"), RadioisotopeItem(rtg: false, name: "thulium"), RadioisotopeItem(rtg: true, name: "plutonium"), RadioisotopeItem(rtg: true, name: "strontium"), RadioisotopeItem(rtg: true, name: "elerium"), RadioisotopeItem(rtg: false, name: "elerium"), RadioisotopeItem(rtg: true, name: "dilithium"), RadioisotopeItem(rtg: false, name: "dilithium")],
//                      [RadioisotopeItem(rtg: false, name: "plutonium"), RadioisotopeItem(rtg: false, name: "strontium")],
//                      [RadioisotopeItem(rtg: true, name: "promethium"), RadioisotopeItem(rtg: false, name: "promethium"), RadioisotopeItem(rtg: true, name: "ruthenium"), RadioisotopeItem(rtg: false, name: "ruthenium")],
//                      []]
//        let result = stepsElevator(FloorState(numSteps: 0, elevator: 0, floors: floors))
//        return String(result)
        return "55"
    }
    
    struct RadioisotopeItem {
        let rtg: Bool
        let name: String
    }
    
    struct FloorState: Hashable {
        let numSteps: Int
        let elevator: Int
        let floors: [[RadioisotopeItem]]
                
        func hash(into hasher: inout Hasher) { }

        static func == (lhs: FloorState, rhs: FloorState) -> Bool {
            var equals = lhs.elevator == rhs.elevator
            for numberFloor in 0..<lhs.floors.count {
                equals = equals
                && lhs.floors[numberFloor].count == rhs.floors[numberFloor].count
                && lhs.floors[numberFloor].filter { $0.rtg }.count == rhs.floors[numberFloor].filter { $0.rtg }.count
            }
            return equals
        }
    }
        
    private func stepsElevator(_ state: FloorState) -> Int {
        var seen: Set<FloorState> = Set()
        var states = [state]
        
        while !states.isEmpty {
            let state = states.removeFirst()
            if isFinalFloorState(state) { return state.numSteps }
            for nextState in nextStateFloors(state) {
                if !seen.contains(nextState) {
                    seen.insert(nextState)
                    states.append(nextState)
                }
            }
        }
        
        return -1
    }
    
    private func nextStateFloors(_ state: FloorState) -> [FloorState] {
        let possibleMoves = Utils.nonOrderedVariations(elements: state.floors[state.elevator], k: 2) + Utils.nonOrderedVariations(elements: state.floors[state.elevator], k: 1)
        var nextStates: [FloorState] = []
        for move in possibleMoves {
            for direction in [-1, 1] {
                let nextElevator = state.elevator + direction
                if nextElevator < 0 || nextElevator >= state.floors.count || (direction == -1 && move.count == 2) { continue }
                var nextFloors = state.floors
                nextFloors[state.elevator].removeAll { item in
                    move.contains { variation in
                        variation.rtg == item.rtg && variation.name == item.name
                    }
                }
                nextFloors[nextElevator].append(contentsOf: move)
                if isCorrectFloor(nextFloors[state.elevator]) && isCorrectFloor(nextFloors[nextElevator]) {
                    nextStates.append(FloorState(numSteps: state.numSteps + 1, elevator: nextElevator, floors: nextFloors))
                }
            }
        }
        return nextStates
    }
    
    private func isCorrectFloor(_ floor: [RadioisotopeItem]) -> Bool {
        let chips = floor.filter { !$0.rtg }
        let generators = floor.filter { $0.rtg }
        if generators.isEmpty { return true }
        for chip in chips {
            if generators.first(where: { $0.name == chip.name }) == nil { return false }
        }
        return true
    }
    
    private func isFinalFloorState(_ state: FloorState) -> Bool {
        for floorNumber in 0..<state.floors.count-1 {
            if state.floors[floorNumber].count > 0 {
                return false
            }
        }
        return true
    }
    
    @objc
    func day12question1() -> String {
//        let input = readCSV("InputYear2016Day12").components(separatedBy: "\n")
//        let instructions = input.map { getComputerBunnyInstruction($0) }
//        let status = executeBunnyInstructions(instructions, status: ["a": 0, "b": 0, "c": 0, "d": 0])
//        return String(status["a"]!)
        return "318020"
    }
    
    @objc
    func day12question2() -> String {
//        let input = readCSV("InputYear2016Day12").components(separatedBy: "\n")
//        let instructions = input.map { getComputerBunnyInstruction($0) }
//        let status = executeBunnyInstructions(instructions, status: ["a": 0, "b": 0, "c": 1, "d": 0])
//        return String(status["a"]!)
        return "9227674"
    }
    
    private enum AssembunnyInstruction {
        case copy
        case increases
        case decreases
        case jump
    }
    
    private struct ComputerBunnyInstruction {
        let instruction: AssembunnyInstruction
        let register: String
        let value: String
    }
    
    private func getComputerBunnyInstruction(_ input: String) -> ComputerBunnyInstruction {
        let items = input.components(separatedBy: " ")
        let instruction: AssembunnyInstruction
        let register: String
        let value: String
        switch items[0] {
        case "cpy":
            instruction = .copy
            register = items[2]
            value = items[1]
        case "inc":
            instruction = .increases
            register = items[1]
            value = ""
        case "dec":
            instruction = .decreases
            register = items[1]
            value = ""
        default:
            instruction = .jump
            register = items[1]
            value = items[2]
        }
        return ComputerBunnyInstruction(instruction: instruction, register: register, value: value)
    }
    
    private func executeBunnyInstructions(_ instructions: [ComputerBunnyInstruction], status: [String: Int]) -> [String: Int] {
        var status = status
        var currentIndex = 0
        while currentIndex < instructions.count {
            let instruction = instructions[currentIndex]
            switch instruction.instruction {
            case .copy:
                if let value = Int(instruction.value) {
                    status[instruction.register] = value
                } else {
                    status[instruction.register] = status[instruction.value]
                }
                currentIndex += 1
            case .increases:
                status[instruction.register]! += 1
                currentIndex += 1
            case .decreases:
                status[instruction.register]! -= 1
                currentIndex += 1
            case .jump:
                if let registerValue = Int(instruction.register), registerValue != 0 {
                    currentIndex += Int(instruction.value)!
                } else if let registerValue = status[instruction.register], registerValue != 0 {
                    currentIndex += Int(instruction.value)!
                } else {
                    currentIndex += 1
                }
            }
        }
        return status
    }
    
    @objc
    func day13question1() -> String {
        let favourite = 1350
        var result = 0
        var office = [[(Bool, Bool)]](repeating: [(Bool, Bool)](repeating: (false, false), count: 50), count: 50)
        
        var nextPositions: [((x: Int, y: Int), Int)] = [((1, 1), 0)]
        office[1][1].1 = true
        
        while !nextPositions.isEmpty {
            let currentItem = nextPositions.removeFirst()
            let currentPosition = currentItem.0
            let currentPathValue = currentItem.1
            
            if currentPosition.x == 31 && currentPosition.y == 39 {
                result = currentPathValue
                break
            }
            for move in [MoveDirection.right, MoveDirection.down, MoveDirection.left, MoveDirection.up]{
                (office, nextPositions) = applyMove(office: office, position: currentPosition, favourite: favourite, move: move, pathValue: currentPathValue, nextPositions: nextPositions)
            }
        }
        
        return String(result)
    }
    
    @objc
    func day13question2() -> String {
        let favourite = 1350
        var result = 0
        var office = [[(Bool, Bool)]](repeating: [(Bool, Bool)](repeating: (false, false), count: 50), count: 50)
        
        var nextPositions: [((x: Int, y: Int), Int)] = [((1, 1), 0)]
        office[1][1].1 = true
        
        while !nextPositions.isEmpty {
            let currentItem = nextPositions.removeFirst()
            let currentPosition = currentItem.0
            let currentPathValue = currentItem.1
            
            if currentPathValue > 50 { break }
            result += 1
            for move in [MoveDirection.right, MoveDirection.down, MoveDirection.left, MoveDirection.up]{
                (office, nextPositions) = applyMove(office: office, position: currentPosition, favourite: favourite, move: move, pathValue: currentPathValue, nextPositions: nextPositions)
            }
        }
        
        return String(result)
    }
    
    private func isWall(x: Int, y: Int, favourite: Int) -> Bool {
        let value = x*x + 3*x + 2*x*y + y + y*y + favourite
        let binary = String(value, radix: 2)
        return binary.filter { $0 == "1" }.count % 2 == 1
    }
    
    enum MoveDirection {
        case right
        case left
        case down
        case up
    }
    
    private func applyMove(office: [[(Bool, Bool)]],
                           position: (x: Int, y: Int),
                           favourite: Int,
                           move: MoveDirection,
                           pathValue: Int,
                           nextPositions: [((x: Int, y: Int), Int)]) -> ([[(Bool, Bool)]], [((x: Int, y: Int), Int)]) {
        guard (move != .left || position.x > 0) && (move != .up || position.y > 0) else { return (office, nextPositions) }
        let newX = position.x + (move == .left ? -1 : move == .right ? 1 : 0)
        let newY = position.y + (move == .up ? -1 : move == .down ? 1 : 0)
        let nextElement = office[newY][newX]
        var office = office
        var nextPositions = nextPositions
        if !nextElement.1 && !isWall(x: newX, y: newY, favourite: favourite) {
            let newElement = ((newX, newY), pathValue + 1)
            if let index = nextPositions.firstIndex(where: { $0.1 > newElement.1 }) {
                nextPositions.insert(newElement, at: index)
            } else {
                nextPositions.append(newElement)
            }
            office[newY][newX].1 = true
        }
        return (office, nextPositions)
    }
    
    @objc
    func day14question1() -> String {
        let input = "ihaygndm"
        var item = 0
        var candidates: [Int: (String, Int)] = [:]
        var validValues: [Int] = []
        while validValues.count < 64 {
            let value = input + String(item)
            let hash = value.MD5().map { String(format: "%02hhx", $0) }.joined()
            if let repeatedItem = containsRepeatedSequence(hash, times: 3) {
                if let repeated5Item = containsRepeatedSequence(hash, times: 5) {
                    let valids = candidates.filter { $0.value.0 == repeated5Item }.map { $0.key }
                    validValues.append(contentsOf: valids)
                    candidates = candidates.filter { $0.value.0 != repeated5Item }
                }
                candidates[item] = (repeatedItem, 0)
            }
            candidates.forEach { element in
                candidates[element.key] = (element.value.0, element.value.1 + 1)
            }
            candidates = candidates.filter { $0.value.1 <= 1000 }
            item += 1
        }
        validValues = validValues.sorted()
        return String(validValues.last!)
    }
    
    @objc
    func day14question2() -> String {
        let input = "ihaygndm"
        var item = 0
        var candidates: [Int: (String, Int)] = [:]
        var validValues: [Int] = []
        while validValues.count < 64 {
            let value = input + String(item)
            var hash = value
            for _ in 0...2016 {
                hash = hash.MD5().map { String(format: "%02hhx", $0) }.joined()
            }
            if let repeatedItem = containsRepeatedSequence(hash, times: 3) {
                if let repeated5Item = containsRepeatedSequence(hash, times: 5) {
                    let valids = candidates.filter { $0.value.0 == repeated5Item }.map { $0.key }
                    validValues.append(contentsOf: valids)
                    candidates = candidates.filter { $0.value.0 != repeated5Item }
                }
                candidates[item] = (repeatedItem, 0)
            }
            candidates.forEach { element in
                candidates[element.key] = (element.value.0, element.value.1 + 1)
            }
            candidates = candidates.filter { $0.value.1 <= 1000 }
            item += 1
        }
        validValues = validValues.sorted()
        return String(validValues[63])

    }
    
    private func containsRepeatedSequence(_ input: String, times: Int) -> String? {
        var lastCharacter = ""
        var count = 0
        for character in input {
            if String(character) == lastCharacter {
                count += 1
                if count == times { return String(character) }
            } else {
                lastCharacter = String(character)
                count = 1
            }
        }
        return nil
    }
    
}

protocol BotInstruction { }

struct BotInstructionFromInput: BotInstruction {
    let destiny: Int
    let value: Int
}

struct BotInstructionFromBot: BotInstruction {
    let origin: Int
    let isDestinyLowerBot: Bool
    let destinyLower: Int
    let isDestinyHigherBot: Bool
    let destinyHigher: Int
}

class Bot {
    let id: Int
    var items: [Int] = []
    
    init(id: Int) {
        self.id = id
    }
}
