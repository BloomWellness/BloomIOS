
import UIKit

class DeepFeedBackCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var submitButton: UIButton!
    
    
    @IBOutlet weak var feedbackTxtView: UITextView!
    
    var submitFeedbackAction: (() -> ()) = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        submitButton.makeBloomShawDown()
    }

    @IBAction func submitButtonTapped(_ sender: Any) {
        submitFeedbackAction()
    }
}
