//
//  LeaderboardViewController.swift
//  DroneAviator
//
//  Created by Anton Babko on 10.10.2023.
//

import UIKit

class LeaderboardViewController: UIViewController {
    
    var leaders: [ScoreRecord] = []
    
    var segmentControl: UISegmentedControl!
    
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        leaders = RecordManager.shared.getScoreRecords(.standart).reversed()
        setupUI()
    }
    
    private func setBackground(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemChromeMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        let hookView = UIView()
        hookView.backgroundColor = .label
        hookView.translatesAutoresizingMaskIntoConstraints = false
        hookView.clipsToBounds = true
        hookView.layer.cornerRadius = 3
        view.addSubview(hookView)
        NSLayoutConstraint.activate([
            hookView.topAnchor.constraint(equalTo: view.topAnchor, constant: 7),
            hookView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            hookView.heightAnchor.constraint(equalToConstant: 6),
            hookView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupUI() {
        setBackground()
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 20
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        segmentControl = UISegmentedControl(items: ["Coins", "Timer"])
        segmentControl.addTarget(self, action: #selector(changeLeaderboard), for: .valueChanged)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.selectedSegmentIndex = 0
        view.addSubview(segmentControl)
        NSLayoutConstraint.activate([
            segmentControl.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            segmentControl.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentControl.heightAnchor.constraint(equalToConstant: 30),
            
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
    }
    
    @objc func changeLeaderboard() {
        if segmentControl.selectedSegmentIndex == 0 {
            leaders = RecordManager.shared.getScoreRecords(.standart).reversed()
        } else {
            leaders = RecordManager.shared.getScoreRecords(.timer).reversed()
        }
        print(leaders)
        UIView.animate(withDuration: 0.5, animations: {
            self.tableView.reloadData()
        })
    }

}

extension LeaderboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        leaders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let score = leaders[indexPath.row].score
        if segmentControl.selectedSegmentIndex == 0 {
            cell.scoreLabel.attributedText = NSAttributedString(string: "\(score)", attributes: [NSAttributedString.Key.font : UIFont(name: "AvenirNext-Bold", size: 16), NSAttributedString.Key.foregroundColor : UIColor(.white)])
        } else {
            let milliseconds = Int(score * 100) % 100
            let seconds = Int(score) % 60
            let minutes = Int(score) / 60
            let timeString = String(format: "%02d:%02d:%02d", minutes, seconds, milliseconds)
            cell.scoreLabel.attributedText = NSAttributedString(string: timeString, attributes: [NSAttributedString.Key.font : UIFont(name: "AvenirNext-Bold", size: 16), NSAttributedString.Key.foregroundColor : UIColor(.white)])
        }
        cell.otherLabel.attributedText = NSAttributedString(string: "\(leaders[indexPath.row].name)", attributes: [NSAttributedString.Key.font : UIFont(name: "AvenirNext-Bold", size: 16), NSAttributedString.Key.foregroundColor : UIColor(.white)])
        return cell
    }
    
}
