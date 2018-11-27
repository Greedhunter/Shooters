//
//  GameScene.swift
//  Shooter
//
//  Created by jack on 11/19/18.
//  Copyright © 2018 jack. All rights reserved.
//

import SpriteKit
import GameplayKit

var gameScore = 0

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var levelNumber = 0.0;
    let scorelabel = SKLabelNode(fontNamed: "Arial-BoldMT")
    let liveLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
    var lives = 5
    let player = SKSpriteNode(imageNamed: "myplane_1")
    //let bulletMusic = SKAction.playSoundFileNamed(<#T##soundFile: String##String#>, waitForCompletion: false)
    enum gameState{
        case startMenu
        case gamestart
        case gameOver
    }
    var currentGameState = gameState.gamestart
    let gameFrame: CGRect
    
    struct physicsCatergories{
        //binary 1 2 4
        static let none: UInt32 = 0
        static let player: UInt32 = 0b1
        static let bullet: UInt32 = 0b10
        static let enemy: UInt32 = 0b100
    }
    
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
    override init(size: CGSize){
        let maxRatio: CGFloat = 16.0/9.0
        let playableWidth = size.width / maxRatio
        let margin = (size.width - playableWidth)/2
        gameFrame = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        gameScore = 0
        self.physicsWorld.contactDelegate = self
        
        player.setScale(3)
        player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = physicsCatergories.player
        player.physicsBody!.collisionBitMask = physicsCatergories.none
        player.physicsBody!.contactTestBitMask = physicsCatergories.enemy
        self.addChild(player)
        
        scorelabel.text = "Score: 0"
        scorelabel.fontSize = 50
        scorelabel.fontColor = SKColor.white
        scorelabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scorelabel.position = CGPoint(x: self.size.width * 0.20, y: self.size.height * 0.9)
        scorelabel.zPosition = 10
        self.addChild(scorelabel)
        
        liveLabel.text = "Lives: 5"
        liveLabel.fontSize = 50
        liveLabel.fontColor = SKColor.white
        liveLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        liveLabel.position = CGPoint(x: self.size.width * 0.80, y: self.size.height * 0.9)
        liveLabel.zPosition = 10
        self.addChild(liveLabel)
        
        levels()
    }
    
    func livesLost(){
        lives -= 1
        liveLabel.text = "Lives: \(lives)"
        
        if lives == 0 {
            gameOver()
        }
    }
    
    func addScore(){
        gameScore += 1
        scorelabel.text = "Score: \(gameScore)"
        
        if gameScore % 20 == 0 {
            levels()
        }
    }
    func fireBullet(){
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.name = "Bullet"
        bullet.setScale(3)
        bullet.position = player.position
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = physicsCatergories.bullet
        bullet.physicsBody!.contactTestBitMask = physicsCatergories.none
        bullet.physicsBody!.contactTestBitMask = physicsCatergories.enemy
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([moveBullet, deleteBullet])
        bullet.run(bulletSequence)
    }
    
    func enemySpawn(){
        let enemySpawnXStart = random(min: gameFrame.minX, max: gameFrame.maxX)
        let enemySpawnXEnd = random(min: gameFrame.minX, max: gameFrame.maxX)
        
        let enemyStart = CGPoint(x: enemySpawnXStart, y: self.size.height * 1.2)
        let enemyEnd = CGPoint(x: enemySpawnXEnd, y: -self.size.height * 0.2)
        
        let enemy = SKSpriteNode(imageNamed: "enemy1_1")
        enemy.name = "Enemy"
        enemy.setScale(3)
        enemy.position = enemyStart
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = physicsCatergories.enemy
        enemy.physicsBody!.collisionBitMask = physicsCatergories.none
        enemy.physicsBody!.contactTestBitMask = physicsCatergories.player | physicsCatergories.bullet
        self.addChild(enemy)
        
        let enemyMovement = SKAction.move(to: enemyEnd, duration: 1.5)
        let deleteEnemy = SKAction.removeFromParent()
        let enemySequence = SKAction.sequence([enemyMovement,deleteEnemy])
        enemy.run(enemySequence)
        
        let diffX = enemyEnd.x - enemyStart.x
        let diffY = enemyEnd.y - enemyStart.y
        let rotate = atan2(diffY, diffX)
        enemy.zRotation = rotate
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
        }else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.categoryBitMask == physicsCatergories.player && body2.categoryBitMask == physicsCatergories.enemy{
            
            livesLost();
            if body1.node != nil {
                explosion(spawnPosition: body1.node!.position)
            }
            if body2.node != nil {
                explosion(spawnPosition: body2.node!.position)
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
        
        if body1.categoryBitMask == physicsCatergories.bullet && body2.categoryBitMask == physicsCatergories.enemy && (body2.node?.position.y)! < self.size.height {
            addScore()
            
            if body2.node != nil {
                explosion(spawnPosition: body2.node!.position)
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
    }
    
    func explosion(spawnPosition: CGPoint){
        let explosion = SKSpriteNode(imageNamed: "explosion1_1")
        explosion.setScale(0)
        explosion.position = spawnPosition
        explosion.zPosition = 3
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 3, duration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let deleteExplosion = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([scaleIn, fadeOut, deleteExplosion])
        
        explosion.run(explosionSequence)
    }
    
    func levels(){
        levelNumber += 1
        
        if self.action(forKey: "spawnedEnemy") != nil {
            self.removeAction(forKey: "spawnedEnemy")
        }
        var level = TimeInterval()
        level = 1.5
        if level != 0 {
            level = 1.5 - (levelNumber * 0.1)
        }else {
            level = 0
        }
        let spawn = SKAction.run(enemySpawn)
        let waitTime = SKAction.wait(forDuration: level)
        let spawnSequence = SKAction.sequence([spawn, waitTime])
        let continousSpawn = SKAction.repeatForever(spawnSequence)
        self.run(continousSpawn, withKey: "spawnedEmemy")
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentGameState == gameState.gamestart {
            fireBullet()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let touchPosition = touch.location(in: self)
            let previousTouchPosition = touch.previousLocation(in: self)
            let dragged = touchPosition.x - previousTouchPosition.x
            if currentGameState == gameState.gamestart {
                player.position.x += dragged
            }
            if player.position.x > gameFrame.maxX {
                player.position.x = gameFrame.maxX
            }
            if player.position.x < gameFrame.minX {
                player.position.x = gameFrame.minX
            }
        }
    }
    func gameOver(){
        currentGameState = gameState.gameOver
        self.removeAllActions()
        self.enumerateChildNodes(withName: "Bullet") { (bullet, stop) in
            bullet.removeAllActions()
        }
        
        self.enumerateChildNodes(withName: "Enemy") { (enemy, stop) in
            enemy.removeAllActions()
        }
        
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChange = SKAction.wait(forDuration: 1)
        let changeSceneSequwnce = SKAction.sequence([waitToChange, changeSceneAction])
        self.run(changeSceneSequwnce)
    }
    
    func changeScene(){
        let scene = GameOver(size: self.size)
        scene.scaleMode = self.scaleMode
        let gameTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(scene, transition: gameTransition)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
