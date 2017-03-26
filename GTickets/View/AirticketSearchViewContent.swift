//
//  AirticketSearchViewContent.swift
//  GTickets
//
//  Created by Slava on 3/26/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

class AirticketSearchViewContent: UIView {
  
  @IBOutlet weak var fromField: FindTextField!
  @IBOutlet weak var toField: FindTextField!
  @IBOutlet weak var fromSearchResultView: UIView!
  @IBOutlet weak var toSearchResultView: UIView!
  
  @IBOutlet weak var toFieldTopOffset: NSLayoutConstraint!
  
  func update() {
    fromField.updateField()
    toField.updateField()
    
    setTopOffsetToField(isDefault: false)
  }
  
  func setTopOffsetToField(isDefault: Bool) {
    let defaultOffset: CGFloat = 25.0
    
    if isDefault {
      fromSearchResultView.isHidden = true
      
      toFieldTopOffset.constant = defaultOffset
    } else {
      let fromSearchResultOffset = fromField.frame.maxY - fromSearchResultView.frame.minY
      
      fromSearchResultView.isHidden = false
      
      toFieldTopOffset.constant = defaultOffset +
                                  fromSearchResultView.frame.height +
                                  fromSearchResultOffset
    }
  }
  
}
