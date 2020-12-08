//
//  DayComputer.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 08/12/2020.
//

import Foundation

class DayComputer: Day {
    enum InstructionType: String, CaseIterable {
        case acc = "acc"
        case jmp = "jmp"
        case nop = "nop"
    }
    
    struct Instruction: CustomStringConvertible {
        var type: InstructionType
        var argument: Int
        
        var description: String {
            return "\(type) \(argument)"
        }
    }
    
    private(set) var pc = 0
    private(set) var accumulator = 0
    var instructions = [Instruction]()

    override func prepareInput() {
        let lines = inputString.split(separator: "\n").map { String($0) }
        
        for line in lines {
            instructions.append(getInstructionFrom(line: line))
        }
    }
    
    func getInstructionFrom(line: String) -> Instruction {
        let instrParts = line.split(separator: " ").map { String($0) }
        
        guard let type = InstructionType(rawValue: instrParts[0]) else {
            fatalError("Unknown instruction \(instrParts[0]) received")
        }
        
        guard let argument = Int(instrParts[1]) else {
            fatalError("Received non-integer argument \(instrParts[1])")
        }
        
        return Instruction(type: type, argument: argument)
    }
    
    func handle(instr: Instruction) {
        switch instr.type {
        case .acc:
            accumulator += instr.argument
            pc += 1
        case .jmp:
            pc += instr.argument
        case .nop:
            pc += 1
        }
    }
    
    func resetComputer() {
        pc = 0
        accumulator = 0
    }
}
