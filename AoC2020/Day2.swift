//
//  Day2.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 02/12/2020.
//

import Foundation

class Day2: Day {
    override var dayIndex: Int { get { 2 } set {}}

    override func part1() -> String {
        let lines = inputString.split(separator: "\n")
        
        var numberOfValidPasswords = 0
        for line in lines {
            if isValidPassword(line: String(line)) {
                numberOfValidPasswords += 1
            }
        }
        
        return "\(numberOfValidPasswords)"
    }
    
    func isValidPassword(line: String) -> Bool {
        let answerParts = line.split(separator: " ").map { String($0) }
        
        let minMax = answerParts[0].split(separator: "-")
        
        let min = Int(minMax[0])!
        let max = Int(minMax[1])!
        
        let charToFind = String(answerParts[1][0])
        
        let origPwdLength = answerParts[2].count
        
        let reducedPwdLength = answerParts[2].replacingOccurrences(of: charToFind, with: "").count
        
        let occurrencesOfChar = origPwdLength - reducedPwdLength
        
        return (occurrencesOfChar >= min) && (occurrencesOfChar <= max)
    }
    
    func isValidPolicy2Password(line: String) -> Bool {
        let answerParts = line.split(separator: " ").map { String($0) }
        
        let minMax = answerParts[0].split(separator: "-")
        
        let idx1 = Int(minMax[0])!
        let idx2 = Int(minMax[1])!
        
        let charToFind = String(answerParts[1][0])
        
        let test1 = String(answerParts[2][idx1 - 1]) == charToFind
        let test2 = String(answerParts[2][idx2 - 1]) == charToFind
        if ((test1) || (test2)) && (test1 != test2) {
            return true
        }
        
        return false
    }
    
    override func part2() -> String {
        let lines = inputString.split(separator: "\n")
        
        var numberOfValidPasswords = 0
        for line in lines {
            if isValidPolicy2Password(line: String(line)) {
                numberOfValidPasswords += 1
            }
        }
        
        return String(numberOfValidPasswords)
    }
}
