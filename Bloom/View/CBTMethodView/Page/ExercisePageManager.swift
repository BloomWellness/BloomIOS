

import Foundation
import UIKit

class ExercisePageManager: UIViewController {
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var excerciseMethod: CBTMethod?
    var groundingExercises: [GroundingExercise] = []
    var deepBreathing: [Int] = [1]
    
    var feedback = ""
    var rating = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.makeBloomShawDown()
        setupCollectionView()

        
        createCustomBackButton(title: excerciseMethod!.title)
        
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
        
        setupData()
    }
    
    func createCustomBackButton(title: String) {
        let backButton = UIButton(type: .custom)
        
        // Set the button image
        if let backButtonImage = UIImage(named: "back_image") {
            let resizedImage = resizeImage(image: backButtonImage, targetSize: CGSize(width: 24, height: 24))
            backButton.setImage(resizedImage, for: .normal)
        }
        
        // Set the button title
        backButton.setTitle(title, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 16) // Customize font as needed
        backButton.setTitleColor(.black, for: .normal) // Customize title color as needed
        
        // Adjust spacing between the image and title
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        backButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
        
        // Set the target action
        backButton.addTarget(self, action: #selector(self.customBackAction), for: .touchUpInside)
        
        // Set the frame of the button - adjust size as needed
        backButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        // Create a UIBarButtonItem with the button as its customView
        let barButtonItem = UIBarButtonItem(customView: backButton)
        
        // Assign the custom UIBarButtonItem as the left navigation item
        self.navigationItem.leftBarButtonItem = barButtonItem
    }
    
    func setupCollectionView() {
        
        
        let nib = UINib(nibName: Constant.CellID.GroundingExerciseCollectionViewCell, bundle: Bundle.main)
        collectionView.register(nib, forCellWithReuseIdentifier: Constant.CellID.GroundingExerciseCollectionViewCell)
        
        let nibFeedback = UINib(nibName: Constant.CellID.FeedBackCollectionViewCell, bundle: Bundle.main)
        collectionView.register(nibFeedback, forCellWithReuseIdentifier: Constant.CellID.FeedBackCollectionViewCell)
        let nibFeedbackDeep = UINib(nibName: Constant.CellID.DeepFeedBackCollectionViewCell, bundle: Bundle.main)
        collectionView.register(nibFeedbackDeep, forCellWithReuseIdentifier: Constant.CellID.DeepFeedBackCollectionViewCell)
        
        let nibDeep = UINib(nibName: Constant.CellID.DeepBreathingCollectionViewCell, bundle: Bundle.main)
        collectionView.register(nibDeep, forCellWithReuseIdentifier: Constant.CellID.DeepBreathingCollectionViewCell)
        
        let nibProgressive1 = UINib(nibName: Constant.CellID.ProgressiveCollectionViewCell, bundle: Bundle.main)
        collectionView.register(nibProgressive1, forCellWithReuseIdentifier: Constant.CellID.ProgressiveCollectionViewCell)
        let nibProgressive2 = UINib(nibName: Constant.CellID.Progressive2CollectionViewCell, bundle: Bundle.main)
        collectionView.register(nibProgressive2, forCellWithReuseIdentifier: Constant.CellID.Progressive2CollectionViewCell)
        let nibProgressive3 = UINib(nibName: Constant.CellID.Progressive3CollectionViewCell, bundle: Bundle.main)
        collectionView.register(nibProgressive3, forCellWithReuseIdentifier: Constant.CellID.Progressive3CollectionViewCell)
        
        let nibMindful1 = UINib(nibName: Constant.CellID.Mindful1CollectionViewCell, bundle: Bundle.main)
        collectionView.register(nibMindful1, forCellWithReuseIdentifier: Constant.CellID.Mindful1CollectionViewCell)
        let nibMindful2 = UINib(nibName: Constant.CellID.Mindful2CollectionViewCell, bundle: Bundle.main)
        collectionView.register(nibMindful2, forCellWithReuseIdentifier: Constant.CellID.Mindful2CollectionViewCell)
        
        let nibThought = UINib(nibName: Constant.CellID.ThoughtCollectionViewCell, bundle: Bundle.main)
        collectionView.register(nibThought, forCellWithReuseIdentifier: Constant.CellID.ThoughtCollectionViewCell)
        let nibThought1 = UINib(nibName: Constant.CellID.Thought1CollectionViewCell, bundle: Bundle.main)
        collectionView.register(nibThought1, forCellWithReuseIdentifier: Constant.CellID.Thought1CollectionViewCell)
        let nibThought2 = UINib(nibName: Constant.CellID.Thought2CollectionViewCell, bundle: Bundle.main)
        collectionView.register(nibThought2, forCellWithReuseIdentifier: Constant.CellID.Thought2CollectionViewCell)
        
        let nibEngage = UINib(nibName: Constant.CellID.EngageCollectionViewCell, bundle: Bundle.main)
        collectionView.register(nibEngage, forCellWithReuseIdentifier: Constant.CellID.EngageCollectionViewCell)
        let nibEngage1 = UINib(nibName: Constant.CellID.Engage1CollectionViewCell, bundle: Bundle.main)
        collectionView.register(nibEngage1, forCellWithReuseIdentifier: Constant.CellID.Engage1CollectionViewCell)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        // Initialize the flow layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0 // No space between cells
        layout.minimumInteritemSpacing = 0

        // Initialize the collection view with the flow layout
        collectionView.isPagingEnabled = true // Enable paging
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func setupData() {
        groundingExercises = [GroundingExercise(title: "5 things you see around you", image: "icon_see", desOne: "You can search closer to home or farther away. Why not stare out of the window if you're inside?", desTwo: "Seek out minute things, like the way the light reflects or a pattern you've never seen before."),
                              GroundingExercise(title: "4 things you touch around you", image: "icon_touch", desOne: "You may concentrate on how the earth feels under your feet.", desTwo: "Simply make a mental note of them if you aren't in a comfortable enough setting to say them out."),
                              GroundingExercise(title: "3 things you hear around you", image: "icon_hear", desOne: "If there's a window nearby. maybe keep an ear out for birds or vehicles.", desTwo: "Pay close attention to any sounds that your mind has blocked out, such the wind flowing through the trees or the ticking of a clock."),
                              GroundingExercise(title: "2 things you smell around you", image: "icon_smell", desOne: "Make an effort to detect odours in the air around you, such as the aroma of the place you're in or the surroundings around you.", desTwo: "Maybe there's a perfume in the air, like from a flower or an unlit candle."),
                              GroundingExercise(title: "1 thing you can taste around you", image: "icon_taste", desOne: "What flavour does the interior of your tongue have? Gum chewing? Juice from oranges? The lunchtime panini?", desTwo: "The final stage is to concentrate on your mouth and taste what you can.")]
        collectionView.reloadData()
        pageControl.numberOfPages = groundingExercises.count + 1
        pageControl.currentPage = 0
    }
    
    @objc func customBackAction() {
        // Handle the custom back action or just pop the view controller
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnDoneTapped(_ sender: Any) {
        
    }
    
    @objc func pageControlDidChange(_ sender: UIPageControl) {
        let currentPage = sender.currentPage
        collectionView.scrollToItem(at: IndexPath(item: currentPage, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    func postStarRating() {
        let cbtMethod = excerciseMethod?.title ?? ""
        let rating = rating
        let comment = feedback
        
        let bodyParams = ["cbtMethod": cbtMethod, "rate": rating, "comment": comment] as [String : Any]
        
        APIManager.shared.postData(endpoint: Endpoints.shared.rateCbt, parameters: bodyParams) { result in
            switch result {
            case .success(let response):
                // Handle successful response
                print("Response received: \(response)")
                // Access properties of response dictionary as needed
                
                DispatchQueue.main.async {
                    self.showAlert(withTitle: "Success", withMessage: "Your feedback successfully submited")
                }
            case .failure(let error):
                // Handle error
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

extension ExercisePageManager: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch excerciseMethod?.type {
            
        case .Grounding:
            return groundingExercises.count + 1
        case .DeepBreathing:
            pageControl.numberOfPages = deepBreathing.count + 1
            return deepBreathing.count + 1
        case .Progressive:
            pageControl.numberOfPages = 3
            return 3
        case .Mindful:
            pageControl.numberOfPages = 2
            return 2
        case .Thought:
            pageControl.numberOfPages = 3
            return 3
        case .Engage:
            pageControl.numberOfPages = 3
            return 2
        case .none:
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  
        guard let feedBackCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.CellID.FeedBackCollectionViewCell, for: indexPath) as? FeedBackCollectionViewCell else { return UICollectionViewCell() }
        guard let feedBackDeepCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.CellID.DeepFeedBackCollectionViewCell, for: indexPath) as? DeepFeedBackCollectionViewCell else { return UICollectionViewCell() }
        
        feedBackCell.submitFeedbackAction = {
            self.rating = 4
            self.feedback = feedBackCell.feedbackTextView.text!
            self.postStarRating()
        }
        
        feedBackDeepCell.submitFeedbackAction = {
            self.rating = 4
            self.feedback = feedBackDeepCell.feedbackTxtView.text!
            self.postStarRating()
        }
        
        switch excerciseMethod?.type {
            
            case .Grounding:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.CellID.GroundingExerciseCollectionViewCell, for: indexPath) as? GroundingExerciseCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            if indexPath.row == groundingExercises.count {
                return feedBackCell
            } else {
                cell.configCell(exercise: groundingExercises[indexPath.row])
                return cell
            }
            
            case .DeepBreathing:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.CellID.DeepBreathingCollectionViewCell, for: indexPath) as? DeepBreathingCollectionViewCell else {
                return UICollectionViewCell() }
                if indexPath.row == deepBreathing.count {
                    return feedBackDeepCell
                } else {
                    return cell
                }
            
            case .Progressive:
            guard let progressiveCell1 = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.CellID.ProgressiveCollectionViewCell, for: indexPath) as? ProgressiveCollectionViewCell,
                  let progressiveCell2 = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.CellID.Progressive2CollectionViewCell, for: indexPath) as? Progressive2CollectionViewCell,
                  let progressiveCell3 = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.CellID.Progressive3CollectionViewCell, for: indexPath) as? Progressive3CollectionViewCell
            else { return UICollectionViewCell() }
            if indexPath.row == 0 {
                return progressiveCell1
            } else if indexPath.row == 1 {
                return progressiveCell2
            } else {
                return progressiveCell3
            }
            
            case .Mindful:
            guard let minfulCell1 = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.CellID.Mindful1CollectionViewCell, for: indexPath) as? Mindful1CollectionViewCell,
                  let minfulCell2 = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.CellID.Mindful2CollectionViewCell, for: indexPath) as? Mindful2CollectionViewCell else { return UICollectionViewCell() }
            if indexPath.row == 0 {
                return minfulCell1
            } else {
                return minfulCell2
            }
            case .Thought:
            guard let thougtCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.CellID.ThoughtCollectionViewCell, for: indexPath) as? ThoughtCollectionViewCell,
                  let thougtCell1 = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.CellID.Thought1CollectionViewCell, for: indexPath) as? Thought1CollectionViewCell,
                  let thougtCell2 = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.CellID.Thought2CollectionViewCell, for: indexPath) as? Thought2CollectionViewCell
            else { return UICollectionViewCell() }
            if indexPath.row == 0 {
                return thougtCell
            } else if indexPath.row == 1 {
                return thougtCell1
            } else {
                return thougtCell2
            }
            case .Engage:
            guard let engageCell1 = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.CellID.EngageCollectionViewCell, for: indexPath) as? EngageCollectionViewCell,
                  let engageCell2 = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.CellID.Engage1CollectionViewCell, for: indexPath) as? Engage1CollectionViewCell else { return UICollectionViewCell() }
            if indexPath.row == 0 {
                return engageCell1
            } else {
                return engageCell2
            }
            case .none:
                break
            }
        return UICollectionViewCell()
    }

    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Assuming there are no additional insets or spacing, the cell width is the same as the collection view's width
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height // Assuming you want the cell height to match the collection view height
        return CGSize(width: width, height: height)
    }
    
}

extension ExercisePageManager: UIPageViewControllerDelegate {
    
}

extension ExercisePageManager: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = collectionView.frame.size.width
        pageControl.currentPage = Int(collectionView.contentOffset.x / pageWidth)
    }
}
