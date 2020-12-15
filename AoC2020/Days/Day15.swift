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
    var newNumAndIdx: (num: Int, idx: Int) = (-1, -1)
    var prevNum = 0
    
    let test = "0,3,6"
    
    override func prepareInput() {
        for (idx, num) in inputString.split(separator: ",").enumerated() {
            if let num = Int(num) {
                if newNumAndIdx.num == -1 {
                    newNumAndIdx = (num: num, idx: idx)
                    continue
                }
                
                nums[newNumAndIdx.num] = newNumAndIdx.idx
                newNumAndIdx = (num: num, idx: idx)
            }
        }
    }
    
    override func part1() -> String {
        for idx in (nums.count + 1)..<2020 {
            if let lastIdx = nums[newNumAndIdx.num] {
                nums[newNumAndIdx.num] = newNumAndIdx.idx
                newNumAndIdx = (num: idx - lastIdx - 1, idx: idx)
            } else {
                nums[newNumAndIdx.num] = newNumAndIdx.idx
                newNumAndIdx = (num: 0, idx: idx)
            }
        }
        
        return String(newNumAndIdx.num)
    }
    
    override func part2() -> String {
        for idx in 2020..<30000000 {
            if let lastIdx = nums[newNumAndIdx.num] {
                nums[newNumAndIdx.num] = newNumAndIdx.idx
                newNumAndIdx = (num: idx - lastIdx - 1, idx: idx)
            } else {
                nums[newNumAndIdx.num] = newNumAndIdx.idx
                newNumAndIdx = (num: 0, idx: idx)
            }
        }
        
        return String(newNumAndIdx.num)
    }
}
