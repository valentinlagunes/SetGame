//
//  GameView.swift
//  set4
//
//  Created by Isaac on 7/16/20.
//  Copyright © 2020 ValentinLagunes. All rights reserved.
//

import UIKit

class GameView: UIView {
    
    //var doneAdding = false
    //lazy var animator = UIDynamicAnimator(referenceView: self)
    var buttonFrame = CGRect(x: 1, y: 1, width: 1, height: 1)
    private var dealCardTime = 0.4
    //    override var frame: CGRect {
    //        didSet { setNeedsDisplay() }
    //    }
    //dictionary to know where each card should be in grid
    var cardToViewDict = [CardView:Int]()
    
    //var gameGrid = Grid(layout: .aspectRatio(5/8))
    lazy var gameGrid = Grid(layout: .aspectRatio(5/8), frame: bounds)
    
    //    init(frame: CGRect, buttonFrame cardStart: CGRect) {
    //        self.buttonFrame = cardStart
    //        super.init(frame: frame)
    //        //gameGrid = Grid(layout: .aspectRatio(5/8), frame: bounds)
    //        //gameGrid.cellCount = 12
    //        //self.autoresizesSubviews = true
    //    }
    //
    //    required init?(coder: NSCoder) {
    //        super.init(coder: coder)
    //        //atalError("init(coder:) has not been implemented")
    //    }
    
    func setGrid(frame bnd: CGRect, cellCount: Int) {
        gameGrid = Grid(layout: .aspectRatio(5/8), frame: bnd)
        gameGrid.cellCount = cellCount
    }
    
    func rearrangeCards(toGridSize: Int)
    {
        gameGrid.cellCount = toGridSize

        for index in subviews.indices {
            let cardView = subviews[index] as? CardView
            let placement = cardToViewDict[cardView!]!
            //card marked for removal
            if placement == 1000
            {
                //subviews[index].removeFromSuperview()
                continue
            }
            //print(cardView!)
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                //print(placement)
                let cView = CardView(frame: (self.gameGrid[placement]?.insetBy(dx: self.gameGrid[placement]!.width * 0.01, dy: self.gameGrid[placement]!.height * 0.005))!)
                self.subviews[index].frame = cView.frame
                self.subviews[index].bounds = cView.bounds
                self.subviews[index].center = cView.center
                self.subviews[index].transform = cView.transform
                //cardView.setNeedsDisplay()
                
            }
            )
        }
    }
    
    func addCardView(currCard: Card, index: Int, delay: Double) -> CardView {
        
        let cardView = CardView(frame: buttonFrame)
        
        cardView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        cardView.thisCard = currCard
        addSubview(cardView)
        //print(subviews.count)
        //sendSubviewToBack(cardView)
        cardView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        cardView.thisCard = currCard
        
       // _ = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: dealCardTime, delay: delay, options: [.curveEaseInOut], animations: {
                //print(self.gameGrid.cellCount)
                let cView = CardView(frame: (self.gameGrid[index]?.insetBy(dx: self.gameGrid[index]!.width * 0.01, dy: self.gameGrid[index]!.height * 0.005))!)
                cardView.frame = cView.frame
                cardView.bounds = cView.bounds
                cardView.center = cView.center
                cardView.transform = cView.transform
                //cardView.setNeedsDisplay()
                
            }, completion: {finished in
                UIView.transition(with: cardView,
                              duration: 0.6,
                              options: [.transitionFlipFromLeft],
                              animations: {cardView.isFaceUp = true})
            }
            )
            
       // }
        cardToViewDict[cardView] = index
        return cardView
    }
        
}
