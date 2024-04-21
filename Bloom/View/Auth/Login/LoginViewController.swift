
import UIKit
import Combine

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    private var activityIndicator: UIActivityIndicatorView?
    
    var userName: String?
    
    var viewModel = LoginViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        setupBindings()
    }
    
    private func setupActivityIndicator() {
       activityIndicator = UIActivityIndicatorView(style: .large)
       activityIndicator?.center = self.view.center
       activityIndicator?.hidesWhenStopped = true
       view.addSubview(activityIndicator!)
    }
    
    private func showLoading(_ show: Bool) {
        if show {
            activityIndicator?.startAnimating()
        } else {
            activityIndicator?.stopAnimating()
        }
    }
    
    private func setupBindings() {
        // Bind text fields to the ViewModel
        emailTextField.textPublisher
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)
        
        passwordTextField.textPublisher
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellables)
        
        // Enable or disable the login button based on the ViewModel
//        viewModel.$isLoginEnabled
//            .receive(on: RunLoop.main)
//            .assign(to: \.isEnabled, on: loginButton)
//            .store(in: &cancellables)
//        
        viewModel.$loginSuccessful
            .receive(on: RunLoop.main)
            .sink { [weak self] success in
                if success {
                    // Update UI for success, e.g., navigate to another screen
                    self?.moveToHome()
                } else {
                    // Optionally handle failure, e.g., show an error message
                }
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                self?.showLoading(isLoading)
            }
            .store(in: &cancellables)
        
        viewModel.$loginFailed
            .receive(on: RunLoop.main)
            .sink { [weak self] loginFailed in
                if loginFailed {
                    self?.showLoginFailedAlert()
                }
            }
            .store(in: &cancellables)
    }
    
    private func showLoginFailedAlert() {
        let alert = UIAlertController(title: "Login Failed", message: "The Username or Password is not correct.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
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
    
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
 
        if validateTextField(emailTextField, message: "Please enter email.") &&
               validateTextField(passwordTextField, message: "Please enter password.") {
            
            }
        let loginDetails = ["email": emailTextField.text ?? "", "password": passwordTextField.text ?? ""]
        APIManager.shared.postData(endpoint: Endpoints.shared.login, parameters: loginDetails) { result in
            switch result {
            case .success(let response):
                // Handle successful response
                print("Response received: \(response)")
                if let accessToken = response["access_token"] as? String {
                    LocalStorage.saveToken(accessToken)
                }
                LocalStorage.saveUser(user: response)
                DispatchQueue.main.async {
                    self.moveToHome()
                }
                // Access properties of response dictionary as needed
            case .failure(let error):
                // Handle error
                print("Error: \(error.localizedDescription)")
            }
        }
        //showLoading(true)
       // viewModel.login()
        
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
                
        guard let signUpVC = createViewControllFromStoryboard(id: Constant.VC.SignupViewController) as? SignupViewController else { return }
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        
        guard let forgotVC = createViewControllFromStoryboard(id: Constant.VC.ForgotPasswordViewController) as? ForgotPasswordViewController else { return }
        self.navigationController?.pushViewController(forgotVC, animated: true)
    }
    
    
    @IBAction func privacyButtonTapped(_ sender: Any) {
    }
    
    func validateTextField(_ textField: UITextField, message: String) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            // If the text field is empty, show an alert
            let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    
    
    
}

