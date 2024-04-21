
import UIKit

class Thought1CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        submitButton.makeBloomShawDown()
        slider.thumbTintColor = .shadow
    }

    @IBAction func submitButtonTapped(_ sender: Any) {
        
    }
}
