

import Foundation
import UIKit

class JournalViewController: UIViewController {
    
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var leftImage: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var callNowButtom: UIButton!
    @IBOutlet weak var smsChatButton: UIButton!
    
    var listJournal: [Journal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        getListJournal()
        grtJournalData()
    }
    
    func setupUI() {
        
        let customButton = UIBarButtonItem(image: UIImage(named: "back_button"), style: .plain, target: self, action: #selector(self.customBackAction))
        
        self.navigationController?.navigationBar.tintColor = .black
        UIBarButtonItem.appearance().tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = customButton
        
        callNowButtom.makeBloomShawDown()
        smsChatButton.makeBloomShawDown()
        
        let nibTableViewCell = UINib(nibName: Constant.CellID.journalTableViewCell, bundle: Bundle.main)
        tableView.register(nibTableViewCell, forCellReuseIdentifier: Constant.CellID.journalTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
    }
    
    @objc func customBackAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func getListJournal() {
        listJournal = [Journal(title: "Source of Hope", description: "You haven't added any sources of hope.", addTitle: "Add text/image",color: UIColor.energy, imageUrl: ""),
                       Journal(title: "Red Flags", description: "You haven't added any red flags..", addTitle: "Add a red flag", color: UIColor.button, imageUrl: ""),
                       Journal(title: "Self-Care Strategies", description: "You haven't added any self-care strategies.", addTitle: "Add a strategy", color: UIColor.calm, imageUrl: ""),
                       Journal(title: "Helpful Activities", description: "You haven't added any helpful activities.", addTitle: "Add an activitiy", color: UIColor.balance, imageUrl: "")]
        tableView.reloadData()
    }
    
    @IBAction func callNowTapped(_ sender: Any) {
        
    }
    
    @IBAction func smsChatTapped(_ sender: Any) {
        
    }
    
    func grtJournalData() {
        let currentDate = Helper.getCurrentISO8601Date()
        print("currentDate: \(currentDate)")
        let bodyParams = ["date": currentDate]
        
        APIManager.shared.postData(endpoint: Endpoints.shared.journalData, parameters: bodyParams) { result in
            switch result {
            case .success(let response):
                // Handle successful response
                print("Response received: \(response)")
                // Access properties of response dictionary as needed
                
                let data: [String: Any] = response
                
                let sources_of_hope = data["sources_of_hope"]  as! String
                let red_flags = data["red_flags"]  as! String
                let self_care_strategies = data["self_care_strategies"]  as! String
                let helpful_activites = data["helpful_activites"]  as! String
                
                self.listJournal = [
                    Journal(
                        title: "Source of Hope",
                        description: sources_of_hope == "No sources of hope found" ? "You haven't added any sources of hope." : sources_of_hope,
                        addTitle: "Add text/image",
                        color: UIColor.energy,
                        imageUrl: data["sources_of_hope_image"] as! String
                    ),
                    
                    Journal(
                        title: "Red Flags",
                        description: red_flags == "No red flags found" ? "You haven't added any red flags.." : red_flags,
                        addTitle: "Add a red flag",
                        color: UIColor.button,
                        imageUrl: data["red_flags_image"] as! String
                    ),
                    
                    Journal(
                        title: "Self-Care Strategies",
                        description: self_care_strategies == "No self care strategies found" ? "You haven't added any self-care strategies." : self_care_strategies,
                        addTitle: "Add a strategy",
                        color: UIColor.calm,
                        imageUrl: data["self_care_strategies_image"] as! String
                    ),
                    
                    Journal(title: "Helpful Activities",
                            description: helpful_activites == "No helpful activites found" ? "You haven't added any helpful activities." : helpful_activites,
                            addTitle: "Add an activitiy",
                            color: UIColor.balance,
                            imageUrl: data["helpful_activites_image"] as! String
                           )
                ]
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                // Handle error
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
}

extension JournalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listJournal.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellID.journalTableViewCell) as? JournalTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.configCellData(journal: listJournal[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let journalDetailVC = createViewControllFromStoryboard(id: Constant.VC.JournalDetailViewController) as? JournalDetailViewController else { return }
        journalDetailVC.journalType = listJournal[indexPath.row].title
        self.navigationController?.pushViewController(journalDetailVC, animated: true)
    }
}
