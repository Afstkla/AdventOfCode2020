//
//  Day3.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 03/12/2020.
//

import Foundation

class Day3: Day {
    override var dayIndex: Int { get { 3 } set {}}
    
    var puzzleGrid = [[String]]()
    
    func makePuzzleGrid() {
        puzzleGrid = [[String]]()
        
        for line in inputString.split(separator: "\n") {
            var puzzleLine = [String]()
            for i in 0..<line.count {
                puzzleLine.append(String(line[i]))
            }
            puzzleGrid.append(puzzleLine)
        }
    }

    override func part1() -> String {
        makePuzzleGrid()
        
        var treeCounter = 0
        for i in 0..<puzzleGrid.count {
            if puzzleGrid[i][3 * i % puzzleGrid[i].count] == "#" {
                treeCounter += 1
            }
        }
        
        return "\(treeCounter)"
    }
    
    override func part2() -> String {
        var multiplier = 1
        for movementOption in [(1,1), (3,1), (5,1), (7,1), (1,2)] {
            var treeCounter = 0
            for i in 0..<puzzleGrid.count {
                if i * movementOption.1 >= puzzleGrid.count {
                    break
                }
                if puzzleGrid[i * movementOption.1][(movementOption.0 * i) % puzzleGrid[i].count] == "#" {
                    treeCounter += 1
                }
            }
            multiplier *= treeCounter
        }
        
        return "\(multiplier)"
    }
}
