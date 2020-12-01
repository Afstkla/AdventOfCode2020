//
//  Day.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 01/12/2020.
//

import Foundation

class Day {
    var solveFunc: (() -> Void)?
    var inputString = ""
    var dayIndex = -1
    
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
    
    func part1() -> String {
        fatalError("\(#function) not implemented")
    }
    
    func part2() -> String {
        fatalError("\(#function) not implemented")
    }
    
    func solve() {
        print("Solution for day \(dayIndex):")
        if let solveFunc = solveFunc {
            solveFunc()
        } else {
            print("\ta: \(part1())")
            print("\tb: \(part2())")
        }
    }
}
