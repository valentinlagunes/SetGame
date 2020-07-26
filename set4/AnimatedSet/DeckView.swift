//
//  DeckView.swift
//  set4
//
//  Created by Isaac on 7/24/20.
//  Copyright © 2020 ValentinLagunes. All rights reserved.
//

import UIKit

class DeckView: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     */
    
    var deckIsEmpty = false {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        if deckIsEmpty
        {
            
            self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        }
        else
        {
            
            
            let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.size.height * 0.06)
            roundedRect.addClip()
            UIColor.white.setFill()
            roundedRect.fill()
            let path = UIBezierPath()
            var x : CGFloat = rect.minX
            path.lineWidth = rect.width * 0.01
            #colorLiteral(red: 0.1590411067, green: 0.2114107907, blue: 0.2406901717, alpha: 1).setStroke()
            while x < rect.maxX
            {
                var point = CGPoint(x: x, y: rect.minY)
                path.move(to: point)
                point = CGPoint(x: x, y: rect.maxY)
                path.addLine(to: point)
                x += 0.05 * rect.width
            }
            var y : CGFloat = rect.minY
            while y < rect.maxY
            {
                var point = CGPoint(x: rect.minX, y: y)
                path.move(to: point)
                point = CGPoint(x: rect.maxX, y: y)
                path.addLine(to: point)
                y += 0.05 * rect.height
            }
            path.stroke()
        }
        
    }
}
