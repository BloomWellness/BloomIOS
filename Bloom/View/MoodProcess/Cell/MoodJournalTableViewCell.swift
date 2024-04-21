
import UIKit

class MoodJournalTableViewCell: UITableViewCell {

    @IBOutlet weak var moodTitle: UILabel!
    @IBOutlet weak var moodDate: UILabel!
    @IBOutlet weak var moodCellImage: UIImageView!
    @IBOutlet weak var moodDescription: UILabel!
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
}
