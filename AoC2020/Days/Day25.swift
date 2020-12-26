//
//  Day25.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 17/12/2020.
//

import Foundation

class Day25: Day {
    override var dayIndex: Int { get { 25 } set {} }
    
    var keys: [Int] = []
    
    override func prepareInput() {
        keys = inputString.lines().map { Int($0)! }
    }
    
    func transform(value: Int, toSubjectNumber subjectNumber: Int) -> Int {
        var res = value * subjectNumber
        res %= 20201227
        return res
    }
    
    override func part1() -> String {
        var indexes = [-1, -1]
        var value = 1
        var idx = 1
        while indexes.contains(-1) {
            value = transform(value: value, toSubjectNumber: 7)
            if value == keys[0] {
                indexes[0] = idx
            }
            
            if value == keys[1] {
                indexes[1] = idx
            }
            
            idx += 1
        }
        
        print(indexes)
        
        var result = 1
        for _ in 0..<indexes[0] {
            result = transform(value: result, toSubjectNumber: keys[1])
        }
        return String(result)
    }
    
    override func part2() -> String {
        ""
    }
}
