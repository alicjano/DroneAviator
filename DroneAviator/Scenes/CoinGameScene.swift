import SpriteKit
import GameKit

class CoinsGameScene: SKScene {
    
    var backgroundImage: SKSpriteNode!
    
    var gameState: gameState  = .notPlaying
    let coinCount = 30
    var cannon: SKSpriteNode!
    var ship: SKSpriteNode!
    var particles: SKEmitterNode!
    
    var score = 0 {
        didSet {
            if score == 30 {
                runNextLevel()
            }
        }
    }
    
    var playButton: SKSpriteNode!
    var menuButton: SKSpriteNode!
    
    var coins = [SKSpriteNode]()
    var level = 1
    var shootTimer: Timer?
    var shipPositionAngle: CGFloat = CGFloat.pi
    var isClockwise = true
    var objct : SKSpriteNode!
    var objcPos:CGFloat = 0
    
    var scoreLabel: SKLabelNode!
    
    //MARK: - DidMove
    override func didMove(to view: SKView) {
        setupGame()
        placeCoinsInCircle()
    }
    
    //MARK: - setupGame
    func setupGame() {
        scene?.size = CGSize(width: 375, height: 667)
        scene?.size = (view?.frame.size)!
        let background = SKSpriteNode(imageNamed: "background")
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = -1
        background.size = CGSize(width: size.width, height: size.height)
        addChild(background)
        scoreLabel  = SKLabelNode(attributedText: NSAttributedString(string: "Score: \(GameManager.shared.score)", attributes: [NSAttributedString.Key.font : UIFont(name: "AvenirNext-Bold", size: 30), NSAttributedString.Key.foregroundColor : UIColor(cgColor: CGColor(red: 51/255, green: 60/255, blue: 65/255, alpha: 1))]))
        scoreLabel.position = CGPoint(x: size.width * 0.5, y: size.height * 0.8)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        let timerTable = SKSpriteNode(imageNamed: "clearButton")
        timerTable.size = CGSize(width: scoreLabel.frame.width + 70, height: scoreLabel.frame.height + 40)
        timerTable.position = CGPoint(x: scoreLabel.position.x, y: scoreLabel.position.y + 15)
        addChild(timerTable)
        ship = SKSpriteNode(imageNamed: GameManager.shared.plane.rawValue)
        ship.size = CGSize(width: size.width/8, height: size.width/7)
        ship.zPosition = 1
        ship.zRotation = -CGFloat.pi/2
        ship.position = CGPoint(x: size.width/2, y: size.height/2 + size.width/2*0.8)
        addChild(ship)
        objct = SKSpriteNode()
        addChild(objct)
        cannon = SKSpriteNode(imageNamed:  GameManager.shared.cannon.rawValue)
        cannon.size = CGSize(width: size.width/6, height: size.width/6)
        cannon.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(cannon)
    }
    
    func showMenu() {
        playButton = SKSpriteNode(imageNamed: "playButton")
        playButton.position = CGPoint(x: size.width/2, y: size.height/5)
        playButton.setScale(0.8)
        playButton.zPosition = 3
        playButton.alpha = 0
        addChild(playButton)
        playButton.run(SKAction.fadeIn(withDuration: 0.5))
        menuButton = SKSpriteNode(imageNamed: "menuButton")
        menuButton.alpha = 0
        menuButton.position = CGPoint(x: size.width/2, y: size.height/5 * 2)
        menuButton.setScale(0.8)
        menuButton.zPosition = 3
        menuButton.run(SKAction.fadeIn(withDuration: 0.5))
        addChild(menuButton)
    }
    
