
import UIKit

class CBTMethodViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var methods: [CBTMethod] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        createCustomBackButton()
        setUpData()
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
        methods = [CBTMethod(title: "5-4-3-2-1 Grounding", description: "Use to help in regain a sense of control and presence in the moment.", isStar: false, type: .Grounding),
                   CBTMethod(title: "Deep Breathing", description: "Deep breathing is a powerful tool used for reducing stress and anxiety.", isStar: false, type: .DeepBreathing),
                   CBTMethod(title: "Progressive Muscle Relaxation", description: "Use to reduce physical tension for outbursts in stress and anxiety.", isStar: false, type: .Progressive),
                   CBTMethod(title: "Mindful Breathing", description: "Simple mindfulness meditation to focus on breathing to help calm the mind.", isStar: false, type: .Mindful),
                   CBTMethod(title: "Thought Reframing", description: "Use to challenge negative thoughts and replacing them with balanced ones.", isStar: false, type: .Thought),
                   CBTMethod(title: "Engage and Enjoy", description: "Use to schedule and engage in activities that are enjoyable or fulfilling.", isStar: false, type: .Engage)]
        tableView.reloadData()
    }

    func setUpView() {
        let nib = UINib(nibName: "CBTMethodCollectionViewCell", bundle: Bundle.main)
        collectionView.register(nib, forCellWithReuseIdentifier: "CBTMethodCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
        let nibTableViewCell = UINib(nibName: "ExerciseTableViewCell", bundle: Bundle.main)
        tableView.register(nibTableViewCell, forCellReuseIdentifier: "ExerciseTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        
    }
    
    @objc func customBackAction() {
        // Handle the custom back action or just pop the view controller
        navigationController?.popViewController(animated: true)
    }
}

extension CBTMethodViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CBTMethodCollectionViewCell", for: indexPath) as! CBTMethodCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
    
}

extension CBTMethodViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return methods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseTableViewCell", for: indexPath) as? ExerciseTableViewCell else {return UITableViewCell()}
        
        cell.configCellWith(method: methods[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let commonIntro = createViewControllFromStoryboard(id: Constant.VC.CommonIntroViewController) as? CommonIntroViewController else { return }
        commonIntro.method = methods[indexPath.row]
        self.navigationController?.pushViewController(commonIntro, animated: true)
    }
}
