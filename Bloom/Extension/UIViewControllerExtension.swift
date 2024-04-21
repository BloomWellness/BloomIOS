//
//  UIViewControllerExtension.swift
//  Bloom
//
//  Created by Apple on 20/04/24.
//

import Foundation
import UIKit

extension UIViewController {
    //alert function
    func showAlert(withTitle title: String, withMessage message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in})
        alert.addAction(ok)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
}
