//
//  Day22.swift
//  AoC2020
//
//  Created by Job Nijenhuis on 17/12/2020.
//

import Foundation

class Day22: Day {
    override var dayIndex: Int { get { 22 } set {} }
    
    var playerOneDeck: [Int] = []
    var playerTwoDeck: [Int] = []
    
    override func prepareInput() {
        let decks = inputString.trimmed().components(separatedBy: "\n\n")
        
        playerOneDeck = decks[0].lines()[1...].map { Int($0)! }
        playerTwoDeck = decks[1].lines()[1...].map { Int($0)! }
    }
    
    enum Winner {
        case playerOne
        case playerTwo
    }
    
    func playGame(deckOne: [Int], deckTwo: [Int]) -> (winner: Winner, deck: [Int]) {
        var localDeckOne = deckOne
        var localDeckTwo = deckTwo
        
        var previousRoundsDecks: Set<[Int]> = Set()
        
        while !localDeckOne.isEmpty && !localDeckTwo.isEmpty {
            if previousRoundsDecks.contains(localDeckOne + [-1] + localDeckTwo) {
                return (winner: .playerOne, deck: playerOneDeck)
            } else {
                previousRoundsDecks.insert(localDeckOne + [-1] + localDeckTwo)
            }

            if roundWinner(deckOne: localDeckOne, deckTwo: localDeckTwo) == .playerOne {
                localDeckOne.append(contentsOf: [localDeckOne[0], localDeckTwo[0]])
            } else {
                localDeckTwo.append(contentsOf: [localDeckTwo[0], localDeckOne[0]])
            }
            
            localDeckOne.removeFirst()
            localDeckTwo.removeFirst()
        }
        
        return localDeckOne.isEmpty ? (winner: .playerTwo, deck: localDeckTwo) : (winner: .playerOne, deck: localDeckOne)
    }
    
    func roundWinner(deckOne: [Int], deckTwo: [Int]) -> Winner {
        var localDeckOne = deckOne
        var localDeckTwo = deckTwo
        
        let playerOneCard = localDeckOne.removeFirst()
        let playerTwoCard = localDeckTwo.removeFirst()
        
        if playerOneCard <= localDeckOne.count && playerTwoCard <= localDeckTwo.count {
            return playGame(deckOne: [Int](localDeckOne[0..<playerOneCard]), deckTwo: [Int](localDeckTwo[0..<playerTwoCard])).winner
        }
        
        if playerOneCard > playerTwoCard {
            return .playerOne
        } else {
            return .playerTwo
        }
    }
    
    override func part1() -> String {
        var localPlayerOneDeck = playerOneDeck
        var localPlayerTwoDeck = playerTwoDeck
        
        while !localPlayerOneDeck.isEmpty && !localPlayerTwoDeck.isEmpty {
            let playerOneCard = localPlayerOneDeck.removeFirst()
            let playerTwoCard = localPlayerTwoDeck.removeFirst()
            
            if playerOneCard > playerTwoCard {
                localPlayerOneDeck.append(contentsOf: [playerOneCard, playerTwoCard])
            } else {
                localPlayerTwoDeck.append(contentsOf: [playerTwoCard, playerOneCard])
            }
        }
        
        let deckToReturn = localPlayerOneDeck.isEmpty ? localPlayerTwoDeck : localPlayerOneDeck
        
        return String(deckToReturn.reversed().enumerated().reduce(0) { $0 + $1.element * ($1.offset + 1) })
    }
    
    override func part2() -> String {
        let winner = playGame(deckOne: playerOneDeck, deckTwo: playerTwoDeck)
                        
        return String(winner.deck.reversed().enumerated().reduce(0) { $0 + $1.element * ($1.offset + 1) })
    }
}
