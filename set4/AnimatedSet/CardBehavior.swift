//
//  CardBehavior.swift
//  set4
//
//  Created by Isaac on 7/22/20.
//  Copyright © 2020 ValentinLagunes. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {
    
    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    
    lazy var itemBehavior : UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = true
        behavior.elasticity = 1.0
        behavior.resistance = 0
        //behavior.allowsRotation = true
        return behavior
    }()
    
    
    lazy var snapBehavior: UISnapBehavior = {
        let behavior = UISnapBehavior()
        behavior.damping = 1
        behavior.snapPoint = CGPoint(x: 0, y: 0)
        return behavior
    }()
    
    private func push(_ item: UIDynamicItem)
    {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        //let push = UIPushBehavior(items: [item], mode: .instantaneous)
        
        // Push item towards the center
        if let referenceBounds = dynamicAnimator?.referenceView?.bounds {
            let center = CGPoint(x: referenceBounds.midX, y: referenceBounds.midY)
            switch (item.center.x, item.center.y) {
            case let (x, y) where x < center.x && y < center.y:
                push.angle = (CGFloat.pi/2).arc4random
            case let (x, y) where x > center.x && y < center.y:
                push.angle = CGFloat.pi-(CGFloat.pi/2).arc4random
            case let (x, y) where x < center.x && y > center.y:
                push.angle = (-CGFloat.pi/2).arc4random
            case let (x, y) where x > center.x && y > center.y:
                push.angle = CGFloat.pi+(CGFloat.pi/2).arc4random
            default:
                push.angle = (CGFloat.pi*2).arc4random
            }
        }
        push.angle = (CGFloat.pi * 2).arc4random
        push.magnitude = CGFloat(5.0) //+ CGFloat(10.0).arc4random
        push.action = { [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
        
        
    }
    
    func addItem(_ item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
    }
    
    func removeItem(_ item: UIDynamicItem)
    {
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
    }
    
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
    
}

extension CGFloat {
    var arc4random: CGFloat {
        if self > 0 {
            return CGFloat(arc4random_uniform(UInt32(self)))
        }
        else if self < 0
        {
            return -CGFloat(arc4random_uniform(UInt32(abs(self))))
        }
        else
        {
            return 0
        }
    }
}
