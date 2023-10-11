import UIKit

class CustomiseViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var imageView: UIImageView!
    var picker: UIPickerView!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        let hookView = UIView()
        hookView.backgroundColor = .white
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
        picker = UIPickerView()
        view.addSubview(picker)
        if #available(iOS 13.0, *) {
            picker.overrideUserInterfaceStyle = .dark // or .dark
        }
        // Do any additional setup after loading the view, typically from a nib.
        picker.delegate = self
        picker.dataSource = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        if UserDefaults.standard.object(forKey: "plane") == nil {
            UserDefaults.standard.set(planeName.allCases[0].rawValue, forKey: "plane")
        } else {
            switch planeName(rawValue: UserDefaults.standard.object(forKey: "plane") as! String) ?? .first {
            case .first:
                picker.selectRow(0, inComponent: 0, animated: false)
            case .second:
                picker.selectRow(1, inComponent: 0, animated: false)
            case .third:
                picker.selectRow(2, inComponent: 0, animated: false)
            case .fourth:
                picker.selectRow(3, inComponent: 0, animated: false)
            }
        }
        
        imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "\(String(describing: UserDefaults.standard.object(forKey: "plane")!))")
        view.addSubview(imageView)
        
        let backgroundViw = UIView()
        
        
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            
            
            picker.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            picker.heightAnchor.constraint(equalTo: imageView.heightAnchor),
            picker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            picker.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20)
        ])
    }
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return planeName.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return planeName.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaults.standard.set(planeName.allCases[row].rawValue, forKey: "plane")
        GameManager.shared.plane = planeName(rawValue: UserDefaults.standard.object(forKey: "plane") as! String) ?? .first
        
        
        UIView.transition(with: imageView,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: {
            self.imageView.image = UIImage(named: "\(String(describing: UserDefaults.standard.object(forKey: "plane")!))")
        }, completion: nil)
        print("\(String(describing: UserDefaults.standard.object(forKey: "plane")))")
    }
    
    
    
}
