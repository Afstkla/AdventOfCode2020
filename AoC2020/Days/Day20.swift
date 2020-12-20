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
    var tileEdges: [Int: [Int]] = [:]
    var tileMatches: [Int: [Int]] = [:]
    
    func getInt(forTileString tileString: String) -> Int {
        return tileString.enumerated().reduce(0) { $0 | (($1.element == "#" ? 1 : 0) << $1.offset) }
    }
    
    override func prepareInput() {
        let unparsedTiles = inputString.trimmed().components(separatedBy: "\n\n")
        
        for unparsedTile in unparsedTiles {
            let lines = unparsedTile.lines()
            
            let tileNum = Int(lines[0].split(separator: " ")[1].dropLast())!
            let tileInfo = lines[1...].map { String($0) }
            
            tiles[tileNum] = tileInfo
        }
        
        for tile in tiles {
            tileEdges[tile.key] = []
            
            tileEdges[tile.key]?.append(getInt(forTileString: tile.value.first!))
            tileEdges[tile.key]?.append(getInt(forTileString: tile.value.last!))
            tileEdges[tile.key]?.append(getInt(forTileString: String(tile.value.first!.reversed())))
            tileEdges[tile.key]?.append(getInt(forTileString: String(tile.value.last!.reversed())))
            
            let leftSide = tile.value.map { $0[0] }.compactMap { $0 }
            tileEdges[tile.key]?.append(getInt(forTileString: String(leftSide)))
            tileEdges[tile.key]?.append(getInt(forTileString: String(leftSide.reversed())))
            
            let rightSide = tile.value.map { $0[$0.count - 1] }.compactMap { $0 }
            tileEdges[tile.key]?.append(getInt(forTileString: String(rightSide)))
            tileEdges[tile.key]?.append(getInt(forTileString: String(rightSide.reversed())))
        }
    }
    
    override func part1() -> String {
        for tile in tiles {
            tileMatches[tile.key] = []
            
            let myEdges = tileEdges[tile.key]!
            
            for otherTile in tiles where tile.key != otherTile.key {
                let otherEdges = tileEdges[otherTile.key]!
                
                for edge in myEdges {
                    if otherEdges.contains(edge) {
                        tileMatches[tile.key]?.append(otherTile.key)
                        break
                    }
                }
            }
        }
        
        let cornerMatches = tileMatches.filter { $0.value.count == 2 }
        
        return String(cornerMatches.reduce(1) { $0 * $1.key })
    }
    
    override func part2() -> String {
        ""
    }
}
