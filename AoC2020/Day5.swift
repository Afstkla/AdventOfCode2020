//
//  Day5.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 05/12/2020.
//

import Foundation

class Day5: Day {
    override var dayIndex: Int { get { 5 } set {}}

    var seatIDs = [Int]()
    
    func prepareInput() {
        let boardingPasses = inputString.split(separator: "\n").map { String($0) }
        
        boardingPasses.forEach {
            seatIDs.append(
                $0.reduce(0) {
                    ($0 * 2) + (($1 == "B" || $1 == "R") ? 1 : 0)
                }
            )
        }
    }
    
    override func part1() -> String {
        return String(seatIDs.max()!)
    }
    
    override func part2() -> String {
        seatIDs.sort(by: <)
        
        for i in 1..<seatIDs.count {
            if seatIDs[i] - seatIDs[i - 1] == 2 {
                return "\(seatIDs[i] - 1)"
            }
        }
        
        return "NOT FOUND"
    }
    
    override func solve() {
        prepareInput()
        
        super.solve()
    }
}
