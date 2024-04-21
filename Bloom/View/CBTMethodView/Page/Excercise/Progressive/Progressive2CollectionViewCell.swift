

import UIKit

class Progressive2CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var gifImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        gifImageView.loadGIF(asset: "progressive")
    }

}
