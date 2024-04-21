
import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var stackMoodView: UIStackView!
    @IBOutlet weak var goodMoodView: UIImageView!
    @IBOutlet weak var shockedMoodView: UIImageView!
    @IBOutlet weak var sadMoodView: UIImageView!
    @IBOutlet weak var angryMoodView: UIImageView!
    @IBOutlet weak var descriptionMoodLabel: UILabel!
    
    @IBOutlet weak var methodNameTopLeftLabel: UILabel!
    @IBOutlet weak var methodTopLeftImage: UIImageView!
    @IBOutlet weak var methodExerciseTopLeftView: UIView!
    @IBOutlet weak var methodExerciseTopLeftLabel: UILabel!
    
    @IBOutlet weak var methodNameTopRightLabel: UILabel!
    @IBOutlet weak var methodTopRightImage: UIImageView!
    @IBOutlet weak var methodExerciseTopRightView: UIView!
    @IBOutlet weak var methodExerciseTopRightLabel: UILabel!
    
    @IBOutlet weak var methodNameBottomLeftLabel: UILabel!
    @IBOutlet weak var methodBottomLeftImage: UIImageView!
    @IBOutlet weak var methodExerciseBottomLeftView: UIView!
    @IBOutlet weak var methodExerciseBottomLeftLabel: UILabel!
    
    @IBOutlet weak var methodNameBottomRightLabel: UILabel!
    @IBOutlet weak var methodBottomRightImage: UIImageView!
    @IBOutlet weak var methodExerciseBottomRightView: UIView!
    @IBOutlet weak var methodExerciseBottomRightLabel: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    
    
    @IBOutlet weak var callNowButton: UIButton!
    @IBOutlet weak var journalButton: UIButton!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    enum Mood: String {
        case good = "HAPPY"
        case sad = "OK"
        case shock = "SAD"
        case angry = "DEPRESSED"
        case all
    }
    
    var currentSelectedMood: Mood = .all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTapGestureForMoodView()
        setupUI()
    }
    
    func setupUI() {
        
        callNowButton.makeBloomShawDown()
        journalButton.makeBloomShawDown()
        let user = LocalStorage.getUserData()
        userNameLabel.text = "Hi " + (user["name"] as? String ?? "")
    }
    
    func initTapGestureForMoodView() {
        
        let tapGoodMoodGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGoodMood))
        goodMoodView.isUserInteractionEnabled = true
        goodMoodView.addGestureRecognizer(tapGoodMoodGesture)
        
        let tapSadMoodGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapSadMood))
        sadMoodView.isUserInteractionEnabled = true
        sadMoodView.addGestureRecognizer(tapSadMoodGesture)
        
        let tapSockedMoodGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapSockedMood))
        shockedMoodView.isUserInteractionEnabled = true
        shockedMoodView.addGestureRecognizer(tapSockedMoodGesture)
        
        let tapAngryMoodGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapAngryMood))
        angryMoodView.isUserInteractionEnabled = true
        angryMoodView.addGestureRecognizer(tapAngryMoodGesture)
    }
    
    @objc private func handleTapGoodMood() {
        print("Tap Good Mood")
        
        
        if currentSelectedMood == .all {
            sadMoodView.isHidden = true
            shockedMoodView.isHidden = true
            angryMoodView.isHidden = true
            descriptionMoodLabel.isHidden = false
            stackMoodView.distribution = .fill
            currentSelectedMood = .good
            sendMood(mood: currentSelectedMood)
        } else if currentSelectedMood == .good {
            sadMoodView.isHidden = false
            shockedMoodView.isHidden = false
            angryMoodView.isHidden = false
            descriptionMoodLabel.isHidden = true
            stackMoodView.distribution = .equalSpacing
            currentSelectedMood = .all
        }
    }
    
    @objc private func handleTapSadMood() {
        print("Tap Sad Mood")
        if currentSelectedMood == .all {
            goodMoodView.isHidden = true
            shockedMoodView.isHidden = true
            angryMoodView.isHidden = true
            descriptionMoodLabel.isHidden = false
            stackMoodView.distribution = .fill
            currentSelectedMood = .sad
            sendMood(mood: currentSelectedMood)

        } else if currentSelectedMood == .sad {
            goodMoodView.isHidden = false
            shockedMoodView.isHidden = false
            angryMoodView.isHidden = false
            descriptionMoodLabel.isHidden = true
            stackMoodView.distribution = .equalSpacing
            currentSelectedMood = .all
        }
    }
    
    @objc private func handleTapSockedMood() {
        print("Tap Socked Mood")
        if currentSelectedMood == .all {
            goodMoodView.isHidden = true
            sadMoodView.isHidden = true
            angryMoodView.isHidden = true
            descriptionMoodLabel.isHidden = false
            stackMoodView.distribution = .fill
            currentSelectedMood = .shock
            sendMood(mood: currentSelectedMood)
        } else if currentSelectedMood == .shock {
            goodMoodView.isHidden = false
            sadMoodView.isHidden = false
            angryMoodView.isHidden = false
            descriptionMoodLabel.isHidden = true
            stackMoodView.distribution = .equalSpacing
            currentSelectedMood = .all
        }
    }
    
    @objc private func handleTapAngryMood() {
        print("Tap Angry Mood")
        if currentSelectedMood == .all {
            goodMoodView.isHidden = true
            sadMoodView.isHidden = true
            shockedMoodView.isHidden = true
            descriptionMoodLabel.isHidden = false
            stackMoodView.distribution = .fill
            currentSelectedMood = .angry
            sendMood(mood: currentSelectedMood)
        } else if currentSelectedMood == .angry {
            goodMoodView.isHidden = false
            sadMoodView.isHidden = false
            shockedMoodView.isHidden = false
            descriptionMoodLabel.isHidden = true
            stackMoodView.distribution = .equalSpacing
            currentSelectedMood = .all
        }
    }
    
    func sendMood(mood: Mood) {
        
        let currentDate = Helper.getCurrentISO8601Date()
        print("currentDate: \(currentDate)")
        
        let bodyParams = ["mood": mood.rawValue, "date": currentDate]
        
        APIManager.shared.postData(endpoint: Endpoints.shared.moodData, parameters: bodyParams) { result in
            switch result {
            case .success(let response):
                // Handle successful response
                print("Response received: \(response)")
                print("userName",response["name"])
                
                // Access properties of response dictionary as needed
            case .failure(let error):
                // Handle error
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func settingTapped(_ sender: Any) {
        guard let settingVC = createViewControllFromStoryboard(id: Constant.VC.SettingViewController) as? SettingViewController else { return }
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    @IBAction func viewAllTapped(_ sender: Any) {
        guard let CBTMethodVC = createViewControllFromStoryboard(id: Constant.VC.CBTMethodViewController) as? CBTMethodViewController else { return }
        self.navigationController?.pushViewController(CBTMethodVC, animated: true)
    }
    
    @IBAction func viewProgressTapped(_ sender: Any) {

        guard let moodProgressVC = createViewControllFromStoryboard(id: Constant.VC.MoodProgressReViewController) as? MoodProgressReViewController else { return }
        self.navigationController?.pushViewController(moodProgressVC, animated: true)
        
    }
    
    @IBAction func callNowTapped(_ sender: Any) {
            
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        // Define actions
        let callAction = UIAlertAction(title: "Call 111", style: .default, handler: { action in
            // Handle share
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            // Handle share
        })
        
        let image = UIImage(named: "icon_call")!.withRenderingMode(.alwaysOriginal)
        callAction.setValue(image, forKey: "image")
        callAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        callAction.setValue(UIColor.systemBlue, forKey: "titleTextColor")
        
        // Add actions to the action sheet
        actionSheetController.addAction(callAction)
        actionSheetController.addAction(cancelAction)
        // Present the action sheet
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func journalTapped(_ sender: Any) {
        guard let journalVC = createViewControllFromStoryboard(id: Constant.VC.JournalViewController) as? JournalViewController else { return }
        self.navigationController?.pushViewController(journalVC, animated: true)
        
    }
}
