//
//  Day14.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 14/12/2020.
//

import Foundation

class Day14: Day {
    override var dayIndex: Int { get { 14 } set {}}
    var lines = [String]()
    
    let test = """
    mask = 000000000000000000000000000000X1001X
    mem[42] = 100
    mask = 00000000000000000000000000000000X0XX
    mem[26] = 1
    """
    
    override func prepareInput() {
        lines = inputString.components(separatedBy: .newlines)
        if lines[lines.count - 1] == "" {
            lines.removeLast()
        }
    }
    
    override func part1() -> String {
        var currentMask = ""
        var mem: [Int: Int64] = [:]
        for line in lines {
            let components = line.components(separatedBy: " = ")
            
            if components[0].contains("mask") {
                currentMask = String(components[1].reversed())
                continue
            }
            
            let memoryAddress = Int(components[0].split(separator: "[")[1].dropLast())!
            var memoryValue = Int64(components[1])!
            
            for (idx, char) in currentMask.enumerated() {
                if char == "X" {
                    continue
                } else if char == "0" {
                    memoryValue &= ~(1 << idx)
                } else if char == "1" {
                    memoryValue |= (1 << idx)
                }
            }
            
            mem[memoryAddress] = memoryValue
        }
        
        return String(mem.values.sum())
    }
    
    override func part2() -> String {
        var currentMask = ""
        var mem: [Int64: Int64] = [:]
        
        var lineNo = 0
        for line in lines {
            lineNo += 1
            
            let components = line.components(separatedBy: " = ")
            
            if components[0].contains("mask") {
                currentMask = String(components[1].reversed())
                continue
            }
            
            let memoryAddress = Int64(components[0].split(separator: "[")[1].dropLast())!
            let memoryValue = Int64(components[1])!
            
            for i in 0..<(1 << currentMask.filter { $0 == "X" }.count) {
                var memAddr = memoryAddress
                var xIdx = 0
                
                for (idx, char) in currentMask.enumerated() {
                    if char == "0" {
                        continue
                    } else if char == "1" {
                        memAddr |= (1 << idx)
                    } else if char == "X" {
                        if (i & (1 << xIdx)) == 0 {
                            memAddr &= ~(1 << idx)
                        } else {
                            memAddr |= (1 << idx)
                        }
                        
                        xIdx += 1
                    }
                }
                
                mem[memAddr] = memoryValue
            }
        }
        
        return String(mem.values.sum())
    }
}
