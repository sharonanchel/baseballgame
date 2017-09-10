//
//  batter.swift
//  game3
//
//  Created by Lorman Lau on 9/9/17.
//  Copyright © 2017 TheGroup1. All rights reserved.
//

import UIKit

class Batter: Player {
    
    func generateHitScore(){
        hitScore = Int(arc4random_uniform(21) + 25)
    }
    
    func checkIfHit(playersNum: Int) -> Bool{
        if playersNum >= hitScore {
            return false
        } else {
            return true
        }
    }
}

class Player {
    var hitScore = Int()
    
    func getHitScore() -> Int{
        return hitScore
    }
    
    func setHitScore(hitScore: Int) {
        self.hitScore = hitScore
    }
}
