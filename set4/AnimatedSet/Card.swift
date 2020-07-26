//
//  Card.swift
//  set4
//
//  Created by Isaac on 7/16/20.
//  Copyright © 2020 ValentinLagunes. All rights reserved.
//

import Foundation

struct Card : Equatable {
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var number : Int
    var shape: String
    var color: String
    var shading : String
    var identifier: Int
    
    static var globalIdent = 0
    
    init(num: Int, sh: String, col: String, shade: String) {
        number = num
        shape = sh
        color = col
        shading = shade
        identifier = Card.globalIdent
        Card.globalIdent += 1
    }
}
