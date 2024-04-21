
import Combine
import Foundation

class LoginViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoginEnabled: Bool = false
    @Published var loginSuccessful: Bool = false
    @Published var isLoading: Bool = false
    @Published var loginFailed: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        Publishers.CombineLatest($email, $password)
            .map { email, password in
                let emailIsValid = self.isValidEmail(email)
                let passwordIsValid = !password.isEmpty
                return emailIsValid && passwordIsValid
            }
            .print("Login Button State") // This will log events to the console.
            .assign(to: &$isLoginEnabled)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func login() {
        guard let url = URL(string: "http://51.21.15.235:3000/auth/login") else {
            print("Invalid URL")
            return
        }
        
        let loginDetails = ["email": email, "password": password]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: loginDetails) else {
            print("Error: Cannot create JSON")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                // Handle networking or connection error
                print("Networking error: \(error.localizedDescription)")
                self.isLoading = false
                self.loginFailed = true
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 400 else {
                // Handle HTTP response error
                print("HTTP error")
                self.isLoading = false
                self.loginFailed = true
                return
            }
            
            guard let data = data else {
                // Handle missing data error
                print("No data received")
                self.isLoading = false
                self.loginFailed = true
                return
            }
            
            // Parse the JSON data from the response
            // This depends on your API's respse structure
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let accessToken = json["access_token"] as? String {
                    print("Access Token: \(accessToken)")
                    LocalStorage.saveToken(accessToken)
                } else {
                    print("Error: Invalid JSON data")
                }
                self.loginSuccessful = true
                self.isLoading = false
                // Here you could update some state to indicate login was successful
                // For example: self.isLoggedIn = true
            } catch {
                self.isLoading = false
                self.loginFailed = true
                print("JSON parsing error: \(error.localizedDescription)")
            }
            
        }.resume() // Starts the task
    }
}
