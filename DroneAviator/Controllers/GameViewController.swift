import UIKit
import SpriteKit
import GameplayKit
import GameKit

class GameViewController: UIViewController, SKSceneDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        GameManager.shared.score = 0
        let skView = self.view as! SKView
        skView.ignoresSiblingOrder = true
        var scene: SKScene!
        switch GameManager.shared.gameType {
        case .standart:
            scene = CoinsGameScene()
        case .timer:
            scene = TimerGameScene()
        }
        scene.scaleMode = .aspectFit
        scene.delegate = self
        skView.presentScene(scene)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}



