//
//  Day20.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 17/12/2020.
//

import Foundation

class Day20: Day {
    override var dayIndex: Int { get { 20 } set {} }
    
    let test = """
    Tile 2311:
    ..##.#..#.
    ##..#.....
    #...##..#.
    ####.#...#
    ##.##.###.
    ##...#.###
    .#.#.#..##
    ..#....#..
    ###...#.#.
    ..###..###

    Tile 1951:
    #.##...##.
    #.####...#
    .....#..##
    #...######
    .##.#....#
    .###.#####
    ###.##.##.
    .###....#.
    ..#.#..#.#
    #...##.#..

    Tile 1171:
    ####...##.
    #..##.#..#
    ##.#..#.#.
    .###.####.
    ..###.####
    .##....##.
    .#...####.
    #.##.####.
    ####..#...
    .....##...

    Tile 1427:
    ###.##.#..
    .#..#.##..
    .#.##.#..#
    #.#.#.##.#
    ....#...##
    ...##..##.
    ...#.#####
    .#.####.#.
    ..#..###.#
    ..##.#..#.

    Tile 1489:
    ##.#.#....
    ..##...#..
    .##..##...
    ..#...#...
    #####...#.
    #..#.#.#.#
    ...#.#.#..
    ##.#...##.
    ..##.##.##
    ###.##.#..

    Tile 2473:
    #....####.
    #..#.##...
    #.##..#...
    ######.#.#
    .#...#.#.#
    .#########
    .###.#..#.
    ########.#
    ##...##.#.
    ..###.#.#.

    Tile 2971:
    ..#.#....#
    #...###...
    #.#.###...
    ##.##..#..
    .#####..##
    .#..####.#
    #..#.#..#.
    ..####.###
    ..#.#.###.
    ...#.#.#.#

    Tile 2729:
    ...#.#.#.#
    ####.#....
    ..#.#.....
    ....#..#.#
    .##..##.#.
    .#.####...
    ####.#.#..
    ##.####...
    ##..#.##..
    #.##...##.

    Tile 3079:
    #.#.#####.
    .#..######
    ..#.......
    ######....
    ####.#..#.
    .#...#.##.
    #.#####.##
    ..#.###...
    ..#.......
    ..#.###...
    """
    
    var tiles: [Int: [String]] = [:]
    var tileMatches: [Int: [(id: Int, value: Int)]] = [:]
    
    func getInt(forTileString tileString: String) -> Int {
        return tileString.enumerated().reduce(0) { $0 | (($1.element == "#" ? 1 : 0) << $1.offset) }
    }
    
    func edges(forTileID tileID: Int) -> [Int] {
        var edges: [Int] = []
        
        // Top
        edges.append(getInt(forTileString: tiles[tileID]!.first!))
        edges.append(getInt(forTileString: String(tiles[tileID]!.first!.reversed())))
        
        // Bottom
        edges.append(getInt(forTileString: tiles[tileID]!.last!))
        edges.append(getInt(forTileString: String(tiles[tileID]!.last!.reversed())))
        
        // Left
        let leftSide = tiles[tileID]!.map { $0[0] }.compactMap { $0 }
        edges.append(getInt(forTileString: String(leftSide)))
        edges.append(getInt(forTileString: String(leftSide.reversed())))
        
        // Right
        let rightSide = tiles[tileID]!.map { $0[$0.count - 1] }.compactMap { $0 }
        edges.append(getInt(forTileString: String(rightSide)))
        edges.append(getInt(forTileString: String(rightSide.reversed())))
        
        return edges
    }
    
    override func prepareInput() {
        let unparsedTiles = inputString.trimmed().components(separatedBy: "\n\n")
        
        for unparsedTile in unparsedTiles {
            let lines = unparsedTile.lines()
            
            let tileNum = Int(lines[0].split(separator: " ")[1].dropLast())!
            let tileInfo = lines[1...].map { String($0) }
            
            tiles[tileNum] = tileInfo
        }
    }
    
    func getEdgeIndices(forTileID tileID: Int) -> [Int] {
        var edgeIndices: [Int] = []
        
        let matches = tileMatches[tileID]!
        
        for match in matches {
            edgeIndices.append(edges(forTileID: tileID).firstIndex(of: match.value)!)
        }
        
        return edgeIndices.sorted()
    }
    
    func printTile(id: Int) {
        print("Tile \(id):")
        print(String(tiles[id]!.flatMap { "\($0)\n" }))
    }
    
    func printTile(strArr: [String]) {
        print(String(strArr.flatMap { "\($0)\n" }))
        print()
    }
    
    enum Direction: Int {
        case top = 0
        case bottom = 1
        case left = 2
        case right = 3
    }
    
    func getTileIDTo(direction: Direction, ofTileID tileID: Int) -> Int? {
        let matches = tileMatches[tileID]!
        
        for match in matches {
            if Direction(rawValue: edges(forTileID: tileID).firstIndex(of: match.value)! / 2) == direction {
                return match.id
            }
        }
        
        return nil
    }
    
    func shouldFlip(tileID: Int, relativeToOtherFileID otherTileID: Int) -> Bool {
        let match = tileMatches[tileID]!.filter { $0.id == otherTileID }.first!
        
        return edges(forTileID: tileID).firstIndex(of: match.value)! % 2 != edges(forTileID: otherTileID).firstIndex(of: match.value)! % 2
    }
    
