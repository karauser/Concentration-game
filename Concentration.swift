//
//  Concentration.swift
//  Cntr game
//
//  Created by Сергей Караваев on 04.04.2021.
//  Copyright © 2022 Karauser. All rights reserved.
//
import Foundation

class Concentration
{
    private (set) var cards = [Card]()
    
    private (set) var flipCount = 0
    
    private (set) var score = 0
    
    private var seenCards: Set<Int> = []
    
    private var dateClick: Date?
    
    private var timePenalty: Int {
        return min (dateClick?.sinceNow ?? 0, Points.maxTimePenalty)
    }
    
    private struct Points {
        static let matchBonus = 2
        static let missMatchPenalty = 1
        static var maxTimePenalty = 1
    }
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set (newValue){
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func resetGame() {
        score = 0
        flipCount = 0
        seenCards = []
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
        }
        cards.shuffle()
    }
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): choosen not in the cards")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    //cards match
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += Points.matchBonus
                } else {
                    //cards didn't match
                    if seenCards.contains(index) {
                        score -= Points.missMatchPenalty
                    }
                    if seenCards.contains(matchIndex) {
                        score -= Points.missMatchPenalty
                    }
                    seenCards.insert(index)
                    seenCards.insert(matchIndex)
                }
                //                score -= timePenalty
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
            flipCount += 1
            dateClick = Date()
        }
    }
    init(numberOfPairsOfCards: Int){
        assert(numberOfPairsOfCards > 0, "Concentration.init(at: \(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
}
extension Date {
    var sinceNow: Int {
        return -Int(self.timeIntervalSinceNow)
    }
}
