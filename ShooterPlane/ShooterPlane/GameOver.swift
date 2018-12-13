//
//  GameOver.swift
//  Shooter
//
//  Created by jack on 11/23/18.
//  Copyright © 2018 jack. All rights reserved.
//

import Foundation
import SpriteKit

let restartLabel = SKLabelNode(fontNamed: "Arial-BoldMT")

class GameOver: SKScene {
    override func didMove(to view: SKView) {        
        let background = SKSpriteNode(imageNamed: "water")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameOverImage = SKSpriteNode(imageNamed: "gameOver")
        gameOverImage.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.75)
        gameOverImage.setScale(3)
        gameOverImage.zPosition = 1
        self.addChild(gameOverImage)
        
        let scoreLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 125
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.5)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        let defaults = UserDefaults()
        var highScore = defaults.integer(forKey: "SavedHighScore")
        
        if gameScore > highScore {
            highScore = gameScore
            defaults.set(highScore, forKey: "SavedHighScore")
        }
        
        let highScoreLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        highScoreLabel.text = "High Score: \(highScore)"
        highScoreLabel.fontSize = 125
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.4)
        highScoreLabel.zPosition = 1
        self.addChild(highScoreLabel)
        
        
        restartLabel.text = "RESTART"
        restartLabel.fontSize = 125
        restartLabel.fontColor = SKColor.white
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        restartLabel.zPosition = 1
        self.addChild(restartLabel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            
            if restartLabel.contains(pointOfTouch){
                let sceneToMove = GameScene(size: self.size)
                sceneToMove.gameStartState()
                sceneToMove.scaleMode = self.scaleMode
                let transitions = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMove, transition: transitions)
                
            }
        }
    }
}
