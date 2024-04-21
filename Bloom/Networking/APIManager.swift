//
//  APIManager.swift
//  Bloom
//
//  Created by Tarun Sahu on 19/04/24.
//

import Foundation
import UIKit
import ProgressHUD

class Endpoints {
    static let shared = Endpoints()
    
    private init() {}
    
    let login = "/auth/login"
    let moodData = "/journal/mood"
    let authVerification = "/auth/request-verification"
    let otpVerify = "/auth/verify"
    let authRegister = "/auth/register"
    let forgetPassword = "/auth/forget-password"
    let resetPasswordOtp = "/auth/verify-reset-password"
    let newPassword = "/auth/reset-password"
    let viewProcess = "/journal/mood-progress"
    let journalData = "/journal/date-journals"
    let journalHighlights = "/journal/journal-highlight"
    let journal = "/journal"
    let rateCbt = "/cbt/rate-cbt"
}


class APIManager {
    static let shared = APIManager() // Singleton instance
    
    private let baseURL = "http://51.21.15.235:3000" //"https://761f-139-135-39-193.ngrok-free.app"
    private let apiKey = LocalStorage.getToken()
    private let endpoints = Endpoints.shared
    
    private init() {}
    
    // MARK: - Read (GET)
    
    func getData(endpoint: String, showLoader: Bool = true, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        performRequest(with: endpoint, method: "GET", body: nil, showLoader: showLoader, completion: completion)
    }
    
    // MARK: - Create (POST)
    
    func postData(endpoint: String, parameters: [String: Any], showLoader: Bool = true, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            performRequest(with: endpoint, method: "POST", body: jsonData, showLoader: showLoader, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
    
    // MARK: - Update (PUT)
    
    func updateData(endpoint: String, parameters: [String: Any], showLoader: Bool = true, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            performRequest(with: endpoint, method: "PUT", body: jsonData, showLoader: showLoader, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
    
    // MARK: - Delete (DELETE)
    
    func deleteData(endpoint: String, showLoader: Bool = true, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        performRequest(with: endpoint, method: "DELETE", body: nil, showLoader: showLoader, completion: completion)
    }
    
    // MARK: - Helper Method
    
    private func performRequest(with endPoint: String, method: String, body: Data?, showLoader: Bool, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        // Show loader if needed
        if showLoader {
            ProgressHUD.animate("") // Show loading indicator with a message
        }
        
        guard let url = URL(string: baseURL + endPoint) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        
        // Add headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            // Hide loader
            if showLoader {
                ProgressHUD.dismiss() // Hide loading indicator
            }
            
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid response", code: 1, userInfo: nil)))
                return
            }
            
            print("statusCode", httpResponse.statusCode)
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: nil)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 2, userInfo: nil)))
                return
            }
            
            do {
                let json1 = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                guard let jsonDict = jsonObject as? [String: Any] else {
                    completion(.failure(NSError(domain: "Invalid JSON format", code: 3, userInfo: nil)))
                    return
                }
                completion(.success(jsonDict))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

