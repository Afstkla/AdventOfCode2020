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
    var cupsB = LinkedList<Int>()
    
    let test = "389125467"
    let bNumberOfValues = 1_000_000
    
    override func prepareInput() {
        test.trimmed().split(by: 1).map { Int($0)! }.forEach {
            cups.append($0)
            cupsB.append(value: $0)
        }
        
        for i in cups.count..<bNumberOfValues {
            cupsB.append(value: i + 1)
        }
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
        var percent = 0
        let max = 1000
        for move in 0..<max {
            if move / (max / 100) != percent {
                percent = move / (max / 100)
                print("\(percent)%")
            }
            
            let takenCups = cupsB.remove(n: 3, after: cupsB.head!)
            
            let currentCupValue = cupsB.head!.value
            
            let takenCupValues = [takenCups.value, takenCups.next!.value, takenCups.next!.next!.value]
            
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
            
            let insertAfterNode: Node<Int>! = cupsB.nodeWithValue(searchValue)
            
            cupsB.insert(n: 3, nodes: takenCups, after: insertAfterNode)
            
            cupsB.head = cupsB.head!.next
        }
        
        while cupsB.head!.value != 1 {
            cupsB.head = cupsB.head!.next
        }
        
        return String(cupsB.head!.next!.value * cupsB.head!.next!.next!.value)
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
    fileprivate var head: Node<T>?
    
    var nodeRefList = [Node<T>]()
    
    public var isEmpty: Bool {
        return head == nil
    }
    
    public var first: Node<T>? {
        return head
    }
    
    public func append(value: T) {
        let newNode = Node(value: value)
        if let headNode = head {
            newNode.previous = headNode.previous
            newNode.next = headNode
            
            headNode.previous!.next = newNode
            headNode.previous = newNode
        } else {
            head = newNode
            
            head!.previous = head
            head!.next = head
        }
        nodeRefList.append(newNode)
    }
    
    public func insert(value: T, after node: Node<T>) {
        let newNode = Node(value: value)
        
        node.next!.previous = newNode
        newNode.next = node.next
        newNode.previous = node
        node.next = newNode
        nodeRefList.append(newNode)
    }
    
    public func insert(n: Int, nodes: Node<T>, after node: Node<T>) {
        let previouslyNextNode = node.next
        
        var lastNodeToAppend = nodes
        for _ in 0..<(n - 1) {
            lastNodeToAppend = lastNodeToAppend.next!
        }
        
        previouslyNextNode!.previous = lastNodeToAppend
        lastNodeToAppend.next = previouslyNextNode
        node.next = nodes
        nodes.previous = node
    }
    
    public func nodeWithValue(_ value: T) -> Node<T>? {
        var ref: Unmanaged<Node> = Unmanaged.passUnretained(head!.next!)
        
        while let next = ref._withUnsafeGuaranteedRef({ $0.next }) {
            if next.value == value {
                return next
            }
            ref = Unmanaged.passUnretained(next)
        }
        return nil
    }
    
    public func removeAll() {
        head = nil
    }
    
    public func remove(node: Node<T>) -> T {
        let prev = node.previous
        let next = node.next
        
        if let prev = prev {
            prev.next = next
        } else {
            head = next
        }
        next!.previous = prev
        
        node.previous = nil
        node.next = nil
        
        return node.value
    }
    
    public func remove(n: Int, after node: Node<T>) -> Node<T> {
        let nodes = node.next
        
        var firstNotToRemove: Node<T> = node
        for _ in 0...n {
            firstNotToRemove = firstNotToRemove.next!
        }
        
        firstNotToRemove.previous = node
        node.next = firstNotToRemove
        
        return nodes!
    }
    
    public var description: String {
        if head == nil {
            return "empty"
        }
        var desc = "\(head!) --> "
        var node = head!.next
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
    
    public var description: String {
        return "\(value)"
    }
}
