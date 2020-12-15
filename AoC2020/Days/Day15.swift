//
//  Day15.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 15/12/2020.
//

import Foundation

class Day15: Day {
    override var dayIndex: Int { get { 15 } set {} }
    
    var nums = [Int: Int]()
    var nextNum = -1
    var prevNum = 0
    
    let test = "0,3,6"
    
    override func prepareInput() {
        for (idx, num) in inputString.split(separator: ",").enumerated() {
            if let num = Int(num) {
                if nextNum == -1 {
                    nextNum = num
                    continue
                }
                
                nums[nextNum] = idx
                nextNum = num
            }
        }
    }
    
    override func part1() -> String {
        for idx in (nums.count + 1)..<2020 {
            if let lastIdx = nums[nextNum] {
                nums[nextNum] = idx
                nextNum = idx - lastIdx
            } else {
                nums[nextNum] = idx
                nextNum = 0
            }
        }
        
        return String(nextNum)
    }
    
    override func part2() -> String {
        for idx in 2020..<30000000 {
            if let lastIdx = nums[nextNum] {
                nums[nextNum] = idx
                nextNum = idx - lastIdx
            } else {
                nums[nextNum] = idx
                nextNum = 0
            }
        }
        
        return String(nextNum)
    }
}
