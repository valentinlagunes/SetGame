//
//  ConcentrationCard.swift
//  set4
//
//  Created by Isaac on 7/25/20.
//  Copyright © 2020 ValentinLagunes. All rights reserved.
//

import Foundation

struct ConcentrationCard : Hashable
{
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func ==(lhs: ConcentrationCard, rhs: ConcentrationCard) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    var seenBefore = false
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
 
    init()
    {
        self.identifier = ConcentrationCard.getUniqueIdentifier()
    }
}
