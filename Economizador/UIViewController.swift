//
//  UIViewController.swift
//  Economizador
//
//  Created by MacbookPro on 2/17/19.
//  Copyright © 2019 apperture. All rights reserved.
//

import Foundation
import UIKit



extension UIViewController
{
    
    func hideKeyboardWhenTappedAround()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
}
