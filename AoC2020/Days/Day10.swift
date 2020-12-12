//
//  Day10.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 10/12/2020.
//

import Foundation

class Day10: Day {
    override var dayIndex: Int { get { 10 } set {}}

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
    
    var tribonacciCache = [0, 0, 1]
    
    func tribonacci(n: Int) -> Int {
        if n <= 1 {
            return 0
        } else if n == 2 {
            return 1
        } else {
            return tribonacci(n: n - 1) + tribonacci(n: n - 2) + tribonacci(n: n - 3)
        }
    }
    
    override func prepareInput() {
        numbers = [0] + inputString.components(separatedBy: .newlines).compactMap(Int.init).sorted(by: <)
        numbers.append(numbers.max()! + 3)
        
        differences = numbers[1..<numbers.count].enumerated().map { $1 - numbers[$0] }
    }
    
    override func part1() -> String {
        String(differences.filter { $0 == 1 }.count * differences.filter { $0 == 3 }.count)
    }
    
    override func part2() -> String {
        String(differences.split(separator: 3).map { $0.count }.reduce(1) { tribonacci(n: $1 + 2) * $0 })
    }
}

