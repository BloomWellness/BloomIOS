
import UIKit

class Engage1CollectionViewCell: UICollectionViewCell {
	
    @IBOutlet weak var datePickerView: UIView!
    
    @IBOutlet weak var hobbiesView: UIView!
    @IBOutlet weak var socialView: UIView!
    @IBOutlet weak var growthView: UIView!
    @IBOutlet weak var physicalView: UIView!
    @IBOutlet weak var selfcareView: UIView!
    @IBOutlet weak var outdoorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        hobbiesView.makeBloomShawDown()
        socialView.makeBloomShawDown()
        growthView.makeBloomShawDown()
        physicalView.makeBloomShawDown()
        selfcareView.makeBloomShawDown()
        outdoorView.makeBloomShawDown()

        setupDatePicker()
    }
    
    private func setupDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .labelGray
        datePicker.tintColor = .white
        
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePickerView.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: datePickerView.centerXAnchor),
            datePicker.centerYAnchor.constraint(equalTo: datePickerView.centerYAnchor)
        ])
        
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
    }
        
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        print("Selected date is \(dateFormatter.string(from: datePicker.date))")
    }

}
