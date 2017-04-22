//
//  UIButtonExtension.swift
//  GTickets
//
//  Created by Slava on 4/2/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

private var SelectedBackgroundColorKey = 0
private var NormalBackgroundColorKey = 0

extension UIButton {
  
  @IBInspectable var selectedBackgroundColor: UIColor? {
    get {
      return objc_getAssociatedObject(self, &SelectedBackgroundColorKey) as? UIColor
    }
    
    set(newValue) {
      objc_setAssociatedObject(self,
                               &SelectedBackgroundColorKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
  }
  
  private var normalBackgroundColor: UIColor? {
    get {
      return objc_getAssociatedObject(self, &NormalBackgroundColorKey) as? UIColor
    }
    
    set(newValue) {
      objc_setAssociatedObject(self,
                               &NormalBackgroundColorKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
  }
  
  override open var backgroundColor: UIColor? {
    didSet {
      if !isSelected {
        normalBackgroundColor = backgroundColor
      }
    }
  }
  
  override open var isSelected: Bool {
    didSet {
      if let selectedBackgroundColor = self.selectedBackgroundColor {
        if isSelected {
          borderWidth = 0
          backgroundColor = selectedBackgroundColor
        } else {
          borderWidth = 1
          backgroundColor = normalBackgroundColor
        }
      }
    }
  }
}
