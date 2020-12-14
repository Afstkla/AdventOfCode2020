//
//  Day6.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 06/12/2020.
//

import Foundation

class Day06: Day {
    override var dayIndex: Int { get { 6 } set {}}

    override func part1() -> String {
        String(inputString.components(separatedBy: ["\n\n"]).map {
            String($0).replacingOccurrences(of: "\n", with: "")
        }.reduce(0) {
            $0 + Set($1.charactersArray).count
        })
    }
    
    override func part2() -> String {
        let groups = inputString.components(separatedBy: ["\n\n"]).map { String($0).split(separator: "\n").map { String($0) } }
        
        var total = 0
        for group in groups {
            for char in Set(group.flatMap() { $0 }) {
                var includesForAll = true
                for entry in group {
                    if !entry.contains(char) {
                        includesForAll = false
                        break
                    }
                }
                
                if includesForAll {
                    total += 1
                }
            }
        }
        return String(total)
    }
}
