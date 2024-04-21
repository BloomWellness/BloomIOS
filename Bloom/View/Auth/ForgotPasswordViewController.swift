
import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    var PasswordId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = .black
        UIBarButtonItem.appearance().tintColor = UIColor.black
    }

    @IBAction func backToSignInTapped(_ sender: Any) {
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        
        let userMail = ["email": emailTextField.text ?? ""]
        APIManager.shared.postData(endpoint: Endpoints.shared.forgetPassword, parameters: userMail) { result in
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
        
        //        guard let verifiVC = createViewControllFromStoryboard(id: Constant.VC.VerifiPasswordViewController) as? VerifiPasswordViewController else { return }
        //        self.navigationController?.pushViewController(verifiVC, animated: true)
        
        
    }
    
    @IBAction func SignUpTapped(_ sender: Any) {
    }
    
    
    // function for otp alert
    
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
                    
                    let otpDetails = ["email": self.emailTextField.text ?? "" , "otc": Int(otp) ?? 0]
                    APIManager.shared.updateData(endpoint: Endpoints.shared.resetPasswordOtp, parameters: otpDetails) { result in
                        switch result {
                        case .success(let response):
                            // Handle successful response
                            print("Response received: \(response)")
                            if let accessToken = response["id"] as? String {
                                self.PasswordId = accessToken
                                
                                
                                DispatchQueue.main.async {
                                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ResestPasswordVC") as? ResestPasswordVC
                                    vc?.resetPasswordId = self.PasswordId
                                    self.navigationController?.pushViewController(vc!, animated: true)
                                }
                               
                                
                               // self.moveToResetpassword()
                            }
                            
                            // Access properties of response dictionary as needed
                        case .failure(let error):
                            // Handle error
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                   
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
    
    func moveToResetpassword() {
        guard let resetPassVC = createViewControllFromStoryboard(id: Constant.VC.ResestPassword) as? ResestPasswordVC else { return }
        
        resetPassVC.resetPasswordId = PasswordId
        let navigationController = UINavigationController(rootViewController: resetPassVC)
        
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
