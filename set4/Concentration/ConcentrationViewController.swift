//
//  ConcentrationViewController.swift
//  set4
//
//  Created by Isaac on 7/25/20.
//  Copyright © 2020 ValentinLagunes. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {

    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    private(set) var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    var emojiChoices = "🦇😱🙀😈🎃👻🍭🍬🍎"
    var emojiChoices2 = "🦇😱🙀😈🎃👻🍭🍬🍎"
    //var emojiChoices = ["🦇😱🙀😈🎃👻🍭🍬🍎"]
    var halloween = "🦇😱🙀😈🎃👻🍭🍬🍎"
    var animals = "🐶🦜🦈🐘🐼🐉🐥🦄🦖"
    var clothes = "🦺🥋👘👙👔👗👡🩱👚"
    var flags = "🇺🇸🇲🇽🇦🇺🇩🇪🇨🇦🇯🇲🇩🇰🇵🇱🇨🇴"
    var plants = "🍄🌻🎄🌹🌵🌴🍀🍁🌸"
    var food = "🍉🍆🍑🍒🍗🥑🍟🌭🥚"
    
    let themes = [
        "Flags": "🇺🇸🇲🇽🇦🇺🇩🇪🇨🇦🇯🇲🇩🇰🇵🇱🇨🇴",
        "Animals": "🐶🦜🦈🐘🐼🐉🐥🦄🦖",
        "Food": "🍉🍆🍑🍒🍗🥑🍟🌭🥚",
        "Halloween": "🦇😱🙀😈🎃👻🍭🍬🍎",
        "Clothes": "🦺🥋👘👙👔👗👡🩱👚",
        "Plants": "🍄🌻🎄🌹🌵🌴🍀🍁🌸"
        
    ]
    
    var currentTheme : String?
    
    lazy var choices = [halloween, animals, clothes, flags, plants, food]
    
    var theme: String? {
        didSet {
            emojiChoices2 = theme ?? ""
            emoji = [:]
            updateViewFromModel()
        }
    }

    @IBAction private func touchCard(_ sender: UIButton) {
        
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
            scoreLabel.text = "Score: \(game.score)"
        } else {
            print("could not find emoji")
        }
    }

    func updateViewFromModel()
    {
        if cardButtons != nil {
            for index in cardButtons.indices
            {
                let button = cardButtons[index]
                let card = game.cards[index]
                if card.isFaceUp {
                    button.setTitle(emoji(for: card), for: UIControl.State.normal)
                    button.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                } else {
                    button.setTitle("", for: UIControl.State.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0, green: 0.4618991017, blue: 1, alpha: 1)
                }
            }
        }
    }
    
    func flipCard(withEmoji emoji: String, on button: UIButton) {
        if button.currentTitle == emoji {
            button.setTitle("", for: UIControl.State.normal)
            button.backgroundColor = #colorLiteral(red: 0, green: 0.4618991017, blue: 1, alpha: 1)
        } else {
            button.setTitle(emoji, for: UIControl.State.normal)
            button.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }
    }
    
    private var emoji = Dictionary<ConcentrationCard, String>()
    
    private func emoji(for card: ConcentrationCard) -> String {
        
        if emoji[card] == nil, emojiChoices2.count > 0 {
            if emojiChoices2.count > 0
            {
                let randomStringIndex = emojiChoices2.index(emojiChoices2.startIndex, offsetBy: emojiChoices2.count.arc4random)
                //emoji[card] = String(emojiChoices2[randomStringIndex])
                //emoji[card] = String(emojiChoices2.remove(at: emojiChoices2.count.arc4random))
                emoji[card] = String(emojiChoices2.remove(at: randomStringIndex))
            }
        }

        return emoji[card] ?? "?"
    }
    
    @IBAction func restartGame(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        flipCount = 0
        for index in cardButtons.indices
        {
            let button = cardButtons[index]
            game.cards[index].isFaceUp = false
            button.setTitle("", for: UIControl.State.normal)
            button.backgroundColor =  #colorLiteral(red: 0, green: 0.4618991017, blue: 1, alpha: 1)
            
        }
//        print(currentTheme)
        let currTheme = currentTheme ?? "Halloween"
        
        emojiChoices2 = themes[currTheme]!
        
        //choices.shuffle()
        //emojiChoices2 = choices[0]
        
        game.score = 0
        scoreLabel.text = "Score: \(game.score)"
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }
        else if self < 0
        {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }
        else
        {
            return 0
        }
    }
}
