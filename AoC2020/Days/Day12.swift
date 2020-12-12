//
//  Day12.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 12/12/2020.
//

import Foundation

class Day12: Day {
    override var dayIndex: Int { get { 12 } set {}}
    
    let test = """
    F10
    N3
    F7
    R90
    F11
    """
    
    var instructions = [String]()
    
    override func prepareInput() {
        instructions = inputString.components(separatedBy: .newlines)
    }
    
    enum Heading: String {
        case north = "N"
        case east = "E"
        case south = "S"
        case west = "W"
        
        func turnLeft(degrees: Int) -> Heading {
            let leftHeading: Heading
            
            switch self {
            case .north: leftHeading = .west
            case .east: leftHeading = .north
            case .south: leftHeading = .east
            case .west: leftHeading = .south
            }
            
            if degrees == 90 {
                return leftHeading
            } else {
                return leftHeading.turnLeft(degrees: degrees - 90)
            }
        }
    }
    
    func move(from coordinate: (east: Int, north: Int), in heading: Heading, with value: Int) -> (east: Int, north: Int) {
        var newCoordinate = coordinate
        
        switch heading {
        case .north: newCoordinate.north += value
        case .east: newCoordinate.east += value
        case .south: newCoordinate.north -= value
        case .west: newCoordinate.east -= value
        }
        
        return newCoordinate
    }
    
    func move(from coordinate: (east: Int, north: Int), towards otherCoordinate: (east: Int, north: Int), times: Int) -> (east: Int, north: Int) {
        return (east: coordinate.east + otherCoordinate.east * times, north: coordinate.north + otherCoordinate.north * times)
    }
    
    override func part1() -> String {
        var heading = Heading.east
        var coordinate = (east: 0, north: 0)
        
        for instructionLine in instructions {
            if instructionLine == "" {
                continue
            }
            
            let instructionType = String(instructionLine[0])
            let instructionValue = Int(instructionLine.dropFirst())!
            
            if let direction = Heading(rawValue: instructionType) {
                // Received N, E, S, W
                coordinate = move(from: coordinate, in: direction, with: instructionValue)
            } else if instructionType == "R" {
                heading = heading.turnLeft(degrees: 360 - instructionValue)
            } else if instructionType == "L" {
                heading = heading.turnLeft(degrees: instructionValue)
            } else if instructionType == "F" {
                coordinate = move(from: coordinate, in: heading, with: instructionValue)
            } else {
                fatalError("Received unknown command: \(instructionLine)")
            }
        }
        
        return String(abs(coordinate.east) + abs(coordinate.north))
    }
    
    func rotateLeft(coordinate: (east: Int, north: Int), withDegrees degrees: Int) -> (east: Int, north: Int) {
        let leftRotation = (east: -coordinate.north, north: coordinate.east)
        
        if degrees == 90 {
            return leftRotation
        } else {
            return rotateLeft(coordinate: leftRotation, withDegrees: degrees - 90)
        }
    }
    
    override func part2() -> String {
        var coordinate = (east: 0, north: 0)
        var waypointCoordinate = (east: 10, north: 1)
        
        for instructionLine in instructions {
            if instructionLine == "" {
                continue
            }
            
            let instructionType = String(instructionLine[0])
            let instructionValue = Int(instructionLine.dropFirst())!
            
            if let direction = Heading(rawValue: instructionType) {
                // Received N, E, S, W
                waypointCoordinate = move(from: waypointCoordinate, in: direction, with: instructionValue)
            } else if instructionType == "R" {
                waypointCoordinate = rotateLeft(coordinate: waypointCoordinate, withDegrees: 360 - instructionValue)
            } else if instructionType == "L" {
                waypointCoordinate = rotateLeft(coordinate: waypointCoordinate, withDegrees: instructionValue)
            } else if instructionType == "F" {
                coordinate = move(from: coordinate, towards: waypointCoordinate, times: instructionValue)
            } else {
                fatalError("Received unknown command: \(instructionLine)")
            }
        }
        
        return String(abs(coordinate.east) + abs(coordinate.north))
    }
}
