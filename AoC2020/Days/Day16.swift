//
//  Day16.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 16/12/2020.
//

import Foundation

class Day16: Day {
    override var dayIndex: Int { get { 16 } set {} }
    
    var rules = [String: [(start: Int, end: Int)]]()
    var myTicket = [Int]()
    var nearbyTickets = [[Int]]()
    
    let test1 = """
    class: 1-3 or 5-7
    row: 6-11 or 33-44
    seat: 13-40 or 45-50

    your ticket:
    7,1,14

    nearby tickets:
    7,3,47
    40,4,50
    55,2,20
    38,6,12
    """
    
    let test2 = """
    class: 0-1 or 4-19
    row: 0-5 or 8-19
    seat: 0-13 or 16-19

    your ticket:
    11,12,13

    nearby tickets:
    3,9,18
    15,1,5
    5,14,9
    """
    
    override func prepareInput() {
        let inputParts = inputString.components(separatedBy: "\n\n")
        
        for ruleLine in inputParts[0].components(separatedBy: .newlines) {
            let ruleInformation = ruleLine.components(separatedBy: [": ", "-", " or "])
            let ruleName = ruleInformation[0]
            
            rules[ruleName] = [
                (start: Int(ruleInformation[1])!,
                 end: Int(ruleInformation[2])!),
                (start: Int(ruleInformation[3])!,
                 end: Int(ruleInformation[4])!)
            ]
        }
        
        myTicket = inputParts[1].components(separatedBy: .newlines)[1].split(separator: ",").map { Int($0)! }
        
        for nearbyTicketLine in inputParts[2].components(separatedBy: .newlines)[1...] {
            if nearbyTicketLine == "" {
                continue
            }
            
            nearbyTickets.append(nearbyTicketLine.split(separator: ",").map { Int($0)! })
        }
    }
    
    var validTickets = [[Int]]()
    
    override func part1() -> String {
        var validNumbers: Set<Int> = Set()
        for rule in rules {
            for range in rule.value {
                for digit in range.start...range.end {
                    validNumbers.insert(digit)
                }
            }
        }
        
        var invalidTicketCounter = 0
        for nearbyTicket in nearbyTickets {
            var isValid = true
            for value in nearbyTicket {
                if !validNumbers.contains(value) {
                    invalidTicketCounter += value
                    isValid = false
                    break
                }
            }
            
            if isValid {
                validTickets.append(nearbyTicket)
            }
        }
        
        return String(invalidTicketCounter)
    }
    
    override func part2() -> String {
        // Too lazy to think about how to do this with Swift Ranges
        var validNumbersArr: [String: Set<Int>] = [:]
        for rule in rules {
            var validNumbers: Set<Int> = Set()
            for range in rule.value {
                for digit in range.start...range.end {
                    validNumbers.insert(digit)
                }
            }
            
            validNumbersArr[rule.key] = validNumbers
        }
        
        // Find all potential maps
        var mapping = [String: [Int]]()
        for val in validNumbersArr {
            for i in 0..<validTickets[0].count {
                var hasFoundPotentialMatch = true
                for nearbyTicket in validTickets {
                    if !val.value.contains(nearbyTicket[i]) {
                        hasFoundPotentialMatch = false
                        break
                    }
                }
                
                if hasFoundPotentialMatch {
                    mapping[val.key] = (mapping[val.key] ?? []) + [i]
                }
            }
        }
        
        // Reduce set of maps
        var finalMapping = [String: Int]()
        while mapping.count != finalMapping.count {
            let oneLengthMaps = mapping.filter { $0.value.count == 1 }
            
            for oneLengthMap in oneLengthMaps {
                finalMapping[oneLengthMap.key] = oneLengthMap.value[0]
                
                for key in mapping.keys {
                    mapping[key]?.removeAll { $0 == oneLengthMap.value[0] }
                }
            }
        }
        
        // Calculate answer
        var result = 1
        for map in finalMapping where map.key.contains("departure") {
            result *= myTicket[map.value]
        }
        
        return String(result)
    }
}
