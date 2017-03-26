//
//  FindTextField.swift
//  GTickets
//
//  Created by Slava on 3/26/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

class FindTextField: UITextField {

  func updateField() {
    layer.borderColor = UIColor.gray.cgColor
    layer.borderWidth = 1
    layer.cornerRadius = 10
    layer.masksToBounds = true
    
    attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes:[NSForegroundColorAttributeName: UIColor.lightText])
    
    leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: frame.height))
    leftViewMode = .always
    
  }
  
}
