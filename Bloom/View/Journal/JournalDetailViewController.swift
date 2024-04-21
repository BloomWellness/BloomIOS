

import Foundation
import UIKit

class JournalDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var buttonSave: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    var imageBase64Data = ""
    var journalType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        buttonSave.makeBloomShawDown()
        
        let customButton = UIBarButtonItem(image: UIImage(named: "back_button"), style: .plain, target: self, action: #selector(self.customBackAction))
        
        self.navigationController?.navigationBar.tintColor = .black
        UIBarButtonItem.appearance().tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = customButton
    }
    
    @objc func customBackAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveTapped(_ sender: Any) {
        let Imagedata = imageBase64Data
        let textData = textView.text ?? ""
        let midnight = midnightDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let formattedMidnight = dateFormatter.string(from: midnight)
        
        print("Date", formattedMidnight)
        
        var param: [String: Any?] = [:]
        switch journalType {
        case "Source of Hope":
            
            param = [
                "sources_of_hope": textData,
                "sources_of_hope_image": Imagedata,
                "red_flags": nil,
                "red_flags_image": nil,
                "self_care_strategies": nil,
                "self_care_strategies_image": nil,
                "helpful_activites": nil,
                "helpful_activites_image": nil,
                "date": formattedMidnight
            ]
            
        case "Red Flags":
            
            param = [
                "sources_of_hope": nil,
                "sources_of_hope_image": nil,
                "red_flags": textData,
                "red_flags_image": Imagedata,
                "self_care_strategies": nil,
                "self_care_strategies_image": nil,
                "helpful_activites": nil,
                "helpful_activites_image": nil,
                "date": formattedMidnight
            ]
        case "Self-Care Strategies":
            
            param = [
                "sources_of_hope": nil,
                "sources_of_hope_image": nil,
                "red_flags": nil,
                "red_flags_image": nil,
                "self_care_strategies": textData,
                "self_care_strategies_image": Imagedata,
                "helpful_activites": nil,
                "helpful_activites_image": nil,
                "date": formattedMidnight
            ]
            
        case "Helpful Activities":
            
            param = [
                "sources_of_hope": nil,
                "sources_of_hope_image": nil,
                "red_flags": nil,
                "red_flags_image": nil,
                "self_care_strategies": nil,
                "self_care_strategies_image": nil,
                "helpful_activites": textData,
                "helpful_activites_image": Imagedata,
                "date": formattedMidnight
            ]
        default:
            break
        }
        
        print("bodyParam",param)
        APIManager.shared.postData(endpoint: Endpoints.shared.journal, parameters: param as [String : Any]) { result in
            switch result {
            case .success(let response):
                print(response)
                // Access properties of response dictionary as needed
            case .failure(let error):
                // Handle error
                print("Error: (error.localizedDescription)")
            }
        }
    }
    
    func midnightDate() -> Date {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day], from: now)
        let midnightDate = calendar.date(from: components)!
        return midnightDate
    }
    
    func startOfDay(for date: Date) -> Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return calendar.date(from: components)
    }
    
    @IBAction func uploadImagebtnTapped(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Photo library is not available")
        }
    }
    
    // Delegate method to handle the selection of an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = pickedImage
            if let imageData = pickedImage.jpegData(compressionQuality: 1.0) {
                let base64String = imageData.base64EncodedString()
                print("Count", base64String.count)
                imageBase64Data = base64String
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Delegate method to handle canceling image picking
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
