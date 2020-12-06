//
//  main.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 01/12/2020.
//

import Foundation

let daySolveStart = Date()
//let day1 = Day1(inputFile: "input_day1")
//day1.solve()
let day = Day6(inputFile: "input-6")
day.solve()
print("Solve time: \(Date().timeIntervalSince(daySolveStart) * 1000)ms")
