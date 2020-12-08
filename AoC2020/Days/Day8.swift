//
//  Day8.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 07/12/2020.
//

import Foundation

class Day8: DayComputer {
    override var dayIndex: Int { get { 8 } set {}}
    
    let testStr = """
    nop +0
    acc +1
    jmp +4
    acc +3
    jmp -3
    acc -99
    acc +1
    jmp -4
    acc +6
    """
    
    var pcVisited = [Int: Bool]()
    
    override func part1() -> String {
        while pcVisited[pc] == nil {
            pcVisited[pc] = true
            step()
        }
        
        return String(accumulator)
    }
    
    override func part2() -> String {
        for i in 0..<instructions.count {
            // Reset the PC
            resetComputer()
            pcVisited.removeAll()
            
            // Change from jmp to nop or vice versa
            if instructions[i].type == .jmp {
                instructions[i].type = .nop
            } else if instructions[i].type == .nop {
                instructions[i].type = .jmp
            } else {
                continue
            }
            
            while pcVisited[pc] == nil && pc < instructions.count {
                pcVisited[pc] = true
                step()
            }
            
            // If we actually ended not because of a loop, but because we reached the end of the program
            if pc == instructions.count {
                break
            }
            
            // Change back
            if instructions[i].type == .jmp {
                instructions[i].type = .nop
            } else if instructions[i].type == .nop {
                instructions[i].type = .jmp
            }
        }
        
        return String(accumulator)
    }
}
