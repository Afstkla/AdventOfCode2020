//
//  Day1.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 01/12/2020.
//

import Foundation

class Day1: Day {
    override var dayIndex: Int { get { 1 } set {}}
    
    override func part1() -> String {
        let numbers = inputString.split(separator: "\n").map { Int($0)! }.sorted(by: <)
        for i in 0..<numbers.count {
            for j in (i+1)..<numbers.count {
                if numbers[i] + numbers[j] == 2020 {
                    return String(numbers[i] * numbers[j])
                } else if numbers[i] + numbers[j] > 2020 {
                    break
                }
            }
        }
        
        return "NOT FOUND"
    }
    
    override func part2() -> String {
        let numbers = inputString.split(separator: "\n").map { Int($0)! }.sorted(by: <)
        for i in 0..<numbers.count {
            for j in (i+1)..<numbers.count {
                for k in (j+1)..<numbers.count {
                    if numbers[i] + numbers[j] + numbers[k] == 2020 {
                        return String(numbers[i] * numbers[j] * numbers[k])
                    } else if numbers[i] + numbers[j] + numbers[k] > 2020 {
                        break
                    }
                }
            }
        }
        
        return "NOT FOUND"
    }
}
