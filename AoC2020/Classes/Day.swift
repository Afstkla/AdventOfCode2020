//
//  Day.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 01/12/2020.
//

import Foundation

class Day {
    var inputString = ""
    var dayIndex = -1
    
    func prepareInput() { return }
    
    init(inputFile: String) {
        if let fileURL = Bundle.main.url(forResource: inputFile, withExtension: "txt") {
            if let fileContents = try? String(contentsOf: fileURL) {
                inputString = fileContents
            } else {
                fatalError("Couldn't get string from inputfile")
            }
        } else {
            if inputFile == "" {
                print("No input file given. Are you sure?")
            } else {
                fatalError("Couldn't find \(inputFile) in Resources")
            }
        }
    }
    
    init() { }
    
    func part1() -> String {
        fatalError("\(#function) not implemented")
    }
    
    func part2() -> String {
        fatalError("\(#function) not implemented")
    }
    
    func solve() {
        print("======== Day \(dayIndex) Solution ========")
        let daySolveStart = Date()
        prepareInput()
        let inputPrepareTime = Date()
        
        print("\(dayIndex)a: \(part1())")
        let aSolveTime = Date()
        print("\(dayIndex)b: \(part2())")
        let bSolvetime = Date()
        
        print("====== Performance Metrics ======")
        print("Input prepared in: \(inputPrepareTime.timeIntervalSince(daySolveStart) * 1000)ms")
        print("a solved in \(aSolveTime.timeIntervalSince(inputPrepareTime) * 1000)")
        print("b solved in \(bSolvetime.timeIntervalSince(aSolveTime) * 1000)")
        print("Total solve time: \(bSolvetime.timeIntervalSince(daySolveStart) * 1000)")
        print()
        print()
    }
}
