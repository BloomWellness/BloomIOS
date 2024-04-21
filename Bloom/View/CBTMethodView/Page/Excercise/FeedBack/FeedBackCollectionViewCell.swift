

import UIKit

class FeedBackCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var starOne: UIImageView!
    @IBOutlet weak var starTwo: UIImageView!
    @IBOutlet weak var starThree: UIImageView!
    @IBOutlet weak var starFour: UIImageView!
    @IBOutlet weak var starFive: UIImageView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var feedbackTextView: UITextView!
    
    var submitFeedbackAction: (() -> ()) = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        submitButton.makeBloomShawDown()
    }

    @IBAction func btnSubmitTapped(_ sender: Any) {
        submitFeedbackAction()
    }
}
