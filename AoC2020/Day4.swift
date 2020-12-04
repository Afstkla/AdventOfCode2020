//
//  Day4.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 04/12/2020.
//

import Foundation

class Day4: Day {
    override var dayIndex: Int { get { 4 } set {}}

    override func part1() -> String {
        let passports = inputString.components(separatedBy: ["\n\n"])
        
        return String(passports.filter { isValidPasswordWithoutCID(str: $0) }.count)
    }
    
    func isValidPasswordWithoutCID(str: String) -> Bool {
        let typesToCheck = ["byr",
                            "iyr",
                            "eyr",
                            "hgt",
                            "hcl",
                            "ecl",
                            "pid",
//                            "cid",
        ]
        
        for type in typesToCheck {
            if !str.contains(type + ":") {
                return false
            }
        }
        
        return true
    }
    
    func hasValidPasswordProperties(str: String) -> Bool {
        let passwordProprerties = str.components(separatedBy: ["\n", " "]).map { $0.split(separator: ":") }
        
        for property in passwordProprerties {
            if property.isEmpty {
                continue
            }
            switch property[0] {
            case "ecl":
                let validEntries = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
                              
                var hasFound = false
                for validEntry in validEntries {
                    if property[1] == validEntry {
                        hasFound = true
                        break
                    }
                }
                
                if !hasFound {
                    return false
                }
            case "pid":
                if property[1].count != 9 {
                    return false
                }
            case "iyr":
                if let issueYear = Int(property[1]) {
                    if issueYear < 2010 || issueYear > 2020 {
                        return false
                    }
                } else {
                    return false
                }
            case "hgt":
                if property[1].contains("cm") {
                    if let height = Int(property[1].replacingOccurrences(of: "cm", with: "")) {
                        if height < 150 || height > 193 {
                            return false
                        }
                    } else {
                        return false
                    }
                } else if property[1].contains("in") {
                    if let height = Int(property[1].replacingOccurrences(of: "in", with: "")) {
                        if height < 59 || height > 76 {
                            return false
                        }
                    } else {
                        return false
                    }
                } else {
                    return false
                }
            case "byr":
                if let byr = Int(property[1]) {
                    if byr < 1920 || byr > 2002 {
                        return false
                    }
                } else {
                    return false
                }
            case "hcl":
                if property[1].range(of: "#[0-9a-fA-F]{6}", options: .regularExpression) == nil {
                    return false
                }
            case "eyr":
                if let byr = Int(property[1]) {
                    if byr < 2020 || byr > 2030 {
                        return false
                    }
                } else {
                    return false
                }
            case "cid":
                // Ignore
                break
            default:
                print("Something went wrong, received: \(property)")
            }
        }
        
        return true
    }
    
    override func part2() -> String {
        let passports = inputString.components(separatedBy: ["\n\n"])

        let passportsWithCID = passports.filter { isValidPasswordWithoutCID(str: $0) }
        
        return String(passportsWithCID.filter { hasValidPasswordProperties(str: $0) }.count)
    }
}

extension String {
    func components<T>(separatedBy separators: [T]) -> [String] where T : StringProtocol {
        var result = [self]
        for separator in separators {
            result = result
                .map { $0.components(separatedBy: separator)}
                .flatMap { $0 }
        }
        return result
    }
}
