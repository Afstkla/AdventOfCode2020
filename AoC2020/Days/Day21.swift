//
//  Day21.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 17/12/2020.
//

import Foundation

class Day21: Day {
    override var dayIndex: Int { get { 21 } set {} }
    
    let test = """
    mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
    trh fvjkl sbzzf mxmxvkd (contains dairy)
    sqjhc fvjkl (contains soy)
    sqjhc mxmxvkd sbzzf (contains fish)
    """
    
    var possibleMatchesDict: [String: [String]] = [:]
    var allergenToIngredientDict: [String: String] = [:]
    var allIngredients: [String] = []

    override func prepareInput() {
        var internalPossibleMatches: [String: [[String]]] = [:]
        for line in inputString.lines() {
            let components = line.replacingOccurrences(of: ")", with: "").components(separatedBy: "(contains ")
            
            let ingredients = components[0].split(separator: " ").map { String($0).trimmed() }
            allIngredients.append(contentsOf: ingredients)
            
            let allergens = components[1].split(separator: ",").map { String($0).trimmed() }
            
            for allergen in allergens {
                if internalPossibleMatches[allergen] == nil {
                    internalPossibleMatches[allergen] = []
                }
                internalPossibleMatches[allergen]!.append(ingredients)
            }
        }
        
        for (allergen, ingredientsArr) in internalPossibleMatches {
            possibleMatchesDict[allergen] = ingredientsArr.overlappingValues()
        }
    }
    
    override func part1() -> String {
        while allergenToIngredientDict.count < possibleMatchesDict.count {
            for (allergen, _) in possibleMatchesDict {
                for (_, matchedIngredient) in allergenToIngredientDict {
                    possibleMatchesDict[allergen]!.removeAll { $0 == matchedIngredient }
                }
                
                if possibleMatchesDict[allergen]!.count == 1 {
                    allergenToIngredientDict[allergen] = possibleMatchesDict[allergen]!.first!
                }
            }
        }
        
        return String(allIngredients.filter { !allergenToIngredientDict.values.contains($0) }.count)
    }
    
    override func part2() -> String {
        var ingredientList = ""
        for allergen in allergenToIngredientDict.keys.sorted() {
            ingredientList.append("\(allergenToIngredientDict[allergen]!),")
        }
        return String(ingredientList.dropLast())
    }
}

extension Array where Element: StringProtocol {
    func overlappingValues(withOtherArray otherArray: [Element]) -> [Element] {
        return [Element](Dictionary(grouping: self + otherArray, by: {$0}).filter { $1.count > 1 }.keys)
    }
}

extension Array where Element == Array<String> {
    func overlappingValues() -> Element {
        return self.reduce(self.flatMap{ $0 }) { $1.overlappingValues(withOtherArray: $0) }
    }
}
