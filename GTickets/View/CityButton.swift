//
//  CityButton.swift
//  GTickets
//
//  Created by Marharyta Lytvynenko on 4/24/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

class CityButton: UIButton {
  @IBInspectable var higlightBackgroundColor: UIColor = UIColor.clear
  
  override var isHighlighted: Bool {
    didSet {
      backgroundColor = isHighlighted ? higlightBackgroundColor : UIColor.clear
      //FIXME: dont fade text color on higlight
    }
  }
}
