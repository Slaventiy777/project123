//
//  CheckboxView.swift
//  GTickets
//
//  Created by Marharyta Lytvynenko on 4/19/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

class CheckboxView: UIView {
  @IBOutlet weak var icon: UIView!
  @IBOutlet weak var info: UILabel!
  
  var onStateChangedAction: (Bool)->() = { _ in }
  
  private(set) var isSelected: Bool = false {
    didSet {
      icon.isHidden = !isSelected
      onStateChangedAction(isSelected)
    }
  }
  
  @IBAction func tap(_ sender: UITapGestureRecognizer) {
    isSelected = !isSelected
  }
  
}
