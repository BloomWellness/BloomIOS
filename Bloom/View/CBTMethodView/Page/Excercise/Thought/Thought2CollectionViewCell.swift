
import UIKit

class Thought2CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var saveBeliefButton: UIButton!
    @IBOutlet weak var addNewBeliefButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        saveBeliefButton.makeBloomShawDown()
        addNewBeliefButton.makeBloomShawDown()
        submitButton.makeBloomShawDown()
    }

    @IBAction func saveBeliefTapped(_ sender: Any) {
    }
    
    @IBAction func addNewBeliefTapped(_ sender: Any) {
        
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
    }
    
}
