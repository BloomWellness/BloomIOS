
import UIKit

class ExerciseTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var dotView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        contentView.frame = contentView.frame.inset(by: padding)
    }
    
    func configCellColor(color: UIColor) {
        
        leftView.backgroundColor = color
        bottomView.backgroundColor = color
        dotView.backgroundColor = color
    }
    
    func configCellWith(method: CBTMethod) {
        
        titleLabel.text = method.title
        descriptionLabel.text = method.description
    }
    
}
