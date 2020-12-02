//
//  main.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 01/12/2020.
//

import Foundation

let day1SolveStart = Date()
//let day1 = Day1(inputFile: "input_day1")
//day1.solve()
let day2 = Day2(inputFile: "input_day2")
day2.solve()
print("Solve time: \(Date().timeIntervalSince(day1SolveStart) * 1000)ms")
