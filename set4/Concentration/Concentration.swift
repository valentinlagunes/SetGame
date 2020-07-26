//
//  Concentration.swift
//  set4
//
//  Created by Isaac on 7/25/20.
//  Copyright © 2020 ValentinLagunes. All rights reserved.
//

import Foundation

struct Concentration
{
    var cards = [ConcentrationCard]()
    
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
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    var score = 0
    
    mutating func chooseCard(at index: Int)
    {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                //check if cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                } else if cards[index].seenBefore {
                    score -= 1
                }
                cards[index].isFaceUp = true
                //indexOfOneAndOnlyFaceUpCard = nil
            } else {
                //either no cards or 2 cards are face up
//                for flipDownIndex in cards.indices {
//                    cards[flipDownIndex].isFaceUp = false
//                }
//                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
        cards[index].seenBefore = true
//        if cards[index].isFaceUp {
//            cards[index].isFaceUp = false
//        } else {
//            cards[index].isFaceUp = true
//        }
    }
    
    init(numberOfPairsOfCards: Int)
    {
        //print(numberOfPairsOfCards)
        //assert(numberOfPairsOfCards <= 0, "Concentration.init( \(numberOfPairsOfCards)): chosen numberOfPairsOfCards invalid")
        for _ in 1...numberOfPairsOfCards
        {
            let card = ConcentrationCard()
            cards.append(card)
            cards.append(card)
        }
        // TODO: shuffle cards
        cards.shuffle()
    }
}
