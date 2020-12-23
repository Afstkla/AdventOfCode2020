//
//  Day23.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 17/12/2020.
//

import Foundation

final class Day23: Day {
    override var dayIndex: Int { get { 23 } set {} }
    
    var cups: [Int] = []
    var cupsB: LinkedList<Int>
    var indexesOfCups: [Int: Node<Int>] = [:]
    
    let test = "853192647"
    let bNumberOfValues = 1_000_000
    
    override init(inputFile: String) {
        let inputNumbers = test.trimmed().split(by: 1).map { Int($0)! }
        cupsB = LinkedList<Int>(headValue: inputNumbers[0])
        indexesOfCups[inputNumbers[0] - 1] = cupsB.head
        
        for num in inputNumbers {
            cups.append(num)
        }
        
        for num in inputNumbers[1...] {
            cupsB.append(value: num)
            indexesOfCups[num - 1] = cupsB.head.previous
        }
        
        for i in cups.count..<bNumberOfValues {
            cupsB.append(value: i + 1)
            indexesOfCups[i] = cupsB.head.previous
        }
        
        super.init(inputFile: inputFile)
    }
    
    override func prepareInput() {
        
    }
    
    override func part1() -> String {
        for _ in 0..<100 {
            let takenCups = cups.removeAndReturnRange(1..<4)
            
            var insertIndex: Int!
            for i in [cups[0] - 1, cups[0] - 2, cups[0] - 3, cups[0] - 4] {
                if i <= 0 {
                    break
                }
                if !takenCups.contains(i) {
                    insertIndex = cups.firstIndex(of: i)! + 1
                    break
                }
            }
            
            if insertIndex == nil {
                insertIndex = cups.firstIndex(of: cups.max()!)! + 1
            }
            
            for i in 0..<takenCups.count {
                cups.insert(takenCups[i], at: insertIndex + i)
            }
            
            cups.shiftedLeftWithWrap()
        }
        
        while cups[0] != 1 { cups.shiftedLeftWithWrap() }
        return String(String(cups.reduce(0) { $0 * 10 + $1 }).dropFirst())
    }
    
    override func part2() -> String {
        let max = 10_000_000
        for _ in 0..<max {
            let takenCups = cupsB.remove(n: 3, after: cupsB.head)
            
            let currentCupValue = cupsB.head.value
            
            let takenCupValues = [takenCups.value, takenCups.next.value, takenCups.next.next.value]
            
            let searchValues = [
                currentCupValue - 1,
                currentCupValue - 2,
                currentCupValue - 3,
                currentCupValue - 4,
                bNumberOfValues,
                bNumberOfValues - 1,
                bNumberOfValues - 2
            ].filter { !takenCupValues.contains($0) }
            
            let searchValue = searchValues.filter { $0 < currentCupValue && $0 > 0 }.max() ?? searchValues.max()!
            
            var insertAfterNode: Node<Int> = indexesOfCups[searchValue - 1]!
            indexesOfCups[takenCupValues[0] - 1] = cupsB.insert(value: takenCupValues[0], after: insertAfterNode)
            
            insertAfterNode = takenCups
            for i in 1...2 {
                indexesOfCups[takenCupValues[i] - 1] = cupsB.insert(value: takenCupValues[i], after: indexesOfCups[takenCupValues[i - 1] - 1]!)
                insertAfterNode = insertAfterNode.next
            }
            
            cupsB.head = cupsB.head.next
        }
        
        while cupsB.head.value != 1 {
            cupsB.head = cupsB.head.next
        }
        
        return String(cupsB.head.next.value * cupsB.head.next.next.value)
    }
}

extension Array where Element == Int {
    func shiftLeftWithWrap() -> [Element] {
        let first = self[0]
        let shifted = self.dropFirst()
        return shifted + [first]
    }
    
    mutating func shiftedLeftWithWrap() {
        self = self.shiftLeftWithWrap()
    }
    
    mutating func removeAndReturnFirst(_ num: Int) -> [Int] {
        let retVal = self[0..<num]
        self.removeFirst(num)
        return [Int](retVal)
    }
    
    mutating func removeAndReturnRange(_ range: Range<Int>) -> [Int] {
        let retVal = self[range]
        self.removeSubrange(range)
        return [Int](retVal)
    }
}

/// Adapted from https://www.raywenderlich.com/947-swift-algorithm-club-swift-linked-list-data-structure
public final class LinkedList<T>: CustomStringConvertible where T: Comparable {
    fileprivate var head: Node<T>
    
    init(headValue: T) {
        let newNode = Node(value: headValue)
        nodeRefList.append(newNode)
        
        head = newNode
        head.previous = head
        head.next = head
    }
    
    var nodeRefList = [Node<T>]()
    
    public var first: Node<T>? {
        return head
    }
    
    public func append(value: T) {
        let newNode = Node(value: value, prev: head.previous, next: head)
        nodeRefList.append(newNode)
        
        head.previous.next = newNode
        head.previous = newNode
    }
    
    public func insert(value: T, after node: Node<T>) -> Node<T> {
        let newNode = Node(value: value, prev: node, next: node.next)
        nodeRefList.append(newNode)
        
        node.next.previous = newNode
        node.next = newNode
        
        return newNode
    }
    
    public func insert(n: Int, nodes: Node<T>, after node: Node<T>) {
        let previouslyNextNode = node.next!
        
        var lastNodeToAppend = nodes
        for _ in 0..<(n - 1) {
            lastNodeToAppend = lastNodeToAppend.next
        }
        
        previouslyNextNode.previous = lastNodeToAppend
        lastNodeToAppend.next = previouslyNextNode
        node.next = nodes
        nodes.previous = node
    }
    
    public func nodeWithValue(_ value: T) -> Node<T>? {
        var ref: Unmanaged<Node> = Unmanaged.passUnretained(head)
        var next = ref._withUnsafeGuaranteedRef({ $0.next })
        
        while next != head {
            if next!.value == value {
                return next
            }
            ref = Unmanaged.passUnretained(next!)
            next = ref._withUnsafeGuaranteedRef({ $0.next })
        }
        return nil
    }
    
    public func remove(n: Int, after node: Node<T>) -> Node<T> {
        let nodes = node.next!
        
        var firstNotToRemove: Node<T> = node
        for _ in 0...n {
            firstNotToRemove = firstNotToRemove.next
        }
        
        firstNotToRemove.previous = node
        node.next = firstNotToRemove
        
        return nodes
    }
    
    public var description: String {
        var desc = "\(head) --> "
        var node = head.next
        while node != head {
            desc.append("\(node!) --> ")
            node = node!.next
        }
        return desc
    }
}

public final class Node<T>: CustomStringConvertible, Equatable where T: Comparable {
    public static func == (lhs: Node<T>, rhs: Node<T>) -> Bool {
        return lhs.value == rhs.value
    }
    
    var value: T
    unowned(unsafe) var next: Node<T>!
    unowned(unsafe) var previous: Node<T>!
    
    init(value: T) {
        self.value = value
    }
    
    init(value: T, prev: Node<T>, next: Node<T>) {
        self.value = value
        self.previous = prev
        self.next = next
    }
    
    public var description: String {
        return "\(value)"
    }
}
