//
//  ResestPasswordVC.swift
//  Bloom
//
//  Created by My Mac on 20/04/24.
//

import UIKit

class ResestPasswordVC: UIViewController {
    
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    var resetPasswordId = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(resetPasswordId)
    }
    
    @IBAction func btnChangePassword(_ sender: UIButton) {
        
        newPassword()
        
    }
    
    func newPassword(){
        let UserDetails = ["id": resetPasswordId, "password": txtConfirmPassword.text ?? ""]
        APIManager.shared.updateData(endpoint: Endpoints.shared.newPassword, parameters: UserDetails) { result in
            switch result {
            case .success(let response):
                // Handle successful response
                print("Response received: \(response)")
                if let accessToken = response["token"] as? String {
                    LocalStorage.saveToken(accessToken)
                }
                    LocalStorage.saveUser(user: response)
                print(response)
                
//                DispatchQueue.main.async {
//                    self.showAlert(withTitle: "Success", withMessage: "Your password successfully changed")
//                }
                
                DispatchQueue.main.async {
                    self.moveToHome()
                }
                // Access properties of response dictionary as needed
            case .failure(let error):
                // Handle error
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func moveToHome() {
        guard let homeVC = createViewControllFromStoryboard(id: Constant.VC.HomeViewController) as? HomeViewController else { return }
        
        let navigationController = UINavigationController(rootViewController: homeVC)
        
        // Get a reference to the current scene
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate,
              let window = sceneDelegate.window else { return }
        
        // Set the new root view controller of the window
        window.rootViewController = navigationController
        
        // Optional: Make a smooth transition
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
        
        // Make the window key and visible
        window.makeKeyAndVisible()
    }
    

}
