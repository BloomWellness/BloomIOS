

import Foundation
import UIKit
import CoreCharts

class MoodProgressReViewController: UIViewController { //CoreChartViewDataSource
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var happyHeight: NSLayoutConstraint!
    @IBOutlet weak var okayHeight: NSLayoutConstraint!
    @IBOutlet weak var sadHeight: NSLayoutConstraint!
    @IBOutlet weak var depressedHeight: NSLayoutConstraint!
    
   // @IBOutlet weak var chartView: UIView!
    
    var journalHightlights: [MoodJournalHightLigh] = [MoodJournalHightLigh(title: "Sources of Hope", description: "Today, I reflected on what keeps me hopeful. Family support, personal growth, and my future goals are at the top of my list.", image: UIImage(named: "mood_cell")!, date: "08/08/2023"),
                                                      MoodJournalHightLigh(title: "Self-Care Strategies", description: "I'm focusing on a regular routine, staying connected with loved ones. 😄", image: UIImage(named: "mood_cell")!, date: "08/08/2023")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        chartView.dataSource = self
        moodProgress()
        journalHighlight()
        let nibTableViewCell = UINib(nibName: Constant.CellID.MoodJournalTableViewCell, bundle: Bundle.main)
        tableView.register(nibTableViewCell, forCellReuseIdentifier: Constant.CellID.MoodJournalTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
    }
//    func loadCoreChartData() -> [CoreChartEntry] {
//
//            var allCityData = [CoreChartEntry]()
//        
//            let cityNames = ["Istanbul","Antalya","Ankara","Trabzon","İzmir"]
//        
//            let plateNumber = [34,07,06,61,35]
//            
//            for index in 0..<cityNames.count {
//                
//                let newEntry = CoreChartEntry(id: "\(plateNumber[index])",
//                                              barTitle: cityNames[index],
//                                              barHeight: Double(plateNumber[index]),
//                                              barColor: rainbowColor())
//                                              
//                                              
//                allCityData.append(newEntry)
//                
//            }
//            
//            return allCityData
//
//    }
    
    func moodProgress(){
        //progress graph
        let currentDate = Helper.getCurrentISO8601Date()
        print("currentDate: \(currentDate)")
        
        let bodyParams = ["date": currentDate]
        
        APIManager.shared.postData(endpoint: Endpoints.shared.viewProcess, parameters: bodyParams) { result in
            switch result {
            case .success(let response):
                // Handle successful response
                print("Response received: \(response)")
                //print("userName",response["name"])
                
                print(response["moodcount"])
                let resultArray = response["moodcount"] as! NSArray
                
                for mood in resultArray {
                    print(mood)
                }
                
                // Access properties of response dictionary as needed
            case .failure(let error):
                // Handle error
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func journalHighlight(){
        let currentDate = Helper.getCurrentISO8601Date()
        print("currentDate: \(currentDate)")
        
        let bodyParams = ["date": currentDate]
        
        APIManager.shared.postData(endpoint: Endpoints.shared.journalHighlights, parameters: bodyParams) { result in
            switch result {
            case .success(let response):
                // Handle successful response
                print("Response received: \(response)")
                
                // Parse the response and create MoodJournalHightLigh objects
                if let responseDict = response as? [String: [String: String]] {
                    var highlights: [MoodJournalHightLigh] = []
                    for (key, value) in responseDict {
                        let title = key.capitalized.replacingOccurrences(of: "_", with: " ")
                        let description = value["description"] ?? "No description found"
                        // Assuming you have a default image for when no image is found
                        let image = UIImage(named: value["image"] ?? "default_image") ?? UIImage() // Replace "default_image" with your actual default image name
                        let date = (value["date"] ?? "") == "No date found" ? "__/__/__" : (value["date"] ?? "")
                        let highlight = MoodJournalHightLigh(title: title, description: description, image: image, date: date)
                        highlights.append(highlight)
                    }
                    DispatchQueue.main.async {
                        self.journalHightlights = highlights
                        // Reload the table view data to reflect the changes
                        self.tableView.reloadData()
                    }
                } else {
                    print("Invalid response format")
                }
                
                // Access properties of response dictionary as needed
            case .failure(let error):
                // Handle error
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

extension MoodProgressReViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journalHightlights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellID.MoodJournalTableViewCell, for: indexPath) as? MoodJournalTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        if indexPath.row == 1 {
            cell.moodCellImage.isHidden = true
        }
        cell.moodTitle.text = journalHightlights[indexPath.row].title
        cell.moodDescription.text = journalHightlights[indexPath.row].description
        cell.moodCellImage.image = journalHightlights[indexPath.row].image
        cell.moodDate.text = journalHightlights[indexPath.row].date
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 132
        } else {
            return 262
        }
    }
}
