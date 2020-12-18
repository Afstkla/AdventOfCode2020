//
//  Day18.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 17/12/2020.
//

import Foundation

class Day18: Day {
    override var dayIndex: Int { get { 18 } set {} }
    
    var equations = [String]()
    
    let test = """
        1 + 2 * 3 + 4 * 5 + 6
        1 + (2 * 3) + (4 * (5 + 6))
        2 * 3 + (4 * 5)
        5 + (8 * 3 + 9 + 3 * 4 * 3)
        5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))
        ((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2
        """
    
    override func prepareInput() {
        for line in inputString.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines) {
            equations.append(line)
        }
    }
    
    func getEquationResult(equation: String) -> Int {
        var result = 0
        var op: String?

        for component in equation.trimmingCharacters(in: CharacterSet(charactersIn: "()")).components(separatedBy: " ") {
            if component == "*" || component == "+" {
                op = component
            } else if let val = Int(component) {
                if op != nil {
                    result = op == "+" ? result + val : result * val
                    op = nil
                } else {
                    result = val
                }
            } else {
                fatalError("Received \(component) in \(equation), not sure how to handle")
            }
        }

        return result
    }
    
    func getEquationResult2(equation: String) -> Int {
        var localEquation = equation
        while let equationPart = localEquation.range(of: #"\d+ \+ \d+"#, options: .regularExpression) {
            let equationWithoutBrackets = localEquation[equationPart]
            localEquation = localEquation.replacingOccurrences(of: equationWithoutBrackets, with: "\(getEquationResult(equation: String(equationWithoutBrackets)))")
        }

        return getEquationResult(equation: localEquation)
    }
    
    override func part1() -> String {
        var totalResult = 0
        for var equation in equations {
            while let equationPart = equation.range(of: #"\([^\(\)]*\)"#, options: .regularExpression) {
                let equationWithoutBrackets = equation[equationPart]
                equation = equation.replacingOccurrences(of: equationWithoutBrackets, with: "\(getEquationResult(equation: String(equationWithoutBrackets)))")
            }
            totalResult += getEquationResult(equation: equation)
        }
        
        return String(totalResult)
    }
    
    override func part2() -> String {
        var totalResult = 0
        for var equation in equations {
            while let equationPart = equation.range(of: #"\([^\(\)]*\)"#, options: .regularExpression) {
                let equationWithoutBrackets = equation[equationPart]
                equation = equation.replacingOccurrences(of: equationWithoutBrackets, with: "\(getEquationResult2(equation: String(equationWithoutBrackets)))")
            }
            totalResult += getEquationResult2(equation: equation)
        }
        
        return String(totalResult)
    }
}

extension String {
    var expression: NSExpression {
        return NSExpression(format: self)
    }
}
