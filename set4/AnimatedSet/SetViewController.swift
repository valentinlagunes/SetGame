//
//  ViewController.swift
//  set
//
//  Created by Isaac on 7/16/20.
//  Copyright © 2020 ValentinLagunes. All rights reserved.
//

import UIKit

class SetViewController: UIViewController, UIDynamicAnimatorDelegate {
    
    var shouldReset = true
    @IBOutlet weak var WinningScreen: UILabel! {
        didSet {
            WinningScreen.isHidden = true
        }
    }
    @IBOutlet weak var discardPile: DeckView!
    @IBOutlet weak var deckButton: DeckView!
    {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(addThreeCards))
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            deckButton.addGestureRecognizer(tap)
        }
    }
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var gameView: GameView! {
        didSet {
            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(rotateShuffle(sender:)))

            gameView.addGestureRecognizer(rotate)
            gameView.buttonFrame = deckButton.frame
        }
    }
    var finishedGame = false {
        didSet {
            
        }
    }
    
    private var dealDelayTime = 0.2
    
    var deckCardHolder: CardView?
    var score = 0 {
        didSet {
            ScoreLabel.text = "Score: \(score)"
        }
    }
    
    var foundMatch = false
    var game = SetGame()
    var numSelected = 0
    var currentlyDealing = false
    
    lazy var animator = UIDynamicAnimator(referenceView: gameView)
    lazy var cardBehavior = CardBehavior(in: animator)
    var snapBehaviorDict = [CardView:UISnapBehavior]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator.delegate = self
        //animator.addBehavior(snapBehavior)
        gameView.gameGrid = Grid(layout: .aspectRatio(5/8), frame: gameView.bounds)
        gameView.gameGrid.cellCount = 12
        discardPile!.deckIsEmpty = true
    }
    
    func addTapstoAll() {
        for subView in gameView.subviews{
            let tapButton = UITapGestureRecognizer(target: self, action: #selector(self.selectCard(sender:)))
            tapButton.numberOfTapsRequired = 1
            tapButton.numberOfTouchesRequired = 1
            //add if it doesn't already have it
            if subView.gestureRecognizers?.count ?? 0 < 1
            {
                subView.addGestureRecognizer(tapButton)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //only set up first time, not every time we switch tabs
        if shouldReset
        {
        gameView.gameGrid = Grid(layout: .aspectRatio(5/8), frame: gameView.bounds)
        gameView.gameGrid.cellCount = 12

        gameView.buttonFrame = gameView!.convert(deckButton!.frame, from: view)

        var dealDelay = 0.0
        for index in 0..<12 {
            
            let currCard = self.game.deck.remove(at: self.game.deck.count - 1)
            self.game.displayedCards.append(currCard)
            _ = self.gameView.addCardView(currCard: currCard, index: index, delay: dealDelay)
            dealDelay += dealDelayTime
        }
        addTapstoAll()

        view.sendSubviewToBack(discardPile)
        }
        shouldReset = false
    }
    
    //this is for handling screen rotation
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gameView.buttonFrame = gameView!.convert(deckButton!.frame, from: view)
        gameView.setGrid(frame: gameView.bounds, cellCount: game.displayedCards.count)
        gameView.rearrangeCards(toGridSize: game.displayedCards.count)

    }
    
    @objc func selectCard(sender: UITapGestureRecognizer){
        
        var duplicates = [Card]()
        let button = sender.view as? CardView
        let selectedCard = button!.thisCard
        
        if button?.cantClick ?? false
        {
            //print("Cant click this card")
            return
        }
        
        if game.selectedCards.count == 2 {
            if !game.selectedCards.contains(selectedCard)
            {
                //print(game.deck.count)
                game.selectedCards.append(selectedCard)
                button?.isSelected = true
                if game.checkMatch() {
                    print("Have match :)")
                    score += 5
                    foundMatch = true
                    duplicates = game.selectedCards
                    //fly away animation
                    //random movement then snap to deck
                    for subView in self.gameView.subviews
                    {
                        if let cardView = subView as? CardView
                        {
                            if duplicates.contains(cardView.thisCard)
                            {
                                //cant touch it anymore
                                cardView.cantClick = true
                                cardBehavior.addItem(cardView)
                                self.gameView.bringSubviewToFront(subView)
                                //mark for removal
                                self.gameView.cardToViewDict[cardView] = 1000

                            }
                        }
                    }
                    //fly away to discard pile after 2 seconds
                    _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                        for subView in self.gameView.subviews
                        {
                            if let cardView = subView as? CardView
                            {
                                if duplicates.contains(cardView.thisCard)
                                {
                                    self.cardBehavior.removeItem(cardView)
                                    let snapBehavior = UISnapBehavior(item: cardView, snapTo: self.gameView.convert(self.discardPile!.center, from: self.view))
                                    self.snapBehaviorDict[cardView] = snapBehavior
                                    snapBehavior.damping = 3
                                    self.animator.addBehavior(snapBehavior)
                                    
                                    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.6, delay: 0, options: [], animations: {
                                        cardView.transform = .identity
                                        cardView.frame.size = self.discardPile!.frame.size
                                        //cardView.frame =  self.gameView.convert(self.discardPile!.frame, from: self.view)

                                    })
                                }
                                
                            }
                        }
                    }
                    
                    
                    var delayTime = 0.0
                    for index in game.selectedCards.indices
                    {
                        let placement = game.displayedCards.firstIndex(of: game.selectedCards[index])
                        
                        game.displayedCards.remove(at: placement!)
                        //remove view from gameView subviews
                        
                        for subview in gameView.subviews
                        {
                            let cardView = subview as? CardView
                            if game.selectedCards[index] == cardView!.thisCard
                            {
                                //print(placement!)
                                //subview.removeFromSuperview()
                                //replace the cards
                                if game.deck.count > 0
                                {
                                    let currCard = game.deck.remove(at: game.deck.count - 1)
                                    game.displayedCards.insert(currCard, at: placement!)
                                    let x = gameView.addCardView(currCard: currCard, index: placement!, delay: delayTime)
                                    gameView.sendSubviewToBack(x)
                                    delayTime += dealDelayTime
                                }
                            }
                            
                        }
                    }
                    game.selectedCards.removeAll()
                    addTapstoAll()
                    if game.deck.count <= 0 {
                        //need to reset the dictionary
                        deckButton!.deckIsEmpty = true
                        resetDictionary()
                        gameView.rearrangeCards(toGridSize: game.displayedCards.count)
                    }
                    if game.displayedCards.count == 0
                    {
                        //finished game
                        WinningScreen.isHidden = false
                    }
                }
                else
                {
                    print("No match :/")
                    score -= 3
                    for view in gameView.subviews
                    {
                        if let cardView = view as? CardView
                        {
                            if game.selectedCards.contains(cardView.thisCard)
                            {
                                cardView.isSelected = false
                                cardView.isGoodMatch = false
                                cardView.isBadMatch = true
                            }
                        }
                        
                    }
                }
            }
            else
            {
                //deselect a card
                if game.selectedCards.count > 0
                {
                    button?.isSelected = false
                    game.selectedCards.remove(at: game.selectedCards.firstIndex(of: selectedCard)!)
                }
            }
        }
        else if game.selectedCards.count == 3 //got here after a bad match
        {
            //deselect all cards after good or bad match
            for view in gameView.subviews
            {
                if let cardView = view as? CardView
                {
                    if game.selectedCards.contains(cardView.thisCard)
                    {
                        cardView.isSelected = false
                        //cardView.isGoodMatch = false
                        cardView.isBadMatch = false
                    }
                }
                
            }
            
            game.selectedCards.removeAll()
            //select a new card after a bad match
            game.selectedCards.append(selectedCard)
            button?.isSelected = true
            foundMatch = false
        }
        else //selecting or deselecting one of first two cards
        {
            if !game.selectedCards.contains(selectedCard)
            {
                game.selectedCards.append(selectedCard)
                button?.isSelected = true
            } else
            {
                if game.selectedCards.count > 0
                {
                    button?.isSelected = false
                    game.selectedCards.remove(at: game.selectedCards.firstIndex(of: selectedCard)!)
                }
            }
        }

    }
    
    func resetDictionary() {
        for index in game.displayedCards.indices
        {
            for subviews in gameView.subviews
            {
                let cardView = subviews as? CardView
                if cardView?.thisCard == game.displayedCards[index]
                {
                    gameView.cardToViewDict[cardView!] = index
                }
            }
        }
    }
    
    @IBAction func resetGame(_ sender: UIButton) {
        WinningScreen.isHidden = true
        currentlyDealing = false
        score = 0
        game.displayedCards.removeAll()
        game.selectedCards.removeAll()
        game.makeNewDeck()
        //updateViewFromModel()
        snapBehaviorDict.removeAll()
        gameView.cardToViewDict.removeAll()
        animator.removeAllBehaviors()
        animator.addBehavior(cardBehavior)
        discardPile.deckIsEmpty = true
        deckButton.deckIsEmpty = false
        for view in gameView.subviews
        {
            view.removeFromSuperview()
        }
        gameView.gameGrid = Grid(layout: .aspectRatio(5/8), frame: gameView.bounds)
        gameView.gameGrid.cellCount = 12

        var dealDelay = 0.0
        for index in 0..<12 {
            
            let currCard = self.game.deck.remove(at: self.game.deck.count - 1)
            self.game.displayedCards.append(currCard)
            _ = self.gameView.addCardView(currCard: currCard, index: index, delay: dealDelay)
            dealDelay += dealDelayTime
        }
        addTapstoAll()
        
    }
    
    
    @objc func callThree()
    {
        addThreeCards()
    }
    
    @IBAction func addThreeCards() {
        if currentlyDealing
        {
            return
        }

        if game.deck.count > 0 //add 3 new cards if haven't selected 3 cards
        {
            //need to possibly deselect a bad match
            if game.selectedCards.count == 3
            {
                if !game.checkMatch()
                {
                    for view in gameView.subviews
                    {
                        if let cardView = view as? CardView
                        {
                            if game.selectedCards.contains(cardView.thisCard)
                            {
                                cardView.isSelected = false
                                //cardView.isGoodMatch = false
                                cardView.isBadMatch = false
                            }
                        }
                        
                    }
                    game.selectedCards.removeAll()
                    
                }
            }
            
            var iter = game.displayedCards.count
            //up to three cards
            iter += 3
            gameView.gameGrid = Grid(layout: .aspectRatio(5/8), frame: gameView.bounds)
            gameView.gameGrid.cellCount = iter
            var timeDelay = 0.0
     //       gameView.rearrangeCards(toGridSize: iter)
            //wait for rearrange cards to finish
//            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
//                for index in self.game.displayedCards.count..<iter
//            {
//                let currCard = self.game.deck.remove(at: self.game.deck.count - 1)
//                self.game.displayedCards.append(currCard)
//                //let cardView = addCard(currCard: currCard, index: index)
//                _ = self.gameView.addCardView(currCard: currCard, index: index, delay: timeDelay)
//                timeDelay += 0.25
//                self.addTapstoAll()
//            }
//            }
//
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0.0, options: [], animations: {
                self.gameView.rearrangeCards(toGridSize: iter)
                self.currentlyDealing = true
            }, completion: { finished in
                    for index in self.game.displayedCards.count..<iter
                {
                    if self.game.deck.count > 0
                    {
                    let currCard = self.game.deck.remove(at: self.game.deck.count - 1)
                    self.game.displayedCards.append(currCard)
                    //let cardView = addCard(currCard: currCard, index: index)
                    _ = self.gameView.addCardView(currCard: currCard, index: index, delay: timeDelay)
                        timeDelay += self.dealDelayTime
                        
                    self.addTapstoAll()
                    }
                    if self.game.deck.count <= 1
                    {
                        self.deckButton!.deckIsEmpty = true
                        //discardPile!.deckIsEmpty = false
                    }
                }
                self.currentlyDealing = false
            })
            //gameView.rearrangeCards()

            addTapstoAll()
        }

    }
    
    @objc func rotateShuffle(sender: UIRotationGestureRecognizer) {
      //  if sender.state == .ended
       // {
            game.displayedCards.shuffle()
            resetDictionary()
            gameView.rearrangeCards(toGridSize: game.displayedCards.count)
        //}

    }
    
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {

        for subView in gameView.subviews
        {
            let cardView = subView as? CardView
            //check if the card has been marked for removal
            if gameView.cardToViewDict[cardView!] == 1000
            {
                //flip the card over
                UIView.transition(with: cardView!,
                                  duration: 0.6,
                                  options: [.transitionFlipFromLeft],
                                  animations: {cardView!.isFaceUp = false},
                                  completion: { finished in
                //on completion, we should delete this card
                                    self.gameView.cardToViewDict.removeValue(forKey: cardView!)
                                    subView.removeFromSuperview()
                                    self.discardPile!.deckIsEmpty = false
                                    self.animator.removeBehavior(self.snapBehaviorDict[cardView!]!)
                }
                )
            }
        }

    }
}