    //MARK: - buttonPlayTap
    func buttonPlayTap(){
        gameState = .playing
        moveNodeInCircle(clockwise: !isClockwise)
        run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 0.7 - Double(GameManager.shared.round / 10)), SKAction.run {
            self.shootAtShip()
            print("shoot")
            print(self.ship.position)
        }])))
    }
    
    //MARK: - planeParticlesColour
    func  planeParticles() {
        var color1 = UIColor()
        var color2 = UIColor()
        switch GameManager.shared.plane {
        case .first:
            color1 = UIColor.yellow
            color2 = UIColor.black
        case .second:
            color1 = UIColor.yellow
            color2 = UIColor.red
        case .third:
            color1 = UIColor.white
            color2 = UIColor.purple
        case .fourth:
            color1 = UIColor.red
            color2 = UIColor.white
        default:
            color1 = UIColor.white
            color2 = UIColor.black
        }
        let colorKeyframes: [UIColor] = [color1, color2]
        let colorTimes: [NSNumber] = [0.0, 0.5]
        let colorSequence = SKKeyframeSequence(keyframeValues: colorKeyframes, times: colorTimes)
        particles.particleColorSequence = colorSequence
    }
    
    //MARK: - restart
    func restart(){
        GameManager.shared.restart()
        let delay = SKAction.wait(forDuration: 0.5)
        let sceneChange = SKAction.run {
            let newSceneSize = CGSize(width: 375, height: 667)
            let newGameScene = CoinsGameScene(size: newSceneSize)
            newGameScene.scaleMode = .aspectFit
            newGameScene.delegate = self.delegate
            self.view?.presentScene(newGameScene, transition: .doorway(withDuration: 1))
        }
        run(.sequence([delay, sceneChange]))
    }
    
    //MARK: - moveNodeInCircle
    func moveNodeInCircle(clockwise: Bool) {
        isClockwise = clockwise
        let directionModifier: CGFloat = clockwise ? 1.0 : -1.0
        // Calculate the current angle of the ship
        shipPositionAngle = getShipAngle(ship)
        if isClockwise {
            objcPos = getShipAngle(ship) + CGFloat.pi / CGFloat.random(in: 2.5...4)
        } else {
            objcPos = getShipAngle(ship) - CGFloat.pi / CGFloat.random(in: 2.5...4)
        }
        let circlePath = UIBezierPath(arcCenter: cannon.position,
                                      radius: size.width/2 * 0.8,
                                      startAngle: shipPositionAngle,
                                      endAngle: shipPositionAngle + CGFloat.pi * 2 * directionModifier,
                                      clockwise: clockwise)
        
        let followPathAction = SKAction.follow(circlePath.cgPath, asOffset: false, orientToPath: true, duration: 3.5)
        let particlesAction = SKAction.run({
            self.showMoveParticles(touchPosition: self.ship.position)
        })
        let repeatAction = SKAction.repeatForever(SKAction.group([followPathAction, particlesAction]))
        
        let circlePathObj = UIBezierPath(arcCenter: cannon.position,
                                         radius: size.width/2 * 0.8,
                                         startAngle: objcPos,
                                         endAngle: objcPos + CGFloat.pi * 2 * directionModifier,
                                         clockwise: clockwise)
        
        let followPathActionObj = SKAction.follow(circlePathObj.cgPath, asOffset: false, orientToPath: true, duration: 3.5)
        let repeatActionobj = SKAction.repeatForever(followPathActionObj)
        objct.removeAllActions()
        objct.run(repeatActionobj)
        
        ship.removeAllActions()
        ship.run(repeatAction)
    }
    
    //MARK: - getShipAngle
    func getShipAngle(_ obj: SKSpriteNode) -> CGFloat {
        let shipDirection = CGPoint(x: obj.position.x - cannon.position.x, y: obj.position.y - cannon.position.y)
        let initialDirection = CGPoint(x: 1, y: 0)
        let angle = atan2(shipDirection.y, shipDirection.x) - atan2(initialDirection.y, initialDirection.x)
        return angle
    }
    
    //MARK: - showMoveParticles
    private func showMoveParticles(touchPosition: CGPoint) {
        if particles == nil {
            particles = SKEmitterNode(fileNamed: "PlaneFire.sks")
            planeParticles()
            particles!.zPosition = 1
            particles!.zRotation = getShipAngle(ship)
            particles!.emissionAngle = getShipAngle(ship)
            particles!.targetNode = self
            addChild(particles!)
        }
        particles!.position = touchPosition
    }
    
    //MARK: - touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameState == .notPlaying {
            gameState = .playing
            moveNodeInCircle(clockwise: isClockwise)
            run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 0.7 - Double(GameManager.shared.round / 10)), SKAction.run {
                self.shootAtShip()
                print("shoot")
                print(self.ship.position)
            }])))
        }
        if gameState == .playing  {
            isClockwise.toggle()
            ship.removeAllActions()
            objct.removeAllActions()
            moveNodeInCircle(clockwise: isClockwise)
        }
        let touch = touches.first
        if let touchLocation = touch?.location(in: self){
            if playButton != nil && playButton.alpha == 1 && playButton.contains(touchLocation) {
                restart()
            }
            if menuButton != nil && menuButton.alpha == 1 && menuButton.contains(touchLocation) {
                showMainMenu()
            }
        }
    }
    
    private func showMainMenu() {
        let delegate = delegate as! GameViewController
        delegate.dismiss(animated: true)
        let vc = MenuViewController()
        vc.modalPresentationStyle = .fullScreen
        delegate.present(vc, animated: true)
    }
    
    //MARK: - shootAtShip
    func shootAtShip() {
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.size = CGSize(width: 15, height: 15)
        bullet.position = cannon.position
        bullet.name = "bullet"
        addChild(bullet)
        
        let shipDirection = CGPoint(x: objct.position.x + CGFloat(Int.random(in: -100...100)) - cannon.position.x, y: objct.position.y - cannon.position.y + CGFloat(Int.random(in: -100...100)))
        let normalizedDirection = shipDirection.normalized()
        let shootVector = CGVector(dx: normalizedDirection.x * 1000, dy: normalizedDirection.y * 1000)
        
        let shootAction = SKAction.move(by: shootVector, duration: 3)
        let removeAction = SKAction.removeFromParent()
        bullet.run(SKAction.sequence([shootAction, removeAction]))
    }
    
    //MARK: - update
    override func update(_ currentTime: TimeInterval) {
        cannon.zRotation = getShipAngle(ship) - CGFloat.pi/2
        if gameState == .playing  {
            showMoveParticles(touchPosition: ship.position)
        } else if gameState == .gameOver{
            particles.particleBirthRate = 0
            let waitAction = SKAction.wait(forDuration: particles.particleLifetime)
            particles.run(waitAction, completion: {
                self.particles.removeFromParent()
            })
        }
        for case let node as SKSpriteNode in self.children {
            if node.name == "bullet" && CGPointDistance(ship.position, node.position) < 30 && gameState == .playing {
                node.removeFromParent()
                planeCrash()
                
            }
            if node.name == "coin" && ship.contains(node.position) && gameState == .playing  {
                node.removeFromParent()
                score += 1
                GameManager.shared.score += 1
                scoreLabel.attributedText = NSAttributedString(string: "Score: \(GameManager.shared.score)", attributes: [NSAttributedString.Key.font : UIFont(name: "AvenirNext-Bold", size: 30), NSAttributedString.Key.foregroundColor : UIColor(cgColor: CGColor(red: 51/255, green: 60/255, blue: 65/255, alpha: 1))])
                Vibration.light.vibrate()
            }
        }
    }
    
    //MARK: - planeCrash
    func planeCrash()   {
        Vibration.error.vibrate()
        gameState = .gameOver
        removeAllActions()
        ship.removeAllActions()
                if RecordManager.shared.isNewRecord(score: Double(score), gameType: .standart) {
                    // Create the UIAlertController
                           let alertController = UIAlertController(title: "New Record!", message: "Please write your name to save it:", preferredStyle: .alert)
                           
                           // Add a UITextField to the UIAlertController
                           alertController.addTextField { (textField) in
                               textField.placeholder = "Your name.."
                           }
                           
                           // Create the "OK" action
                           let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
                               if let textField = alertController.textFields?.first {
                                   if !textField.text!.isEmpty {
                                       var name = textField.text
                                       RecordManager.shared.addScoreRecord(score: Double(self!.score), name: name!, gameType: .standart)
                                   }
                               }
                           }
                           
                           // Create the "Cancel" action
                           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                           
                           // Add the actions to the UIAlertController
                           alertController.addAction(okAction)
                           alertController.addAction(cancelAction)
                            let delegate = self.delegate as! GameViewController
                           // Present the UIAlertController
                            delegate.present(alertController, animated: true)
                }
        let removeAction = SKAction.fadeOut(withDuration: 0.5)
        ship.run(removeAction)
        run(SKAction.sequence([SKAction.wait(forDuration: 1) ,SKAction.run {
            self.ship.removeFromParent()
            self.showMenu()
        }]))
        
    }
    
    //MARK: - placeCoinsInCircle
    func placeCoinsInCircle() {
        let coinRadius: CGFloat =  size.width/2 * 0.8
        let angleIncrement = CGFloat.pi * 2 / CGFloat(coinCount)
        
        for i in 0..<coinCount {
            let angle = angleIncrement * CGFloat(i)
            let x = cannon.position.x + cos(angle) * coinRadius
            let y = cannon.position.y + sin(angle) * coinRadius
            
            let coin = SKSpriteNode(imageNamed: "coin")
            coin.size = CGSize(width: 20, height: 20)
            coin.name = "coin"
            coin.position = CGPoint(x: x, y: y)
            addChild(coin)
            coins.append(coin)
        }
    }
    
    //MARK: - runNextLevel
    func runNextLevel() {
        gameState = .gameOver
        GameManager.shared.nextLevel()
        let delay = SKAction.wait(forDuration: 0.5)
        let sceneChange = SKAction.run {
            let newSceneSize = CGSize(width: 375, height: 667)
            let newGameScene = CoinsGameScene(size: newSceneSize)
            newGameScene.scaleMode = .aspectFit
            newGameScene.delegate = self.delegate
            self.view?.presentScene(newGameScene, transition: .crossFade(withDuration: 0.5))
        }
        run(.sequence([delay, sceneChange]))
    }
    
    func CGPointDistanceSquared(_ from: CGPoint,_ to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }

    func CGPointDistance(_ from: CGPoint, _ to: CGPoint) -> CGFloat {
        return sqrt(CGPointDistanceSquared(from, to))
    }

}
extension CGPoint {
    func normalized() -> CGPoint {
        let length = CGFloat(sqrt(self.x * self.x + self.y * self.y))
        return CGPoint(x: self.x / length, y: self.y / length)
    }
}
