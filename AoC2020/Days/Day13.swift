//
//  Day13.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 13/12/2020.
//

import Foundation

class Day13: Day {
    override var dayIndex: Int { get { 13 } set {} }
    
    var startTimestamp = 0
    var busIDs = [(busID: Int, idx: Int)]()
    
    let test = """
    939
    7,13,x,x,59,x,31,19
    """
    
    func gcd(_ a: Int, _ b: Int) -> Int {
        var (a, b) = (a, b)
        while b != 0 {
            (a, b) = (b, a % b)
        }
        return abs(a)
    }
    
    func lcm(a: Int, b: Int) -> Int {
        return (a / gcd(a, b)) * b
    }
    
    override func prepareInput() {
        let lines = inputString.components(separatedBy: .newlines)
        
        startTimestamp = Int(lines[0])!
        
        for (idx, input) in lines[1].split(separator: ",").enumerated() {
            if input == "x" {
                continue
            } else {
                busIDs.append((busID: Int(input)!, idx: idx))
            }
        }
    }
    
    override func part1() -> String {
        let firstBusWithWaitTime = busIDs.map { $0.busID }.filter { $0 != 1 }.map { (busID: $0, waitTime: $0 - (startTimestamp % $0)) }.sorted { $0.waitTime < $1.waitTime }.first!
        return String(firstBusWithWaitTime.busID * firstBusWithWaitTime.waitTime)
    }
    
    override func part2() -> String {
        let sortedArr = busIDs.sorted { $0.busID > $1.busID }
        var stepSize = 1
        var num = 0
        var indexToSolve = 0
        
        while indexToSolve < busIDs.count {
            let busID = sortedArr[indexToSolve]
            
            if (num + busID.idx) % busID.busID == 0 {
                indexToSolve += 1
                stepSize = lcm(a: stepSize, b: busID.busID)
                continue
            }
            
            num += stepSize
        }
        
        return String(num)
    }
}
