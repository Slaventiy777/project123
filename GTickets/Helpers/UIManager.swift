//
//  UIManager.swift
//  GTickets
//
//  Created by Marharyta Lytvynenko on 3/26/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

extension CALayer {
  @IBInspectable var _borderColor : UIColor? {
    set (newValue) {
      self.borderColor = (newValue ?? UIColor.clear).cgColor
    }
    get {
      return UIColor(cgColor: self.borderColor!)
    }
  }
}
