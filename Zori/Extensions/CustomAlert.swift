//
//  CustomAlert.swift
//  Zori
//
//  Created by Oleksandr on 8/1/18.
//  Copyright © 2018 ekreative. All rights reserved.
//

import Foundation
import UIKit
import Moya

extension UIViewController {
    @IBAction internal func backTapped(_ sender: UIButton) {
        if presentingViewController != nil {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}

protocol Alertable: class {
    func showAlert(_ alert: String)
    func showError(_ error: Error)
}

extension Alertable {
    func showAlert(_ alert: String) {
        let alertController = UIAlertController(title: "", message: alert, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alertController.dismiss(animated: false, completion: nil)
        }))
        
        if self is UIViewController {
            (self as? UIViewController)?.present(alertController, animated: true, completion: nil)
        } else {
            UIApplication.shared.windows.first?.rootViewController?.resignFirstResponder()
            UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showError(_ error: Error) {
        if case MoyaError.underlying(_, _) = error {
            return
        }
        
        var message = NSLocalizedString("default_error", comment: "Something went wrog error")
        
        defer {
            showAlert(message)
        }
        
        let errorDesc = error.localizedDescription
        if errorDesc.contains("iTunes Store") {
            message = errorDesc
            return
        }
        //Prepare message for network error
        if let errorResponse = error as? MoyaError {
            if let body = try? errorResponse.response?.mapJSON() as? [String: Any], let bodyMessage = (body["error"] as? [String: Any])?["message"] as? String {
                message = bodyMessage
            }
            return
        }
        
        //Prepare message for CustomError
        if let customError = error as? CustomError {
            message = customError.localizedDescription
        }
        
    }
    
}
