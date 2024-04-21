
import UIKit

class SignupViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var buttonDismiss: UIBarButtonItem!
    
    var verificationId = ""
    var isOtpVerified = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.isHidden = true
        passwordTextField.isHidden = true
        termLabel.isHidden = true
        buttonDismiss.isHidden = true
        
        self.navigationController?.navigationBar.tintColor = .black
        UIBarButtonItem.appearance().tintColor = UIColor.black
    }
    
    @IBAction func buttonDismissTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonCreateTapped(_ sender: Any) {
        if emailTextField.isHidden != true {
            
            //when user enter mail id and tap on create button this code run
            let Usermail = ["email": emailTextField.text ?? ""]
            APIManager.shared.postData(endpoint: Endpoints.shared.authVerification, parameters: Usermail) { result in
                switch result {
                case .success(let response):
                    // Handle successful response
                    print("Response received: \(response)")
                    if let accessToken = response["access_token"] as? String {
                        LocalStorage.saveToken(accessToken)
                    }
                    DispatchQueue.main.async {
                        //self.moveToHome()
                    }
                    // Access properties of response dictionary as needed
                case .failure(let error):
                    // Handle error
                    print("Error: \(error.localizedDescription)")
                }
            }
            presentOTPInputAlert()
            
        } else{
            // api call when user enter name and password
            let UserDetails = ["id": verificationId, "name": nameTextField.text ?? "","password": passwordTextField.text ?? ""]
            APIManager.shared.postData(endpoint: Endpoints.shared.authRegister, parameters: UserDetails) { result in
                switch result {
                case .success(let response):
                    // Handle successful response
                    print("Response received: \(response)")
                    if let accessToken = response["token"] as? String {
                        LocalStorage.saveToken(accessToken)
                    }
                        LocalStorage.saveUser(user: response)
                    print(response)
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
        
        //        guard let verifiVC = createViewControllFromStoryboard(id: Constant.VC.VerifiPasswordViewController) as? VerifiPasswordViewController else { return }
        //        self.navigationController?.pushViewController(verifiVC, animated: true)
    }
    
    //MARK: - function for otp pop up
    func presentOTPInputAlert() {
        let alertController = UIAlertController(title: "Enter OTP", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "OTP"
            textField.keyboardType = .numberPad
            textField.addTarget(self, action: #selector(self.otpTextFieldDidChange(_:)), for: .editingChanged) // Add target to validate input dynamically
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let verifyAction = UIAlertAction(title: "Verify", style: .default) { _ in
            // Handle OTP verification
            if let otp = alertController.textFields?.first?.text, otp.count < 6 {
                print("Entered OTP: \(otp)")
                
                // API for otp Put Method
                let OtpDetails = ["email": self.emailTextField.text ?? "" , "otc": Int(otp) ?? 0]
                APIManager.shared.updateData(endpoint: Endpoints.shared.otpVerify, parameters: OtpDetails) { result in
                    switch result {
                    case .success(let response):
                        // Handle successful response
                        print("Response received: \(response)")
                        if let accessToken = response["id"] as? String {
                            self.verificationId = accessToken
                        }
                        
                        // Access properties of response dictionary as needed
                    case .failure(let error):
                        // Handle error
                        print("Error: \(error.localizedDescription)")
                    }
                }
                
                //after user enter right otp then this execute
                self.nameTextField.isHidden = false
                self.passwordTextField.isHidden = false
                self.termLabel.isHidden = false
                self.buttonDismiss.isHidden = false
                self.emailTextField.isHidden = true
                
            } else {
                // Show error message for invalid OTP length
                self.showInvalidOTPAlert()
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(verifyAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    @objc func otpTextFieldDidChange(_ textField: UITextField) {
        // Limit OTP input to 6 digits
        //            if let text = textField.text, text.count > 6 {
        //                textField.deleteBackward()
        //            }
    }
    
    func showInvalidOTPAlert() {
        let alertController = UIAlertController(title: "Invalid OTP", message: "Please enter a 6-digit OTP.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //alert function
//    func showAlert(withTitle title: String, withMessage message:String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in})
//        alert.addAction(ok)
//        DispatchQueue.main.async(execute: {
//            self.present(alert, animated: true)
//        })
//    }
    
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
