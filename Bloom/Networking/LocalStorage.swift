

import Foundation

class LocalStorage {
    
    static func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "authToken")
        UserDefaults.standard.synchronize()
    }

    static func getToken() -> String {
        return UserDefaults.standard.value(forKey: "authToken") as? String ?? ""
    }
    
    
    static func saveUser(user:[String: Any]) {
        UserDefaults.standard.set(user, forKey: "userData")
        UserDefaults.standard.synchronize()
    }
    
    static func getUserData() -> [String: Any] {
        return UserDefaults.standard.value(forKey: "userData")  as? [String: Any] ?? [:]
    }
    
}
