
import UIKit

class Mindful1CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var gifImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        gifImageView.loadGIF(asset: "mindful")
    }

}
