
import Foundation
import UIKit


class CommonIntroViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonBegin: UIButton!
    
    var method: CBTMethod?
    
    var dataIntro: [CommonIntro] = [CommonIntro(title: "How is this going to help?", description: " How is this going to help? How is this going to help? How is this going to help?", isExpand: false),
                                    CommonIntro(title: "When should I not apply this method?", description: " When should I not apply this method? When should I not apply this method?", isExpand: false),
                                    CommonIntro(title: "Advice", description: " How is this going to help? How is this going to help? How is this going to help?AdviceAdviceAdvice", isExpand: false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpTableView()
        setUpData()
    }
    
    func setUpView() {
        buttonBegin.makeBloomShawDown()
        createCustomBackButton()
//        let customButton = UIBarButtonItem(image: UIImage(named: "back_button"), style: .plain, target: self, action: #selector(self.customBackAction))
//        
//        self.navigationController?.navigationBar.tintColor = .black
//        UIBarButtonItem.appearance().tintColor = UIColor.black
//        self.navigationItem.leftBarButtonItem = customButton
    }
    
    func setUpTableView() {
        let nibTableViewCell = UINib(nibName: "CommonIntroTableViewCell", bundle: Bundle.main)
        tableView.register(nibTableViewCell, forCellReuseIdentifier: "CommonIntroTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
    }
    
    func createCustomBackButton() {
        let backButton = UIButton(type: .custom)
        
        // Set the button image
        if let backButtonImage = UIImage(named: "back_image") {
            let resizedImage = resizeImage(image: backButtonImage, targetSize: CGSize(width: 24, height: 24))
            backButton.setImage(resizedImage, for: .normal)
        }
        
        // Adjust spacing between the image and title
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -50, bottom: 0, right: 10)
        
        // Set the target action
        backButton.addTarget(self, action: #selector(self.customBackAction), for: .touchUpInside)
        
        // Set the frame of the button - adjust size as needed
        backButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        // Create a UIBarButtonItem with the button as its customView
        let barButtonItem = UIBarButtonItem(customView: backButton)
        
        // Assign the custom UIBarButtonItem as the left navigation item
        self.navigationItem.leftBarButtonItem = barButtonItem
    }
    
    func setUpData() {
        self.titleLabel.text = method?.title
    }
    
    @objc func customBackAction() {
        // Handle the custom back action or just pop the view controller
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnBeginTapped(_ sender: Any) {
        
        guard let excercisePage = createViewControllFromStoryboard(id: Constant.VC.ExercisePageManager) as? ExercisePageManager else { return }
        excercisePage.excerciseMethod = method
        self.navigationController?.pushViewController(excercisePage, animated: true)
    }
}

extension CommonIntroViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataIntro.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellID.CommonIntroTableViewCell, for: indexPath) as? CommonIntroTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        cell.descriptionLabel.isHidden = !dataIntro[indexPath.row].isExpand
        cell.titleLabel.text = dataIntro[indexPath.row].title
        cell.descriptionLabel.text = dataIntro[indexPath.row].description
        cell.ExpandImageView.image = dataIntro[indexPath.row].isExpand ? UIImage(named: "icon_collapse") : UIImage(named: "icon_expand")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataIntro[indexPath.row].isExpand ? 90 : 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Toggle expansion state
        dataIntro[indexPath.row].isExpand.toggle()
        UIView.animate(withDuration: 0.5) {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
