//
//  Day24.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 17/12/2020.
//

import Foundation

class Day24: Day {
    override var dayIndex: Int { get { 24 } set {} }
    
    enum Direction: Int, CustomStringConvertible, CaseIterable {
        case se = 0
        case sw = 1
        case ne = 2
        case nw = 3
        case e  = 4
        case w  = 5
        
        var description: String {
            switch self {
            case .se: return "se"
            case .sw: return "sw"
            case .ne: return "ne"
            case .nw: return "nw"
            case .e:  return "e"
            case .w:  return "w"
            }
        }
    }
    
    enum TileColor {
        case black
        case white
        
        mutating func toggled() { self = self.toggle() }
        
        func toggle() -> TileColor { return self == .black ? .white : .black }
    }
    
    var blackTiles: [[Int]: TileColor] = [:]
    
    func move(arr: inout [Int], in direction: Direction) {
        switch direction {
        case .se: arr = [arr[0] + 1, arr[1] - 1]
        case .sw: arr = [arr[0] - 1, arr[1] - 1]
        case .ne: arr = [arr[0] + 1, arr[1] + 1]
        case .nw: arr = [arr[0] - 1, arr[1] + 1]
        case .e:  arr = [arr[0] + 2, arr[1]]
        case .w:  arr = [arr[0] - 2, arr[1]]
        }
    }
    
    var movementInstructions: [[Direction]] = []
    
    let replacementDict: [String: Int] = [ "se": 0, "sw": 1, "ne": 2, "nw": 3, "e": 4, "w": 5]
    
    override func prepareInput() {
        var input = inputString
        for i in replacementDict.keys.sorted(by: { $0.count > $1.count }) {
            input = input.replacingOccurrences(of: i, with: "\(replacementDict[i]!)")
        }
        
        for line in input.lines() {
            movementInstructions.append(line.map { Direction(rawValue: Int("\($0)")!)! })
        }
    }
    
    override func part1() -> String {
        for movementInstruction in movementInstructions {
            var location = [0, 0]
            for instruction in movementInstruction {
                move(arr: &location, in: instruction)
            }
            if blackTiles[location] == nil {
                blackTiles[location] = .black
            } else {
                blackTiles[location] = blackTiles[location]?.toggle() == .black ? .black : nil
            }
        }
        
        return String(blackTiles.values.count)
    }
    
    func shouldToggle(tileAt location: [Int], in grid: [[Int]: TileColor]) -> Bool {
        var blackTileCounter = 0
        let selfTileColor = grid[location] ?? .white
        
        for direction in Direction.allCases {
            var locationToCheck = location
            
            move(arr: &locationToCheck, in: direction)
            
            if (grid[locationToCheck] ?? .white) == .black {
                blackTileCounter += 1
            }
            
            // Early stopping
            if blackTileCounter > 2 {
                break
            }
        }
        
        if selfTileColor == .black && (blackTileCounter == 0 || blackTileCounter > 2) {
            return true
        }
        
        if selfTileColor == .white && blackTileCounter == 2 {
            return true
        }
        
        return false
    }
    
    override func part2() -> String {
        for _ in 1...100 {
            var checkedTiles = [[Int]]()
            var newTiles = [[Int]: TileColor]()
            
            for (location, tileColor) in blackTiles {
                if !checkedTiles.contains(location) {
                    if shouldToggle(tileAt: location, in: blackTiles) {
                        newTiles[location] = (tileColor).toggle() == .black ? .black : nil
                    } else {
                        newTiles[location] = tileColor == .black ? .black : nil
                    }
                }
                checkedTiles.append(location)
                
                for direction in Direction.allCases {
                    var locationToCheck = location
                    
                    move(arr: &locationToCheck, in: direction)
                    
                    if !checkedTiles.contains(locationToCheck) {
                        if shouldToggle(tileAt: locationToCheck, in: blackTiles) {
                            newTiles[locationToCheck] = (blackTiles[locationToCheck] ?? .white).toggle() == .black ? .black : nil
                        } else {
                            newTiles[locationToCheck] = blackTiles[locationToCheck] == .black ? .black : nil
                        }
                    }
                    checkedTiles.append(locationToCheck)
                }
            }
            
            blackTiles = newTiles
        }
        
        return String(blackTiles.values.count)
    }
}
