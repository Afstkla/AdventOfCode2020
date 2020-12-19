//
//  Day19.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 17/12/2020.
//

import Foundation

class Day19: Day {
    override var dayIndex: Int { get { 19 } set {} }
    
    var rules: [Int: String] = [:]
    var ruleLines: [Int: String] = [:]
    
    var testLines: [String] = []
    
    func parse(rule: String, idx: Int) {
        if rule.contains("\"") {
            rules[idx] = String(rule.trimmingCharacters(in: CharacterSet(charactersIn: "\"")))
        } else {
            var parsedRule = ""
            let components = rule.split(separator: " ")
            
            for component in components {
                if let intValue = Int(component) {
                    if intValue == idx {
                        if idx == 11 {
                            parsedRule.append(#"{XXX}"#)
                        } else {
                            parsedRule.append("+")
                        }
                        continue
                    }
                    if rules[intValue] == nil {
                        parse(rule: ruleLines[intValue]!, idx: intValue)
                    }
                    
                    if rules[intValue]!.range(of: "^[ab]+$", options: .regularExpression) != nil {
                        parsedRule.append("\(rules[intValue]!)")
                    } else {
                        parsedRule.append("(\(rules[intValue]!))")
                    }
                } else {
                    parsedRule.append(String(component))
                }
            }
            /// I really hate this solution, but I couldn't find a nice way to solve this with regexes. Rexegg has a nice tutorial on something that would've been very nice here, but isn't implemented in any regex engine..
            /// https://www.rexegg.com/regex-quantifier-capture.html#comform

            if idx == 11 && rule.contains(String(11)) {
                parsedRule.append(#"{XXX}"#)
                let parsedRuleBackup = parsedRule
                parsedRule = ""
                
                /// Problem initially solved with `1..<10`, but anything down to `1..<4` still gives the correct results for my input (and is a lot quicker)
                for i in 1..<4 {
                    parsedRule.append(parsedRuleBackup.replacingOccurrences(of: "XXX", with: String(i)) + "|")
                }
                
                parsedRule.removeLast()
            }
            
            
            rules[idx] = parsedRule
        }
    }
    
    override func prepareInput() {
        rules = [:]
        ruleLines = [:]
        testLines = []
        
        let inputParts = inputString.components(separatedBy: "\n\n")
        
        let localRuleLines = inputParts[0].lines().map {
            $0.split(separator: ":")
        }
        
        for localRuleLine in localRuleLines {
            ruleLines[Int(localRuleLine[0])!] = String(localRuleLine[1].trimmed())
        }
        
        for i in ruleLines.keys {
            if rules[i] == nil {
                parse(rule: ruleLines[i]!, idx: i)
            } else {
                continue
            }
        }
        
        testLines = inputParts[1].lines()
        
        print(rules[0]!)
    }
    
    override func part1() -> String {
        String(testLines.filter { $0.range(of: "^\(rules[0]!)$", options: .regularExpression) != nil }.count)
    }
    
    override func part2() -> String {
        inputString = inputString.replacingOccurrences(of: "\n8: 42\n", with: "\n8: 42 | 42 8\n")
        inputString = inputString.replacingOccurrences(of: "\n11: 42 31\n", with: "\n11: 42 31 | 42 11 31\n")
        
        prepareInput()
        
        return String(testLines.filter { $0.range(of: "^\(rules[0]!)$", options: .regularExpression) != nil }.count)
    }
}

extension StringProtocol {
    func lines() -> [String] {
        return self.trimmed().components(separatedBy: .newlines)
    }
    
    func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
