

import UIKit

class GroundingExerciseCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainTitleLabel: UILabel!
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var descriptionOneLabel: UILabel!
    @IBOutlet weak var descriptionTwoLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(exercise: GroundingExercise) {
        mainTitleLabel.text = exercise.title
        mainImageView.image = UIImage(named: exercise.image)
        descriptionOneLabel.text = exercise.desOne
        descriptionTwoLabel.text = exercise.desTwo
    }

}
