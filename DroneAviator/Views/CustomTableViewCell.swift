import UIKit

class CustomTableViewCell: UITableViewCell {
    
    // Define UI elements
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Score: ???"
        return label
    }()
    
    let otherLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        // Set any other properties for your label
        return label
    }()
    
    // Add subviews and configure constraints in init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(scoreLabel)
        addSubview(otherLabel)
        
        // Define constraints for scoreLabel
        scoreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        scoreLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        // Define constraints for otherLabel
        otherLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        otherLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
