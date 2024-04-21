
import UIKit

class JournalTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var addView: UIView!
    
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
        
        let padding = UIEdgeInsets(top: 5, left: 0, bottom: 10, right: 0)
        contentView.frame = contentView.frame.inset(by: padding)
    }
    
    func configCellData(journal: Journal) {
        leftView.backgroundColor = journal.color
        bottomView.backgroundColor = journal.color
        
        titleLabel.text = journal.title
        descriptionLabel.text = journal.description
        addLabel.text = journal.addTitle
    }
    
}
