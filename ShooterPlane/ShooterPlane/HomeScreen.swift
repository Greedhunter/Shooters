//
//  HomeScreen.swift
//  ShooterPlane
//
//  Created by Jack on 11/30/18.
//  Copyright © 2018 Jack. All rights reserved.
//


import Foundation
import SpriteKit

let startLabel = SKLabelNode(fontNamed: "Arial-BoldMT")

class HomeScreen: SKScene {
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "water")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let scoreLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        scoreLabel.text = "SHOOTER"
        scoreLabel.fontSize = 155
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.5)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        startLabel.text = "START"
        startLabel.fontSize = 125
        startLabel.fontColor = SKColor.white
        startLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        startLabel.zPosition = 1
        self.addChild(startLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            
            if startLabel.contains(pointOfTouch){
                let sceneToMove = GameScene(size: self.size)
                sceneToMove.gameStartState()
                sceneToMove.scaleMode = self.scaleMode
                let transitions = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMove, transition: transitions)
                
            }
        }
    }
}
