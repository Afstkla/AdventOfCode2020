//
//  Day11.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 11/12/2020.
//

import Foundation

class Day11: Day {
    override var dayIndex: Int { get { 11 } set {}}
    
    let test = """
    L.LL.LL.LL
    LLLLLLL.LL
    L.L.L..L..
    LLLL.LL.LL
    L.LL.LL.LL
    L.LLLLL.LL
    ..L.L.....
    LLLLLLLLLL
    L.LLLLLL.L
    L.LLLLL.LL
    """
    
    enum Tile: Character {
        case floor = "."
        case emptyChair = "L"
        case takenChair = "#"
    }
    
    var floorPlan = [[Tile]]()
    var lineLength = 0
    var inputLength = 0
    
    override func prepareInput() {
        floorPlan = inputString.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).map({ $0.map({ Tile(rawValue: $0)! }) })
        lineLength = floorPlan[0].count
        inputLength = floorPlan.count
    }
    
    override func part1() -> String {
        var innerFloorplan = floorPlan
        
        while true {
            var newFloorPlan = innerFloorplan
            
            for idx in 0..<inputLength * lineLength {
                let i = idx / lineLength
                let j = idx % lineLength
                let val = innerFloorplan[i][j]
                if val == .floor {
                    newFloorPlan[i][j]  = .floor
                    continue
                }
                var counter = 0
                for k in [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)] {
                    if i + k.0 < 0 || i + k.0 >= inputLength || j + k.1 < 0 || j + k.1 >= lineLength {
                        continue
                    } else if innerFloorplan[i + k.0][j + k.1] == .takenChair {
                        counter += 1
                    }
                }
                if val == .emptyChair && counter == 0 {
                    newFloorPlan[i][j] = .takenChair
                } else if val == .takenChair && counter >= 4 {
                    newFloorPlan[i][j] = .emptyChair
                }
            }
            
            if innerFloorplan == newFloorPlan {
                innerFloorplan = newFloorPlan
                break
            }
            
            innerFloorplan = newFloorPlan
        }
        
        return String(innerFloorplan.map { $0.filter { $0 == .takenChair }.count }.sum())
    }
    
    override func part2() -> String {
        var innerFloorplan = floorPlan
        
        while true {
            var newFloorPlan = innerFloorplan
            
            for idx in 0..<inputLength * lineLength {
                let i = idx / lineLength
                let j = idx % lineLength
                let val = innerFloorplan[i][j]
                if val == .floor {
                    newFloorPlan[i][j]  = .floor
                    continue
                }
                var counter = 0
                for k in [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)] {
                    var x = 1
                    while j + x * k.1 >= 0 && j + x * k.1 < lineLength && i + x * k.0 >= 0 && i + x * k.0 < inputLength {
                        if innerFloorplan[i + x * k.0][j + x * k.1] == .takenChair {
                            counter += 1
                            break
                        } else if innerFloorplan[i + x * k.0][j + x * k.1] == .emptyChair {
                            break
                        }
                        
                        x += 1
                    }
                    
                    x += 1
                }
                if val == .emptyChair && counter == 0 {
                    newFloorPlan[i][j] = .takenChair
                } else if val == .takenChair && counter >= 5 {
                    newFloorPlan[i][j] = .emptyChair
                }
            }
            
            if innerFloorplan == newFloorPlan {
                innerFloorplan = newFloorPlan
                break
            }
            
            innerFloorplan = newFloorPlan
        }
        
        return String(innerFloorplan.map { $0.filter { $0 == .takenChair }.count }.sum())
    }
}

extension String {
    func split(by length: Int) -> [String] {
        var startIndex = self.startIndex
        var results = [Substring]()

        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }

        return results.map { String($0) }
    }
}
