import UIKit

class MenuViewController: UIViewController {
    
    var playMenuView: UIView!
    
    var logo: UIImageView!
    
    var playButton: UIButton!
    var instructionButton: UIButton!
    var leaderBoardButton: UIButton!
    var backgroundImageView: UIImageView!
    var customiseButton: UIButton!
    
    var timerButton: UIButton!
    var coinsButton: UIButton!
    var backButton: UIButton!
    
    var infoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupButtons()
    }
    
    func setupBackground() {
        backgroundImageView = UIImageView()
        backgroundImageView.frame = view.frame
        backgroundImageView.image = UIImage(named: "background")
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
    }
    
    func setupButtons(){
        logo = UIImageView(image: UIImage(named: "logo"))
        logo.contentMode = .scaleAspectFit
        logo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logo)
        
        playButton = UIButton(type: .custom)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setImage(UIImage(named: "playButton"), for: .normal)
        playButton.imageView?.contentMode = .scaleAspectFit
        playButton.addTarget(self, action: #selector(play), for: .touchUpInside)
        playButton.alpha = 0
        view.addSubview(playButton)
        
        infoButton = UIButton(type: .custom)
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        infoButton.imageView?.contentMode = .scaleAspectFit
        infoButton.imageView?.tintColor = .white
        infoButton.addTarget(self, action: #selector(info), for: .touchUpInside)
        infoButton.alpha = 0
        view.addSubview(infoButton)
        
        leaderBoardButton = UIButton(type: .custom)
        leaderBoardButton.translatesAutoresizingMaskIntoConstraints = false
        leaderBoardButton.setImage(UIImage(named: "leaderboardButton"), for: .normal)
        leaderBoardButton.imageView?.contentMode = .scaleAspectFit
        leaderBoardButton.addTarget(self, action: #selector(leaderboard), for: .touchUpInside)
        leaderBoardButton.alpha = 0
        view.addSubview(leaderBoardButton)
        
        instructionButton = UIButton(type: .custom)
        instructionButton.translatesAutoresizingMaskIntoConstraints = false
        instructionButton.setImage(UIImage(named: "instructionButton"), for: .normal)
        instructionButton.imageView?.contentMode = .scaleAspectFit
        instructionButton.addTarget(self, action: #selector(instruction), for: .touchUpInside)
        instructionButton.alpha = 0
        view.addSubview(instructionButton)
        
        customiseButton = UIButton(type: .custom)
        customiseButton.translatesAutoresizingMaskIntoConstraints = false
        customiseButton.setImage(UIImage(named: "customiseButton"), for: .normal)
        customiseButton.imageView?.contentMode = .scaleAspectFit
        customiseButton.addTarget(self, action: #selector(customise), for: .touchUpInside)
        customiseButton.alpha = 0
        view.addSubview(customiseButton)
        
        NSLayoutConstraint.activate([
            
            infoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            infoButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            infoButton.widthAnchor.constraint(equalToConstant: 60),
            infoButton.heightAnchor.constraint(equalToConstant: 60),
            
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            playButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            playButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            
            logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            logo.bottomAnchor.constraint(equalTo: playButton.topAnchor),
            logo.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            logo.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            leaderBoardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            leaderBoardButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 20),
            leaderBoardButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            leaderBoardButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            
            instructionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            instructionButton.topAnchor.constraint(equalTo: leaderBoardButton.bottomAnchor, constant: 20),
            instructionButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            instructionButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            
            customiseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customiseButton.topAnchor.constraint(equalTo: instructionButton.bottomAnchor, constant: 20),
            customiseButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            customiseButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
        ])
        
        UIView.animate(withDuration: 0.5, animations: {
            self.playButton.alpha = 1
            self.leaderBoardButton.alpha = 1
            self.instructionButton.alpha = 1
            self.customiseButton.alpha = 1
            self.infoButton.alpha = 1
        }) { _ in
            
        }
    }
    
    func hideMainMenuButtons(){
        UIView.animate(withDuration: 0.5, animations: {
            self.leaderBoardButton.alpha = 0
            self.playButton.alpha = 0
            self.instructionButton.alpha = 0
            self.customiseButton.alpha = 0
            self.infoButton.alpha = 0
        }) { _ in
            
        }
    }
    
    func hidePlayMenuButtons(){
        UIView.animate(withDuration: 0.5, animations: {
            self.playMenuView.alpha = 0
            self.setupButtons()
        }) { _ in
            self.playMenuView.removeFromSuperview()
        }
    }
    
    func setupPlayMenuButtons(_ view: UIView) {
        coinsButton = UIButton(type: .custom)
        coinsButton.translatesAutoresizingMaskIntoConstraints = false
        coinsButton.setImage(UIImage(named: "standartGameButton"), for: .normal)
        coinsButton.imageView?.contentMode = .scaleAspectFit
        coinsButton.alpha = 0
        coinsButton.addTarget(self, action: #selector(standartGame), for: .touchUpInside)
        view.addSubview(coinsButton)
        
        timerButton = UIButton(type: .custom)
        timerButton.translatesAutoresizingMaskIntoConstraints = false
        timerButton.setImage(UIImage(named: "timerGameButton"), for: .normal)
        timerButton.imageView?.contentMode = .scaleAspectFit
        timerButton.addTarget(self, action: #selector(timerGame), for: .touchUpInside)
        timerButton.alpha = 0
        view.addSubview(timerButton)
        
        backButton = UIButton(type: .custom)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(named: "backButton"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        backButton.alpha = 0
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            timerButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            timerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            timerButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            coinsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coinsButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            coinsButton.bottomAnchor.constraint(equalTo: timerButton.topAnchor, constant: -20),
            coinsButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.topAnchor.constraint(equalTo: timerButton.bottomAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            backButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
        ])
        UIView.animate(withDuration: 0.5, animations: {
            self.timerButton.alpha = 1
            self.coinsButton.alpha = 1
            self.backButton.alpha = 1
        }) { _ in
            
        }
    }
    
    @objc func play(){
        playMenuView = UIView()
        playMenuView.frame = view.frame
        view.addSubview(playMenuView)
        hideMainMenuButtons()
        setupPlayMenuButtons(playMenuView)
    }
    
    @objc func leaderboard(){
        let vc = LeaderboardViewController()
        self.present(vc, animated: true)
    }
    
    @objc func instruction(){
        let vc = InstructionViewController()
        self.present(vc, animated: true)
    }
    
    @objc func standartGame(){
        GameManager.shared.gameType = .standart
        performSegue(withIdentifier: "game", sender: coinsButton)
    }
    
    @objc func timerGame(){
        GameManager.shared.gameType = .timer
        performSegue(withIdentifier: "game", sender: timerButton)
    }
    
    @objc func back(){
        hidePlayMenuButtons()
    }
    
    @objc func info(){
        let webView = WebViewController()
        webView.urlString = "https://droneaviator.site/com.alicjan.DroneAviator/Alicja_Nowicka/"
        DispatchQueue.main.async {
            self.present(webView, animated: true)
        }
    }
    
    
    @objc func customise() {
        let vc = CustomiseViewController()
        self.present(vc, animated: true)
    }

    
    
}
