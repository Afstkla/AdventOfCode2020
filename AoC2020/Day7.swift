//
//  Day7.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 07/12/2020.
//

import Foundation

class Day7: Day {
    override var dayIndex: Int { get { 6 } set {}}
    
    struct Bag: Hashable {
        var name: String
        var count: Int?
    }
    
    var bagContains = [Bag: [Bag]]()
    
    func prepareInput() {
        let bagRows = inputString.lines()
        
        for bagRow in bagRows {
            let bagStuff = bagRow.components(separatedBy: "contain")
            
            let inputBag = getBag(from: bagStuff[0])
            
            let outputStuffs = bagStuff[1].split(separator: ",").map { String($0) }
            var outputBags = [Bag]()
            
            for outputStuff in outputStuffs {
                let outputBagBag = getBag(from: outputStuff)
                
                if outputBagBag.name == "no other" {
                    continue
                }
                
                outputBags.append(outputBagBag)
            }
            
            bagContains[inputBag] = outputBags
        }
    }
    
    func getBag(from str: String) -> Bag {
        let bagStuff = str.trimmed.split(separator: " ")
        
        var cnt: Int? = nil
        if let count = Int(bagStuff[0]) {
            cnt = count
        }
        
        let bagName = String(bagStuff[cnt == nil ? 0 : 1] + " " + bagStuff[cnt == nil ? 1 : 2])
        
        return Bag(name: bagName.trimmed, count: cnt)
    }
    
    func getOuter(bagName: String) -> [String] {
        var allOuterBags = [bagName]
        
        let outerBags = bagContains.filter { $0.value.map { $0.name}.contains(bagName) }.map { $0.key }
        for outerBag in outerBags {
            allOuterBags.append(contentsOf: getOuter(bagName: outerBag.name))
        }
        
        return allOuterBags
    }
    
    func getNumBags(bagName: String) -> Int {
        var bagCount = 1
        
        let innerBags = bagContains.filter { $0.key.name == bagName }.map { $0.value }
        for innerBag in innerBags.flatMap({ $0 }) {
            bagCount += (getNumBags(bagName: innerBag.name) * innerBag.count!)
        }
        
        return bagCount
    }
    
    var allBagsWithMyBag = [Bag]()
    
    override func part1() -> String {
        return String(Set(getOuter(bagName: "shiny gold")).count - 1) // -1 to remove "shiny gold"
    }
    
    override func part2() -> String {
        return String(getNumBags(bagName: "shiny gold") - 1) // -1 to remove "shiny gold"
    }
    
    override func solve() {
        prepareInput()
        
        super.solve()
    }
}