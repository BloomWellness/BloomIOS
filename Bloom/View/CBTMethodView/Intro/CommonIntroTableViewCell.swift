
import UIKit

class CommonIntroTableViewCell: UITableViewCell {

    @IBOutlet weak var ExpandImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
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
        
        let padding = UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 0)
        contentView.frame = contentView.frame.inset(by: padding)
    }
    
}
