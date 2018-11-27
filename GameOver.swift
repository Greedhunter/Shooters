//
//  GameOver.swift
//  Shooter
//
//  Created by jack on 11/23/18.
//  Copyright © 2018 jack. All rights reserved.
//

import Foundation
import SpriteKit

class GameOver: SKScene {
    override func didMove(to view: SKView) {
        let gameOverImage = SKSpriteNode(imageNamed: "gameOver")
        gameOverImage.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.75)
        gameOverImage.setScale(3)
        gameOverImage.zPosition = 1
        self.addChild(gameOverImage)
        
        let scoreLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 125
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.4)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
    }
}
