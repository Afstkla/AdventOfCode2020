//
//  Day3.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 03/12/2020.
//

import Foundation

class Day03: Day {
    override var dayIndex: Int { get { 3 } set {}}
    
    var puzzleGrid = [String]()
    override func prepareInput() {
        puzzleGrid = inputString.split(separator: "\n").map { String($0) }
    }

    override func part1() -> String {
        String(puzzleGrid.indices.filter { puzzleGrid[$0][($0 * 3) % puzzleGrid[$0].count] == "#" }.count)
    }
    
    override func part2() -> String {
        String([(1,1), (3,1), (5,1), (7,1), (1,2)].reduce(1) { (previousResult, newValue) in
            puzzleGrid.indices.filter { (idx) in
                let somehowIfIDontUseThisVariableTheCompilerComplains = (idx % newValue.1) == 0 && puzzleGrid[idx][((idx / newValue.1) * newValue.0) % puzzleGrid[idx].count] == "#"
                return somehowIfIDontUseThisVariableTheCompilerComplains
            }.count * previousResult
            
            /*
             This would've been even nicer, but I keep getting "The compiler is unable to type-check this expression in reasonable time. Try breaking up the expression into distinct sub-expressions"
             puzzleGrid.indices.filter {
                 ($0 % newValue.1) == 0 && puzzleGrid[$0][(($0 / newValue.1) * newValue.0) % puzzleGrid[$0].count] == "#"
             }.count * previousResult
             */
        })
    }
}
