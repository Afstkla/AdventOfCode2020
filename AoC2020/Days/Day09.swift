//
//  Day9.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 08/12/2020.
//

import Foundation

class Day09: Day {
    override var dayIndex: Int { get { 9 } set {}}
    
    let testInput = """
    35
    20
    15
    25
    47
    40
    62
    55
    65
    95
    102
    117
    150
    182
    127
    219
    299
    277
    309
    576
    """
    
    var numbers = [Int]()
    var preambleLength = 25
    
    override func prepareInput() {
        numbers = inputString.split(separator: "\n").map { Int($0)! }
        preambleLength = 25
        
//        numbers = testInput.split(separator: "\n").map { Int($0)! }
//        preambleLength = 5
    }
    
    override func part1() -> String {
        for idx in preambleLength..<numbers.count {
            if !Array(numbers[(idx - preambleLength)..<idx]).combinations.contains(numbers[idx]) {
                return String(numbers[idx])
            }
        }
        
        fatalError("No solution found for \(dayIndex)a")
    }
    
    override func part2() -> String {
        let aResult = Int(part1())!
        
        var endIdx = 1
        var searchDirection = 1
        for i in 0..<numbers.count {
            /// This solution is significantly faster than `for j in i..<numbers.count`, calculating the sum, and checking if it corresponds to the result of a. However, it's a little bit less readable :)
            while(true) {
                let numberSlice = numbers[i..<endIdx]
                
                if numberSlice.sum() == aResult {
                    return String(numberSlice.min()! + numberSlice.max()!)
                }
                
                if (searchDirection == 1) == (numberSlice.sum() < aResult) {
                    endIdx += searchDirection
                } else {
                    searchDirection *= -1
                    break
                }
            }
        }
        
        fatalError("No solution found for \(dayIndex)b")
    }
}

extension Array where Element == Int {
    var combinations: [Int] {
        var combinations = [Int]()
        
        for i in 0..<self.count {
            for j in i..<self.count {
                combinations.append(self[i] + self[j])
            }
        }
        
        return combinations
    }
}
