import SpriteKit
import GameKit

class TimerGameScene: SKScene {
    
    var timer: Timer?
    var startTime: Date?
    var accumulatedTime: TimeInterval = 0
    
    var isTimerActive = false
    
    var timeString: String = "00:00:00"
    
    
    // Start the timer
    func startTimer() {
            if timer == nil {
                startTime = Date()
                timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            }
    }
    
    // Pause the timer
     func pauseTimer() {
             if let startTime = startTime {
                 accumulatedTime += Date().timeIntervalSince(startTime)
                 timer?.invalidate()
                 timer = nil
             }
    }
    
    // Continue the timer
    func continueTimer() {
            if timer == nil {
                startTime = Date()
                timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            }
    }
    
    // Stop the timer
    func stopTimer() {
            timer?.invalidate()
        if RecordManager.shared.isNewRecord(score: Double(accumulatedTime + (startTime != nil ? Date().timeIntervalSince(startTime!) : 0)), gameType: .timer) {
            // Create the UIAlertController
                   let alertController = UIAlertController(title: "New Record!", message: "Please write your name to save it:", preferredStyle: .alert)
                   
                   // Add a UITextField to the UIAlertController
                   alertController.addTextField { (textField) in
                       textField.placeholder = "Your name.."
                   }
                   
                   // Create the "OK" action
                   let okAction = UIAlertAction(title: "OK", style: .default) {(_) in
                       if let textField = alertController.textFields?.first {
                           if !textField.text!.isEmpty {
                               var name = textField.text
                               RecordManager.shared.addScoreRecord(score: Double(self.accumulatedTime + (self.startTime != nil ? Date().timeIntervalSince(self.startTime!) : 0)), name: name!, gameType: .timer)
                               self.timer = nil
                               self.startTime = nil
                               self.accumulatedTime = 0
                           }
                       }
                   }
                   
                   // Create the "Cancel" action
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                self.timer = nil
                self.startTime = nil
                self.accumulatedTime = 0
            }
                   
                   // Add the actions to the UIAlertController
                   alertController.addAction(okAction)
                   alertController.addAction(cancelAction)
                    let delegate = self.delegate as! GameViewController
                   // Present the UIAlertController
            delegate.present(alertController, animated: true) {
    
            }
        }
    }
    
    // Update the timer label
    @objc func updateTimer() {
        updateTimerLabel()
    }
    
    // Update the timer label with milliseconds
    func updateTimerLabel() {
            let currentTime = accumulatedTime + (startTime != nil ? Date().timeIntervalSince(startTime!) : 0)
            let milliseconds = Int(currentTime * 100) % 100
            let seconds = Int(currentTime) % 60
            let minutes = Int(currentTime) / 60
            timeString = String(format: "%02d:%02d:%02d", minutes, seconds, milliseconds)
            print(timeString)
        scoreLabel.attributedText = NSAttributedString(string: timeString, attributes: [NSAttributedString.Key.font : UIFont(name: "AvenirNext-Bold", size: 30), NSAttributedString.Key.foregroundColor : UIColor(cgColor: CGColor(red: 51/255, green: 60/255, blue: 65/255, alpha: 1))])
    }
    
    func getTime() -> String {
            let currentTime = accumulatedTime + (startTime != nil ? Date().timeIntervalSince(startTime!) : 0)
            let milliseconds = Int(currentTime * 100) % 100
            let seconds = Int(currentTime) % 60
            let minutes = Int(currentTime) / 60
            timeString = String(format: "%02d:%02d:%02d", minutes, seconds, milliseconds)
            return timeString
    }
    
    var backgroundImage: SKSpriteNode!
    
    var gameState: gameState  = .notPlaying
    var cannon: SKSpriteNode!
    var ship: SKSpriteNode!
    var particles: SKEmitterNode!
    
 
    var playButton: SKSpriteNode!
    var menuButton: SKSpriteNode!
    
    var shootTimer: Timer?
    var shipPositionAngle: CGFloat = CGFloat.pi
    var isClockwise = true
    var objct : SKSpriteNode!
    var objcPos:CGFloat = 0
    
    var scoreLabel: SKLabelNode!
    
    //MARK: - DidMove
    override func didMove(to view: SKView) {
        setupGame()
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
        scoreLabel  = SKLabelNode(attributedText: NSAttributedString(string: "00:00:00", attributes: [NSAttributedString.Key.font : UIFont(name: "AvenirNext-Bold", size: 30), NSAttributedString.Key.foregroundColor : UIColor(cgColor: CGColor(red: 51/255, green: 60/255, blue: 65/255, alpha: 1))]))
        scoreLabel.position = CGPoint(x: size.width * 0.5, y: size.height * 0.8)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        let timerTable = SKSpriteNode(imageNamed: "clearButton")
        timerTable.size = CGSize(width: scoreLabel.frame.width + 30, height: scoreLabel.frame.height + 30)
        timerTable.position = CGPoint(x: scoreLabel.position.x, y: scoreLabel.position.y + 15)
        addChild(timerTable)
        ship = SKSpriteNode(imageNamed: GameManager.shared.plane.rawValue)
        ship.size = CGSize(width: size.width/8, height: size.width/7)
        ship.zPosition = 1
        ship.zRotation = CGFloat.pi/2
        ship.position = CGPoint(x: size.width/2, y: size.height/2 + size.width/2*0.8)
        addChild(ship)
        objct = SKSpriteNode()
        addChild(objct)
        cannon = SKSpriteNode(imageNamed:  GameManager.shared.cannon.rawValue)
        cannon.size = CGSize(width: size.width/6, height: size.width/6)
        cannon.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(cannon)
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
    
    func showMenu() {
        playButton = SKSpriteNode(imageNamed: "playButton")
        playButton.position = CGPoint(x: size.width/2, y: size.height/5)
        playButton.setScale(0.8)
        playButton.alpha = 0
        playButton.zPosition = 3
        addChild(playButton)
        playButton.run(SKAction.fadeIn(withDuration: 0.5))
        menuButton = SKSpriteNode(imageNamed: "menuButton")
        menuButton.alpha = 0
        menuButton.position = CGPoint(x: size.width/2, y: size.height/5 * 2)
        menuButton.setScale(0.8)
        menuButton.run(SKAction.fadeIn(withDuration: 0.5))
        menuButton.zPosition = 3
        addChild(menuButton)
    }
    
    //MARK: - restart
    func restart(){
        GameManager.shared.restart()
        let delay = SKAction.wait(forDuration: 0.5)
        let sceneChange = SKAction.run {
            let newSceneSize = CGSize(width: 375, height: 667)
            let newGameScene = TimerGameScene(size: newSceneSize)
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
            startTimer()
            gameState = .playing
            moveNodeInCircle(clockwise: !isClockwise)
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
        
        switch Int.random(in: 1...3) {
        case 3:
            let shipDirection = CGPoint(x: ship.position.x + CGFloat(Int.random(in: -100...100)) - cannon.position.x, y: ship.position.y - cannon.position.y + CGFloat(Int.random(in: -100...100)))
            let normalizedDirection = shipDirection.normalized()
            let shootVector = CGVector(dx: normalizedDirection.x * 1000, dy: normalizedDirection.y * 1000)
            
            let shootAction = SKAction.move(by: shootVector, duration: 3)
            let removeAction = SKAction.removeFromParent()
            bullet.run(SKAction.sequence([shootAction, removeAction]))
        default:
            let shipDirection = CGPoint(x: objct.position.x + CGFloat(Int.random(in: -100...100)) - cannon.position.x, y: objct.position.y - cannon.position.y + CGFloat(Int.random(in: -100...100)))
            let normalizedDirection = shipDirection.normalized()
            let shootVector = CGVector(dx: normalizedDirection.x * 1000, dy: normalizedDirection.y * 1000)
            
            let shootAction = SKAction.move(by: shootVector, duration: 3)
            let removeAction = SKAction.removeFromParent()
            bullet.run(SKAction.sequence([shootAction, removeAction]))
        }
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
                stopTimer()
                planeCrash()
                showMenu()
            }
        }
    }
    
    //MARK: - planeCrash
    func planeCrash()   {
        Vibration.error.vibrate()
        gameState = .gameOver
        removeAllActions()
        ship.removeAllActions()
        //TODO
        let removeAction = SKAction.fadeOut(withDuration: 0.5)
        ship.run(removeAction)
        run(SKAction.sequence([SKAction.wait(forDuration: 1) ,SKAction.run {
            self.ship.removeFromParent()
        }]))
    }
    
    //MARK: - runNextLevel
    func runNextLevel() {
        gameState = .gameOver
        GameManager.shared.nextLevel()
        let delay = SKAction.wait(forDuration: 0.5)
        let sceneChange = SKAction.run {
            let newSceneSize = CGSize(width: 375, height: 667)
            let newGameScene = TimerGameScene(size: newSceneSize)
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
