//
//  UIViewController.swift
//  VAComputingIOSTask
//
//  Created by iMac on 31/07/2021.
//


import UIKit

extension UIViewController {
    func showAlert(title: String , message: String) {
        let alert = UIAlertController(title: title as String, message: message as String, preferredStyle:.alert)
        let font = UIFont.systemFont(ofSize: 13)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler:nil))
        alert.setValue(NSAttributedString(string: message, attributes: [NSAttributedString.Key.font: font]), forKey: "attributedMessage")
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}


