

import Foundation
import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let items: [String] = ["Profile Information", "Privacy Policy", "About Us", "Report Problem"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationItem.hidesBackButton = true
        let customButton = UIBarButtonItem(image: UIImage(named: "back_button"), style: .plain, target: self, action: #selector(self.customBackAction))
        
        self.navigationController?.navigationBar.tintColor = .black
        UIBarButtonItem.appearance().tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = customButton
//        self.navigationItem.backButtonDisplayMode = .minimal
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.showsVerticalScrollIndicator = false
        
        let deleteViewGesture = UITapGestureRecognizer(target: self, action: #selector(handleDeleteView))
        deleteView.isUserInteractionEnabled = true
        deleteView.addGestureRecognizer(deleteViewGesture)

    }
    
    @objc private func handleDeleteView() {
        print("Delete Data Tapped")
        
    }
    
    @objc func customBackAction() {
        navigationController?.popViewController(animated: true)
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(items[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
