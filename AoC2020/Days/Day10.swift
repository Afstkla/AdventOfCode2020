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
    var differences = [Int]()
    
    override func prepareInput() {
        numbers = [0] + inputString.components(separatedBy: .newlines).compactMap(Int.init).sorted(by: <)
        numbers.append(numbers.max()! + 3)
        
        differences = numbers[1..<numbers.count].enumerated().map {
            // Differences
            $1 - numbers[$0]
        }
    }
    
    override func part1() -> String {
        String(differences.filter { $0 == 1 }.count * differences.filter { $0 == 3 }.count)
    }
    
    override func part2() -> String {
        String(differences.split(separator: 3).map {
            // Split by tiny jumps
            $0.count
        }.reduce(1) { intermediateResult, newValue in
            // We have a list of numbers 0, 1, 2, ..., n, n + 3
            // Possible arrangements are 2^(n - 1) if the maximum jump size wouldn't be 3. With the maximum jump size 3, it starts to affect the result starting at n = 4 (as we can't remove all 1..<n-1 values, as that'd give a jump of 4)
            // To solve this, we have to adjust for the number of invalid jumps, which is given by 3^(n - 4) for any value of n >= 4. To solve n < 3, we use the floor function to reduce the value to 0
            let possibleCombinations = Int(pow(2, Double(newValue - 1)) - floor(pow(3, Double(newValue - 4))))
            return possibleCombinations * intermediateResult
        })
    }
}
