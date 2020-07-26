//
//  CardView.swift
//  set4
//
//  Created by Isaac on 7/16/20.
//  Copyright © 2020 ValentinLagunes. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {
    override var description: String {
        return "\(thisCard.color)\(thisCard.number)\(thisCard.shape)\(thisCard.shading)"
    }
    
    var cantClick = false
    var isSelected = false {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    var isBadMatch = false
    var isGoodMatch = false {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    var isFaceUp = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       // initialSetup()
        self.backgroundColor = #colorLiteral(red: 0.8702258468, green: 0.882743299, blue: 0.8660495281, alpha: 1)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }

    override var frame: CGRect {
        didSet { setNeedsDisplay() }
    }
    
    var thisCard = Card(num: 3, sh: "diamond", col: "green", shade: "half") {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsLayout()
        setNeedsDisplay()
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect)
    {
        if !isFaceUp //draw back of card
        {
            let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
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
        else
        {
        // Drawing code
        let context = UIGraphicsGetCurrentContext()
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        if isSelected {
            UIColor.black.setStroke()
            roundedRect.lineWidth = rect.height * 0.05
            roundedRect.stroke()
        } else if isGoodMatch {
            UIColor.yellow.setStroke()
            roundedRect.lineWidth = rect.height * 0.05
            roundedRect.stroke()
        } else if isBadMatch {
            UIColor.red.setStroke()
            roundedRect.lineWidth = rect.height * 0.05
            roundedRect.stroke()
        }
        let numShapes = thisCard.number
        
        
        let sizeOfEachRect = CGSize(width: bounds.height/3, height: bounds.height/3.2)
        
        let x = bounds.midX - sizeOfEachRect.width / 2
        let y = bounds.midY - sizeOfEachRect.height / 2
        
        let origin = CGPoint(x: x,y: y)
        
        let rect = CGRect(origin: origin, size: sizeOfEachRect)
        //UIColor.black.setStroke()
        var thisColor : UIColor
        if thisCard.color == "green"
        {
            thisColor = #colorLiteral(red: 0.0004062078516, green: 0.298048899, blue: 0.002715641896, alpha: 1)
            //UIColor.green.setFill()
        } else if thisCard.color == "purple" {
            thisColor = UIColor.purple
            
        } else {
            thisColor = UIColor.red
        }
        thisColor.setStroke()
        thisColor.setFill()
        if numShapes == 1 {
            let path = drawSomething(card: thisCard, rect: rect)

            path.stroke()
            if thisCard.shading == "half" {
                thisColor.setStroke()
                path.addClip()
                drawStripes(rect: rect, path: path)
                path.stroke()
            } else if thisCard.shading == "full" {
                path.fill()
            }
        } else if numShapes == 2 {
            let rect1 = rect.offsetBy(dx: 0, dy: sizeOfEachRect.height/1.9)
            let rect2 = rect.offsetBy(dx: 0, dy: -(sizeOfEachRect.height/1.9))

            let path = drawSomething(card: thisCard, rect: rect1)
            let path2 = drawSomething(card: thisCard, rect: rect2)
            

            
            path.stroke()
            //path.fill()
            path2.stroke()
            //path2.fill()
            if thisCard.shading == "half" {
                thisColor.setStroke()
                context?.saveGState()
                path.addClip()
                drawStripes(rect: rect1, path: path)
                path.stroke()
                context?.restoreGState()
                path2.addClip()
                drawStripes(rect: rect2, path: path2)
                path2.stroke()
                
            } else if thisCard.shading == "full" {
                path.fill()
                path2.fill()
            }
            
        } else if numShapes == 3 {
            let rect1 = CGRect(x: rect.minX,
                           y: rect.minY - sizeOfEachRect.height - 3,
                           width: sizeOfEachRect.width,
                           height: sizeOfEachRect.height)
            
            let rect2 = CGRect(x: rect.minX,
                           y: rect.maxY + 3,
                           width: sizeOfEachRect.width,
                           height: sizeOfEachRect.height)
            let path = drawSomething(card: thisCard, rect: rect1)

            path.stroke()
            
            let path2 = drawSomething(card: thisCard, rect: rect2)

            path2.stroke()

            let path3 = drawSomething(card: thisCard, rect: rect)

            path3.stroke()
            
            if thisCard.shading == "half" {
                thisColor.setStroke()
                context?.saveGState()
                path.addClip()
                drawStripes(rect: rect1, path: path)
                path.stroke()
                context?.restoreGState()
                context?.saveGState()
                path2.addClip()
                drawStripes(rect: rect2, path: path2)
                path2.stroke()
                context?.restoreGState()
                path3.addClip()
                drawStripes(rect: rect, path: path3)
                path3.stroke()
                
            } else if thisCard.shading == "full" {
                path.fill()
                path2.fill()
                path3.fill()
            }
        }
        }
    }
    
    func drawSomething(card: Card, rect: CGRect) -> UIBezierPath {
        if card.shape == "diamond" {
            return drawDiamond(rect: rect)
        } else if card.shape == "oval" {
            return drawOval(rect: rect)
        } else {
            return drawSquiggle(rect: rect)
        }
    }
    
    func drawOval(rect: CGRect) -> UIBezierPath
    {
        let path = UIBezierPath()
        
        var point = CGPoint(x: rect.midX - rect.width / 4, y: rect.midY)
        
        path.addArc(withCenter: point, radius: rect.width / 4, startAngle: CGFloat.pi / 2, endAngle: -CGFloat.pi / 2, clockwise: true)
        point = CGPoint(x: rect.midX - rect.width / 4, y: rect.midY - rect.width / 4)
        point = CGPoint(x: rect.midX + rect.width / 4, y: rect.midY - rect.width / 4)
        path.addLine(to: point)
        point = CGPoint(x: rect.midX + rect.width / 4, y: rect.midY)
        path.addArc(withCenter: point, radius: rect.width / 4, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi / 2, clockwise: true)
        point = CGPoint(x: rect.midX - rect.width / 4, y: rect.midY + rect.width / 4)
        path.addLine(to: point)
        
        return path
    }
    
    
    func drawSquiggle(rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        var point  = CGPoint(x: rect.midX - rect.width / 2, y: rect.midY - rect.height / 4)
        path.move(to: point)
        point = CGPoint(x: rect.midX + rect.width / 2, y: rect.midY - rect.height / 4)
        var point1 = CGPoint(x: rect.midX , y: rect.midY - rect.height / 2)
        var point2 = CGPoint(x: rect.midX , y: rect.midY + rect.height / 4)
        path.addCurve(to: point, controlPoint1: point1, controlPoint2: point2)
        path.move(to: point)
        point = CGPoint(x: rect.midX + rect.width / 2, y: rect.midY + rect.height / 4)
        path.addLine(to: point)
        point = CGPoint(x: rect.midX - rect.width / 2, y: rect.midY + rect.height / 4)
        point1 = CGPoint(x: rect.midX , y: rect.midY - rect.height / 6)
        point2 = CGPoint(x: rect.midX , y: rect.midY + rect.height / 4)
        path.addCurve(to: point, controlPoint1: point2, controlPoint2: point1)
        point  = CGPoint(x: rect.midX - rect.width / 2, y: rect.midY - rect.height / 4)
        path.addLine(to: point)
        return path
    }
    
    func drawDiamond(rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        var point  = CGPoint(x: rect.midX - rect.width / 2, y: rect.midY)
        path.move(to: point)
        point = CGPoint(x: rect.midX, y: rect.midY - rect.height / 4)
        path.addLine(to: point)
        point = CGPoint(x: rect.midX + rect.width / 2, y: rect.midY )
        path.addLine(to: point)
        point =  CGPoint(x: rect.midX, y: rect.midY + rect.height / 4)
        path.addLine(to: point)
        point = CGPoint(x: rect.midX - rect.width / 2, y: rect.midY )
        path.addLine(to: point)
        return path
    }
    
    func drawStripes(rect: CGRect, path: UIBezierPath)
    {
        var x : CGFloat = rect.minX
        path.lineWidth = rect.width * 0.01
        while x < rect.maxX
        {
            var point = CGPoint(x: x, y: rect.minY)
            path.move(to: point)
            point = CGPoint(x: x, y: rect.maxY)
            path.addLine(to: point)
            x += 0.05 * rect.width
        }
    }

}

extension CardView {
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.80
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    
}

extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width/2, height: height)
    }
    func inset(by size: CGSize) ->CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth), dy: (height - newHeight) / 2)
    }
    
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}


