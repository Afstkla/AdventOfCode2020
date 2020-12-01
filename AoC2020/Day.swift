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
            // we found the file in our bundle!
            if let fileContents = try? String(contentsOf: fileURL) {
                // we loaded the file into a string!
                inputString = fileContents
                
//                let numbers = fileContents.split(separator: "\n").map { Int($0)! }.sorted(by: <)
                
//                getSolution1a(numbers: numbers)
//                getSolution1b(numbers: numbers)
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
