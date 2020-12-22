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
        
        var previousRoundsDecks: Set<[[Int]]> = Set()
        
        while !localDeckOne.isEmpty && !localDeckTwo.isEmpty {
            if previousRoundsDecks.contains([localDeckOne, localDeckTwo]) {
                return (winner: .playerOne, deck: playerOneDeck)
            } else {
                previousRoundsDecks.insert([localDeckOne, localDeckTwo])
            }

            playRound(deckOne: &localDeckOne, deckTwo: &localDeckTwo)
        }
        
        return localDeckOne.isEmpty ? (winner: .playerTwo, deck: localDeckTwo) : (winner: .playerOne, deck: localDeckOne)
    }
    
    @discardableResult func playRound(deckOne: inout [Int], deckTwo: inout [Int]) -> Winner {
        let playerOneCard = deckOne.removeFirst()
        let playerTwoCard = deckTwo.removeFirst()
        
        var winner: Winner
        
        if playerOneCard <= deckOne.count && playerTwoCard <= deckTwo.count {
            winner = playGame(deckOne: [Int](deckOne[0..<playerOneCard]), deckTwo: [Int](deckTwo[0..<playerTwoCard])).winner
        } else if playerOneCard > playerTwoCard {
            winner = .playerOne
        } else {
            winner = .playerTwo
        }
        
        if winner == .playerOne {
            deckOne.append(contentsOf: [playerOneCard, playerTwoCard])
        } else {
            deckTwo.append(contentsOf: [playerTwoCard, playerOneCard])
        }
        
        return winner
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
