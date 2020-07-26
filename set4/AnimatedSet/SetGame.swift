//
//  SetGame.swift
//  set4
//
//  Created by Isaac on 7/16/20.
//  Copyright © 2020 ValentinLagunes. All rights reserved.
//

import Foundation

class SetGame {

    
    var number = [1, 2, 3]
    var shape = ["diamond", "oval", "squiggle"]
    //var shape = ["diamond", "diamond", "diamond"]
    var shaded = ["none", "half", "full"]
    //var shaded = ["full", "full", "full"]
    var color = ["green", "purple", "red"]
    //var color = ["green", "green", "green"]
    var deck = [Card]()
    var displayedCards = [Card]()
    var selectedCards = [Card]()
    
    
    func checkMatch() -> Bool
    {
        var matchingColor = false
        var matchingNumber = false
        var matchingShade = false
        var matchingShape = false
        if selectedCards[0].color == selectedCards[1].color && selectedCards[1].color == selectedCards[2].color
        {
            matchingColor = true
        }
        else if selectedCards[0].color != selectedCards[1].color && selectedCards[1].color != selectedCards[2].color && selectedCards[0].color != selectedCards[2].color
        {
            matchingColor = true
        }
        if selectedCards[0].number == selectedCards[1].number && selectedCards[1].number == selectedCards[2].number
        {
            matchingNumber = true
        }
        else if selectedCards[0].number != selectedCards[1].number && selectedCards[1].number != selectedCards[2].number && selectedCards[0].number != selectedCards[2].number
        {
            matchingNumber = true
        }
        if selectedCards[0].shading == selectedCards[1].shading && selectedCards[1].shading == selectedCards[2].shading
        {
            matchingShade = true
        }
        else if selectedCards[0].shading != selectedCards[1].shading && selectedCards[1].shading != selectedCards[2].shading && selectedCards[0].shading != selectedCards[2].shading
        {
            matchingShade = true
        }
        if selectedCards[0].shape == selectedCards[1].shape && selectedCards[1].shape == selectedCards[2].shape
        {
            matchingShape =  true
        }
        else if selectedCards[0].shape != selectedCards[1].shape && selectedCards[1].shape != selectedCards[2].shape && selectedCards[0].shape != selectedCards[2].shape
        {
            matchingShape = true
        }
        if matchingColor && matchingShape && matchingShade && matchingNumber
        {
            return true
        }
        return false
    }
    
    func makeNewDeck() {
        deck.removeAll()
        for num in number {
            for sh in shape {
                for shd in shaded {
                    for col in color {
                        let newCard = Card(num: num, sh: sh, col: col, shade: shd)
                        deck.append(newCard)
                        }
                    }
                }
            }
        deck.shuffle()
    }
    
    
    //make a deck of all 81 possible cards
    init() {
        makeNewDeck()
    }
   
    
}
