//
//  Day10.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 10/12/2020.
//

import Foundation

class Day10: Day {
    override var dayIndex: Int { get { 9 } set {}}

    let test1 = """
    16
    10
    15
    5
    1
    11
    7
    19
    6
    12
    4
    """
    
    let test2 = """
    28
    33
    18
    42
    31
    14
    46
    20
    48
    47
    24
    23
    49
    45
    19
    38
    39
    11
    1
    32
    25
    35
    8
    17
    7
    9
    4
    2
    34
    10
    3
    """
    
    var numbers = [Int]()
    
    override func prepareInput() {
        numbers = [0] + inputString.components(separatedBy: .newlines).compactMap(Int.init).sorted(by: <)
        numbers.append(numbers.max()! + 3)
    }
    
    override func part1() -> String {
        var oneJoltDiff = 0
        var threeJoltDiff = 0
        
        for i in 1..<numbers.count {
            if numbers[i] - numbers[i - 1] == 1 {
                oneJoltDiff += 1
            } else if numbers[i] - numbers[i - 1] == 3 {
                threeJoltDiff += 1
            }
        }
        
        return String(oneJoltDiff * threeJoltDiff)
    }
    
    override func part2() -> String {
        let splits: Int = numbers[1..<numbers.count].enumerated().map {
            // Differences
            $1 - numbers[$0]
        }.split(separator: 3).map {
            // Split by tiny jumps
            $0.count - 1
        }.reduce(1) { res, newValue in
            let somehowIfIDontUseThisVariableTheCompilerComplains = Int(pow(2, Double(newValue)) - floor(pow(3, Double(newValue - 3))))
            return somehowIfIDontUseThisVariableTheCompilerComplains * res
        }
        
        return String(splits)
    }
}
