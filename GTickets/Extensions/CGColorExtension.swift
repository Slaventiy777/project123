//
//  CGColorExtension.swift
//  GTickets
//
//  Created by Slava on 4/2/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

extension CGColor {
  
  var uiColor: UIKit.UIColor {
    return UIKit.UIColor(cgColor: self)
  }
  
}
