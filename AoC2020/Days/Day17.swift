//
//  Day17.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 17/12/2020.
//

import Foundation

class Day17: Day {
    override var dayIndex: Int { get { 17 } set {} }
    
    struct XYZ: Equatable, Hashable {
        var x: Int
        var y: Int
        var z: Int
        
        static func ==(lhs: XYZ, rhs: XYZ) -> Bool {
            return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
        }
    }
    
    struct XYZW: Equatable, Hashable {
        var x: Int
        var y: Int
        var z: Int
        var w: Int
        
        static func ==(lhs: XYZW, rhs: XYZW) -> Bool {
            return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z && lhs.w == rhs.w
        }
    }
    
    let test = """
    .#.
    ..#
    ###
    """
    
    var grid = Set<XYZ>()
    var xyzwgrid = Set<XYZW>()
    
    override func prepareInput() {
        for (x, line) in inputString.components(separatedBy: .newlines).enumerated() {
            for (y, char) in line.enumerated() {
                if char == "#" {
                    grid.insert(XYZ(x: x, y: y, z: 0))
                    xyzwgrid.insert(XYZW(x: x, y: y, z: 0, w: 0))
                }
            }
        }
    }
    
    override func part1() -> String {
        for _ in 0..<6 {
            var localGrid = Set<XYZ>()
            var checkedCoordinates = [XYZ]()
            
            for coord in grid {
                for xx in -1...1 {
                    for yy in -1...1 {
                        for zz in -1...1 {
                            if checkedCoordinates.contains(where: { XYZ(x: coord.x + xx, y: coord.y + yy, z: coord.z + zz) == $0 }) {
                                continue
                            }
                            checkedCoordinates.append(XYZ(x: coord.x + xx, y: coord.y + yy, z: coord.z + zz))
                            
                            var counter = 0
                            
                            for x in -1...1 {
                                for y in -1...1 {
                                    for z in -1...1 {
                                        if x == 0 && y == 0 && z == 0 {
                                            continue
                                        }
                                        
                                        if grid.contains(where: { XYZ(x: coord.x + x + xx, y: coord.y + y + yy, z: coord.z + z + zz) == $0 }) {
                                            counter += 1
                                        }
                                    }
                                }
                            }
                            
                            if grid.contains(where: { $0 == XYZ(x: coord.x + xx, y: coord.y + yy, z: coord.z + zz) }) {
                                if counter == 2 || counter == 3 {
                                    localGrid.insert(XYZ(x: coord.x + xx, y: coord.y + yy, z: coord.z + zz))
                                }
                            } else if counter == 3 {
                                localGrid.insert(XYZ(x: coord.x + xx, y: coord.y + yy, z: coord.z + zz))
                            }
                        }
                    }
                }
            }
            
            grid = localGrid
        }
        
        return String(grid.count)
    }
    
    override func part2() -> String {
        for _ in 0..<6 {
            var localGrid = Set<XYZW>()
            var checkedCoordinates = [XYZW]()
            
            for coord in xyzwgrid {
                for xx in -1...1 {
                    for yy in -1...1 {
                        for zz in -1...1 {
                            for ww in -1...1 {
                                if checkedCoordinates.contains(where: { XYZW(x: coord.x + xx, y: coord.y + yy, z: coord.z + zz, w: coord.w + ww) == $0 }) {
                                    continue
                                }
                                checkedCoordinates.append(XYZW(x: coord.x + xx, y: coord.y + yy, z: coord.z + zz, w: coord.w + ww))
                                
                                var counter = 0
                                
                                for x in -1...1 {
                                    for y in -1...1 {
                                        for z in -1...1 {
                                            for w in -1...1 {
                                                if x == 0 && y == 0 && z == 0 && w == 0 {
                                                    continue
                                                }
                                                
                                                if xyzwgrid.contains(where: { XYZW(x: coord.x + x + xx, y: coord.y + y + yy, z: coord.z + z + zz, w: coord.w + w + ww) == $0 }) {
                                                    counter += 1
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                if xyzwgrid.contains(where: { $0 == XYZW(x: coord.x + xx, y: coord.y + yy, z: coord.z + zz, w: coord.w + ww) }) {
                                    if counter == 2 || counter == 3 {
                                        localGrid.insert(XYZW(x: coord.x + xx, y: coord.y + yy, z: coord.z + zz, w: coord.w + ww))
                                    }
                                } else if counter == 3 {
                                    localGrid.insert(XYZW(x: coord.x + xx, y: coord.y + yy, z: coord.z + zz, w: coord.w + ww))
                                }
                            }
                        }
                    }
                }
            }
            
            xyzwgrid = localGrid
        }
    
        return String(xyzwgrid.count)
    }
}
