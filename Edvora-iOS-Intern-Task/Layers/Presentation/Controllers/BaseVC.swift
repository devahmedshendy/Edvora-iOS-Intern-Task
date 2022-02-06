//
//  BaseVC.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/5/22.
//

import UIKit

class BaseVC: UIViewController {
    
    // MARK: - Alert Methods
    
    func showErrorAlert(_ message: String) {
        let action = UIAlertAction(title: "Ok",
                                   style: .cancel ,
                                   handler: nil)
        
        showAlertWithTitle("Error",
                           message: message,
                           actions: [action])
    }
    
    func showAlertWithTitle(_ title: String, message: String,
                            actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        for action in actions {
            alert.addAction(action)
        }
        
        present(alert, animated: true)
    }
}
