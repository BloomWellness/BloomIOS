
import UIKit

class DeepBreathingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var gifImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        gifImageView.loadGIF(asset: "breathe")
    }

}
