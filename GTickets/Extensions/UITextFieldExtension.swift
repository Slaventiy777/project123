//
//  UITextFieldExtension.swift
//  GTickets
//
//  Created by Marharyta Lytvynenko on 4/24/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

extension UITextField {
  func setPaddingPoints(_ amount:CGFloat) {
    setLeftPaddingPoints(amount)
    setRightPaddingPoints(amount)
  }
  
  func setLeftPaddingPoints(_ amount:CGFloat){
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
    self.leftView = paddingView
    self.leftViewMode = .always
  }
  
  func setRightPaddingPoints(_ amount:CGFloat) {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
    self.rightView = paddingView
    self.rightViewMode = .always
  }
}