    override func part1() -> String {
        var localEdges: [Int: [Int]] = [:]
        
        for (tileID, _) in tiles {
            localEdges[tileID] = edges(forTileID: tileID)
        }
        
        for tile in tiles {
            tileMatches[tile.key] = []
            
            let myEdges = localEdges[tile.key]!
            
            for otherTile in tiles where tile.key != otherTile.key {
                let otherEdges = localEdges[otherTile.key]!
                
                for edge in myEdges {
                    if otherEdges.contains(edge) {
                        tileMatches[tile.key]?.append((id: otherTile.key, value: edge))
                        break
                    }
                }
            }
        }
        
        let cornerMatches = tileMatches.filter { $0.value.count == 2 }
        
        return String(cornerMatches.reduce(1) { $0 * $1.key })
    }
    
    override func part2() -> String {
        // Step 1: Choose a (random) starting corner
        var solutionGrid: [[Int]] = []
        let corners = tileMatches.filter { $0.value.count == 2 }
        let firstCorner = corners.first!
        var currTileID = firstCorner.key
        
        solutionGrid.append([])
        solutionGrid[0].append(currTileID)
        
        // Step 2: Rotate the starting corner so that we are in the top left (this means having a match for edge index (2 or 3) and (6 or 7)
        // We don't care about orientation, so we don't care about flipping
        while !(getEdgeIndices(forTileID: currTileID).contains(2) || getEdgeIndices(forTileID: currTileID).contains(3)) || !(getEdgeIndices(forTileID: currTileID).contains(6) || getEdgeIndices(forTileID: currTileID).contains(7)) {
            tiles[currTileID]?.rotateLeft()
        }

        while solutionGrid.flatMap({ $0 }).count != tiles.count {
            // Step 3: Choose the neighbouring tile on the right (index 6 or 7)
            while let nextTileID = getTileIDTo(direction: .right, ofTileID: currTileID) {
                // Step 4: Rotate / flip to make fit
                // Step 4a: Make sure rotation is correct
                while getTileIDTo(direction: .left, ofTileID: nextTileID) != currTileID {
                    tiles[nextTileID]?.rotateLeft()
                }
                
                // Step 4b: Make sure it is flipped correctly
                if shouldFlip(tileID: nextTileID, relativeToOtherFileID: currTileID) {
                    tiles[nextTileID]?.flip()
                }
                
                solutionGrid[solutionGrid.count - 1].append(nextTileID)
                
                currTileID = nextTileID
            }
            
            currTileID = solutionGrid[solutionGrid.count - 1][0]
            // Step 5: We're on a new line. Let's get the tile below the first one in the previous line in order
            if let nextTileID = getTileIDTo(direction: .bottom, ofTileID: currTileID) {
                // Step 5a: Make sure rotation is correct
                while getTileIDTo(direction: .top, ofTileID: nextTileID) != currTileID {
                    tiles[nextTileID]?.rotateLeft()
                }
                
                // Step 5b: Make sure it is flipped correctly
                if shouldFlip(tileID: nextTileID, relativeToOtherFileID: currTileID) {
                    tiles[nextTileID]?.flip(vertically: false)
                }
                
                solutionGrid.append([nextTileID])
                
                currTileID = nextTileID
            }
        }
        
        // Step 6: Print and make the grid
        var grid: [String] = []
        for i in solutionGrid {
            for j in 1..<(tiles[i[0]]!.count - 1) {
                grid.append("")
                for k in i {
                    grid[grid.count - 1] += tiles[k]![j][1..<(tiles[k]![j].count-1)]
                }
            }
        }
        
        // Step 7: Start searching for dragons
        let dragon = """
        ..................#.
        #....##....##....###
        .#..#..#..#..#..#...
        """.lines()
        
        for _ in 0..<2 {
            for _ in 0..<4 {
                var potentialDragonCounter = 0
                for (idx, line) in grid.enumerated() {
                    var firstMatch = line.startIndex
                    repeat {
                        if let range = line.range(of: dragon[1], options: .regularExpression, range: firstMatch..<line.endIndex) {
                            firstMatch = range.upperBound
                            if grid[idx - 1].range(of: ".{\(line.distance(from: line.startIndex, to: range.lowerBound))}\(dragon[0])", options: .regularExpression) != nil {
                                if grid[idx + 1].range(of: ".{\(line.distance(from: line.startIndex, to: range.lowerBound))}\(dragon[2])", options: .regularExpression) != nil {
                                    potentialDragonCounter += 1
                                } else {
                                    firstMatch = line.endIndex
                                }
                            } else {
                                firstMatch = line.endIndex
                            }
                        } else {
                            firstMatch = line.endIndex
                        }
                    } while firstMatch != line.endIndex
                }
                
                if potentialDragonCounter > 0 {
                    return String(String(grid.flatMap { $0 }).filter { $0 == "#" }.count - potentialDragonCounter * String(dragon.flatMap { $0 }).filter { $0 == "#" }.count)
                }
                grid.rotateLeft()
            }
            grid.flip()
        }
        
        return ""
    }
}

extension Array where Element == String {
    func rotatedLeft() -> [String] {
        var result = [String](repeating: "", count: self[0].count)
        
        for line in self {
            for (i, char) in line.enumerated() {
                result[line.count - 1 - i].append(char)
            }
        }
        
        return result
    }
    
    func flipped(vertically: Bool = true) -> [String] {
        if vertically {
            return self.reversed()
        } else {
            return self.map { String($0.reversed()) }
        }
    }
    
    mutating func rotateLeft() {
        self = self.rotatedLeft()
    }
    
    mutating func flip(vertically: Bool = true) {
        self = self.flipped(vertically: vertically)
    }
}
